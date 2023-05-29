use v6.c;

use Method::Also;

use JSON::GLib::Raw::Types;
use JSON::GLib::Raw::ObjectNodeArray;

use GLib::Value;

class X::JSON::GLib::Node::NoSetImmutable is Exception is export {
  method message { 'Cannot alter an immutable JSON::GLib::Node' }
}

class JSON::GLib::Node {
  has JsonNode $!jn;

  submethod BUILD ( :node(:$!jn) ) { }

  method JSON::GLib::Raw::Definitions::JsonNode
    is also<JsonNode>
  { $!jn }

  multi method new (JsonNode $node) {
    $node ?? self.bless(:$node) !! Nil;
  }
  multi method new (Int() $type = JSON_NODE_NULL) {
    my JsonNodeType $t = $type;
    my $node = json_node_new($t);

    $node ?? self.bless(:$node) !! Nil;
  }

  multi method new ($ar, :$array is required) {
    self.init_array($ar // JsonArray.new);
  }
  multi method new (
    $arr,
    :arr(:$array) is required
  ) {
    self.init_array(JsonArray);
  }
  method init_array (JsonArray() $array, :$raw = False) is also<init-array> {
    my $n = json_node_alloc();
    $n = self.bless( node => $n );

    return Nil unless $n;

    json_node_init_array($!jn, $array);

    $n ??
      ($raw ?? $n !! self)
      !!
      Nil;
  }

  multi method new(
    $b,
    :bool(:$boolean) is required
  ) {
    self.init_boolean($b);
  }
  method init_boolean (Int() $value, :$raw = False)
    is also<
      init-boolean
      init_bool
      init-bool
    >
  {
    my gboolean $v = $value.so.Int;
    my $node = json_node_init_boolean(JSON::GLib::Node.alloc, $v);

    $node ?? self.bless(:$node) !! Nil;
  }

  multi method new (
    $d,
    :dbl(:$double) is required
  ) {
    self.init_double($d);
  }
  method init_double (Num() $value, :$raw = False) is also<init-double> {
    my gdouble $v = $value;
    my $node = json_node_init_double($!jn, $v);

    $node ?? self.bless(:$node) !! Nil;
  }

  multi method new (
    $i,
    :int(:$integer) is required
  ) {
    self.init_int($i);
  }
  method init_int (Int() $value, :$raw = False) is also<init-int> {
    my gint64 $v = $value;
    my $node = json_node_init_int(JSON::GLib::Node.alloc, $v);

    $node ?? self.bless(:$node) !! Nil;
  }

  multi method new (:$null is required) {
    self.init-null;
  }
  method init_null (:$raw = False) is also<init-null> {
    my $node = json_node_init_null( JSON::GLib::Node.alloc );

    $node ?? self.bless(:$node) !! Nil;
  }

  multi method new (
    :object(:jsonobject(:$jo)) is required
  ) {
    self.init_object(JsonObject);
  }
  multi method new (
    JsonObject() $o,
    :object(:jsonobject(:$jo)) is required
  ) {
    self.init_object($o);
  }
  method init_object (JsonObject() $object, :$raw = False)
    is also<init-object>
  {
    my $n = json_node_alloc();
    $n = self.bless( node => $n );

    return Nil unless $n;

    json_node_init_array($!jn, $object);

    $n ??
      ($raw ?? $n !! self)
      !!
      Nil;
  }

  multi method new ($s, :str(:$string) is required) {
    self.init_string($s);
  }
  method init_string (Str() $value, :$raw = False) is also<init-string> {
    my $node = json_node_init_string(JSON::GLib::Node.alloc, $value);

    $node ?? self.bless(:$node) !! Nil;
  }

  method array (:$raw = False) is rw {
    Proxy.new:
      FETCH => -> $                 { self.get_array(:$raw) },
      STORE => -> $, JsonArray() \a { self.set_array(a)     };
  }

  method boolean is also<bool> is rw {
    Proxy.new:
      FETCH => -> $           { self.get_boolean    },
      STORE => -> $, Int() \b { self.set_boolean(b) };
  }

  method double is rw {
    Proxy.new:
      FETCH => -> $           { self.get_double    },
      STORE => -> $, Num() \d { self.set_double(d) };
  }

  method int is rw {
    Proxy.new:
      FETCH => -> $           { self.get_int    },
      STORE => -> $, Int() \i { self.set_int(i) };
  }

  method object (:$raw = False) is rw {
    Proxy.new:
      FETCH => -> $                  { self.get_object(:$raw) },
      STORE => -> $, JsonObject() \o { self.set_object(o)     };
  }

  method parent (:$raw = False) is rw {
    Proxy.new:
      FETCH => -> $                { self.get_parent(:$raw) },
      STORE => -> $, JsonNode() \p { self.set_parent(p)     };
  }

  method string is rw {
    Proxy.new:
      FETCH => -> $           { self.get_string    },
      STORE => -> $, Str() \s { self.set_string(s) };
  }

  method value (:$raw = False) is rw {
    Proxy.new:
      FETCH => -> $              { self.get_value(:$raw) },
      STORE => -> $, GValue() \v { self.set_value(v)     };
  }

  method alloc (JSON::GLib::Node:U: ) {
    json_node_alloc();
  }

  method clear_parent is also<clear-parent> {
    self.parent = JsonNode;
  }

  method copy (:$raw = False) {
    my $n = json_node_copy($!jn);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method dup_array (:$raw = False) is also<dup-array> {
    my $n = json_node_dup_array($!jn);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method dup_object (:$raw = False) is also<dup-object> {
    my $n = json_node_dup_object($!jn);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method dup_string (:$raw = False) is also<dup-string> {
    my $n = json_node_dup_string($!jn);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method equal (JsonNode() $b) {
    so json_node_equal($!jn, $b);
  }

  method free {
    json_node_free($!jn);
  }

  method get_array (:$raw = False) is also<get-array> {
    my $a = json_node_get_array($!jn);

    $a ??
      ( $raw ?? $a !! ::('JSON::GLib::Array').new($a) )
      !!
      Nil;
  }

  method get_boolean
    is also<
      get-boolean
      get_bool
      get-bool
    >
  {
    so json_node_get_boolean($!jn);
  }

  method get_double is also<get-double> {
    json_node_get_double($!jn);
  }

  method get_int is also<get-int> {
    json_node_get_int($!jn);
  }

  method get_node_type
    is also<
      get-node-type
      node_type
      node-type
    >
  {
    JsonNodeTypeEnum( json_node_get_node_type($!jn) );
  }

  method get_object (:$raw = False) is also<get-object> {
    my $o = json_node_get_object($!jn);

    $o ??
      ( $raw ?? $o !! ::('JSON::GLib::Object').new($o) )
      !!
      Nil;
  }

  method get_parent (:$raw = False) is also<get-parent> {
    my $p = json_node_get_parent($!jn);

    $p ??
      ( $raw ?? $p !! JSON::GLib::Node.new($p) )
      !!
      Nil;
  }

  method get_string
    is also<
      get-string
      Str
    >
  {
    json_node_get_string($!jn);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &json_node_get_type, $n, $t );
  }

  proto method get_value (|)
    is also<get-value>
  { * }

  multi method get_value (:$raw = False) {
    my $v = GValue.new;
    samewith($v);

    $v ??
      ( $raw ?? $v !! GLib::Value.new($v) )
      !!
      Nil;
  }
  multi method get_value (GValue() $value)  {
    json_node_get_value($!jn, $value);
  }

  method get_value_type
    is also<
      get-value-type
      value_type
      value-type
    >
  {
    json_node_get_value_type($!jn);
  }

  method hash {
    json_node_hash($!jn);
  }

  method is_immutable is also<is-immutable> {
    so json_node_is_immutable($!jn);
  }

  method is_null is also<is-null> {
    so json_node_is_null($!jn);
  }

  method ref {
    json_node_ref($!jn);
    self;
  }

  method seal {
    json_node_seal($!jn);
  }

  method set_array (JsonArray() $array) is also<set-array> {
    # Avoids the C-exception at the cost of speed... which beats a dead
    # program!
    X::JSON::GLib::Node::NoSetImmutable.throw if self.is_immutable;

    json_node_set_array($!jn, $array);
  }

  method set_boolean (Int() $value)
    is also<
      set-boolean
      set_bool
      set-bool
    >
  {
    my $v = $value.so.Int;

    # Avoids the C-exception at the cost of speed... which beats a dead
    # program!
    X::JSON::GLib::Node::NoSetImmutable.throw if self.is_immutable;

    json_node_set_boolean($!jn, $v);
  }

  method set_double (Num() $value) is also<set-double> {
    my gdouble $v = $value;

    # Avoids the C-exception at the cost of speed... which beats a dead
    # program!
    X::JSON::GLib::Node::NoSetImmutable.throw if self.is_immutable;

    json_node_set_double($!jn, $value);
  }

  method set_int (Int() $value) is also<set-int> {
    my gint64 $v = $value;

    # Avoids the C-exception at the cost of speed... which beats a dead
    # program!
    X::JSON::GLib::Node::NoSetImmutable.throw if self.is_immutable;

    json_node_set_int($!jn, $v);
  }

  method set_object (JsonObject() $object) is also<set-object> {
    # Avoids the C-exception at the cost of speed... which beats a dead
    # program!
    X::JSON::GLib::Node::NoSetImmutable.throw if self.is_immutable;

    json_node_set_object($!jn, $object);
  }

  method unset_object is also<unset-object> {
    self.set_object(JsonObject);
  }

  method set_parent (JsonNode $parent) is also<set-parent> {
    json_node_set_parent($!jn, $parent);
  }

  method set_string (Str() $value) is also<set-string> {
    json_node_set_string($!jn, $value);
  }

  method set_value (GValue() $value) is also<set-value> {
    json_node_set_value($!jn, $value);
  }

  method take_array (JsonArray() $array) is also<take-array> {
    json_node_take_array($!jn, $array);
  }

  method take_object (JsonObject() $object) is also<take-object> {
    json_node_take_object($!jn, $object);
  }

  method type_name is also<type-name> {
    json_node_type_name($!jn);
  }

  method unref {
    json_node_unref($!jn);
  }

}

our subset JsonNodeOrObj is export of Mu where JsonNode | JSON::GLib::Node;
