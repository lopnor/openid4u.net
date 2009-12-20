? extends 'base';

? block head => sub {
        <style type="text/css">
        a.login {
            display: block;
            float: left;
            text-indent: -9999px;
            padding: 5px;
            margin: 20px 15px;
            width: 200px;
            height: 50px;
            border: 1px solid #ccc;
        }
        #livedoor_login {
            background: url(/images/livedoor.png) no-repeat;
            background-position: center center;
        }
        #hatena_login {
            background: url(/images/hatena.png) no-repeat;
            background-position: center center;
        }
        #jugem_login {
            background: url(/images/jugemkey.png) no-repeat;
            background-position: center center;
        }
        #flickr_login {
            background: url(/images/flickr.png) no-repeat;
            background-position: center center;
        }
        #facebook_login {
            background: url(/images/facebook.png) no-repeat;
            background-position: center center;
        }
        </style>
? };

? block body => sub {
            <div class="prompt">Select login method.</div>
            <div class="options">
? for (qw(facebook flickr livedoor hatena jugem)) {
            <a class="login" 
                id="<?= $_ ?>_login" 
                href="<?= $c->uri_for('/login', $_) ?>">login with <?= $_ ?> ID</a>
? }
            </div>
? };
