package OpenID4u::API::OpenID;
use Any::Moose;
use OpenID4u::Types;
use Net::OpenID::Server;
use OpenID4u::API::User;
use URI;

use constant IDENTIFIER_SELECT => 'http://specs.openid.net/auth/2.0/identifier_select';

has server_secret => (
    is => 'ro',
    isa => 'Str',
);

has setup_url => (
    is => 'ro',
    isa => 'OpenID4u::Types::URI',
    coerce => 1,
);

has endpoint_url => (
    is => 'ro',
    isa => 'OpenID4u::Types::URI',
    coerce => 1,
);

sub handle_request {
    my ($self, $params, $user) = @_;
    
    my $nos = $self->_instance($params, $user);
    $nos->handle_page;
}

sub is_identity {
    my ($self, $params, $user) = @_;
    my $nos = $self->_instance($params, $user);
    $nos->is_identity->($user, $params->{'openid.identity'});
}

sub find_service {
    my ($self, $q) = @_;
    my $id = $q->{'openid.identity'};
    if ($id eq IDENTIFIER_SELECT) {
        return;
    }
    my $user = OpenID4u::API::User->new(
        identity => $id,
    ) or return;
    return $user->service;
}

sub return_url {
    my ($self, %params) = @_;
    my $q = $params{query};
    my $user = $params{user};

    my $nos = $self->_instance($q, $user);
    if ($params{sign}) {
        $nos->signed_return_url(
            identity => $nos->get_identity->($user, $q->{'openid.identity'}),
            return_to => $q->{'openid.return_to'},
            trust_root => $q->{'openid.trust_root'},
            assoc_handle => $q->{'openid.assoc_handle'} || '',
            ns => $q->{'ns'} || '',
        );
    } else {
        $nos->cancel_return_url(return_to => $q->{'openid.return_to'});
    }
}

sub _instance {
    my ($self, $params, $user) = @_;

    Net::OpenID::Server->new(
        get_args => $params,
        post_args => $params,
        get_user => sub {$user},
        get_identity => sub {
            my ($user, $url) = @_;
            if ($url eq IDENTIFIER_SELECT) {
                return $user ? $user->identity : ();
            } else {
                return $url;
            }
        },
        is_identity => sub {
            my ($user, $url) = @_;
            $user ? 
            $url eq IDENTIFIER_SELECT ? 1 :
            $url eq $user->identity ? 1 : 0 : 
            0;
        },
        is_trusted => sub {
            my ($user, $url, $is_identity) = @_;
            $is_identity;
        },
        server_secret => $self->server_secret,
        setup_url => $self->setup_url,
        endpoint_url => $self->endpoint_url,
    );
}

1;
