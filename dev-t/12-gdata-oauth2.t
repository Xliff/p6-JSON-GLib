use v6.c;

use JSON::GLib::Raw::Types;
use JSON::GLib::Parser;
use JSON::GLib::Object;

my $data;

my $p = JSON::GLib::Parser.new;
say $p.load-from-data($data);
if $ERROR {
  $ERROR.gist.say;
  $ERROR.message.say;
  exit;
}

$p.root.say;
$p.root.is-null.say;
$p.root.node-type.say;
$p.root.object.member-names.gist.say;
$p.root.object.get-values.map( *.value.value ).gist.say;
$data.chars.say;

INIT {
  $data = q:to/JSON/;
    {
      "access_token" : "ya29.a0AfB_byDAqxLdxUe-0D71YXfNHIKXn3pEg8I5ms8IvUR49s8tAvauk1sPij9g2z0CL8K_grQF8EsE0ASujwDp4NYeY6RBIEa6CGloOsLXOjDe6tLtyFZynvcie4b5uwWu2x3ljWvpBiGdLGkMxa8b26ehWFzvz07t0qwEaCgYKAfwSARESFQHGX2Mi2NiQ-uBS-iRjZjMCs-uOgA0171",
      "expires_in" : 3599,
      "scope" : "https://www.googleapis.com/auth/calendar",
      "token_type" : "Bearer"
    }
    JSON
}
