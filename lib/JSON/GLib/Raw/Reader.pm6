use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use JSON::GLib::Raw::Definitions;

unit package JSON::GLib::Raw::Reader;

### /usr/include/json-glib-1.0/json-glib/json-reader.h

sub json_reader_count_elements (JsonReader $reader)
  returns gint
  is native(json-glib)
  is export
{ * }

sub json_reader_count_members (JsonReader $reader)
  returns gint
  is native(json-glib)
  is export
{ * }

sub json_reader_end_element (JsonReader $reader)
  is native(json-glib)
  is export
{ * }

sub json_reader_end_member (JsonReader $reader)
  is native(json-glib)
  is export
{ * }

sub json_reader_error_quark ()
  returns GQuark
  is native(json-glib)
  is export
{ * }

sub json_reader_get_boolean_value (JsonReader $reader)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_reader_get_double_value (JsonReader $reader)
  returns gdouble
  is native(json-glib)
  is export
{ * }

sub json_reader_get_error (JsonReader $reader)
  returns GError
  is native(json-glib)
  is export
{ * }

sub json_reader_get_int_value (JsonReader $reader)
  returns gint64
  is native(json-glib)
  is export
{ * }

sub json_reader_get_member_name (JsonReader $reader)
  returns Str
  is native(json-glib)
  is export
{ * }

sub json_reader_get_null_value (JsonReader $reader)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_reader_get_string_value (JsonReader $reader)
  returns Str
  is native(json-glib)
  is export
{ * }

sub json_reader_get_type ()
  returns GType
  is native(json-glib)
  is export
{ * }

sub json_reader_get_value (JsonReader $reader)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_reader_is_array (JsonReader $reader)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_reader_is_object (JsonReader $reader)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_reader_is_value (JsonReader $reader)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_reader_list_members (JsonReader $reader)
  returns Str
  is native(json-glib)
  is export
{ * }

sub json_reader_new (JsonNode $node)
  returns JsonReader
  is native(json-glib)
  is export
{ * }

sub json_reader_read_element (JsonReader $reader, guint $index)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_reader_read_member (JsonReader $reader, Str $member_name)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_reader_set_root (JsonReader $reader, JsonNode $root)
  is native(json-glib)
  is export
{ * }
