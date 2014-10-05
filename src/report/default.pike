import suite;

void run(array(Suite) suites) {
    foreach (suites, Suite suite) {
        write("Suite %s\n", suite->path);
        write("Tests %d\n", sizeof(suite->tests));
        int fails = 0;
        foreach (suite->tests, Test test) {
            write("Test %s\n", test->name);
            if (test->fail) {
                write("%s failed\n", test->name);
                fails++;
            }
        }
        write("Fails %d\n", fails);
    }
}

