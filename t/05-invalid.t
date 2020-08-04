use v6.c;

use Test;

use JSON::GLib::Raw::Types;

use JSON::GLib::Parser;

sub test-specific-invalidity ($j, $c) {
  my $parser = JSON::GLib::Parser.new;
  isa-ok $parser, JSON::GLib::Parser, 'JSON::GLib::Parser can be instantiated';

  my $res = $parser.load-from-data($j);

  nok $res, "JSON::GLib::Parser recognizes '{ $j }' as invalid";
  is $ERROR.domain, JSON::GLib::Parser.error_quark, 'ERROR is in the proper domain';
  is $ERROR.code, $c.Int, 'ERROR contains the proper code';

  if %*ENV<JSON_GLIB_DEBUG> {
    diag "invalid data: '{ $j }'";
    diag "expected error: { $ERROR.message }";
  }
}

multi sub test-invalid ($j, 'bareword') {
  test-specific-invalidity($j, JSON_PARSER_ERROR_INVALID_BAREWORD);
}

multi sub test-invalid ($j, 'missing-comma') {
  test-specific-invalidity($j, JSON_PARSER_ERROR_MISSING_COMMA);
}

multi sub test-invalid ($j, 'trailing-comma') {
  test-specific-invalidity($j, JSON_PARSER_ERROR_TRAILING_COMMA);
}

multi sub test-invalid ($j) {
  my $parser = JSON::GLib::Parser.new;
  isa-ok $parser, JSON::GLib::Parser, 'JSON::GLib::Parser can be instantiated';

  my $res = $parser.load-from-data($j);
  nok $res, "JSON::GLib::Parser recognizes '{ $j }' as invalid";
  ok $ERROR, 'Global $ERROR is defined';

  diag "expected error: { $ERROR.message }" if $*ENV<JSON-GLIB-DEBUG>;
}

my @tests = (
  # Barewords
  [ 'bareword-1', 'rainbows'              ],
  [ 'bareword-2', '[ unicorns ]'          ],
  [ 'bareword-3', '{ \"foo\" : ponies }'  ],
  [ 'bareword-4', '[ 3, 2, 1, lift_off ]' ],
  [ 'bareword-5', '{ foo : 42 }'          ],

  # values
  [ 'values-1', '[ -false ]'         ],

  # assignment
  [ 'assignment-1', 'var foo'        ],
  [ 'assignment-2', 'var foo = no'   ],
  [ 'assignment-3', 'var = true'     ],
  [ 'assignment-4', 'var blah = 42:' ],
  [ 'assignment-5', 'let foo = true;'],

  # arrays
  [ 'array-1', '[ true, false'  ],
  [ 'array-2', '[ true }'       ],
  [ 'array-3', '[ "foo" : 42 ]' ],

  # objects
  [ 'object-1', '{ foo : 42 }'        ],
  [ 'object-2', '{ 42 : "foo" }'      ],
  [ 'object-3', '{ "foo", 42 }'       ],
  [ 'object-4', '{ "foo" : 42 ]'      ],
  [ 'object-5', '{ "blah" }'          ],
  [ 'object-6', '{ "a" : 0 "b" : 1 }' ],
  [ 'object-7', '{ null: false }'     ],

  # missing commas
  [ 'missing-comma-1', '[ true false ]'                 ],
  [ 'missing-comma-2', '{ "foo": 42 "bar": null }' ],

  # trailing commas
  [ 'trailing-comma-1', '[ true, ]'       ],
  [ 'trailing-comma-2', '{ "foo" : 42, }' ]
);

for @tests -> $t {
  given $t[0] {
    when .starts-with('bareword')       { test-invalid($t[1], 'bareword')       }
    when .starts-with('missing-comma')  { test-invalid($t[1], 'missing-comma')  }
    when .starts-with('trailing-comma') { test-invalid($t[1], 'trailing-comma') }

    default                             { test-invalid($t[1])                   }

  }
}
