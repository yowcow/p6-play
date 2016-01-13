use v6;
use Test;

class MyHoge {
    has Str $!hoge = '';

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

subtest {

    sub hoge(@items --> Hash) {
        % = @items.map({ $_ => 'hoge' });
    }

    my %res = hoge(<foo bar>);

    is %res, { foo => 'hoge', bar => 'hoge' };

}, 'Test implicit variable?';

done-testing;
