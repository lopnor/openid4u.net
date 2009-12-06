package OpenID4u::API::Auth::Role;
use Any::Moose '::Role';
use LWP::UserAgent;

requires '_build_api', 'login', 'login_url', 'find_user';

has [qw/api_key secret/] => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has api => (
    is => 'ro',
    isa => 'Object',
    required => 1,
    lazy_build => 1,
);

has ua => (
    is => 'ro',
    isa => 'LWP::UserAgent',
    required => 1,
    default => sub {
        LWP::UserAgent->new(
            agent => 'Mozilla/5.0',
            requests_redirectable => [],
        )
    },
);

sub _try_urls {
    my ($self, @urls) = @_;
    for (@urls) {
        my $res = $self->ua->head($_);
        return $res->header('Location') if $res->is_redirect;
        return $_ if $res->is_success;
    }
}

1;
