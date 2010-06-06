package OpenID4u::View::MT;
use Ark 'View::MT';

after 'process' => sub {
    my ($self, $c) = @_;
    unless ($c->res->content_type) {
        $c->res->content_type('text/html; charset=utf-8');
    }
};

1;
