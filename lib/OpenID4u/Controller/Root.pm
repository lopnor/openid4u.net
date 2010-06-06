package OpenID4u::Controller::Root;
use Ark 'Controller';
use OpenID4u::API::User;

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

    $OpenID4u::API::User::BASE_URI = $c->uri_for('/')->as_string;

    my $model = $c->model('Auth');
    my $user = $model->login($service, $c->req->parameters->mixed);
    unless ($user) {
        my $url = $model->login_url(
            $service, 
            {callback_url => $c->uri_for("/login/$service/")}, # for jugem
        );
        return $c->redirect($url);
    }
    $c->session->set(user => $user);
    $c->redirect($c->session->remove('next_uri') || $user->identity);
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

sub server_xrds :Local :Args(0) {
    my ($self, $c) = @_;
    $c->res->content_type('application/xrds+xml');
}

sub signon_xrds :Local :Args(0) {
    my ($self, $c) = @_;
    $c->res->content_type('application/xrds+xml');
}

sub server :Local :Args(0) {
    my ($self, $c) = @_;
    my $user = $c->session->get('user');
    my $model = $c->model('OpenID');
    my $q = $c->req->parameters->mixed;
    my ($type, $data) = $model->handle_request($q, $user);
    if ($type eq 'redirect') {
        unless ($user) {
            $c->session->set(next_uri => $c->req->uri);
            return $c->redirect($c->uri_for('/login', $model->find_service($q)));
        }
        if ({ URI->new($data)->query_form() }->{'openid.mode'} eq 'id_res') {
            $c->session->set(next_uri => $data);
            $c->session->set(query => $q);
            return $c->redirect($c->uri_for('setup'));
        }
        return $c->redirect($data);
    } elsif ( $type eq 'setup' ) {
        unless ($user) {
            $c->session->set(next_uri => $c->req->uri);
            return $c->redirect($c->uri_for('/login', $model->find_service($q)));
        }
        $c->session->set(query => $q);
        $c->redirect($c->uri_for('setup'));
    } else {
        $c->res->content_type( $type );
        $c->res->body( $data );
    }
}

sub setup :Local :Args(0) {
    my ($self, $c) = @_;
    my $model = $c->model('OpenID');
    my $user = $c->session->get('user');
    my $q = $c->session->get('query');
    unless ($user) {
        $c->session->set(next_uri => $c->req->uri);
        return $c->redirect($c->uri_for('/login', $model->find_service($q)));
    }
    unless ($model->is_identity($q, $user)) {
        $c->session->remove('user');
        $c->res->code(403);
        $c->res->body('different user!');
        return;
    }
    if ($c->req->method eq 'POST') {
        $c->session->remove('query');
        $c->session->remove('user');
        my $url =  $c->session->remove('next_uri') if $c->req->param('yes');
        $url ||= $model->return_url(
            sign => $c->req->param('yes') ? 1 : 0,
            query => $q,
            user => $user,
        );
        return $c->redirect($url);
    }
    $c->stash(
        {
            trust_root => $q->{'openid.trust_root'} || $q->{'openid.realm'},
            identity => $user->identity,
            claimed_id => $q->{'openid.claimed_id'},
            return_to => $q->{'openid.return_to'},
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
