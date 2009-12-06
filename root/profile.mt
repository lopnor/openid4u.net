? extends 'base';

? block head => sub {
        <meta http-equiv="X-XRDS-Location" content="http://openid4u.net/signon.xrds" />
? };

? block body => sub {
            <div class="prompt">
                This is openid identity page for <?= $stash->{username} ?> from <?= $stash->{service} ?>.<br />
                More informations may be found at the url below.
            </div>
            <ul>
                <li><a href="<?= $stash->{url} ?>"><?= $stash->{url} ?></a>
            </ul>
? };
