<?= raw_string qq(<\?xml version="1.0" encoding="UTF-8"?\>) ?>
<xrds:XRDS
        xmlns:xrds="xri://$xrds"
        xmlns:openid="http://openid.net/xmlns/1.0"
        xmlns="xri://$xrd*($v*2.0)">
    <XRD>
        <Service priority="0">
            <Type>http://specs.openid.net/auth/2.0/signon</Type>
            <URI><?= $c->uri_for('/server') ?></URI>
            <LocalID><?= $s->{user}->identity ?></LocalID>
        </Service>
    </XRD>
</xrds:XRDS>
