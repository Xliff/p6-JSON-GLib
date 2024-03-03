use v6.c;

use NativeCall;

use GLib::Raw::Definitions;

use GLib::Roles::Pointers;

unit package JSON::GLib::Raw::Definitions;

my constant forced = 210;

constant json-glib is export = 'json-glib-1.0',v0;

class JsonArray     is repr<CPointer> is export does GLib::Roles::Pointers { }
class JsonBuilder   is repr<CPointer> is export does GLib::Roles::Pointers { }
class JsonGenerator is repr<CPointer> is export does GLib::Roles::Pointers { }
class JsonNode      is repr<CPointer> is export does GLib::Roles::Pointers { }
class JsonObject    is repr<CPointer> is export does GLib::Roles::Pointers { }
class JsonParser    is repr<CPointer> is export does GLib::Roles::Pointers { }
class JsonPath      is repr<CPointer> is export does GLib::Roles::Pointers { }
class JsonReader    is repr<CPointer> is export does GLib::Roles::Pointers { }

constant JsonNodeType is export := guint32;
our enum JsonNodeTypeEnum is export <
  JSON_NODE_OBJECT
  JSON_NODE_ARRAY
  JSON_NODE_VALUE
  JSON_NODE_NULL
>;

constant JsonParserError is export := guint32;
our enum JsonParserErrorEnum is export <
  JSON_PARSER_ERROR_PARSE
  JSON_PARSER_ERROR_TRAILING_COMMA
  JSON_PARSER_ERROR_MISSING_COMMA
  JSON_PARSER_ERROR_MISSING_COLON
  JSON_PARSER_ERROR_INVALID_BAREWORD
  JSON_PARSER_ERROR_EMPTY_MEMBER_NAME
  JSON_PARSER_ERROR_INVALID_DATA
  JSON_PARSER_ERROR_UNKNOWN
>;

constant JsonPathError is export := guint32;
our enum JsonPathErrorEnum is export <
  JSON_PATH_ERROR_INVALID_QUERY
>;

constant JsonReaderError is export := guint32;
our enum JsonReaderErrorEnum is export <
  JSON_READER_ERROR_NO_ARRAY
  JSON_READER_ERROR_INVALID_INDEX
  JSON_READER_ERROR_NO_OBJECT
  JSON_READER_ERROR_INVALID_MEMBER
  JSON_READER_ERROR_INVALID_NODE
  JSON_READER_ERROR_NO_VALUE
  JSON_READER_ERROR_INVALID_TYPE
>;

class JsonObjectIter is repr<CStruct> is export does GLib::Roles::Pointers {
  HAS gpointer @!priv_pointer[6] is CArray;
  HAS int64    @!priv_int[2]     is CArray;
  HAS gboolean @!priv_boolean[1] is CArray;
}