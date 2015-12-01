use v6;
use MyClass::MyBase;
use MyClass::MyRole :fooo;

unit class MyClass::MyClass is MyClass::MyBase does MyClass::MyRole;

method hoge() {
    "MyClass::MyClass.hoge";
}
