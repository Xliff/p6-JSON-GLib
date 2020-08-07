use v6.c;

use Test;

use JSON::GLib::Raw::Types;

use GLib::Variant;
use JSON::GLib::Variant;

my @two-way-test-cases = (
  { name => '/boolean',               sig => '(b)',     vdata => '(true,)',                                           jdata => '[true]'                      },
  { name => "/byte",                  sig => "(y)",     vdata => "(byte 0xff,)",                                      jdata => "[255]"                       },
  { name => "/int16",                 sig => "(n)",     vdata => "(int16 -12345,)",                                   jdata => "[-12345]"                    },
  { name => "/uint16",                sig => "(q)",     vdata => "(uint16 40001,)",                                   jdata => "[40001]"                     },
  { name => "/int32",                 sig => "(i)",     vdata => "(-7654321,)",                                       jdata => "[-7654321]"                  },
  { name => "/uint32",                sig => "(u)",     vdata => "(uint32 12345678,)",                                jdata => "[12345678]"                  },
  { name => "/int64",                 sig => "(x)",     vdata => "(int64 -666999666999,)",                            jdata => "[-666999666999]"             },
  { name => "/uint64",                sig => "(t)",     vdata => "(uint64 1999999999999999,)",                        jdata => "[1999999999999999]"          },
  { name => "/handle",                sig => "(h)",     vdata => "(handle 1,)",                                       jdata => "[1]"                         },
  { name => "/double",                sig => "(d)",     vdata => "(1.23,)",                                           jdata => "[1.23]"                      },
  { name => "/double-whole",          sig => "(d)",     vdata => "(123.0,)",                                          jdata => "[123.0]"                     },
  { name => "/string",                sig => "(s)",     vdata => "('hello world!',)",                                 jdata => "[\"hello world!\"]"          },
  { name => "/object-path",           sig => "(o)",     vdata => "(objectpath '/org/gtk/json_glib',)",                jdata => "[\"/org/gtk/json_glib\"]"    },
  { name => "/signature",             sig => "(g)",     vdata => "(signature '(asna\{sv\}i)',)",                      jdata => "[\"(asna\{sv\}i)\"]"           },
  { name => "/maybe/simple/null",     sig => "(ms)",    vdata => "(\@ms nothing,)",                                   jdata => "[null]"                      },
  { name => "/maybe/simple/string",   sig => "(ms)",    vdata => "(\@ms 'maybe string',)",                            jdata => "[\"maybe string\"]"          },
  { name => "/maybe/container/null",  sig => "(m(sn))", vdata => "(\@m(sn) nothing,)",                                jdata => "[null]"                      },
  { name => "/maybe/container/tuple", sig => "(m(sn))", vdata => "(\@m(sn) ('foo', 0),)",                             jdata => "[[\"foo\",0]]"               },
  { name => "/maybe/variant/boolean", sig => "(mv)",    vdata => "(\@mv <true>,)",                                    jdata => "[true]"                      },
  { name => "/array/empty",           sig => "as",      vdata => "\@as []",                                           jdata => "[]"                          },
  { name => "/array/byte",            sig => "ay",      vdata => "[byte 0x01, 0x0a, 0x03, 0xff]",                     jdata => "[1,10,3,255]"                },
  { name => "/array/string",          sig => "as",      vdata => "['a', 'b', 'ab', 'ba']",                            jdata => "[\"a\",\"b\",\"ab\",\"ba\"]" },
  { name => "/array/array/int32",     sig => "aai",     vdata => "[[1, 2], [3, 4], [5, 6]]",                          jdata => "[[1,2],[3,4],[5,6]]"         },
  { name => "/array/variant",         sig => "av",      vdata => "[<true>, <int64 1>, <'oops'>, <int64 -2>, <0.5>]",  jdata => "[true,1,\"oops\",-2,0.5]"    },

  {
    name  => "/tuple",
    sig   => "(bynqiuxthds)",
    vdata => "(false, byte 0x00, int16 -1, uint16 1, -2, uint32 2, int64 429496729, uint64 3, handle 16, 2.48, 'end')",
    jdata => "[false,0,-1,1,-2,2,429496729,3,16,2.48,\"end\"]"
  },

  { name => "/dictionary/empty",        sig => 'a{sv}', vdata => '@a{sv} {}',                                         jdata => '{}' },
  { name => "/dictionary/single-entry", sig => '{ss}',  vdata => "\{'hello', 'world'\}",                              jdata => '{"hello":"world"}' },

  {
    name  => "/dictionary/string-int32",
    sig   => "a\{si\}",
    vdata => "\{'foo': 1, 'bar': 2\}",
    jdata => "\{\"foo\":1,\"bar\":2}"
  },

  {
    name  => "/dictionary/string-variant",
    sig   => "a\{sv\}",
    vdata => "\{'str': <'hi!'>, 'bool': <true>\}",
    jdata => "\{\"str\":\"hi!\",\"bool\":true}"
  },

  {
    name  => "/dictionary/int64-variant",
    sig   => "a\{xv\}",
    vdata => "\{int64 -5: <'minus five'>, 10: <'ten'>\}",
    jdata => "\{\"-5\":\"minus five\",\"10\":\"ten\"\}"
  },

  {
    name  => "/dictionary/uint64-boolean",
    sig   => "a\{tb\}",
    vdata => "\{uint64 999888777666: true, 0: false\}",
    jdata => "\{\"999888777666\":true,\"0\":false}"
  },

  {
    name  => "/dictionary/boolean-variant",
    sig   => "a\{by\}",
    vdata => "\{true: byte 0x01, false: 0x00\}",
    jdata => "\{\"true\":1,\"false\":0\}"
  },

  {
    name  => "/dictionary/double-string",
    sig   => "a\{ds\}",
    vdata => "\{1.0: 'one point zero'\}",
    jdata => "\{\"1.000000\":\"one point zero\"\}"
  },

  {
    name  => "/variant/string",
    sig   => "(v)",
    vdata => "(<'string within variant'>,)",
    jdata => "[\"string within variant\"]"
  },

  {
    name  => "/variant/maybe/null",
    sig   => "(v)",
    vdata => "(<\@mv nothing>,)",
    jdata => "[null]"
  },

  {
    name  => "/variant/dictionary",
    sig   => "v",
    vdata => "<\{'foo': <'bar'>, 'hi': <int64 1024>\}>",
    jdata => "\{\"foo\":\"bar\",\"hi\":1024\}"
  },

  {
    name  => "/variant/variant/array",
    sig   => "v",
    vdata => "<[<'any'>, <'thing'>, <int64 0>, <int64 -1>]>",
    jdata => "[\"any\",\"thing\",0,-1]"
  },

  {
    name  => "/deep-nesting",
    sig   => "a(a(a(a(a(a(a(a(a(a(s))))))))))",
    vdata => "[([([([([([([([([([('sorprise',)],)],)],)],)],)],)],)],)],)]",
    jdata => "[[[[[[[[[[[[[[[[[[[[\"sorprise\"]]]]]]]]]]]]]]]]]]]]"
  },

  {
    name  => "/mixed1",
    sig   => "a\{s(syba(od))\}",
    vdata => "\{'foo': ('bar', byte 0x64, true, [(objectpath '/baz', 1.3), ('/cat', -2.5)])\}",
    jdata => "\{\"foo\":[\"bar\",100,true,[[\"/baz\",1.3],[\"/cat\",-2.5]]]\}"
  },

  {
    name   => "/mixed2",
    sig    => "(a\{by\}amsvmaba\{qm(sg)\})",
    vdata  => "(\{true: byte 0x01, false: 0x00}, [\@ms 'do', nothing, 'did'], <\@av []>, \@mab nothing, \{uint16 10000: \@m(sg) ('yes', 'august'), 0: nothing\})",
    jdata  => "[\{\"true\":1,\"false\":0},[\"do\",null,\"did\"],[],null,\{\"10000\":[\"yes\",\"august\"],\"0\":null\}]"
  }
);

my @json_to_gvariant_test_cases = (
  { name => '/string-to-boolean',      sig => '(b)', vdata => '(true,)',                    jdata => "[\"true\"]"             },
  { name => '/string-to-byte',         sig => '(y)', vdata => '(byte 0xff,)',               jdata => "[\"255\"]"              },
  { name => '/string-to-int16',        sig => '(n)', vdata => '(int16 -12345,)',            jdata => "[\"-12345\"]"           },
  { name => '/string-to-uint16',       sig => '(q)', vdata => '(uint16 40001,)',            jdata => "[\"40001\"]"            },
  { name => '/string-to-int32',        sig => '(i)', vdata => '(-7654321,)',                jdata => "[\"-7654321\"]"         },
  { name => '/string-to-int64',        sig => '(x)', vdata => '(int64 -666999666999,)',     jdata => "[\"-666999666999\"]"    },
  { name => '/string-to-uint64',       sig => '(t)', vdata => '(uint64 1999999999999999,)', jdata => "[\"1999999999999999\"]" },
  { name => '/string-to-double',       sig => '(d)', vdata => '(1.23,)',                    jdata => "[\"1.23\"]"             },
  { name => '/string-to-double-whole', sig => '(d)', vdata => '(123.0,)',                   jdata => "[\"123.0\"]"            }
);

sub gvariant-to-json ($test) {
  my $v = GLib::Variant.parse($test<sig>, $test<vdata>);
  #my $d = JSON::GLib::Variant.serialize($v);

  #ok $d, 'Variant data can be serialized';

  my $jd = JSON::GLib::Variant.serialize-data($v);
  is $jd.chars, $test<jdata>.chars, 'Serialized data is the proper length';
  is       $jd,       $test<jdata>, 'Serialized data matches expected result';
}

sub json-to-gvariant ($test) {
  my $v = JSON::GLib::Variant.deserialize-data($test<jdata>, $test<sig>);
  my $vd = $v.print;

  ok $v, 'JSON data can be deserialized';
  is $vd, $test<vdata>, 'Deserialized data is correct'
}

for @two-way-test-cases {
  subtest "/gvariant/to-json{ .<name> }", { gvariant-to-json($_) }
}
for @two-way-test-cases {
  subtest "/gvariant/from-json{ .<name> }", { json-to-gvariant($_) }
}
for @json_to_gvariant_test_cases {
  subtest "/gvariant/from-json{ .<name> }", { json-to-gvariant($_) }
}
