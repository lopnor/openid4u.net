package OpenID4u::API::Auth;
use Any::Moose;

has [qw/facebook flickr hatena jugem livedoor/] => (
    is => 'ro',
    isa => 'HashRef',
    required => 1,
);

for my $method (qw(login login_url find_user)) {
    __PACKAGE__->meta->add_method(
        $method, 
        sub {
            my ($self, $service, $args) = @_;
            $service = lc $service;
            my $class = $self->get_impl($service) or return;
            return $class->new($self->$service)->$method($args);
        }
    );
}

sub get_impl {
    my ($self, $service) = @_;
    my $class = join('::', __PACKAGE__, ucfirst($service));
    Any::Moose::load_class($class) unless Any::Moose::is_class_loaded($class);
    return $class;
}

1;
