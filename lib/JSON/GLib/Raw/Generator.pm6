use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GIO::Raw::Definitions;
use GIO::Raw::Structs;
use JSON::GLib::Raw::Definitions;

### /usr/include/json-glib-1.0/json-glib/json-generator.h

sub json_generator_get_indent (JsonGenerator $generator)
  returns guint
  is native(json-glib)
  is export
{ * }

sub json_generator_get_indent_char (JsonGenerator $generator)
  returns gunichar
  is native(json-glib)
  is export
{ * }

sub json_generator_get_pretty (JsonGenerator $generator)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_generator_get_root (JsonGenerator $generator)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_generator_get_type ()
  returns GType
  is native(json-glib)
  is export
{ * }

sub json_generator_new ()
  returns JsonGenerator
  is native(json-glib)
  is export
{ * }

sub json_generator_set_indent (
  JsonGenerator $generator,
  guint $indent_level
)
  is native(json-glib)
  is export
{ * }

sub json_generator_set_indent_char (
  JsonGenerator $generator,
  gunichar $indent_char
)
  is native(json-glib)
  is export
{ * }

sub json_generator_set_pretty (JsonGenerator $generator, gboolean $is_pretty)
  is native(json-glib)
  is export
{ * }

sub json_generator_set_root (JsonGenerator $generator, JsonNode $node)
  is native(json-glib)
  is export
{ * }

sub json_generator_to_data (JsonGenerator $generator, gsize $length is rw)
  returns Str
  is native(json-glib)
  is export
{ * }

sub json_generator_to_file (
  JsonGenerator $generator,
  Str $filename,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_generator_to_gstring (JsonGenerator $generator, GString $string)
  returns GString
  is native(json-glib)
  is export
{ * }

sub json_generator_to_stream (
  JsonGenerator $generator,
  GOutputStream $stream,
  GCancellable $cancellable,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(json-glib)
  is export
{ * }
