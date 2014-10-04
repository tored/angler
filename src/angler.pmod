class AssertException {
    public string msg;
    public array(mixed) vals;

    void create(string m, mixed ... v) {
        msg = m;
        vals = v;
    }
}

public void assertEq(mixed a , mixed b) {
    if (a != b) {
       throw(AssertException("assertEq", a, b));
    }
}

public void assertNotEq(mixed a , mixed b) {
    if (a == b) {
       throw(AssertException("assertEq", a, b));
    }
}