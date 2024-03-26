use v6.c;

use Test;

use GLib::GList;
use JSON::GLib::Raw::Types;
use JSON::GLib::Array;
use JSON::GLib::Node;
use JSON::GLib::Object;

subtest 'Empty Array', {
  my $a = JSON::GLib::Array.new;

  is  $a.elems, 0,   'Array count is 0';
  nok $a.elements,   'Array has no elements';
}

subtest 'Adding Array elements', {
  my $a = JSON::GLib::Array.new;
  my $n = JSON::GLib::Node.new(JSON_NODE_NULL);

  is  $a.elems,                       0, 'Starting with an empty array';

  $a.add-element($n);
  is  $a.elems,                       1, 'Array contains one element';

  $n = $a[0];
  is  $n.node-type,      JSON_NODE_NULL, 'First element is a NULL node';

  $a.add-int-element(42);
  is  $a.elems,                       2, 'Array contains two elements';
  is  $a.get-int-element(1),         42, 'Array[1] is 42';

  $a.add-double-element(3.14);
  is  $a.elems,                       3, 'Array contains three elements';
  ok  $a.get-double-element(2) ≅ 3.14,   'Array[2] is 3.14 (within reason)';

  $a.add-boolean-element(True);
  is  $a.elems,                       4, 'Array contains four elements';
  ok  $a.get-boolean-element(3),         'Array[3] contains a boolean True value';

  $a.add-string-element("Hello");
  is  $a.elems,                       5, 'Array contains five elements';
  is  $a.get-string-element(4), 'Hello', 'Array[4] contains the string "Hello"';
  $a.add-string-element;
  nok $a.get-string-element(5),          'Array[5] is NULL';
  ok $a.get-element(5).defined,          'Array[5] is not a NULL JsonNode';
  ok $a.get-null-element(5),             'Array[5] contains a JsonNode that is NULL';

  $a.add-array-element;
  nok $a.get-array-element(6),           'Array[6] contains a NULL element';
  ok  $a.get-null-element(6),            '.get-null-element(6) also returns NULL';

  $a.add-object-element(JSON::GLib::Object.new);
  ok  $a.get-object-element(7),          'Array[7] does contains a non-NULL element';

  $a.add-object-element;
  nok $a.get-object-element(8),          'Array[8] contains a NULL element';
  ok  $a.get-null-element(8),            '.get-null-element(8) also returns NULL';
}

subtest 'Removing Array elements', {
  my $a = JSON::GLib::Array.new;
  my $n = JSON::GLib::Node.new;

  $a.add-element($n);
  $a.remove-element(0);

  nok $a.elems, 'Array contains no elements after add+remove operation';
}

{
  use NativeCall;

  class TestForeachFixture is repr<CStruct> {
    has GList $!elements;
    has gint  $.n_elements is rw;
    has gint  $.iterations is rw;

    method elements is rw {
      Proxy.new:
        FETCH => -> $             { $!elements },
        STORE => -> $, GList() \l { $!elements := l };
    }

  }

  my @type-verify = (
    [ G_TYPE_INT64  , JSON_NODE_VALUE ],
    [ G_TYPE_BOOLEAN, JSON_NODE_VALUE ],
    [ G_TYPE_STRING , JSON_NODE_VALUE ],
    [ G_TYPE_INVALID, JSON_NODE_NULL  ]
  );

  subtest 'Test Foreach Elements', {
    my $a = JSON::GLib::Array.new;
    my $f = TestForeachFixture.new;

    $a.add($_) for 42, True, 'hello', Nil;
    my $e = $a.elements(:glist);
    $f.elements = $e.GList;
    ok $f.elements.defined, 'Array has elements';

    $f.n_elements = $a.elems;
    is $f.n_elements, $e.elems, 'Fixture and element counts agree';

    $f.iterations = 0;
    $a.foreach-element(-> *@a {
      # CATCH { default { .message.say } }
      my $fix-data = cast(TestForeachFixture, @a[* - 1]);
      my $list = GLib::GList.new($fix-data.elements);
      my $node = JSON::GLib::Node.new( @a[2] );
      my $i = @a[1];
      ok $list.find($node.JsonNode.p),              "Found element in iteration { $i }";
      is $node.node-type,  @type-verify[$i][1],     "Node types are correct in iteration { $i }";
      is $node.value-type, @type-verify[$i][0].Int, "Value types are correct in iteration { $i }";
      $fix-data.iterations++;
    }, cast(Pointer, $f) );

    is $f.iterations, $f.n_elements, 'Went the proper number of iterations';
  }
}
