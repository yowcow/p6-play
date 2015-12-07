use v6;
use MyClass::MyBase;
use MyClass::MyRole :fooo;

unit class MyClass::MyClass is MyClass::MyBase does MyClass::MyRole;

my Str $MESSAGE = 'hello';

method hoge() {
    "MyClass::MyClass.hoge";
}

multi method hello() { $MESSAGE }
multi method hello(Str:D $hello) {
    $MESSAGE = $hello;
    self.hello;
}
multi method hello(Str:U $hello) {
    $MESSAGE = 'what?';
    self.hello;
}
