use v6;
use Test;

subtest {
    my regex number { \d+ [ \. \d+ ]? }

    say "31.51" ~~ &number;
    say "15 + 4.5" ~~ / <number> \s* '+' \s* <number> /;

    pass 'number';
}, 'Test regex';

subtest {
    my regex works-but-slow { .+ q }
    my token fails-but-fast { .+ q }
    my $s = 'Tokens won\'t backtrack, which makes them fail quicker!';

    is so $s ~~ &works-but-slow, True;
    is so $s ~~ &fails-but-fast, False;
}, 'Test token';

subtest {
    my token non-space-y { 'once' 'upon' 'a' 'time' }
    my rule  space-y     { 'once' 'upon' 'a' 'time' }

    say 'onceuponatime' ~~ &non-space-y;
    say 'onceuponatime' ~~ &space-y;
    say 'once upon a time' ~~ &non-space-y;
    say 'once upon a time' ~~ &space-y;
}, 'Test rule';

subtest {

    grammar TestGrammar {
        token TOP { ^ \d+ $ }
    }

    class TestActions {
        method TOP($/) {
            $/.make(2 + $/);
        }
    }

    my $actions = TestActions.new;
    my $match   = TestGrammar.parse('40', :$actions);

    say $match;
    is $match.made, 42;
}, 'Test grammar';

subtest {
    grammar KeyValuePairs {
        token TOP {
            [<pair> \n+]*
        }
        token ws { \h* }
        rule pair { <key=.identifier> '=' <value=.identifier> }
        token identifier { \w+ }
    }

    {
        my $str = q:to/EOI/;
        second=2
        hits=42
        perl=6
        EOI

        my $res = KeyValuePairs.parse($str);
        $res.say;
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

        #for @$res -> $p {
        #    #say "Key: {$p.key()}, Value: {$p.value()}";
        #}
    }
}, 'Test key-value pair';

done-testing;
