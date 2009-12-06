package OpenID4u::API::Auth::Facebook;
use Any::Moose;
with 'OpenID4u::API::Auth::Role';
use WWW::Facebook::API;

sub _build_api {
    my ($self) = @_;
    WWW::Facebook::API->new(
        api_key => $self->api_key,
        secret => $self->secret,
        desktop => 0,
    );
}

sub login {
    my ($self, $params) = @_;
    if (my $token = $params->{auth_token}) {
        $self->api->auth->get_session($token);
        return delete $self->api->{session_uid};
    }
}

sub login_url {
    my ($self) = @_;
    $self->api->get_login_url;
}

sub find_user {
    my ($self, $username) = @_;
    return $self->_try_urls("http://www.facebook.com/profile.php?id=$username");
}

1;
