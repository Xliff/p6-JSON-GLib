use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use JSON::GLib::Raw::Definitions;

unit package JSON::GLib::Raw::Parser;

### /usr/include/json-glib-1.0/json-glib/json-parser.h

sub json_parser_error_quark ()
  returns GQuark
  is native(json-glib)
  is export
{ * }

sub json_parser_get_current_line (JsonParser $parser)
  returns guint
  is native(json-glib)
  is export
{ * }

sub json_parser_get_current_pos (JsonParser $parser)
  returns guint
  is native(json-glib)
  is export
{ * }

sub json_parser_get_root (JsonParser $parser)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_parser_get_type ()
  returns GType
  is native(json-glib)
  is export
{ * }

sub json_parser_has_assignment (JsonParser $parser, CArray[Str] $variable_name)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_parser_load_from_data (
  JsonParser $parser,
  Str $data,
  gssize $length,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_parser_load_from_file (
  JsonParser $parser,
  Str $filename,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_parser_load_from_stream (
  JsonParser $parser,
  GInputStream $stream,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_parser_load_from_stream_async (
  JsonParser $parser,
  GInputStream $stream,
  GCancellable $cancellable,
  GAsyncReadyCallback $callback,
  gpointer $user_data
)
  is native(json-glib)
  is export
{ * }

sub json_parser_load_from_stream_finish (
  JsonParser $parser,
  GAsyncResult $result,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_parser_new ()
  returns JsonParser
  is native(json-glib)
  is export
{ * }

sub json_parser_new_immutable ()
  returns JsonParser
  is native(json-glib)
  is export
{ * }

sub json_parser_steal_root (JsonParser $parser)
  returns JsonNode
  is native(json-glib)
  is export
{ * }
