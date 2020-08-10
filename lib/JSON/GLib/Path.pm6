use v6.c;

use NativeCall;
use Method::Also;

use JSON::GLib::Raw::Types;
use JSON::GLib::Raw::Path;

use JSON::GLib::Node;

use GLib::Roles::Object;

class JSON::GLib::Path {
  also does GLib::Roles::Object;

  has JsonPath $!jp is implementor;

  submethod BUILD ( :path(:$!jp) ) { }

  submethod TWEAK                  { self.roleInit-Object }

  method JSON::GLib::Raw::Definitions::JsonPath
    is also<JsonPath>
  { $!jp }

  multi method new (JsonPath $path) {
    $path ?? self.bless( :$path ) !! Nil;
  }
  multi method new {
    my $path = json_path_new();

    $path ?? self.bless( :$path ) !! Nil;
  }

  method compile (Str() $expression, CArray[Pointer[GError]] $error = gerror) {
    clear_error;
    my $rv = so json_path_compile($!jp, $expression, $error);
    set_error($error);
    $rv;
  }

  method error_quark (JSON::GLib::Path:U: )
    is also<
      error-quark
      error
    >
  {
    json_path_error_quark();
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &json_path_get_type, $n, $t );
  }

  method match (JsonNode() $root, :$raw = False) {
    my $n = json_path_match($!jp, $root);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method query (
    Str() $expr,
    JsonNode() $root,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  ) {
    clear_error;
    my $n = json_path_query($expr, $root, $error);
    set_error($error);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

}
