package OpenID4u::Types;
use Any::Moose;
use Any::Moose '::Util::TypeConstraints';
use URI;

subtype 'OpenID4u::Types::URI'
    => as 'URI';

coerce 'OpenID4u::Types::URI'
    => from 'Str'
    => via {URI->new($_)};

1;
