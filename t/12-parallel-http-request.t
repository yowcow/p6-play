use v6;
use HTTP::Request;
use HTTP::UserAgent;
use Test;
use URI;

my Str @urls =
    "http://www.beaconsco.com/",
    "http://bo.beaconsco.com/",
    "http://ho.beaconsco.com/";

my @p = (for @urls -> $url {
    my URI $uri .= new($url);

    start {
        say "Making request to {$uri}...";

        my HTTP::UserAgent $ua .= new;
        my HTTP::Request  $req .= new(GET => $uri);
        my HTTP::Response $res  = $ua.request($req);

        say "Got response from $uri with status code: {$res.code}";

        "URL: $url (Code: {$res.code})";
    }
});

await @p;

my @results = @p>>.result;

is @results.elems, 3, 'Got 3 responses';

done-testing;
