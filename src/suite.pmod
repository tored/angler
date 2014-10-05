class Suite {
    string path;
    array(Test) tests = ({});

    void create(string p) {
        path = p;
    }
}

class Test {
    int error;
    string name;
    Fail fail;

    void create(string n) {
        name = n;
    }
}

class Fail {
    public string msg;
    public array(mixed) vals;

    void create(string m, mixed ... v) {
        msg = m;
        vals = v;
    }
}