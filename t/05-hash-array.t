use v6;
use Test;

subtest {
    my %hash = blackberries => 42;

    is-deeply %hash, %( blackberries => 42 );

}, 'Test hash comparison';

subtest {
    my $blackberries = 42;
    my %opts = :$blackberries;

    is-deeply %opts, %( blackberries => 42 );

}, 'Test variable into hash';

subtest {
    sub myhash(*@items) returns Hash {
        %(  map {
                %( .split('=').pairup );
            }, @items
        );
    }

    my %res = myhash(<hoge=fuga foo=bar>);

    is-deeply %res, %(
        hoge => 'fuga',
        foo  => 'bar',
    );

    my %res2 = myhash();

    is-deeply %res2, %();

}, 'Test sub returns a hash';

subtest {
    my @items = <hoge fuga foo bar>;

    my %res = @items.pairup;

    is-deeply %res, %(hoge => 'fuga', foo => 'bar');

}, 'Test pairup array into hash';

subtest {
    sub mysub(Str $one, Str $two, Str $three) {
        (   one => $one,
            two => $two,
            three => $three
        );
    }

    subtest {
        my Str @items = <hoge fuga foobar>;

        my %res = mysub(|@items);

        is-deeply %res, %(
            one   => 'hoge',
            two   => 'fuga',
            three => 'foobar',
        );

    }, 'Succeeds with 3 variables';

    subtest {
        my Str @items = <hoge fuga>;

        dies-ok { mysub(|@items) };

    }, 'Fails with 2 variables';

}, 'Test flatten array into variables';

done-testing;
