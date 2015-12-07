use v6;

unit role MyClass::MyRole;

method foo() is export(:fooo) returns Str {
    "MyClass::MyRole.foo";
}

method bar() is export(:MANDATORY) returns Str {
    "MyClass::MyRole.bar";
}

method foobar is export(:barrr) returns Str {
    "MyClass::MyRole.foobar";
}
