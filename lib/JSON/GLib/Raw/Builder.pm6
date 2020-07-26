use v6.c;

use NativeCall;

use JSON::GLib::Raw::Types;

unit package JSON::GLib::Raw::Builder;

### /usr/include/json-glib-1.0/json-glib/json-builder.h

sub json_builder_add_boolean_value (JsonBuilder $builder, gboolean $value)
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_add_double_value (JsonBuilder $builder, gdouble $value)
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_add_int_value (JsonBuilder $builder, gint64 $value)
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_add_null_value (JsonBuilder $builder)
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_add_string_value (JsonBuilder $builder, Str $value)
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_add_value (JsonBuilder $builder, JsonNode $node)
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_begin_array (JsonBuilder $builder)
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_begin_object (JsonBuilder $builder)
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_end_array (JsonBuilder $builder)
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_end_object (JsonBuilder $builder)
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_get_root (JsonBuilder $builder)
  returns JsonNode
  is native(gtk)
  is export
{ * }

sub json_builder_get_type ()
  returns GType
  is native(gtk)
  is export
{ * }

sub json_builder_new ()
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_new_immutable ()
  returns JsonBuilder
  is native(gtk)
  is export
{ * }

sub json_builder_reset (JsonBuilder $builder)
  is native(gtk)
  is export
{ * }

sub json_builder_set_member_name (JsonBuilder $builder, Str $member_name)
  returns JsonBuilder
  is native(gtk)
  is export
{ * }
