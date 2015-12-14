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

    sub myhash() {
        my @items = <hoge=fuga foo=bar>;

        map {
            my @res = .split('=');
            @res[0] => @res[1];
        }, @items;
    }

    my %res = myhash;

    is-deeply %res, %(
        hoge => 'fuga',
        foo  => 'bar',
    );

}, 'Test sub returns a hash';

done-testing;
