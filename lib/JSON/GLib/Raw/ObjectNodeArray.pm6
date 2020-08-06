use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use JSON::GLib::Raw::Definitions;

unit package JSON::GLib::Raw::ObjectNodeArray;

### /usr/include/json-glib-1.0/json-glib/json-types.h

sub json_array_add_array_element (JsonArray $array, JsonArray $value)
  is native(json-glib)
  is export
{ * }

sub json_array_add_boolean_element (JsonArray $array, gboolean $value)
  is native(json-glib)
  is export
{ * }

sub json_array_add_double_element (JsonArray $array, gdouble $value)
  is native(json-glib)
  is export
{ * }

sub json_array_add_element (JsonArray $array, JsonNode $node)
  is native(json-glib)
  is export
{ * }

sub json_array_add_int_element (JsonArray $array, gint64 $value)
  is native(json-glib)
  is export
{ * }

sub json_array_add_null_element (JsonArray $array)
  is native(json-glib)
  is export
{ * }

sub json_array_add_object_element (JsonArray $array, JsonObject $value)
  is native(json-glib)
  is export
{ * }

sub json_array_add_string_element (JsonArray $array, Str $value)
  is native(json-glib)
  is export
{ * }

sub json_array_dup_element (JsonArray $array, guint $index)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_array_equal (JsonArray $a, JsonArray $b)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_array_foreach_element (
  JsonArray $array,
  &func (JsonArray, guint, JsonNode, gpointer),
  gpointer $data
)
  is native(json-glib)
  is export
{ * }

sub json_array_get_array_element (JsonArray $array, guint $index)
  returns JsonArray
  is native(json-glib)
  is export
{ * }

sub json_array_get_boolean_element (JsonArray $array, guint $index)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_array_get_double_element (JsonArray $array, guint $index)
  returns gdouble
  is native(json-glib)
  is export
{ * }

sub json_array_get_element (JsonArray $array, guint $index)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_array_get_elements (JsonArray $array)
  returns GList
  is native(json-glib)
  is export
{ * }

sub json_array_get_int_element (JsonArray $array, guint $index)
  returns gint64
  is native(json-glib)
  is export
{ * }

sub json_array_get_length (JsonArray $array)
  returns guint
  is native(json-glib)
  is export
{ * }

sub json_array_get_null_element (JsonArray $array, guint $index)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_array_get_object_element (JsonArray $array, guint $index)
  returns JsonObject
  is native(json-glib)
  is export
{ * }

sub json_array_get_string_element (JsonArray $array, guint $index)
  returns Str
  is native(json-glib)
  is export
{ * }

sub json_array_get_type ()
  returns GType
  is native(json-glib)
  is export
{ * }

sub json_array_hash (JsonArray $key)
  returns guint
  is native(json-glib)
  is export
{ * }

sub json_array_is_immutable (JsonArray $array)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_array_new ()
  returns JsonArray
  is native(json-glib)
  is export
{ * }

sub json_array_ref (JsonArray $array)
  returns JsonArray
  is native(json-glib)
  is export
{ * }

sub json_array_remove_element (JsonArray $array, guint $index)
  is native(json-glib)
  is export
{ * }

sub json_array_seal (JsonArray $array)
  is native(json-glib)
  is export
{ * }

sub json_array_sized_new (guint $n_elements)
  returns JsonArray
  is native(json-glib)
  is export
{ * }

sub json_array_unref (JsonArray $array)
  is native(json-glib)
  is export
{ * }

sub json_node_alloc ()
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_copy (JsonNode $node)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_dup_array (JsonNode $node)
  returns JsonArray
  is native(json-glib)
  is export
{ * }

sub json_node_dup_object (JsonNode $node)
  returns JsonObject
  is native(json-glib)
  is export
{ * }

sub json_node_dup_string (JsonNode $node)
  returns Str
  is native(json-glib)
  is export
{ * }

sub json_node_equal (JsonNode $a, JsonNode $b)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_node_free (JsonNode $node)
  is native(json-glib)
  is export
{ * }

sub json_node_get_array (JsonNode $node)
  returns JsonArray
  is native(json-glib)
  is export
{ * }

sub json_node_get_boolean (JsonNode $node)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_node_get_double (JsonNode $node)
  returns gdouble
  is native(json-glib)
  is export
{ * }

sub json_node_get_int (JsonNode $node)
  returns gint64
  is native(json-glib)
  is export
{ * }

sub json_node_get_node_type (JsonNode $node)
  returns JsonNodeType
  is native(json-glib)
  is export
{ * }

sub json_node_get_object (JsonNode $node)
  returns JsonObject
  is native(json-glib)
  is export
{ * }

sub json_node_get_parent (JsonNode $node)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_get_string (JsonNode $node)
  returns Str
  is native(json-glib)
  is export
{ * }

sub json_node_get_type ()
  returns GType
  is native(json-glib)
  is export
{ * }

sub json_node_get_value (JsonNode $node, GValue $value)
  is native(json-glib)
  is export
{ * }

sub json_node_get_value_type (JsonNode $node)
  returns GType
  is native(json-glib)
  is export
{ * }

sub json_node_hash (JsonNode $key)
  returns guint
  is native(json-glib)
  is export
{ * }

sub json_node_init (JsonNode $node, JsonNodeType $type)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_init_array (JsonNode $node, JsonArray $array)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_init_boolean (JsonNode $node, gboolean $value)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_init_double (JsonNode $node, gdouble $value)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_init_int (JsonNode $node, gint64 $value)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_init_null (JsonNode $node)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_init_object (JsonNode $node, JsonObject $object)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_init_string (JsonNode $node, Str $value)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_is_immutable (JsonNode $node)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_node_is_null (JsonNode $node)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_node_new (JsonNodeType $type)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_ref (JsonNode $node)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_node_seal (JsonNode $node)
  is native(json-glib)
  is export
{ * }

sub json_node_set_array (JsonNode $node, JsonArray $array)
  is native(json-glib)
  is export
{ * }

sub json_node_set_boolean (JsonNode $node, gboolean $value)
  is native(json-glib)
  is export
{ * }

sub json_node_set_double (JsonNode $node, gdouble $value)
  is native(json-glib)
  is export
{ * }

sub json_node_set_int (JsonNode $node, gint64 $value)
  is native(json-glib)
  is export
{ * }

sub json_node_set_object (JsonNode $node, JsonObject $object)
  is native(json-glib)
  is export
{ * }

sub json_node_set_parent (JsonNode $node, JsonNode $parent)
  is native(json-glib)
  is export
{ * }

sub json_node_set_string (JsonNode $node, Str $value)
  is native(json-glib)
  is export
{ * }

sub json_node_set_value (JsonNode $node, GValue $value)
  is native(json-glib)
  is export
{ * }

sub json_node_take_array (JsonNode $node, JsonArray $array)
  is native(json-glib)
  is export
{ * }

sub json_node_take_object (JsonNode $node, JsonObject $object)
  is native(json-glib)
  is export
{ * }

sub json_node_type_name (JsonNode $node)
  returns Str
  is native(json-glib)
  is export
{ * }

sub json_node_unref (JsonNode $node)
  is native(json-glib)
  is export
{ * }

sub json_object_add_member (
  JsonObject $object,
  Str $member_name,
  JsonNode $node
)
  is native(json-glib)
  is export
{ * }

sub json_object_dup_member (JsonObject $object, Str $member_name)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_object_equal (JsonObject $a, JsonObject $b)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_object_foreach_member (
  JsonObject $object,
  &func (JsonObject, Str, JsonNode, gpointer),
  gpointer $data
)
  is native(json-glib)
  is export
{ * }

sub json_object_get_array_member (JsonObject $object, Str $member_name)
  returns JsonArray
  is native(json-glib)
  is export
{ * }

sub json_object_get_boolean_member (JsonObject $object, Str $member_name)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_object_get_double_member (JsonObject $object, Str $member_name)
  returns gdouble
  is native(json-glib)
  is export
{ * }

sub json_object_get_int_member (JsonObject $object, Str $member_name)
  returns gint64
  is native(json-glib)
  is export
{ * }

sub json_object_get_member (JsonObject $object, Str $member_name)
  returns JsonNode
  is native(json-glib)
  is export
{ * }

sub json_object_get_members (JsonObject $object)
  returns GList
  is native(json-glib)
  is export
{ * }

sub json_object_get_null_member (JsonObject $object, Str $member_name)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_object_get_object_member (JsonObject $object, Str $member_name)
  returns JsonObject
  is native(json-glib)
  is export
{ * }

sub json_object_get_size (JsonObject $object)
  returns guint
  is native(json-glib)
  is export
{ * }

sub json_object_get_string_member (JsonObject $object, Str $member_name)
  returns Str
  is native(json-glib)
  is export
{ * }

sub json_object_get_type ()
  returns GType
  is native(json-glib)
  is export
{ * }

sub json_object_get_values (JsonObject $object)
  returns GList
  is native(json-glib)
  is export
{ * }

sub json_object_has_member (JsonObject $object, Str $member_name)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_object_hash (JsonObject $key)
  returns guint
  is native(json-glib)
  is export
{ * }

sub json_object_is_immutable (JsonObject $object)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_object_iter_init (JsonObjectIter $iter, JsonObject $object)
  is native(json-glib)
  is export
{ * }

sub json_object_iter_next (
  JsonObjectIter $iter,
  CArray[Str] $member_name,
  CArray[JsonNode] $member_node
)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_object_new ()
  returns JsonObject
  is native(json-glib)
  is export
{ * }

sub json_object_ref (JsonObject $object)
  returns JsonObject
  is native(json-glib)
  is export
{ * }

sub json_object_remove_member (JsonObject $object, Str $member_name)
  is native(json-glib)
  is export
{ * }

sub json_object_seal (JsonObject $object)
  is native(json-glib)
  is export
{ * }

sub json_object_set_array_member (
  JsonObject $object,
  Str $member_name,
  JsonArray $value
)
  is native(json-glib)
  is export
{ * }

sub json_object_set_boolean_member (
  JsonObject $object,
  Str $member_name,
  gboolean $value
)
  is native(json-glib)
  is export
{ * }

sub json_object_set_double_member (
  JsonObject $object,
  Str $member_name,
  gdouble $value
)
  is native(json-glib)
  is export
{ * }

sub json_object_set_int_member (
  JsonObject $object,
  Str $member_name,
  gint64 $value
)
  is native(json-glib)
  is export
{ * }

sub json_object_set_member (
  JsonObject $object,
  Str $member_name,
  JsonNode $node
)
  is native(json-glib)
  is export
{ * }

sub json_object_set_null_member (JsonObject $object, Str $member_name)
  is native(json-glib)
  is export
{ * }

sub json_object_set_object_member (
  JsonObject $object,
  Str $member_name,
  JsonObject $value
)
  is native(json-glib)
  is export
{ * }

sub json_object_set_string_member (
  JsonObject $object,
  Str $member_name,
  Str $value
)
  is native(json-glib)
  is export
{ * }

sub json_object_unref (JsonObject $object)
  is native(json-glib)
  is export
{ * }

sub json_string_compare (Str $a, Str $b)
  returns gint
  is native(json-glib)
  is export
{ * }

sub json_string_equal (gconstpointer $a, gconstpointer $b)
  returns uint32
  is native(json-glib)
  is export
{ * }

sub json_string_hash (Str $key)
  returns guint
  is native(json-glib)
  is export
{ * }
