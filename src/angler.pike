import .suite;

array(Suite) suites = ({});

void scan(array(string) paths) {
    foreach (paths, string path) {
        Stdio.Stat stat = file_stat(path);
        if (stat) {
            if (stat.isdir) {
                run(path, Filesystem.System()->get_dir(path, "*.pike"));
            } else if (stat.isreg && sizeof(basename(path)/".pike") > 1) {
                run("", ({path}));
            } else {
                write("Not a pike file: %s\n", path);
            }
        } else {
            write("Not a directory or file: %s\n", path);    
        }
    }
}

void run(string root, array(string) files) {
    foreach (files, string file) {
        Suite suite = Suite(combine_path(root, file));
        object o;
        mixed err = catch {
            o = ((program) suite->path)();
        };
        if (err) {
            write("Could not compile test suite: %s\n", suite->path);
            continue;
        }
        foreach(indices(o), string s) {
            mixed f = o[s];
            if (functionp(f) && search(s, "test") == 0) {
                Test test = Test();
                mixed err = catch {
                    f();
                };
                if (err) {
                    test->error = 1;
                }
                suite->tests += ({test});
            }
        }
        suites += ({suite});
    }
}

int main(int argc, array(string) argv) {
    add_module_path(".");
    mixed args = Arg.parse(argv);
    string report_type;
    if (args["report"]) {
        report_type = args["report"];
    } else {
        report_type = "default";
    }
    object report;
    string report_path = combine_path("report", report_type) + ".pike";
    if (file_stat(report_path)) {
        mixed err = catch {
            report = ((program) report_path)();
        };
        if (err) {
            write("Could not compile reporter: %s\n", report_path);
            exit(1);
        }

        if (!report["run"]) {
            write("Missing run method in reporter: %s\n", report_path);
            exit(1);
        }
    } else {
        write("No such report type: %s\n", report_type);
        exit(1);
    }
    array(string) paths = args[Arg.REST];
    if (!sizeof(paths)) {
        write("No paths to unit tests\n");
        exit(1);
    }
    scan(paths);
    report->run(suites);
}
