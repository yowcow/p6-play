use v6;
use Test;

subtest {
    my %hash = blackberries => 42;

    is-deeply %hash, { blackberries => 42 };

}, 'Test hash comparison';

subtest {
    my $blackberries = 42;
    my %opts = :$blackberries;

    is-deeply %opts, { blackberries => 42 };

}, 'Test variable into hash';

subtest {
    my $hash1 = { hoge => 'fuga' };
    my $hash2 = { fuga => 'hoge' };
    my %result = %$hash1, %$hash2;

    is-deeply %result, { hoge => 'fuga', fuga => 'hoge' };

}, 'Test merging hash';

subtest {
    sub myhash(*@items) returns Hash {
        %(
            @items.map(-> $item {
                %( $item.split('=').pairup )
            })
        );
    }

    my %res = myhash(<hoge=fuga foo=bar>);

    is-deeply %res, {
        hoge => 'fuga',
        foo  => 'bar',
    };

    my %res2 = myhash();

    is-deeply %res2, {};

}, 'Test sub returns a hash';

subtest {
    my @items = <hoge fuga foo bar>;

    my %res = @items.pairup;

    is-deeply %res, { hoge => 'fuga', foo => 'bar' };

}, 'Test pairup array into hash';

subtest {
    sub mysub(Str $one, Str $two, Str $three) returns Hash {
        {   one   => $one,
            two   => $two,
            three => $three
        };
    }

    subtest {
        my Str @items = <hoge fuga foobar>;

        my %res = mysub(|@items);

        is-deeply %res, {
            one   => 'hoge',
            two   => 'fuga',
            three => 'foobar',
        };

    }, 'Succeeds with 3 variables';

    subtest {
        my Str @items = <hoge fuga>;

        dies-ok { mysub(|@items) };

    }, 'Fails with 2 variables';

    subtest {
        my Int @items = 1 .. 3;

        dies-ok { mysub(|@items) };

    }, 'Fails with wrong type';

}, 'Test flatten array into variables';

subtest {

    subtest {
        my @array = 1 .. 5;

        is @array, [1, 2, 3, 4, 5];

    }, 'Simple array';

    subtest {
        my @array = (0 .. Inf)[10 .. 13];

        is @array, [10, 11, 12, 13];

    }, 'Partial inf list';

}, 'Test array';

subtest {
    my @array = 1 .. 4;

    is @array, [1 .. 4];

    @array[1] += @array.splice(2, 1)[0];

    is @array, [1, 5, 4];

}, 'Test splice array';

subtest {

    my @items = [
        { hoge => 'hoge1' },
        { hoge => 'hoge2' },
        { hoge => 'hoge3' },
        { hoge => 'hoge4' },
    ];

    is @items>><hoge>, <hoge1 hoge2 hoge3 hoge4>;
}, 'Test >>';

done-testing;
