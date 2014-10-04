import .suite;

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
        report = ((program) report_path)();
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
    // TODO support multiple paths, files and folders
    run(paths[0]);
    report->run(suites);
}
