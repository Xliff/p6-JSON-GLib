use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use JSON::GLib::Raw::Definitions;

unit package JSON::GLib::Raw::Path;

### /usr/include/json-glib-1.0/json-glib/json-path.h

sub json_path_compile (
  JsonPath $path,
  Str $expression,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_path_error_quark ()
  returns GQuark
  is native(json-glib)
  is export
{ * }

sub json_path_get_type ()
  returns GType
  is native(json-glib)
  is export
{ * }

sub json_path_match (JsonPath $path, JsonNode $root)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_path_new ()
  returns JsonPath
  is native(json-glib)
  is export
{ * }

sub json_path_query (
  Str $expression,
  JsonNode $root,
  CArray[Pointer[GError]] $error
)
  returns JsonNode
  is native(json-glib)
  is export
{ * }
