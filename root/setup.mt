? extends 'base';

? block body => sub {
<div class="prompt">
    <?= $s->{trust_root} ?> is asking permission. <br>
    Will you pass the ID? 
</div>
<dl>
    <dt>trust_root</dt>
    <dd><?= $s->{trust_root} ?></dd>
    <dt>Your Identity</dt>
    <dd><?= $s->{identity} ?></dd>
    <dt>return_to</dt>
    <dd><?= $s->{return_to} ?></dd>

<form method="post">
    <input type="submit" name="yes" value="Yes">
    <input type="submit" name="no" value="No">
</form>
? };
