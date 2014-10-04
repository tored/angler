class Suite {
    string path;
    array(Test) tests = ({});

    void create(string p) {
        path = p;
    }
}

class Test {
    int error;
}