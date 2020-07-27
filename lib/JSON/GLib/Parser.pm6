use v6.c;

use NativeCall;

use JSON::GLib::Raw::Types;
use JSON::GLib::Raw::Parser;

use JSON::GLib::Node;

use GLib::Roles::Object;
use JSON::GLib::Roles::Signals::Parser;

class JSON::GLib::Parser {
  also does GLib::Roles::Object;
  also does JSON::GLib::Roles::Signals::Parser;

  has JsonParser $!jp is implementor;

  submethod BUILD ( :parser(:$!jp) ) { }
  submethod TWEAK                    { self.roleInit-Object }

  method JSON::GLib::Definitions::JsonParser
  { $!jp }

  method new {
    my $parser = json_parser_new();

    $parser ?? self.bless( :$parser ) !! Nil;
  }

  method new_immutable {
    my $parser = json_parser_new_immutable();

    $parser ?? self.bless( :$parser ) !! Nil;
  }

  # Type: gboolean
  method immutable is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('immutable', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'immutable is a construct-only attribute'
      }
    );
  }

  # Is originally:
  # JsonParser, JsonArray, gint, gpointer --> void
  method array-element {
    self.connect-array-element($!jp);
  }

  # Is originally:
  # JsonParser, JsonArray, gpointer --> void
  method array-end {
    self.connect-array-end($!jp);
  }

  # Is originally:
  # JsonParser, gpointer --> void
  method array-start {
    self.connect($!jp, 'array-start');
  }

  # Is originally:
  # JsonParser, gpointer, gpointer --> void
  method error {
    self.connect-error($!jp);
  }

  # Is originally:
  # JsonParser, JsonObject, gpointer --> void
  method object-end {
    self.connect-object-end($!jp);
  }

  # Is originally:
  # JsonParser, JsonObject, gchar, gpointer --> void
  method object-member {
    self.connect-object-member($!jp);
  }

  # Is originally:
  # JsonParser, gpointer --> void
  method object-start {
    self.connect($!jp, 'object-start');
  }

  # Is originally:
  # JsonParser, gpointer --> void
  method parse-end {
    self.connect($!jp, 'parse-end');
  }

  # Is originally:
  # JsonParser, gpointer --> void
  method parse-start {
    self.connect($!jp, 'parse-start');
  }

  method error_quark (JSON::Parser::U: ) {
    json_parser_error_quark();
  }

  method get_current_line {
    json_parser_get_current_line($!jp);
  }

  method get_current_pos {
    json_parser_get_current_pos($!jp);
  }

  method get_root (:$raw = False) {
    my $n = json_parser_get_root($!jp);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil
  }

  method get_type {
    state ($n, $t);l

    unstable_get_type( self.^name, &json_parser_get_type, $n, $t );
  }

  method has_assignment (Str() $variable_name) {
    so json_parser_has_assignment($!jp, $variable_name);
  }

  method load_from_data (
    Str() $data,
    Int() $length                  = -1,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my gssize $l = $length;

    clear_error;
    my $rv = so json_parser_load_from_data($!jp, $data, $l, $error);
    set_error($error);
    $rv;
  }

  method load_from_file (
    Str() $filename,
    CArray[Pointer[GError]] $error = gerror
  ) {
    clear_error;
    my $rv = so json_parser_load_from_file($!jp, $filename, $error);
    set_error($erro);
    $rv;
  }

  method load_from_stream (
    GInputStream() $stream,
    GCancellable() $cancellable    = GCancellable,
    CArray[Pointer[GError]] $error = gerror
  ) {
    clear_error;
    my $rv = so json_parser_load_from_stream(
      $!jp,
      $stream,
      $cancellable,
      $error
    );
    set_error($error);
    $rv;
  }

  proto method load_from_stream_async (|)
  { * }

  multi method load_from_stream_async (
    GInputStream() $stream,
    &callback,
    gpointer $user_data = gpointer
  ) {
    samewith(stream, GCancellable, &callback, $user_data);
  }
  multi method load_from_stream_async (
    GInputStream() $stream,
    GCancellable() $cancellable,
    &callback,
    gpointer $user_data = gpointer
  ) {
    json_parser_load_from_stream_async(
      $!jp,
      $stream,
      $cancellable,
      &callback,
      $user_data
    );
  }

  method load_from_stream_finish (
    GAsyncResult() $result,
    CArray[Pointer[GError]] $error = gerror
  ) {
    clear_error;
    my $rv = so json_parser_load_from_stream_finish($!jp, $result, $error);
    set_error($error);
    $rv;
  }

  method steal_root (:$raw = False) {
    my $n = json_parser_steal_root($!jp);

    $n ??
      ( $raw ?? $n !! JSON::GLib::Node.new($n) )
      !!
      Nil
  }

}
