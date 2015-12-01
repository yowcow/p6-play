use v6;

unit role MyClass::MyRole;

method foo() is export(:fooo) {
    "MyClass::MyRole.foo";
}

method bar() is export(:MANDATORY) {
    "MyClass::MyRole.bar";
}

method foobar is export(:barrr) {
    "MyClass::MyRole.foobar";
}
