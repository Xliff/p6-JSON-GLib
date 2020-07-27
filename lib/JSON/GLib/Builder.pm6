use v6.c;

use JSON::GLib::Raw::Types;
use JSON::GLib::Raw::Builder;

use GLib::Roles::Object;

class JSON::GLib::Builder {
  also does GLib::Roles::Object;

  has JsonBuilder $!jb is implementor;

  submethod BUILD ( :builder(:$!jb) ) { }

  submethod TWEAK { self.roleInit-Object }

  method JSON::GLib::Raw::Structs::JsonBuilder
  { $!jb }

  multi method new (JsonBuilder $builder) {
    $builder ?? self.bless( :$builder ) !! Nil;
  }
  multi method new {
    my $builder = my $jb = json_builder_new();

    $builder ?? self.bless( :$builder ) !! Nil;
  }

  method new_immutable {
    my $builder = my $jb = json_builder_new_immutable();

    $builder ?? self.bless( :$builder ) !! Nil;
  }

  # Type: gboolean
  method immutable is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('immutable', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'immutable is a construct-only attribute'
      }
    );
  }

  method add_boolean_value (Int() $value, :$raw = False) {
    my gboolean $v = $value.so.Int;

    my $jb = json_builder_add_boolean_value($!jb, $v);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

  method add_double_value (Num() $value, :$raw = False) {
    my gdouble $v = $value;

    my $jb = json_builder_add_double_value($!jb, $v);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

  method add_int_value (Int() $value, :$raw = False) {
    my gint64 $v = $value;

    my $jb = json_builder_add_int_value($!jb, $v);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

  method add_null_value (:$raw = False) {
    my $jb = json_builder_add_null_value($!jb);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

  method add_string_value (Str() $value, :$raw = False) {
    my $jb = json_builder_add_string_value($!jb, $value);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

  method add_value (JsonNode() $node, :$raw = False) {
    my $jb = json_builder_add_value($!jb, $node);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

  method begin_array (:$raw = False) {
    my $jb = json_builder_begin_array($!jb);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

  method begin_object (:$raw = False) {
    my $jb = json_builder_begin_object($!jb);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

  method end_array (:$raw = False) {
    my $jb = json_builder_end_array($!jb);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

  method end_object (:$raw = False) {
    my $jb = json_builder_end_object($!jb);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

  method get_root (:$raw = False) {
    my $jb = json_builder_get_root($!jb);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &json_builder_get_type, $n, $t );
  }

  method reset {
    my $jb = json_builder_reset($!jb);
  }

  method set_member_name (Str() $member_name, :$raw = False) {
    my $jb = json_builder_set_member_name($!jb, $member_name);

    $jb ??
      ( $raw ?? $jb !! self )
      !!
      Nil;
  }

}
