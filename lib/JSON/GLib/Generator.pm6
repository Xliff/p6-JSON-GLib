use v6.c;

use NativeCall;

use JSON::GLib::Raw::Types;
use JSON::GLib::Raw::Generator;

use GLib::String;
use JSON::GLib::Node;

use GLib::Roles::Object;

class JSON::GLib::Generator {
  also does GLib::Roles::Object;

  has JsonGenerator $!jg is implementor;

  submethod BUILD ( :generator( :$!jg ) ) { }

  submethod TWEAK { self.roleInit-Object }

  method JSON::GLib::Definitions::JsonGenerator
  { $!jg }


  multi method new (JsonGenerator $generator) {
    $generator ?? self.bless( :$generator ) !! Nil;
  }
  multi method new {
    my $generator = json_generator_new();

    $generator ?? self.bless( :$generator ) !! Nil;
  }

  method indent is rw {
    Proxy.new:
      FETCH => -> $           { self.get_indent    },
      STORE => -> $, Int() \i { self.set_indent(i) };
  }

  method indent-char is rw {
    Proxy.new:
      FETCH => -> $           { self.get_indent_char    },
      STORE => -> $, Int() \i { self.set_indent_char(i) };
  }

  method pretty is rw {
    Proxy.new:
      FETCH => -> $           { self.get_pretty    },
      STORE => -> $, Int() \i { self.set_pretty(i) };
  }

  method root (:$all = False) is rw {
    Proxy.new:
      FETCH => -> $                { self.get_root(:$all)  },
      STORE => -> $, JsonNode() $j { self.set_root($j)     };
  }

  method get_indent {
    json_generator_get_indent($!jg);
  }

  method get_indent_char {
    json_generator_get_indent_char($!jg);
  }

  method get_pretty {
    json_generator_get_pretty($!jg);
  }

  method get_root (:$raw = False) {
    my $n = json_generator_get_root($!jg);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &json_generator_get_type, $n, $t );
  }

  method set_indent (Int() $indent_level) {
    my guint $i = $indent_level;

    json_generator_set_indent($!jg, $i);
  }

  method set_indent_char (Int() $indent_char) {
    my gunichar $i = $indent_char;

    json_generator_set_indent_char($!jg, $i);
  }

  method set_pretty (Int() $is_pretty) {
    my gboolean $i = $is_pretty.so.Int;

    json_generator_set_pretty($!jg, $i);
  }

  method set_root (JsonNode() $node) {
    json_generator_set_root($!jg, $node);
  }

  proto method to_data (|)
  { * }

  multi method to_data (:$all = False) {
    samewith($, :$all);
  }
  multi method to_data ($length is rw, :$all = False) {
    my gsize $l = 0;

    my $d = json_generator_to_data($!jg, $l);
    $length = $l;
    $all.not ?? $d !! ($d, $length);
  }

  method to_file (Str() $filename, CArray[Pointer[GError]] $error = gerror) {
    clear_error;
    my $rv = json_generator_to_file($!jg, $filename, $error);
    set_error($error);
    $rv;
  }

  method to_gstring (GString() $string, :$raw = False) {
    # I can hear the jokes, already....
    my $gs = json_generator_to_gstring($!jg, $string);

    $gs ??
      ( $raw ?? $gs !! GLib::String.new($gs) )
      !!
      Nil;
  }

  method to_stream (
    GOutputStream() $stream,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror
  ) {
    clear_error;
    my $rv = so json_generator_to_stream($!jg, $stream, $cancellable, $error);
    set_error($error);
  }

}
