use v6.c;

use JSON::GLib::Raw::Types;
use JSON::GLib::ObjectNodeArray;

class JSON::GLib::Node {
  has JsonNode $!jn;

  submethod BUILD ( :node(:$!jn) ) { }

  multi method new (JsonNode $node) {
    $node ?? self.bless(:$node) !! Nil;
  }
  multi method new {
    my $node = json_node_new();

    $node ?? self.bless(:$node) !! Nil;
  }

  method init (Int() $type, :$raw = False) {
    my JsonNodeType $t = $type;
    my $n = json_node_init($!jn, $t);

    $n ??
      ($raw ?? $n !! self)
      !!
      Nil;
  }

  method init_array (JsonArray() $array) {
    my $n = json_node_init_array($!jn, $array);

    $n ??
      ($raw ?? $n !! self)
      !!
      Nil;
  }

  method init_boolean (Int() $value, :$raw = False) {
    my gboolean $v = $value.so.Int;
    my $n = json_node_init_boolean($!jn, $v);

    $n ??
      ($raw ?? $n !! self)
      !!
      Nil;
  }

  method init_double (Num() $value, :$raw = False) {
    my gdouble $value = $v;
    my $n = json_node_init_double($!jn, $v);

    $n ??
      ($raw ?? $n !! self)
      !!
      Nil;
  }

  method init_int (Int() $value, :$raw = False) {
    my gint64 $v = $value;
    my $n = json_node_init_int($!jn, $v);

    $n ??
      ($raw ?? $n !! self)
      !!
      Nil;
  }

  method init_null {
    my $n = json_node_init_null($!jn);

    $n ??
      ($raw ?? $n !! self)
      !!
      Nil;
  }

  method init_object (JsonObject() $object, :$raw = False) {
    my $n = json_node_init_object($!jn, $object);

    $n ??
      ($raw ?? $n !! self)
      !!
      Nil;
  }

  method init_string (Str() $value, :$raw = False) {
    my $n = json_node_init_string($!jn, $value);

    $n ??
      ($raw ?? $n !! self)
      !!
      Nil;
  }

  method array (:$raw = False) is rw {
    Proxy.new:
      FETCH => -> $                { self.get_array(:$raw) },
      STORE => -> $, JsonAray() \a { self.set_array(a)     };
  }

  method boolean is rw {
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
      FETCH => -> $              { my $v = GValue.new;
                                   self.get_value($v);
                                   $raw ?? $v !! GLib::Value.new($v) },

      STORE => -> $, GValue() \v { self.set_value(v) };
  }

  method alloc (JSON::LGLib::Node:U: JsonNode $node) {
    json_node_alloc($node);
  }

  method copy (:$raw = False) {
    my $n = json_node_copy($!jn);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method dup_array (:$raw = False) {
    my $n = json_node_dup_array($!jn);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method dup_object (:$raw = False) {
    my $n = json_node_dup_object($!jn);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method dup_string (:$raw = False) {
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

  method get_array (:$raw = False) {
    my $a = json_node_get_array($!jn);

    $a ??
      ( $raw ?? $a !! ::('JSON::GLib::Array').new($a) )
      !!
      Nil;
  }

  method get_boolean {
    so json_node_get_boolean($!jn);
  }

  method get_double {
    json_node_get_double($!jn);
  }

  method get_int {
    json_node_get_int($!jn);
  }

  method get_node_type {
    JsonNodeTypeEnum( json_node_get_node_type($!jn) );
  }

  method get_object (:$raw = False) {
    my $o = json_node_get_object($!jn);

    $o ??
      ( $raw ?? $o !! JSON::GLib::Object.new($o) )
      !!
      Nil;
  }

  method get_parent (:$raw = False) {
    my $p = json_node_get_parent($!jn);

    $p ??
      ( $raw ?? $n !! JSON::GLib::Node.new($p) )
      !!
      Nil;
  }

  method get_string {
    json_node_get_string($!jn);
  }

  method get_type {
    json_node_get_type();
  }

  method get_value (GValue() $value) {
    json_node_get_value($!jn, $value);
  }

  method get_value_type {
    json_node_get_value_type($!jn);
  }

  method hash {
    json_node_hash($!jn);
  }

  method is_immutable {
    so json_node_is_immutable($!jn);
  }

  method is_null {
    so json_node_is_null($!jn);
  }

  method ref {
    json_node_ref($!jn);
    self;
  }

  method seal {
    json_node_seal($!jn);
  }

  method set_array (JsonArray() $array) {
    json_node_set_array($!jn, $array);
  }

  method set_boolean (Int() $value) {
    my $v = $value.so.Int;

    json_node_set_boolean($!jn, $v);
  }

  method set_double (Num() $value) {
    my gdouble $v = $value;

    json_node_set_double($!jn, $value);
  }

  method set_int (Int() $value) {
    my gint64 $v = $value;

    json_node_set_int($!jn, $v);
  }

  method set_object (JsonObject() $object) {
    json_node_set_object($!jn, $object);
  }

  method unset_object {
    self.set_object(JsonObject);
  }

  method set_parent (JsonNode $parent) {
    json_node_set_parent($!jn, $parent);
  }

  method set_string (Str() $value) {
    json_node_set_string($!jn, $value);
  }

  method set_value (GValue() $value) {
    json_node_set_value($!jn, $value);
  }

  method take_array (JsonArray() $array) {
    json_node_take_array($!jn, $array);
  }

  method take_object (JsonObject() $object) {
    json_node_take_object($!jn, $object);
  }

  method type_name {
    json_node_type_name($!jn);
  }

  method unref {
    json_node_unref($!jn);
  }

}
