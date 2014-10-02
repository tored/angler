import angler;

void testIntEq() {
    assertEq(1, 1);
}

void testFloatEq() {
    assertEq(1.0, 1.0);
}

void testStringEq() {
    assertEq("a", "a");
}

void testIntNotEq() {
    assertNotEq(1, 2);
}

void testFloatNotEq() {
    assertNotEq(1.0, 2.0);
}

void testStringNotEq() {
    assertNotEq("a", "b");
}
