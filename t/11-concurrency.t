use v6;
use Test;

my $p1 = start {
    my @result = (for 1 .. 3 {
        my Int $sec = (rand * 2).Int + 1;
        sleep $sec;
        say "Promise 1: Slept for $sec sec.";
        $sec;
    });
    @result;
};

my $p2 = start {
    my @result = (for 1 .. 3 {
        my Int $sec = (rand * 2).Int + 1;
        sleep $sec;
        say "Promise 2: Slept for $sec sec.";
        $sec;
    });
    @result;
};

await $p1, $p2;

is $p1.result.elems, 3;
is $p2.result.elems, 3;

done-testing;
