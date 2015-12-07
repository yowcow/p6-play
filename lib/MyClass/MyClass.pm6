use v6;
use MyClass::MyBase;
use MyClass::MyRole :fooo;

unit class MyClass::MyClass is MyClass::MyBase does MyClass::MyRole;

my Str $MESSAGE = 'hello';

method hoge() returns Str {
    "MyClass::MyClass.hoge";
}

multi method hello() returns Str { $MESSAGE }
multi method hello(Str:D $hello) returns Str {
    $MESSAGE = $hello;
    self.hello;
}
multi method hello(Str:U $hello) returns Str {
    $MESSAGE = 'what?';
    self.hello;
}
