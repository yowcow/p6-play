use v6;
use Test;

subtest {

    my @items = (0 .. Inf)[10 .. 13];

    is-deeply @items, [10, 11, 12, 13];

}, 'Test list';

subtest {

    subtest {
        my @items = (gather for 0 .. Inf { take $_ * 2 })[10 .. 13];

        is-deeply @items, [20, 22, 24, 26];

    }, 'Simple';

    subtest {
        my @items = (gather for 0 .. Inf {
            state $a = $_;
            $a = take $_ + $a;
        })[3 .. 5];  # 0, 1, 3, 6, 10, 15

        is-deeply @items, [6, 10, 15];

    }, 'With state';

}, 'Test gather for';

done-testing;
