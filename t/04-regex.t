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
            <scheme> '://' <hostname> [':' <port>]? [<path>]? ['?' <query>]?
        }
        token scheme   { http | https | ftp | sftp }
        token hostname { <-[\/\:]>+ }
        token port     { \d+ }
        token path     { <-[\?]>+ }
        token query    { ( .+ ) }
    }

    class MyURLActions {
        method query($/) {
            make %(
                map { %( .split('=').pairup ) }, $0.split('&')
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
        is $res<query>.made, %(hoge => 'hoge', fuga => 'fuga');

    }, 'With actions';

}, 'Test parsing as Grammar';

done-testing;
