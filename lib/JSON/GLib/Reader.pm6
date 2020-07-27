use v6.c;

use JSON::GLib::Raw::Types;
use JSON::GLib::Raw::Reader;

use JSON::GLib::Node;

use GLib::Roles::Object;

class JSON::GLib::Reader {
  also does GLib::Roles::Object;

  has JsonReader $!jr;

  submethod BUILD ( :reader(:$!jr) ) { }

  submethod TWEAK                    { self.roleInit-Object }


  method JSON::GLib::Raw::Definitions::JsonReader
  { $!jr }

  multi method new (JsonReader $reader) {
    $reader ?? self.bless( :$reader ) !! Nil;
  }
  multi method new {
    my $reader = json_reader_new();

    $reader ?? self.bless( :$reader ) !! Nil;
  }

  # Type: JsonNode
  method root (:$raw = False) is rw  {
    my $gv = GLib::Value.new( JSON::GLib::Node.get_type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
      	  self.prop_get('root', $gv)
      	);

        my $p = $gv.pointer;

        return Nil unless $p;
        return $p = cast(JsonNode, $p) if $raw;

        JSON::GLib::Node.new($p);
      },
      STORE => -> $, JsonNode() \n {
        self.set_root(n);
      }
    );
  }


  method count_elements {
    json_reader_count_elements($!jr);
  }

  method count_members {
    json_reader_count_members($!jr);
  }

  method end_element {
    json_reader_end_element($!jr);
  }

  method end_member {
    json_reader_end_member($!jr);
  }

  method error_quark (JSON::GLib::Reader:U ) {
    json_reader_error_quark();
  }

  method get_boolean_value {
    so json_reader_get_boolean_value($!jr);
  }

  method get_double_value {
    json_reader_get_double_value($!jr);
  }

  method get_error {
    json_reader_get_error($!jr);
  }

  method get_int_value {
    json_reader_get_int_value($!jr);
  }

  method get_member_name {
    json_reader_get_member_name($!jr);
  }

  method get_null_value {
    so json_reader_get_null_value($!jr);
  }

  method get_string_value {
    json_reader_get_string_value($!jr);
  }

  method get_type {
    state ($n, $t)

    unstable_get_type( self.^name, &json_reader_get_type, $n, $t );
  }

  method get_value (:$raw = False) {
    my $n = json_reader_get_value($!jr);

    $n
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method is_array {
    so json_reader_is_array($!jr);
  }

  method is_object {
    so json_reader_is_object($!jr);
  }

  method is_value {
    so json_reader_is_value($!jr);
  }

  method list_members {
    CArrayToArray( json_reader_list_members($!jr) );
  }

  method read_element (Int() $index) {
    my guint $i = $index;

    json_reader_read_element($!jr, $index);
  }

  method read_member (Str() $member_name) {
    so json_reader_read_member($!jr, $member_name);
  }

  method set_root (JsonNode() $root) {
    json_reader_set_root($!jr, $root);
  }
}
