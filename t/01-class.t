use v6;
use lib 'lib';
use MyClass::MyClass;
use Test;

use-ok 'MyClass::MyClass';

subtest {

    is MyClass::MyClass.hoge, 'MyClass::MyClass.hoge';

}, 'Test MyClass::MyClass.hoge';

subtest {

    is MyClass::MyClass.fuga, 'MyClass::MyBase.fuga';

}, 'Test MyClass::MyClass.fuga';

subtest {

    is MyClass::MyClass.foo, 'MyClass::MyRole.foo';

}, 'Test MyClass::MyClass.foo';

subtest {

    is MyClass::MyClass.bar, 'MyClass::MyRole.bar';

}, 'Test MyClass::MyClass.bar';

subtest {

    is MyClass::MyClass.foobar, 'MyClass::MyRole.foobar'; # Why!?
    #dies-ok { MyClass::MyClass.foobar }

}, 'Test MyClass::MyClass.foobar';

done-testing;
