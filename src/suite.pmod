class Suite {
    string path;
    int error = 0;
    array(Test) tests = ({});

    void create(string p) {
        path = p;
    }
}

class Test {
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