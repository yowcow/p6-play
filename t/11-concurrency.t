use v6;
use Test;

my $p1 = start {
    my @result = (for 1 .. 30 -> $i {
        "Promise 1: $i";
    });
    @result;
};

my $p2 = start {
    my @result = (for 1 .. 30 -> $i {
        "Promise 2: $i";
    });
    @result;
};

await $p1, $p2;

is $p1.result.elems, 30;
is $p2.result.elems, 30;

done-testing;
