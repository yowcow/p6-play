use v6;
use Test;

subtest {

    ok 't/data'.IO.d;
    ok !'t/data'.IO.f;

    ok !'t/data/test.txt'.IO.d;
    ok 't/data/test.txt'.IO.f;

}, 'Test directory/file exists';

subtest {

    subtest {
        my $data = slurp 't/data/test.txt';

        is $data, q:to"END"
hoge
fuga
foo
bar
END
    }, 'Actual file';

    subtest {
        dies-ok { slurp 't/data' };
    }, 'Non-existing file';

}, 'Test slurping file';

subtest {

    dies-ok { open 't/path/to/hoge.txt' };

}, 'Test `open` on non-existing file';

subtest {

    my $fh = open 't/data/test.txt';

    subtest {
        my $line = $fh.get;

        is $line, 'hoge';
    }, 'Line 1';

    subtest {
        my $line = $fh.get;

        is $line, 'fuga';
    }, 'Line 2';

    close $fh;

    subtest {
        dies-ok { $fh.get };
    }, 'Fails reading after closing';

}, 'Test reading line-by-line';

done-testing;
