package OpenID4u::API::Auth::Livedoor;
use Any::Moose;
with 'OpenID4u::API::Auth::Role';
use WebService::Livedoor::Auth;

sub _build_api {
    my ($self) = @_;
    WebService::Livedoor::Auth->new(
        {
            app_key => $self->api_key,
            secret  => $self->secret,
        }
    );
}

sub login {
    my ($self, $params) = @_;
    if ($params->{sig}) {
        if (my $user = $self->api->validate_response($params)) {
            $self->api->get_livedoor_id($user);
        }
    }
}

sub login_url {
    my ($self) = @_;
    $self->api->uri_to_login( perms => 'id' );
}

sub find_user {
    my ($self, $username) = @_;
    $self->_try_urls("http://profile.livedoor.com/$username");
}

1;
