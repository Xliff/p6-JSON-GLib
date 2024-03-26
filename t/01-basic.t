use v6.c;

use Test;

lives-ok { use JSON::GLib::Array       }, 'JSON::GLib::Array loads properly';
lives-ok { use JSON::GLib::Builder     }, 'JSON::GLib::Builder loads properly';
lives-ok { use JSON::GLib::Generator   }, 'JSON::GLib::Generator loads properly';
lives-ok { use JSON::GLib::Node        }, 'JSON::GLib::Node loads properly';
lives-ok { use JSON::GLib::Object      }, 'JSON::GLib::Object loads properly';
lives-ok { use JSON::GLib::Parser      }, 'JSON::GLib::Parser loads properly';
lives-ok { use JSON::GLib::Path        }, 'JSON::GLib::Path loads properly';
lives-ok { use JSON::GLib::Reader      }, 'JSON::GLib::Reader loads properly';
lives-ok { use JSON::GLib::Variant     }, 'JSON::GLib::Variant loads properly';
