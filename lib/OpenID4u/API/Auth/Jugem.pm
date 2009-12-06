package OpenID4u::API::Auth::Jugem;
use Any::Moose;
with 'OpenID4u::API::Auth::Role';
use WebService::JugemKey::Auth;

sub _build_api {
    my ($self) = @_;
    WebService::JugemKey::Auth->new(
        {
            api_key => $self->api_key,
            secret  => $self->secret,
        }
    );
}

sub login {
    my ($self, $params) = @_;
    if (my $frob = $params->{frob}) {
        my $user = $self->api->get_token($frob) or return;
        return $user->name;
    }
}

sub login_url {
    my ($self, $args) = @_;
    $self->api->uri_to_login($args);
}

sub find_user {
    my ($self, $username) = @_;
    $self->_try_urls("http://profile.jugemkey.jp/$username");
}

1;
