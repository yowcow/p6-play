use v6;
use Test;

subtest {
    my regex number { \d+ [ \. \d+ ]? }

    ok so "31.51" ~~ &number;

    ok so "15 + 4.5" ~~ / <number> \s* '+' \s* <number> /;
    is $/<number>.list, ['15', '4.5'];

}, 'Test regex';

subtest {

    my regex works-but-slow { .+ q }
    my token fails-but-fast { .+ q }

    my $s = 'Tokens won\'t backtrack, which makes them fail quicker!';

    is so $s ~~ &works-but-slow, True;
    is so $s ~~ &fails-but-fast, False;

}, 'Test retex and token';

subtest {

    my token non-space-y { 'once' 'upon' 'a' 'time' }
    my rule  space-y     { 'once' 'upon' 'a' 'time' }

    ok so 'onceuponatime' ~~ &non-space-y;
    ok !so 'onceuponatime' ~~ &space-y;
    ok !so 'once upon a time' ~~ &non-space-y;
    ok so 'once upon a time' ~~ &space-y;

}, 'Test rule and token';

subtest {

    grammar TestGrammar {
        token TOP { ^ \d+ $ }
    }

    class TestActions {
        method TOP($/) {
            $/.make: 2 + $/;
        }
    }

    my $actions = TestActions.new;
    my $match   = TestGrammar.parse('40', :$actions);

    is $match, 40;
    is $match.made, 42;

}, 'Test simple grammar and action';

subtest {
    grammar KeyValuePairs {
        token TOP {
            [<pair> \n+]*
        }
        token ws { \h* }
        token identifier { \w+ }
        rule pair { <key=.identifier> \h* '=' \h* <value=.identifier> }
    }

    {
        my $str = q:to/EOI/;
        second=2
        hits=42
        perl=6
        hoge = fuga
        EOI

        my $res = KeyValuePairs.parse($str);

        is $res<pair>.elems, 4;

        is $res<pair>[0].hash, { key => 'second', value => '2' };
        is $res<pair>[1].hash, { key => 'hits', value => '42' };
        is $res<pair>[2].hash, { key => 'perl', value => '6' };
        is $res<pair>[3].hash, { key => 'hoge', value => 'fuga' };

        $res<pair>.list ==> map { .hash } ==> my @result;

        is @result, [
            { key => 'second', value => '2' },
            { key => 'hits',   value => '42' },
            { key => 'perl',   value => '6' },
            { key => 'hoge',   value => 'fuga' },
        ];
    }

    class KeyValuePairsActions {
        method key($/)   { $/.make('hoge' ~~ $/) }
        method value($/) { $/.make(10 + $/) }
        method pair($/)  { $/.make($<key>.made => $<value>.made) }
        method TOP($/)   { $/.make($<pair>>>.made) }
    }

    # http://doc.perl6.org/language/grammars#Creating_Grammars
    # WIP
    {
        my $str = q:to/EOI/;
        third=3
        hits=42
        perl=5
        EOI

        my $actions = KeyValuePairsActions.new;
        my $res = KeyValuePairs.parse($str, :$actions);

        $res<pair>.list ==> map { .hash } ==> my @result;
    }
}, 'Test key-value pair';

done-testing;
