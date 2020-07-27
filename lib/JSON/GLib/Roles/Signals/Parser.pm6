use v6.c;

use NativeCall;

use JSON::GLib::Raw::Types;

role JSON::GLib::Roles::Signals::Parser {
  has %!signals-p;

  # JsonParser, JsonArray, gint, gpointer
  method connect-array-element (
    $obj,
    $signal = 'array-element',
    &handler?
  ) {
    my $hid;
    %!signals-p{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-array-element($obj, $signal,
        -> $, $ja, $g, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $ja, $g, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-p{$signal}[0].tap(&handler) with &handler;
    %!signals-p{$signal}[0];
  }

  # JsonParser, JsonArray, gpointer
  method connect-array-end (
    $obj,
    $signal = 'array-end',
    &handler?
  ) {
    my $hid;
    %!signals-p{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-array-end($obj, $signal,
        -> $, $ja, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $ja, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-p{$signal}[0].tap(&handler) with &handler;
    %!signals-p{$signal}[0];
  }

  # JsonParser, gpointer, gpointer
  method connect-error (
    $obj,
    $signal = 'error',
    &handler?
  ) {
    my $hid;
    %!signals-p{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-error($obj, $signal,
        -> $, $g, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $g, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-p{$signal}[0].tap(&handler) with &handler;
    %!signals-p{$signal}[0];
  }

  # JsonParser, JsonObject, gpointer
  method connect-object-end (
    $obj,
    $signal = 'object-end',
    &handler?
  ) {
    my $hid;
    %!signals-p{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-object-end($obj, $signal,
        -> $, $jo, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $jo, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-p{$signal}[0].tap(&handler) with &handler;
    %!signals-p{$signal}[0];
  }

  # JsonParser, JsonObject, gchar, gpointer
  method connect-object-member (
    $obj,
    $signal = 'object-member',
    &handler?
  ) {
    my $hid;
    %!signals-p{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-object-member($obj, $signal,
        -> $, $jo, $g, $ud {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $jo, $g, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-p{$signal}[0].tap(&handler) with &handler;
    %!signals-p{$signal}[0];
  }

}


# JsonParser, JsonArray, gint, gpointer
sub g-connect-array-element(
  Pointer $app,
  Str $name,
  &handler (Pointer, JsonArray, gint, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# JsonParser, JsonArray, gpointer
sub g-connect-array-end(
  Pointer $app,
  Str $name,
  &handler (Pointer, JsonArray, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# JsonParser, gpointer, gpointer
sub g-connect-error(
  Pointer $app,
  Str $name,
  &handler (Pointer, gpointer, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# JsonParser, JsonObject, gpointer
sub g-connect-object-end(
  Pointer $app,
  Str $name,
  &handler (Pointer, JsonObject, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# JsonParser, JsonObject, gchar, gpointer
sub g-connect-object-member(
  Pointer $app,
  Str $name,
  &handler (Pointer, JsonObject, Str, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
