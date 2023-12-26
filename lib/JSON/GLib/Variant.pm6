use v6.c;

use Method::Also;
use JSON::Fast;

use NativeCall;

use JSON::GLib::Raw::Types;

use GLib::Variant;
use JSON::GLib::Node;

use GLib::Roles::StaticClass;

role JSON::GLib::Variant::Deserialize {
  method deserialize (
    Str()                    $signature,
    CArray[Pointer[GError]]  $error      = gerror,
                            :$raw        = False
  ) {
    clear_error;
    my $v = propReturnObject(
      json_gvariant_deserialize(self.JsonNode, $signature, $error),
      $raw,
      |GLib::Variant.getTypePair
    );
    set_error($error);
    $v;
  }

}

role JSON::GLib::Node::Deserialize {

  # cw: Not to be confused with .raku, this method returns a Raku appropriate
  #     datastructure that represents the deserialized variant!.
  method Raku {
    from-json( self.Str );
  }

}

role JSON::GLib::Variant::Serialize {

  method serialize ( :$raw = False, :$node = True ) {
    my $n = propReturnObject(
      json_gvariant_serialize(self.GVariant),
      $raw,
      |JSON::GLib::Node.getTypePair
    );
    return $n if $node;
    $n.Str;
  }

  method json-node {
    self.serialize( :node ) but JSON::GLib::Node::Deserialize;
  }

  method json {
    self.serialize( :!node );
  }
  method to-json {
    self.json;
  }

}

class JSON::GLib::Variant {
  also does GLib::Roles::StaticClass;

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
    Str()                   $json,
    Int()                   $length,
    Str()                   $signature,
    CArray[Pointer[GError]] $error      = gerror,
    :$raw = False
  ) {
    my gssize $l = $length;

    clear_error;
    my $v = json_gvariant_deserialize_data($json, $l, $signature, $error);
    set_error($error);

    $v ??
      ( $raw ?? $v !! GLib::Variant.new($v) )
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

sub GVariant-to-Raku (GVariant() $v) is export {
  (
    GLib::Variant.new($v) but JSON::GLib::Variant::Serialize
  ).json-node.Raku
}

### /usr/include/json-glib-1.0/json-glib/json-gvariant.h

sub json_gvariant_deserialize (
  JsonNode                $json_node,
  Str                     $signature,
  CArray[Pointer[GError]] $error
)
  returns GVariant
  is      native(json-glib)
  is      export
{ * }

sub json_gvariant_deserialize_data (
  Str                     $json,
  gssize                  $length,
  Str                     $signature,
  CArray[Pointer[GError]] $error
)
  returns GVariant
  is      native(json-glib)
  is      export
{ * }

sub json_gvariant_serialize (GVariant $variant)
  returns JsonNode
  is      native(json-glib)
  is      export
{ * }

sub json_gvariant_serialize_data (GVariant $variant, gsize $length)
  returns Str
  is      native(json-glib)
  is      export
{ * }
