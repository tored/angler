class Suite {
    string path;
    int tests = 0;
    int fails = 0;

    void create(string p) {
        path = p;
    }
}

array(Suite) suites = ({});

void run(string path) {
    array(string) files = Filesystem.System()->get_dir(path, "*.pike");
    foreach (files, string file) {
        Suite suite = Suite(path + "/" + file);
        program p = (program) (suite->path);
        object o = p();
        foreach(indices(o), string s) {
            mixed f = o[s];
            if (functionp(f) && search(s, "test") == 0) {
                suite->tests++;
                mixed err = catch {
                    f();
                };
                if (err) {
                    suite->fails++;
                }
            }
        }
        suites += ({suite});
    }
}

void report() {
    foreach (suites, Suite suite) {
        write("Suite %s\n", suite->path);
        write("Tests %d\n", suite->tests);
        write("Fails %d\n", suite->fails);
    }
}

int main(int argc, array(string) argv) {
    if (argc == 2) {
        add_module_path(".");
        run(argv[1]);
        report();
    } else {
        write("Missing testing directory path\n");
    }
}