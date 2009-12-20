package OpenID4u::Model::OpenID;
use Ark 'Model::Adaptor';
use YAML 'LoadFile';

__PACKAGE__->config(
    class => 'OpenID4u::API::OpenID',
    args => LoadFile(OpenID4u->path_to('config.yaml'))->{openid},
    deref => 1,
);

1;
