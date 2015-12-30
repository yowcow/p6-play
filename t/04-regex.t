use v6;
use Test;

subtest {

    my Str $str = 'aaabbbcccddd';

    if $str ~~ / ( <[abc]>+ ) / {
        #say $/.WHAT; # Match object
        is $0, 'aaabbbccc';
    }
    else {
        fail 'Should match';
    }

}, 'Test matching chars';

subtest {

    my Str $str = 'Perl6';

    # Lower-case letter OR number
    if $str ~~ m{ \w+ (<:Ll+:N>) } {
        is ~$0, 6;
    }
    else {
        fail 'Should match "6"';
    }

}, 'Combination of unicode properties';

subtest {

    ok !Bool('a'     ~~ / a ** 2..4 /);
    ok Bool('aa'     ~~ / a ** 2..4 /);
    ok Bool('aaa'    ~~ / a ** 2..4 /);
    ok Bool('aaaa'   ~~ / a ** 2..4 /);
    ok Bool('aaaaa'  ~~ / a ** 2..4 /);

}, 'Test quantifier';

subtest {

    ok Bool('There were a young man' ~~ / man $$ /);
    ok !Bool('There were a young man' ~~ / ^^ man /);

    ok Bool('There were' ~~ m:i/ ^^ there /);
    ok !Bool('There were' ~~ m:i/ there $$ /);
}, 'Test anchors';

subtest {

    subtest {

        if 'abc' ~~ / ( a || b ) (c) / {
            is ~$0, 'b';
            is ~$1, 'c';
        }
        else {
            fail 'Should match';
        }

    }, 'Capturing';

    subtest {

        if 'abc' ~~ / [ a || b ] (c) / {
            is ~$0, 'c';
        }
        else {
            fail 'Should match';
        }

    }, 'Non-capturing';

}, 'Test capturing/non-capturing grouping';

subtest {

    my $str = 'The quick brown fox';

    ok Bool($str ~~ /own >>/);
    ok !Bool($str ~~ /<< own/);

}, 'Test boundary';

subtest {
    my Str $url = 'http://hogehoge.com/path/to/something';

    if $url ~~ / ^ http\:\/\/ ( <-[\/]>+ ) \/ (.+) / {
        is $0, 'hogehoge.com';
        is $1, 'path/to/something';
    }
    else {
        fail 'Should match';
    }

}, 'Test matching non-char';

subtest {

    grammar MyURL {
        token TOP {
            <scheme> '://' <hostname> [':' <port>]? [<path>]? ['?' <query>]? ['#' <hoge>]?
        }
        token scheme   { http | https | ftp | sftp }
        token hostname { <-[\/\:]>+ }
        token port     { \d+ }
        token path     { <-[\?]>+ }
        token query    { <-[\#]>+ }
        token hoge     { .+ }
    }

    class MyURLActions {
        method query($/) {
            make %(
                map { %( .split('=').pairup ) }, $/.split('&')
            );
        }
    }

    subtest {
        my $url = 'http://hogefuga.com';

        my $res = MyURL.parse($url);

        is $res<scheme>,    'http';
        is $res<hostname>,  'hogefuga.com';
        is $res<port>,      Nil;
        is $res<path>,      Nil;
        is $res<query>,     Nil;

    }, 'Simple URL';

    subtest {
        my $url = 'http://hogefuga.com:8080/path/to/hoge?hoge=hoge&fuga=fuga';

        my $res = MyURL.parse($url);

        is $res<scheme>,    'http';
        is $res<hostname>,  'hogefuga.com';
        is $res<port>,      '8080';
        is $res<path>,      '/path/to/hoge';
        is $res<query>,     'hoge=hoge&fuga=fuga';

    }, 'Complex URL';

    subtest {
        my $url = 'http://hogefuga.com:8080/path/to/hoge?hoge=hoge&fuga=fuga';

        my $res = MyURL.parse($url, actions => MyURLActions.new);

        is $res<scheme>,     'http';
        is $res<query>,      'hoge=hoge&fuga=fuga';
        is $res<query>.made, { hoge => 'hoge', fuga => 'fuga' };

    }, 'With actions';

}, 'Test parsing as Grammar';

done-testing;
