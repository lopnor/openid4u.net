package OpenID4u;
use Ark;

our $VERSION = '0.01';

use_plugins qw{
    Session
    Session::State::Cookie
    Session::Store::Memory
};

1;
