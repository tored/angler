import .suite;
import .engine;

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
    array(Suite) suites = scanPaths(paths);
    report->run(suites);
}
