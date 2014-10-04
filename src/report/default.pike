import suite;

void run(array(Suite) suites) {
    foreach (suites, Suite suite) {
        write("Suite %s\n", suite->path);
        write("Tests %d\n", sizeof(suite->tests));
        int errors = 0;
        foreach (suite->tests, Test test) {
            if (test->error) {
                errors++;
            }
        }
        write("Fails %d\n", errors);
    }
}

