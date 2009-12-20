? extends 'base';

? block head => sub {
        <link rel="openid.server" href="<?= $c->uri_for('/server') ?>" />
        <link rel="openid2.provider" href="<?= $c->uri_for('/server') ?>" />
        <meta http-equiv="x-xrds-location" content="<?= $c->uri_for('/signon_xrds', $s->{service} , $s->{username} ) ?>" />

? };

? block body => sub {
            <div class="prompt">
                This is openid identity page for <?= $s->{username} ?> from <?= $s->{service} ?>.<br />
                More informations may be found at the url below.
            </div>
            <ul>
                <li><a href="<?= $s->{url} ?>"><?= $s->{url} ?></a>
            </ul>
? };
