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

done-testing;
