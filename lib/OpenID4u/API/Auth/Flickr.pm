package OpenID4u::API::Auth::Flickr;
use Any::Moose;
with 'OpenID4u::API::Auth::Role';
use Flickr::API;
use XML::Parser::Lite::Tree::XPath;

sub _build_api {
    my ($self) = @_;
    Flickr::API->new(
        {
            key => $self->api_key,
            secret => $self->secret,
        }
    );
}

sub login {
    my ($self, $params) = @_;
    if (my $frob = $params->{frob}) {
        my $res = $self->api->execute_method(
            'flickr.auth.getToken',
            {frob => $frob}
        );
        if ($res->{success}) {
            my $xpath = XML::Parser::Lite::Tree::XPath->new($res->{tree});
            my ($user) = @{$xpath->select_nodes('/auth/user')};
            my $name = ($user->{attributes}->{username} || $user->{attributes}->{nsid});
            return $name;
        }
    }
}

sub login_url {
    my ($self) = @_;
    $self->api->request_auth_url('read');
}

sub find_user {
    my ($self, $username) = @_;
    my $res = $self->api->execute_method(
        'flickr.people.findByUsername',
        { username => $username },
    );
    if ($res->{success}) {
        my $xpath = XML::Parser::Lite::Tree::XPath->new($res->{tree});
        my ($user) = @{$xpath->select_nodes('/user')};
        my $nsid = $user->{attributes}->{nsid};
        $res = $self->api->execute_method(
            'flickr.urls.getUserPhotos',
            { user_id => $nsid },
        );
        $xpath = XML::Parser::Lite::Tree::XPath->new($res->{tree});
        ($user) = @{$xpath->select_nodes('/user')};
        return $user->{attributes}->{url};
    }
}

1;
