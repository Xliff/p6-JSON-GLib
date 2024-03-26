use v6.c;

use Test;

lives-ok { use JSON::GLib::Array       }, 'JSON::GLiub::Array loads properly';
lives-ok { use JSON::GLib::Builder     }, 'JSON::Builder loads properly';
lives-ok { use JSON::GLib::Generator   }, 'JSON::Generator loads properly';
lives-ok { use JSON::GLib::Node        }, 'JSON::GLib::Node loads properly';
