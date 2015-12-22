use v6;
use Test;

sub hoge(Str $something) returns Str {
    try {

        $something += 1;

        CATCH {
            when X::AdHoc {
                return 'Caught X::AdHoc: ' ~ $_;
            }
            default {
                return 'Caught default: ' ~ $_
            }
        }
    }

    $something;
}

subtest {

    subtest {
        my Str $result = hoge('5');

        like $result, /^Caught\sdefault\:/;

    }, 'Returns an error str';

}, 'Test hoge';

done-testing;
