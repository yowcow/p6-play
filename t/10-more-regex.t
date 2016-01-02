use v6;
use Test;

my regex block { ^^ (.+?) <before <:Lu>> };

sub parse(Str $given) returns Array {
    my $result = $given ~~ &block;

    $result ?? [ ~$result, |parse(substr $given, $result.to) ]
            !! [ ~$given ];
}

sub filter(@elems, Int $from = 0) returns Array {

    return @elems if @elems.elems - 1 <= $from;

    if @elems[0] ~~ m{ ^^ <:Lu>+ $$ } && @elems[1] !~~ m{ ^^ <:Lu> <:Ll> } {
        return filter(
            [ @elems[0] ~ @elems[1], |@elems[2..*] ],
            $from + 1
        );
    }
    else {
        return filter(
            @elems,
            $from + 1
        );
    }
}

subtest {
     my @result = parse('FOOBar');

     is @result, [< F O O Bar >];

}, 'Test parse';

subtest {
    my @result = filter([< F O O Bar Foo Bar >]);

    is @result, [< FOO Bar Foo Bar >];

}, 'Test filter';

done-testing;
