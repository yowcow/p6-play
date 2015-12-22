use v6;
use Test;

subtest {

    my Int $hoge;

    subtest {
        is $hoge.WHAT, Int, 'is Int';
        ok !$hoge.defined,  'is not defined';
    }, 'Initial state';

    $hoge = 123;

    subtest {
        is $hoge.WHAT, Int, 'is Int';
        ok $hoge.defined,   'is defined';
        is $hoge, 123,      'is 123';
    }, 'After assigning 123';

    $hoge = Nil;

    subtest {
        is $hoge.WHAT, Int, 'is Int';
        ok !$hoge.defined,  'is not defined';
    }, 'After assigning Nil';

}, 'Test variable';

done-testing;
