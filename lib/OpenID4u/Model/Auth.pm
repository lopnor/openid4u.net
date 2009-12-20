package OpenID4u::Model::Auth;
use Ark 'Model::Adaptor';
use YAML qw/LoadFile/;

__PACKAGE__->config(
    class => 'OpenID4u::API::Auth',
    args => LoadFile(OpenID4u->path_to('config.yaml'))->{auth},
    deref => 1,
);

1;
