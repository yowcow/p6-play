use v6;
use JSON::Tiny;
use Test;

subtest {

    subtest {
        my $parsed1 = from-json(slurp 't/data/data1.json');
        my $parsed2 = from-json(slurp 't/data/data2.json');

        ok $parsed1 eqv $parsed2;

    }, 'Serial';

    subtest {
        my $parsing1 = start from-json(slurp 't/data/data1.json');
        my $parsing2 = start from-json(slurp 't/data/data2.json');

        my ($parsed1, $parsed2) = await $parsing1, $parsing2;

        ok $parsed1 eqv $parsed2;

    }, 'Parallel';

}, 'Test JSON comparison';

done-testing;
