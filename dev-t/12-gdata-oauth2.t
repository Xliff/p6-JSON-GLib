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

