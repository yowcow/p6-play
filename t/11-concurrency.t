use v6;
use Test;

subtest {

    subtest {
        my $p1 = Promise.new;

        is $p1.status, 'Planned', 'status is Planned';

        $p1.keep: 'result';

        is $p1.status, 'Kept', 'status is Kept';
        is $p1.result, 'result';

    }, 'keep';

    subtest {
        my $p = Promise.new;

        $p.break: 'Oh no';

        is $p.status, 'Broken';

        try $p.result;
        is $p.cause, 'Oh no';

    }, 'break';

}, 'Test Promise';

subtest {

    subtest {
        my $p1 = Promise.new;
        my $p2 = $p1.then(-> $v {

            is $v.result, 'First result';

            "Second result";
        });

        $p1.keep: "First result";

        is $p2.result, 'Second result';

    }, 'keep';

    subtest {
        my $p1 = Promise.new;
        my $p2 = $p1.then(-> $v {
            is $v.result, 'First result', '$v.result is "First result"';
        });

        $p1.break: "First result";

        try $p2.result;
        is $p2.cause, 'First result';

    }, 'break';

}, 'Test Promise.then';

subtest {
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

}, 'Test creating Promise with `start`';

done-testing;
