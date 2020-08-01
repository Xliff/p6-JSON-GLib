use v6.c;

use Test;

use JSON::GLib::Raw::Types;

use JSON::GLib::Array;
use JSON::GLib::Generator;
use JSON::GLib::Node;
use JSON::GLib::Object;
use JSON::GLib::Parser;

constant LC_NUMERIC = 1;

my  $empty-array  = '[]';
my  $empty-object = '{}';
my $simple-array  = '[true,false,null,42,"foo"]';
my $nested-array  = '[true,[false,null],42]';

my $simple-object =
  '{"Bool1":true,"Bool2":false,"Null":null,"Int":42,"":54,"String":"foo"}';

# taken from the RFC 4627, Examples section
my $nested-object = '{'                                 ~
  '"Image":{'                                           ~
    '"Width":800,'                                      ~
    '"Height":600,'                                     ~
    '"Title":"View from 15th Floor",'                   ~
    '"Thumbnail":{'                                     ~
      '"Url":"http://www.example.com/image/481989943",' ~
      '"Height":125,'                                   ~
      '"Width":"100"'                                   ~
    '},'                                                ~
    '"IDs":[116,943,234,38793]'                         ~
  '}'                                                   ~
'}';

my @pretty-examples = (
  "[\n]",
  "\{\n\}",
  "[\n"              ~
    "\ttrue,\n"      ~
    "\tfalse,\n"     ~
    "\tnull,\n"      ~
    "\t\"hello\"\n"  ~
  ']',
  "\{\n"                  ~
    "\t\"foo\" : 42,\n"   ~
    "\t\"bar\" : true,\n" ~
    "\t\"baz\" : null\n"  ~
  '}'
);

my @decimal-separators = (
   C => { sep => '.', matches => True  },
  de => { sep => ',', matches => False },
  en => { sep => '.', matches => True  },
  fr => { sep => ',', matches => False }
);

sub do-checks ($d, $m) {
  say "checking '$d' (expected '$m')" if %*ENV<JSON-GLIB-VERBOSE>;

  is $d.chars, $m.chars, 'Generated data is the expected length';
  is       $d,       $m, 'Generated data is the proper serialization';
}

subtest 'Empty Array', {
  my $gen = JSON::GLib::Generator.new;
  my $root = JSON::GLib::Node.new(JSON_NODE_ARRAY);
  $root.take-array( JSON::GLib::Array.new );
  $gen.root = $root;

  ($gen.pretty, $gen.indent) = (False, 0);
  $gen.indent-char = ' ';
  my $d = $gen.to-data;

  is            $d.chars,     $empty-array.chars, 'Generated data is the expected length';
  is                  $d,           $empty-array, 'Generated data is the proper serialization';
  is      $gen.pretty.so,                  False, 'Generator Pretty attribute set to False';
  is         $gen.indent,                      0, 'Generator returns 0 indent level';
  is    $gen.indent-char,                ' '.ord, 'Generator indent char is a space';
}

subtest 'Empty Object', {
  my $gen = JSON::GLib::Generator.new;
  my $root = JSON::GLib::Node.new(JSON_NODE_OBJECT);
  $root.take-object( JSON::GLib::Object.new );
  ($gen.root, $gen.pretty) = ($root, False);

  do-checks($gen.to-data, $empty-object);
}

subtest 'Simple Array', {
  my $gen   = JSON::GLib::Generator.new;
  my $root  = JSON::GLib::Node.new(JSON_NODE_ARRAY);
  my $array = JSON::GLib::Array.new(:sized, 5);

  $array.add($_) for True, False, Nil, 42, 'foo';
  $root.take-array($array);
  ($gen.root, $gen.pretty) = ($root, False);

  do-checks(~$gen, $simple-array);
}

subtest 'Nested Array', {
  my $gen   = JSON::GLib::Generator.new;
  my $root  = JSON::GLib::Node.new(JSON_NODE_ARRAY);
  my $array = JSON::GLib::Array.new(:sized, 3);

  $array.add(True);
  {
    my $nested = JSON::GLib::Array.new(:sized, 2);
    $nested.add($_) for False, Nil;
    $array.add($nested);
  }
  $array.add(42);

  $root.take-array($array);
  ($gen.root, $gen.pretty) = ($root, False);

  do-checks(~$gen, $nested-array);
}

subtest 'Simple Object', {
  my $gen    = JSON::GLib::Generator.new;
  my $root   = JSON::GLib::Node.new(JSON_NODE_OBJECT);
  my $object = JSON::GLib::Object.new;

  $object.set-member(.key, .value) for Bool1 =>  True,
                                       Bool2 => False,
                                        Null =>   Nil,
                                         Int =>    42,
                                          '' =>    54,
                                      String => 'foo';

  $root.take-object($object);
  ($gen.root, $gen.pretty) = ($root, False);
  my $d = ~$gen;

  do-checks(~$gen, $simple-object);
}

subtest 'Nested Object', {
  my $gen    = JSON::GLib::Generator.new;
  my $root   = JSON::GLib::Node.new(JSON_NODE_OBJECT);
  my $object  = JSON::GLib::Object.new;

  $object.set-member(.key, .value) for Width  => 800,
                                       Height => 600,
                                       Title  => 'View from 15th Floor';

  {
    my $nested = JSON::GLib::Object.new;
    $nested.set-member(.key, .value) for Url    => 'http://www.example.com/image/481989943',
                                         Height => 125,
                                         Width  => 100.Str;

    $object.set-member('Thumbnail', $nested);
  }

  {
    my $array = JSON::GLib::Array.new;
    $array.add($_) for 116, 943, 234, 38793;
    $object.set-member('IDs', $array);
  }

  my $nested = JSON::GLib::Object.new;
  $nested.set-member('Image', $object);

  $root.take-object($nested);
  ($gen.root, $gen.pretty) = ($root, 0);

  do-checks(~$gen, $nested-object);
}

subtest 'Decimal Separator', {
  my $n   = JSON::GLib::Node.new(JSON_NODE_VALUE);
  my $gen = JSON::GLib::Generator.new;

  sub setlocale (int32, Str)
    returns Str
    is native
  { * }

  my $old-locale = setlocale(LC_NUMERIC, Str);
  ($n.double, $gen.root) = (3.14, $n);

  for @decimal-separators {
    setlocale(LC_NUMERIC, .key);

    my $s = ~$gen;
    say "DecimalSeparatorSubtest: value: { $n.double.fmt('%.2f') } - string '{ $s }'"
      if %*ENV<JSON-GLIB-VERBOSE>;

    ok $s, 'Generated string is defined';
    is $s.contains( .value<sep> ), .value<matches>, "Separator for { .key } meets match requirement";
  }
  setlocale(LC_NUMERIC, $old-locale);
}

subtest 'Double stays Double', {
  my $n   = JSON::GLib::Node.new(JSON_NODE_VALUE);
  my $gen = JSON::GLib::Generator.new;

  ($n.double, $gen.root) = (1, $n);
  is ~$gen, '1.0', 'A double value returns a double-typed node.'
}

subtest 'Pretty', {
  my $n   = JSON::GLib::Node.new(JSON_NODE_VALUE);
  my $gen = JSON::GLib::Generator.new;
  my $p   = JSON::GLib::Parser.new;
  ($gen.pretty, $gen.indent, $gen.indent-char) = (True, 1, "\t");

  for @pretty-examples {
    $p.load-from-data($_);
    my $root = $p.root;

    ok $root, "Root node for parsed '{ .subst(/\n/, '\\n', :g) }' is defined";
    $gen.root = $root;
    do-checks(~$gen, $_);
  }
}

my @string-fixtures = (
  [                        'abc',                 '"abc"' ],
  [                    "a\x7fxc",        "\"a\\u007fxc\"" ],
  [           "a{ 0o033.chr }xc",        "\"a\\u001bxc\"" ],
  [                      "a\nxc",            "\"a\\nxc\"" ],
  [                      "a\\xc",           "\"a\\\\xc\"" ],
  #[ "Barney B\303\244r", "\"Barney B\303\244r\"" ]
  [ "Barney B\xc3\xa4r", "\"Barney B\xc3\xa4r\"" ]
);

subtest 'String Encode', {
  for @string-fixtures {
    my $gen = JSON::GLib::Generator.new;
    my $n  = JSON::GLib::Node.new(JSON_NODE_VALUE);

    $n.string = .[0];
    $gen.root = $n;
    diag .map( *.subst(/\n/, '\\n', :g) ).join('|');
    do-checks(~$gen, .[1]);
  }
}
