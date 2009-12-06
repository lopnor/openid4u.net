package OpenID4u::Controller::Root;
use Ark 'Controller';

has '+namespace' => default => '';

# default 404 handler
sub default :Path :Args {
    my ($self, $c) = @_;

    $c->res->status(404);
    $c->res->body('404 Not Found');
}

sub index :Path :Path('login') :Args(0) {}

sub login :Path('login') :Args(1) {
    my ($self, $c, $service) = @_;

    my $model = $c->model('Auth');
    my $username = $model->login($service, $c->req->params);
    unless ($username) {
        my $url = $model->login_url(
            $service, 
            {callback_url => $c->uri_for("/login/$service/")}, # for jugem
        );
        return $c->redirect($url);
    }
    $c->redirect($c->uri_for($service, $username));
}

sub profile :Regex('^(facebook|flickr|hatena|jugem|livedoor)/(.*)/?$') {
    my ($self, $c, $service, $username) = @_;
    my $model = $c->model('Auth');
    my $url = $model->find_user($service, $username) or $c->detach('default');
    $c->stash(
        {
            service => $service,
            username => $username,
            url => $url,
        }
    );
}

sub end :Private {
    my ($self, $c) = @_;

    unless ($c->res->body or $c->res->status =~ /^3\d\d/) {
        $c->forward( $c->view('MT') );
    }
}

1;
