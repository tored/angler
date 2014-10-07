import .suite;

array(Suite) scanPaths(array(string) paths) {
    array(Suite) suites = ({});
    foreach (paths, string path) {
        Stdio.Stat stat = file_stat(path);
        if (stat) {
            if (stat.isdir) {
               suites += runSuites(path, Filesystem.System()->get_dir(path, "*.pike"));
            } else if (stat.isreg && sizeof(basename(path)/".pike") > 1) {
                suites += runSuites("", ({path}));
            } else {
                write("Not a pike file: %s\n", path);
            }
        } else {
            write("Not a directory or file: %s\n", path);
        }
    }
    return suites;
}

array(Suite) runSuites(string root, array(string) files) {
    array(Suite) suites = ({});
    foreach (files, string file) {
        Suite suite = runSuite(combine_path(root, file));
        suites += ({suite});
    }
    return suites;
}

Suite runSuite(string path) {
    Suite suite = Suite(path);
    object o;
    mixed err = catch {
        o = ((program) suite->path)();
    };
    if (err) {
        write("Could not compile test suite: %s\n", suite->path);
        suite->error = 1; 
        return suite;
    }
    foreach(indices(o), string s) {
        mixed f = o[s];
        if (functionp(f) && search(s, "test") == 0) {
            Test test = runTest(f);
            suite->tests += ({test});
        }
    }
    return suite;
}


Test runTest(function fn) {
    Test test = Test(function_name(fn));
    mixed fail = catch {
        fn();
    };
    if (fail) {
        test->fail = fail;
    }
    return test;
}
