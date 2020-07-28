use v6.c;

use Method::Also;

use NativeCall;

use GLib::GList;
use JSON::GLib::Raw::Types;
use JSON::GLib::Raw::ObjectNodeArray;

use JSON::GLib::Node;

use GLib::Roles::ListData;

our subset JsonArrayOrObj is export of Mu
  where JsonArray | ::('JSON::GLib::Array');

# BOXED
class JSON::GLib::Array does Positional {
  has JsonArray $!ja;

  submethod BUILD ( :array(:$!ja) ) { }

  method JSON::GLib::Raw::Definitions::JsonArray
    is also<JsonArray>
  { $!ja }

  method AT-POS(Int \p) {
    self.get_element(p);
  }

  method EXISTS-POS(Int \p) {
    return False if p < 0;

    my $l := self.get_length;
    return False unless $l > 0;

    return True if p < $l;
    False;
  }

  multi method new (JsonArray $array) {
    $array ?? self.bless( :$array ) !! Nil;
  }
  multi method new {
    my $array = json_array_new();

    $array ?? self.bless( :$array ) !! Nil;
  }

  method sized_new (Int() $n_elements) is also<sized-new> {
    my guint $n = $n_elements;
    my $array = json_array_sized_new($n);

    $array ?? self.bless( :$array ) !! Nil;
  }

  multi method add (JsonArrayOrObj $value) {
    self.add_array_element($value);
  }
  method add_array_element (JsonArray() $value = JsonArray)
    is also<add-array-element>
  {
    json_array_add_array_element($!ja, $value);
  }

  multi method add (Bool $v) {
    self.add_boolean_element($v.so.Int);
  }
  method add_boolean_element (Int() $value) is also<add-boolean-element> {
    my gboolean $v = $value.so.Int;

    json_array_add_boolean_element($!ja, $v);
  }

  multi method add (Num $value) {
    self.add-double-element($value);
  }
  method add_double_element (Num() $value) is also<add-double-element> {
    my gdouble $v = $value;

    json_array_add_double_element($!ja, $v);
  }

  multi method add (JsonNodeOrObj $v) {
    self.add_element($v);
  }
  method add_element (JsonNode() $node) is also<add-element> {
    json_array_add_element($!ja, $node);
  }

  multi method add (Int $v) {
    self.add_int_element($v);
  }
  method add_int_element (Int() $value) is also<add-int-element> {
    my gint64 $v = $value;

    json_array_add_int_element($!ja, $v);
  }

  multi method add {
    self.add_null_element;
  }
  multi method add (Nil) {
    self.add_null_element;
  }
  method add_null_element () is also<add-null-element> {
    json_array_add_null_element($!ja);
  }

  multi method add ( $v where * ~~ ::('JsonObjectOrObj') ) {
    self.add_object_element($v);
  }
  method add_object_element (JsonObject() $value = JsonObject)
    is also<add-object-element>
  {
    json_array_add_object_element($!ja, $value);
  }

  multi method add (Str $v) {
    self.add_string_element($v);
  }
  method add_string_element (Str() $value = Str) is also<add-string-element> {
    json_array_add_string_element($!ja, $value);
  }

  method dup_element (Int() $index, :$raw = False) is also<dup-element> {
    my $n = json_array_dup_element($!ja, $index);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method equal (JsonArray() $b) {
    so json_array_equal($!ja, $b);
  }

  method foreach_element (&func, gpointer $data = gpointer)
    is also<foreach-element>
  {
    json_array_foreach_element($!ja, &func, $data);
  }

  method get_array_element (Int() $index, :$raw = False)
    is also<get-array-element>
  {
    my guint $i = $index;

    my $a = json_array_get_array_element($!ja, $i);

    $a ??
      ( $raw ?? $a !! JSON::GLib::Array.new($a) )
      !!
      Nil;
  }

  method get_boolean_element (Int() $index) is also<get-boolean-element> {
    my gint $i = $index;

   json_array_get_boolean_element($!ja, $index);
  }

  method get_double_element (Int() $index) is also<get-double-element> {
    my gint $i = $index;

   json_array_get_double_element($!ja, $index);
  }

  method get_element (Int() $index, :$raw = False) is also<get-element> {
    my gint $i = $index;
    my $n = json_array_get_element($!ja, $index);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method get_elements (:$glist = False, :$raw = False)
    is also<
      get-elements
      elements
    >
  {
    my $el = json_array_get_elements($!ja);

    return Nil unless $el;
    return $el if $glist && $raw;

    $el = GLib::GList.new($el) but GLib::Roles::ListData[JsonNode];
    return $el if $glist;

    $raw ?? $el.Array
         !! $el.Array.map({ JSON::GLib::Node.new($_) }).Array;
  }

  method get_int_element (Int() $index) is also<get-int-element> {
    my gint $i = $index;

   json_array_get_int_element($!ja, $index);
  }

  method get_length
    is also<
      get-length
      elems
    >
  {
    json_array_get_length($!ja);
  }

  method get_null_element (Int() $index) is also<get-null-element> {
    my gint $i = $index;

    so json_array_get_null_element($!ja, $index);
  }

  method get_object_element (Int() $index, :$raw = False)
    is also<get-object-element>
  {
    my gint $i = $index;

    my $o = json_array_get_object_element($!ja, $index);

    $o ??
      ( $raw ?? $o !! ::('JSON::GLib::Object').new($o) )
      !!
      Nil;
  }

  method get_string_element (Int() $index) is also<get-string-element> {
    my gint $i = $index;

    json_array_get_string_element($!ja, $index);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &json_array_get_type, $n, $t );
  }

  method hash {
    json_array_hash($!ja);
  }

  method is_immutable is also<is-immutable> {
    so json_array_is_immutable($!ja);
  }

  method ref {
    json_array_ref($!ja);
    self;
  }

  method remove_element (Int() $index) is also<remove-element> {
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
