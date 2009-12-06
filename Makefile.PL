use inc::Module::Install;
name 'OpenID4u';
all_from 'lib/OpenID4u.pm';

requires 'Ark';
requires 'Hatena::API::Auth';
requires 'WWW::Facebook::API';
requires 'Flickr::API';
requires 'XML::Parser::Lite::Tree::XPath';
requires 'WebService::JugemKey::Auth';
requires 'WebService::Livedoor::Auth';

tests 't/*.t';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
