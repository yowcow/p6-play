use v6;
use Test;

class MyHoge {
    has $!hoge = '';

    method get() { $!hoge }
    method set(Str:D :$!hoge) { }
}

subtest {
    my $hoge = MyHoge.new;

    isa-ok $hoge, 'MyHoge';
    is $hoge.get, '';

}, 'Test get';

subtest {

    subtest {
        my $hoge = MyHoge.new;

        $hoge.set(hoge => 'hoge');

        is $hoge.get, 'hoge';

    }, 'Defined string';

    subtest {
        my $hoge = MyHoge.new;
        my Str $str;

        dies-ok { $hoge.set(hoge => $str) };

    }, 'Undefined string';

}, 'Test set';

done-testing;
