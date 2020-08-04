use v6.c;

use Method::Also;

use NativeCall;

use JSON::GLib::Raw::Types;

use GLib::Variant;

use GLib::Roles::StaticClass;

class JSON::GLib::Variant {
  also does GLib::Roles::StaticClass;

  method deserialize (
    JsonNode() $json_node,
    Str() $signature,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  ) {
    my $v = json_gvariant_deserialize($json_node, $signature, $error);

    $v ??
      ( $raw ?? $v !! GLib::Variant.new($v) )
      !!
      Nil;
  }

  proto method deserialize_data (|)
      is also<deserialize-data>
  { * }

  multi method deserialize_data (
    Str() $json,
    Str() $signature,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  ) {
    samewith($json, -1, $signature, $error, :$raw);
  }
  multi method deserialize_data (
    Str() $json,
    Int() $length,
    Str() $signature,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  ) {
    my gssize $l = $length;

    clear_error;
    my $n = json_gvariant_deserialize_data($json, $l, $signature, $error);
    set_error($error);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method serialize (GVariant() $variant, :$raw = False) {
    my $n = json_gvariant_serialize($variant);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }


  proto method serialize_data(|)
    is also<serialize-data>
  { * }

  multi method serialize_data (GVariant() $variant)  {
    samewith($variant, $);
  }
  multi method serialize_data (GVariant() $variant, $length is rw) {
    my gssize $l = 0;

    my $ss = json_gvariant_serialize_data($variant, $l);
    $length = $l;
    $ss;
  }

}

### /usr/include/json-glib-1.0/json-glib/json-gvariant.h

sub json_gvariant_deserialize (
  JsonNode $json_node,
  Str $signature,
  CArray[Pointer[GError]] $error
)
  returns GVariant
  is native(json-glib)
  is export
{ * }

sub json_gvariant_deserialize_data (
  Str $json,
  gssize $length,
  Str $signature,
  CArray[Pointer[GError]] $error
)
  returns GVariant
  is native(json-glib)
  is export
{ * }

sub json_gvariant_serialize (GVariant $variant)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_gvariant_serialize_data (GVariant $variant, gsize $length)
  returns Str
  is native(json-glib)
  is export
{ * }
