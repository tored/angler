import suite;

public void assertEq(mixed a , mixed b) {
    if (a != b) {
       throw(Fail("assertEq", a, b));
    }
}

public void assertNotEq(mixed a , mixed b) {
    if (a == b) {
       throw(Fail("assertNotEq", a, b));
    }
}