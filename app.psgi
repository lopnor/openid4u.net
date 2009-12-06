use Plack::Builder;
use Plack::Middleware::Static;
use Plack::Middleware::ReverseProxy;

use OpenID4u;

my $app = OpenID4u->new;
$app->setup;

builder {
    enable 'Plack::Middleware::ReverseProxy';
    enable 'Plack::Middleware::Static',
        path => qr{^/(js/|css/|swf/|images?/|imgs?/|static/|[^/]+\.[^/]+$)},
        root => $app->path_to('root')->stringify;

    $app->handler;
};
