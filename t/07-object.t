use v6.c;

use Test;

use JSON::GLib::Raw::Types;

use JSON::GLib::Node;
use JSON::GLib::Object;

subtest 'Empty Object', {
  my $o = JSON::GLib::Object.new;

  is  $o.size,        0, 'Object has no members at start';
  nok $o.get-members,    'Object members list returns Falsy';
}

subtest 'Add Member', {
  my  $o = JSON::GLib::Object.new;
  my  $n = JSON::GLib::Node.new( :null );

  is  $o.size,        0, 'Object has no members at start';
  $o.set-member('Null', $n);
  is  $o.size,        1, 'Object has 1 member after adding Null => Nil';

  my $no = $o.get-member('Null');
  is $no.node-type, JSON_NODE_NULL, "Value at member 'Null' is undefined";
}

subtest 'Set Member', {
  my  $o = JSON::GLib::Object.new;
  my  $n = JSON::GLib::Node.init-string('Hello');

  is      $o.size,               0, 'Object has no members at start';
  $o.set-member('String', $n);
  is      $o.size,               1, "Object has 1 member after adding 'String' => 'Hello' ";

  $n = $o.get-member('String');
  is $n.node-type, JSON_NODE_VALUE, "Retrieved node from 'String' is a VALUE node";
  is                     $n.string, 'Hello', "Value node contains the value 'Hello'";

  $n.string = 'World';
  diag 'After setting node contents to "World"';
  is $n.node-type, JSON_NODE_VALUE, "Retrieved node from 'String' is a VALUE node";
  is                     $n.string, 'World', "Value node contains the value 'World'";

  diag 'After setting node contents to "Goodbye"';
  $n.string = 'Goodbye';
  is                     $n.string, 'Goodbye', "Value node contains the value 'Goodbye'";

  diag 'NULL content checks';
  $o.set-member('Array', JsonArray);
  $n = $o.get-member('Array');
  is $n.node-type, JSON_NODE_NULL, "Retrieved node from 'Array' is a NULL node";

  $o.set-member('Object', JsonObject);
  $n = $o.get-null-member('Object');
  ok $n,                           "Retrieved node from 'Object' is a NULL node";

  $o.set-member('',  Nil);
  $n = $o.get-null-member('');
  ok $n,                           "Retrieved node from 'Object' is a NULL node";
}

# Skipping test_get_member_default as routines now deprecated!

subtest 'Remove Member', {
  my  $o = JSON::GLib::Object.new;
  my  $n = JSON::GLib::Node.new(JSON_NODE_NULL);

  $o.set-member('Null', $n);
  $o.remove-member('Null');

  is $o.size, 0, 'Object has no members after Add/Remove operation';
}

sub create-test-object {
  my $o = JSON::GLib::Object.new;

  $o.set_member(.[0], .[1]) for
    ('integer', 42),     ('boolean', True), ('string', 'hello'),
    ('double', 3.14159), ('null', Nil),     ('', 0);
  $o;
}

{
  use NativeCall;

  use GLib::Roles::Pointers;

  class TestForeachFixture is repr<CStruct> does GLib::Roles::Pointers {
    has gint $.n-members is rw;
  }

  my %verify = (
    integer => { type => JSON_NODE_VALUE, gtype => G_TYPE_INT64.Int   },
    boolean => { type => JSON_NODE_VALUE, gtype => G_TYPE_BOOLEAN.Int },
    string  => { type => JSON_NODE_VALUE, gtype => G_TYPE_STRING.Int  },
    double  => { type => JSON_NODE_VALUE, gtype => G_TYPE_DOUBLE.Int  },
    null    => { type => JSON_NODE_NULL,  gtype => G_TYPE_INVALID.Int },
    ''      => { type => JSON_NODE_VALUE, gtype => G_TYPE_INT64.Int   }
  );

  sub verify-foreach ($o, $mn, $n is copy, $ud is copy) {
    CATCH { default { .message.say } }

    $n = JSON::GLib::Node.new($n);
    $ud = cast(TestForeachFixture, $ud);

    is $n.node-type,   %verify{$mn}<type>,  "Node type '$mn' matches type of " ~ %verify{$mn}<type>;
    is $n.value-type, %verify{$mn}<gtype>, "Node GType '$mn' matches type of " ~ %verify{$mn}<gtype>;
    $ud.n-members++;
  }

  subtest 'Test Foreach', {
    my $o = create-test-object;
    my $f = TestForeachFixture.new;
    $o.foreach-member(&verify-foreach, $f.p);

    is $f.n-members, $o.size, 'Iterated proper number of times through foreach!';
  }

  subtest 'Test Iter', {
    my $i = (my $o = create-test-object).iter;

    my $f = TestForeachFixture.new;
    while $i.next -> $io {
      verify-foreach($o, $io[0], $io[1].JsonNode, $f.p)
    }

    is $f.n-members, $o.size, 'Iterated proper number of times through foreach!';
  }

}

subtest 'Empty Member', {
  my $o = JSON::GLib::Object.new;

  $o.set-string-member('string', '');
  ok $o.has-member('string'),             'Object retains null member "string"';
  is $o.get-string-member('string'), '',  'Member "string" is the null string';

  $o.set-string-member('null', Str);
  ok $o.has-member('null'),               "Object retains null member 'null'";
  is $o.get-string-member('null'),   Str, 'Member "null" is Nil';

  $o.set-null-member('array');
  is $o.get-array-member('array'),   Nil, 'Member "array" is Nil';

  $o.set-object-member('object', JsonObject);
  ok $o.get-member('object'),             "Retrieved member 'object' is NOT Nil";
  is $o.get-object-member('object'), Nil, 'Retrieved object member is Nil'
}
