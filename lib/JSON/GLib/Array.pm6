use v6.c;

use JSON::GLib::Raw::Types;
use JSON::GLib::Raw::ObjectNodeArray;

use JSON::GLib::Node;

use GLib::Roles::Object;
use GLib::Roles::ListData;

class JSON::GLib::Array {
  also does GLib::Roles::Object;

  has JsonArray $!ja is implementor;

  method new () {
    my $array = json_array_new();

    $array ?? self.bless( :$array ) !! Nil;
  }

  method sized_new (Int() $n_elements) {
    my $guint $n = $n_elements;
    my $array = json_array_sized_new($n);

    $array ?? self.bless( :$array ) !! Nil;
  }

  method add_array_element (JsonArray() $value) {
    json_array_add_array_element($!ja, $value);
  }

  method add_boolean_element (Int() $value) {
    my gboolean $v = $value.so.Int;

    json_array_add_boolean_element($!ja, $v);
  }

  method add_double_element (Num() $value) {
    my gdouble $v = $value;

    json_array_add_double_element($!ja, $v);
  }

  method add_element (JsonNode() $node) {
    json_array_add_element($!ja, $node);
  }

  method add_int_element (Int() $value) {
    myt gint64 $v = $value;

    json_array_add_int_element($!ja, $v);
  }

  method add_null_element () {
    json_array_add_null_element($!ja);
  }

  method add_object_element (JsonObject() $value) {
    json_array_add_object_element($!ja, $value);
  }

  method add_string_element (Str() $value) {
    json_array_add_string_element($!ja, $value);
  }

  method dup_element (Int() $index, :$raw = False) {
    my $n = json_array_dup_element($!ja, $index);

    $n ??
      ( $raw ?? $n !! JSON:GLib::Node.new($n) )
      !!
      Nil;
  }

  method equal (JsonArray() $b) {
    so json_array_equal($!ja, $b);
  }

  method foreach_element (&func, gpointer $data = gpointer) {
    json_array_foreach_element($!ja, &func, $data);
  }

  method get_array_element (Int() $index) {
    my guint $i = $index;

    my $a = json_array_get_array_element($!ja, $i);

    $a ??
      ( $raw ?? $a !! JSON::GLib::Array.new($a) )
      !!
      Nil;
  }

  method get_boolean_element (Int() $index) {
    my gint $i = $index;

   json_array_get_boolean_element($!ja, $index);
  }

  method get_double_element (Int() $index) {
    my gint $i = $index;

   json_array_get_double_element($!ja, $index);
  }

  method get_element (Int() $index, :$raw = False) {
    my gint $i = $index;
    my $n = json_array_get_element($!ja, $index);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method get_elements (:$glist = raw, :$raw = False) {
    my $el = json_array_get_elements($!ja);

    return Nil unless $el;
    return $el if $glist && $raw;

    $el = GLib::GList.new($el) but GLib::Roles::ListData[JsonNode];
    return $el if $glist;

    $raw ?? $el.Array
         !! $el.Array.map({ JSON::GLib::Node.new($_) }).Array;
  }

  method get_int_element (Int() $index) {
    my gint $i = $index;

   json_array_get_int_element($!ja, $index);
  }

  method get_length {
    json_array_get_length($!ja);
  }

  method get_null_element (Int() $index) {
    my gint $i = $index;

    so json_array_get_null_element($!ja, $index);
  }

  method get_object_element (Int() $index) {
    my gint $i = $index;

   json_array_get_object_element($!ja, $index);
  }

  method get_string_element (Int() $index) {
    my gint $i = $index;

    json_array_get_string_element($!ja, $index);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &json_array_get_type, $n, $t );
  }

  method hash {
    json_array_hash($!ja);
  }

  method is_immutable {
    so json_array_is_immutable($!ja);
  }

  method ref {
    json_array_ref($!ja);
    self;
  }

  method remove_element (Int() $index) {
    my gint $i = $index;

   json_array_remove_element($!ja, $index);
  }

  method seal {
    json_array_seal($!ja);
  }

  method unref {
    json_array_unref($!ja);
  }

}
