use v6.c;

use Test;

use JSON::GLib::Raw::Types;

use GLib::Value;
use JSON::GLib::Node;
use JSON::GLib::Object;

my $n = JSON::GLib::Node.new(JSON_NODE_NULL);
my $c = $n.copy;

sub test-node-copy($t, $a = '', $v = Nil) {
  my $n = JSON::GLib::Node.new($t);

  $n."$a"() = $v if $a && $v;
  my $c = $n.copy;

  is  $n.node-type, $c.node-type,  "({ $t }) Node and copy have same node type ";
  is $n.value-type, $c.value-type, "({ $t }) Node and copy have same value type";
  is  $n.type-name, $c.type-name,  "({ $t }) Node and copy have same type name ";
}

{
  my $n = JSON::GLib::Node.new(JSON_NODE_VALUE);
  $n.int = 42;

  is $n.int, 42, 'JSON node can get and set int value'
}

{
  my $n = JSON::GLib::Node.new(JSON_NODE_VALUE);
  $n.double = 3.14159;

  ok $n.double =~= 3.14159, 'JSON node can get and set a double value';
}

{
  my $n = JSON::GLib::Node.new(JSON_NODE_VALUE);
  $n.boolean = True;

  ok $n.boolean, 'JSON node can get and set a boolean value';
}

{
  my $string = 'Hello World';
  my $n = JSON::GLib::Node.new(JSON_NODE_VALUE);
  $n.string = $string;

  is $n.string, $string, 'JSON node can get and set a string value';
}

{
  test-node-copy(JSON_NODE_NULL);
  test-node-copy(JSON_NODE_VALUE, 'string', 'hello');
}

{
  my $n = JSON::GLib::Node.new(JSON_NODE_OBJECT);
  my $o = JSON::GLib::Object.new;
  my $v = JSON::GLib::Node.new(JSON_NODE_VALUE);
  $v.int = 42;;
  $o.set-member('answer', $v);
  $n.take-object($o);

  my $c = $n.copy;

  is $n.node-type, $c.node-type, 'Constructed object and copy are the same node type';
  is +$n.object.JsonObject.p,
     +$c.object.JsonObject.p,    'Constructed object and copy have same contents';
}

{

  my $n = JSON::GLib::Node.new(JSON_NODE_NULL);
  ok $n.is-null,                        'JSON node holds null object';
  is $n.node-type,      JSON_NODE_NULL, 'JSON node has NULL node-type';
  is $n.value-type, G_TYPE_INVALID.Int, 'JSON node has value type of INVALID';
  is $n.type-name,              'NULL', 'JSON node has type-name of "NULL';
}

{
  my $n = JSON::GLib::Node.new(JSON_NODE_VALUE);

  $n.int = 0;
  is $n.int, 0,        'Node can set and get a value of 0';
  nok $n.get-boolean,  'Node boolean value resolves to FALSE';
  nok $n.is-null,      'Node is not null';

  $n.int = 42;
  is $n.int, 42,       'Node can set and get a value of 42';
  ok $n.double =~= 42, 'Node can retrieve the int value of 42 as a double';
  ok $n.get-boolean,   'Node boolean value resolves to TRUE';
  nok $n.is-null,      'Node is not null';
}

{
  my $n = JSON::GLib::Node.new(JSON_NODE_VALUE);
  $n.double = 3.14;

  ok $n.double =~= 3.14, 'Node can set and get a value of 3.14';
  is $n.int, 3,          'Node can retrieve the int value as 3';
  ok $n.boolean,         'Node boolean value resolves to TRUE';
}

# This test loses its value unless it is LOW LEVEL, hence the long way
# 'round seen inside.
{
  my ($n, $value) = ( JSON::GLib::Node.new(JSON_NODE_VALUE) );

  sub test-value($v, $vt, $vn) {
    $value."$vn"() = $v;

    is $value.type,        $vt, 'Value is of type ' ~ $vt;
    is $value."$vn"(),      $v, 'Value is set to ' ~ $v;

    my $check = $n.value = $value;

    is $value.type,          $check.type, 'Value and check-value have the same type';
    is $value."$vn"(),    $check."$vn"(), 'Value and check-value have the same value';
    is $value.type,                  $vt, 'Check-value has a type of ' ~ $vt;
    is $check."$vn"(),                $v, 'Check-value is set to ' ~ $v;
  }

  is $n.node-type, JSON_NODE_VALUE, 'Node has node-type of VALUE';

  $value = GLib::Value.new(G_TYPE_INT64);
  test-value(42, G_TYPE_INT64, 'int64');
  $value = GLib::Value.new(G_TYPE_STRING);
  test-value('Hello, World!', G_TYPE_STRING, 'string');
}

{
  my ($n, $value) = ( JSON::GLib::Node.new(JSON_NODE_VALUE) );
  is $n.node-type, JSON_NODE_VALUE, 'Created node has node-type of VALUE';

  sub test-value-promote ($v, $pt, $o, $p) {
    $value."$o"() = $v;
    my $check = $n.value = $value;

    is           $check.type,            $pt, 'Checked-value has type of ' ~ $pt;
    is-approx   $check.value,             $v, 0.00001,
                                              'Check-value has the appropriate value, within tolerance';
    isnt         $value.type,    $check.type, 'Value and check-value DO NOT have matching types';
    is-approx  $value."$o"(),  $check."$p"(), 0.00001,
                                              'Value matches check-value, within tolerance';
  }

  $value = GLib::Value.new(G_TYPE_INT);
  test-value-promote(42, G_TYPE_INT64, 'int', 'int64');
  $value = GLib::Value.new(G_TYPE_FLOAT);
  test-value-promote(3.14159, G_TYPE_DOUBLE, 'float', 'double');
}

sub init-node($v, :$all = False) {
  my $m = do given $v.WHAT {
    when Nil  { 'null'     }
    when Rat  { 'double'   }
    when Str  { 'string'   }
    when Num  { 'double'   }
    when Bool { 'boolean'  }
    when Int  { 'int'      }

    # default  {  Can be an error condition }
    default { die "Unknown seal type '$_'" }
  }

  my $rv = $m eq 'null'
    ?? JSON::GLib::Node.init_null
    !! JSON::GLib::Node."init-{ $m }"($v);
  $all.not ?? $rv !! ($rv, $m);
}

{
  sub test-seal ($v) {
    my ($n, $m) = init-node($v, :all);

    nok $n.is-immutable, "$m node starts as mutable";
    $n.seal;
    ok $n.is-immutable, "$m node immutable after .seal()";
  }

  test-seal(1);
  test-seal(15.2);
  test-seal('hi there');
  test-seal(Nil);

  {
    my $obj = JSON::GLib::Object.new;
    my $n   = JSON::GLib::Node.new($obj, :object);

    nok   $n.is-immutable, 'Node is mutable';
    nok $obj.is-immutable, 'Object is mutable';
    $n.seal;
    ok    $n.is-immutable, 'Node is now immutable';
    ok  $obj.is-immutable, 'Object is now immutable';
  }

  {
    my $arr = JSON::GLib::Array.new;
    my $n   = JSON::GLib::Node.new($arr, :array);

    nok   $n.is-immutable, 'Array Node is mutable';
    nok $arr.is-immutable, 'Array Object is mutable';
    $n.seal;
    ok    $n.is-immutable, 'Node is now immutable';
    ok  $arr.is-immutable, 'Object is now immutable';
  }
}

{
  sub test-immutable($v, $nv) {
    my ($e, $m);

    my $p = start {
      CATCH { when X::JSON::GLib::Node::NoSetImmutable { $e = $_ } }
      my $n;

      ($n, $m) = init-node($v, :all);
      $n.seal;
      $n."$m"() = $nv;
    }

    await $p;
    isa-ok $e, X::JSON::GLib::Node::NoSetImmutable, "Could not set immutable '$m' value";
  }

  test-immutable(5, 1);
  test-immutable(True, False);
  test-immutable(5.6, 1.1);
  test-immutable('bonghits', 'asdasd');

  {
    my $e;
    my $p = start {
      CATCH { when X::JSON::GLib::Node::NoSetImmutable { $e = $_ } }
      my $n = JSON::GLib::Node.init-int(5);
      $n.seal;
      $n.value = gv_int(50);
    }

    await $p;
    isa-ok $e, X::JSON::GLib::Node::NoSetImmutable, 'Could not set immutable GValue value';
  }

  {
    my $e;
    my $p = start {
      CATCH { when X::JSON::GLib::Node::NoSetImmutable { $e = $_ } }
      my $n = JSON::GLib::Node.init-int(5);
      $n.seal;

      my ($mut, $imut) = JSON::GLib::Object.new xx 2;
      my ($pmut, $pimut) = (
        JSON::GLib::Node.init-object($mut),
        JSON::GLib::Node.init-object($imut)
      );
      $pimut.seal;
      $mut.set-member('test', $n);
      $n.parent = $pmut;
      $mut.remove-member('test');
      $n.clear-parent;

      $n.parent = $pimut;
    }

    await $p;
    isa-ok $e, X::JSON::GLib::Node::NoSetImmutable, 'Could not set immutable object value';
  }

}
