package OpenID4u::API::Auth::Hatena;
use Any::Moose;
with 'OpenID4u::API::Auth::Role';
use Hatena::API::Auth;

sub _build_api {
    my ($self) = @_;
    Hatena::API::Auth->new(
        {
            api_key => $self->api_key,
            secret  => $self->secret,
        }
    );
}

sub login {
    my ($self, $params) = @_;

    if (my $cert = $params->{cert}) {
        my $user = $self->api->login($cert) or return;
        return $user->name;
    }
}

sub login_url {
    my ($self) = @_;
    $self->api->uri_to_login;
}

sub find_user {
    my ($self, $username) = @_;
    $self->_try_urls("http://www.hatena.ne.jp/$username/");
}

1;
