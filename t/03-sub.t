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

subtest {

    sub hoge(Int(Cool) $number) {
        is $number, 22;
    }

    hoge('22');

}, 'Test coersion';

subtest {

    sub hoge(%something is copy) {

        is-deeply %something, {
            hoge => 'fuga',
            fuga => {
                'hoge' => 'hoge',
            },
        };

        %something<fuga> = 'hoge';
    }

    sub fuga(%something) {

        is-deeply %something, {
            hoge => 'fuga',
            fuga => {
                'hoge' => 'hoge',
            },
        };

        %something<fuga> = 'hoge';
    }

    my %hash =
        hoge => 'fuga',
        fuga => {
            hoge => 'hoge',
        };
    hoge(%hash);

    is-deeply %hash, {
        hoge => 'fuga',
        fuga => {
            hoge => 'hoge',
        }
    }, 'No destruction if param is copy';

    fuga(%hash);

    is-deeply %hash, {
        hoge => 'fuga',
        fuga => 'hoge',
    }, 'Destroyed if param is a reference';

}, 'Test passing as reference and copy';

subtest {

    sub myreverse(Str:D $given --> Str:D) {
        my Int $last-idx = $given.chars - 1;
        (for (0 .. $last-idx).map({ $last-idx - $_ }) -> $i {
            $given.substr($i, 1)
        }).join;
    }

    is myreverse('abcd'),       'dcba';
    is myreverse('あいうえお'), 'おえういあ';

}, 'Test reversing';

done-testing;
