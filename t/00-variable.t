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

subtest {

    my Int %hash;

    subtest {
        is %hash.WHAT, Hash[Int];
        ok %hash.defined;
        ok !%hash<hoge>.defined;
        is %hash.keys, ();
        is-deeply %hash, %();
    }, 'Initial state';

    %hash<hoge> = 123;

    subtest {
        ok %hash.defined;
        ok %hash<hoge>.defined;
        is %hash.keys, (<hoge>);
        is-deeply %hash, %(hoge => 123);
    }, 'After assigning hoge=>123';

    %hash<hoge> = Nil;

    subtest {
        ok %hash.defined;
        ok !%hash<hoge>.defined;
        is %hash.keys, <hoge>;
        is-deeply %hash, %(hoge => Int);
    }, 'After assigning hoge=>Nil';

    my $res = %hash<hoge>:delete;

    is $res.WHAT, Int;
    ok !$res.defined;

    subtest {
        ok %hash.defined;
        ok !%hash<hoge>.defined;
        is %hash.keys, ();
        is-deeply %hash, %();
    }, 'After deleting hash key';

}, 'Test Hash';

done-testing;
