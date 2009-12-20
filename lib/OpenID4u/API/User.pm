package OpenID4u::API::User;
use Any::Moose;
use OpenID4u::Types;
use URI;

our $BASE_URI;

has base_uri => ( 
    is => 'ro', 
    isa => 'OpenID4u::Types::URI', 
    required => 1,
    lazy_build => 1,
    coerce => 1,
);

sub _build_base_uri { $BASE_URI }

has service => ( 
    is => 'ro', 
    isa => 'Str', 
    required => 1,
    lazy_build => 1,
);

sub _build_service {
    my ($self) = @_;
    my $path = $self->identity->path;
    my ($service) = $path =~ m{^/([^/]+)/};
    return $service;
}

has username => ( 
    is => 'ro', 
    isa => 'Str', 
    required => 1, 
    lazy_build => 1,
);

sub _build_username {
    my ($self) = @_;
    my $path = $self->identity->path;
    my ($username) = $path =~ m{^/[^/]+/([^/]+)/};
    return $username;
}

has identity => (
    is => 'ro',
    isa => 'OpenID4u::Types::URI',
    required => 1,
    lazy_build => 1,
    coerce => 1,
);

sub _build_identity {
    my ($self) = @_;
    my $path = sprintf("/%s/%s/", $self->service, $self->username);
    URI->new_abs($path, $self->base_uri);
}

1;
