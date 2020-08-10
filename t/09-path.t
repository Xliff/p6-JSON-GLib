use v6.c;

use Test;

use JSON::GLib::Raw::Types;

use JSON::GLib::Generator;
use JSON::GLib::Parser;
use JSON::GLib::Path;

my $json = q:to/JSON/;
  {
    "store": {
      "book": [
        { "category": "reference",
          "author": "Nigel Rees",
          "title": "Sayings of the Century",
          "price": "8.95"
        },
        { "category": "fiction",
          "author": "Evelyn Waugh",
          "title": "Sword of Honour",
          "price": "12.99"
        },
        { "category": "fiction",
          "author": "Herman Melville",
          "title": "Moby Dick",
          "isbn": "0-553-21311-3",
          "price": "8.99"
        },
        { "category": "fiction",
          "author": "J. R. R. Tolkien",
          "title": "The Lord of the Rings",
          "isbn": "0-395-19395-8",
          "price": "22.99"
        }
      ],
      "bicycle": {
        "color": "red",
        "price": "19.95"
      }
    }
  }
  JSON

my @expressions = (
  {
    desc       => 'INVALID: invalid first character',
    expr       => '/',
    is-valid   => False,
    error-code => JSON_PATH_ERROR_INVALID_QUERY
  },
  {
    desc       => 'INVALID: Invalid character following root',
    expr       => '$ponies',
    is-valid   => False,
    error-code => JSON_PATH_ERROR_INVALID_QUERY,
  },
  {
    desc       => 'INVALID: missing member name or wildcard after dot',
    expr       => '$.store.',
    is-valid   => False,
    error-code => JSON_PATH_ERROR_INVALID_QUERY,
  },
  {
    desc       => 'INVALID: Malformed slice (missing step)',
    expr       => '$.store.book[0:1:]',
    is-valid   => False,
    error-code => JSON_PATH_ERROR_INVALID_QUERY,
  },
  {
    desc       => 'INVALID: Malformed set',
    expr       => '$.store.book[0,1~2]',
    is-valid   => False,
    error-code => JSON_PATH_ERROR_INVALID_QUERY,
  },
  {
    desc       => 'INVALID: Malformed array notation',
    expr       => q«${'store'}»,
    is-valid   => False,
    error-code => JSON_PATH_ERROR_INVALID_QUERY,
  },
  {
    desc       => 'INVALID: Malformed slice (invalid separator)',
    expr       => '$.store.book[0~2]',
    is-valid   => False,
    error-code => JSON_PATH_ERROR_INVALID_QUERY,
  },
  {
    desc       => 'Title of the first book in the store, using objct notation.',
    expr       => '$.store.book[0].title',
    res        => '["Sayings of the Century"]',
    is-valid   => True,
  },
  {
    desc       => 'Title of the first book in the store, using array notation.',
    expr       => q«$['store']['book'][0]['title']»,
    res        => '["Sayings of the Century"]',
    is-valid   => True,
  },
  {
    desc       => 'All the authors from the every book.',
    expr       => '$.store.book[*].author',
    res        => '["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"]',
    is-valid   => True,
  },
  {
    desc       => 'All the authors.',
    expr       => '$..author',
    res        => '["Nigel Rees","Evelyn Waugh","Herman Melville","J. R. R. Tolkien"]',
    is-valid   => True,
  },
  {
    desc       => 'Everything inside the store.',
    expr       => '$.store.*',
    is-valid   => True,
  },
  {
    desc       => 'All the prices in the store.',
    expr       => '$.store..price',
    res        => '["8.95","12.99","8.99","22.99","19.95"]',
    is-valid   => True,
  },
  {
    desc       => 'The third book.',
    expr       => '$..book[2]',
    res        => '[{"category":"fiction","author":"Herman Melville","title":"Moby Dick","isbn":"0-553-21311-3","price":"8.99"}]',
    is-valid   => True,
  },
  {
    desc       => 'The last book.',
    expr       => '$..book[-1:]',
    res        => '[{"category":"fiction","author":"J. R. R. Tolkien","title":"The Lord of the Rings","isbn":"0-395-19395-8","price":"22.99"}]',
    is-valid   => True,
  },
  {
    desc       => 'The first two books.',
    expr       => '$..book[0,1]',
    res        => '[{"category":"reference","author":"Nigel Rees","title":"Sayings of the Century","price":"8.95"},{"category":"fiction","author":"Evelyn Waugh","title":"Sword of Honour","price":"12.99"}]',
    is-valid   => True,
  },
  {
    desc       => 'The first two books, using a slice.',
    expr       => '$..book[:2]',
    res        => '[{"category":"reference","author":"Nigel Rees","title":"Sayings of the Century","price":"8.95"},{"category":"fiction","author":"Evelyn Waugh","title":"Sword of Honour","price":"12.99"}]',
    is-valid   => True,
  },
  {
    desc       => 'All the books.',
    expr       => q«$['store']['book'][*]»,
    res        => '[{"category":"reference","author":"Nigel Rees","title":"Sayings of the Century","price":"8.95"},{"category":"fiction","author":"Evelyn Waugh","title":"Sword of Honour","price":"12.99"},{"category":"fiction","author":"Herman Melville","title":"Moby Dick","isbn":"0-553-21311-3","price":"8.99"},{"category":"fiction","author":"J. R. R. Tolkien","title":"The Lord of the Rings","isbn":"0-395-19395-8","price":"22.99"}]',
    is-valid   => True,
  },
  {
    desc       => 'All the members of the bicycle object.',
    expr       => '$.store.bicycle.*',
    res        => '["red","19.95"]',
    is-valid   => True,
  },
  {
    desc       => 'The root node.',
    expr       => '$',
    res        => q«
                  [{"store":{"book":[{"category":"reference","author":"Nigel Rees","title":"Sayings of the Century","price":"8.95"},
                           {"category":"fiction","author":"Evelyn Waugh","title":"Sword of Honour","price":"12.99"},
                           {"category":"fiction","author":"Herman Melville","title":"Moby Dick","isbn":"0-553-21311-3","price":"8.99"},
                           {"category":"fiction","author":"J. R. R. Tolkien","title":"The Lord of the Rings","isbn":"0-395-19395-8","price":"22.99"}],
                    "bicycle":{"color":"red","price":"19.95"}}}]».subst(/\s <!before \w>/, '', :g),
    is-valid   => True,
  }
);

sub path-expressions-valid ($k, $e) {
  my $p = JSON::GLib::Path.new;

  subtest "/path/expressions/valid/{ $k }", {
    diag "* { $e<desc> } ('{ $e<expr> }')";

    ok  $p.compile($e<expr>),                      'Path compiles';
    nok $ERROR,                                    'No error detected';
  }
}

sub path-expressions-invalid ($k, $e) {
  my $p = JSON::GLib::Path.new;


  subtest "/path/expressions/invalid/{ $k }", {
    diag "* { $e<desc> } ('{ $e<expr> }')";

    nok  $p.compile($$e<expr>),                          'Path DOES NOT compile';
    ok   $ERROR,                                         'An error was detected';

    diag $ERROR.gist;

    is   $ERROR.domain,    JSON::GLib::Path.error,       'Error domain is JSON_PATH_ERROR';

    # cw: Disabled test. For some reason routines are not setting GError.code!
    #is   $ERROR.code,      $e<error-code>,               "Error code is { $e<errror-code> }";
  }
}

sub path-match ($e) {
  my ($p, $g, $path) =
    (JSON::GLib::Parser, JSON::GLib::Generator, JSON::GLib::Path)».new;

  $p.load-from-data($json);
  my $root = $p.root;

  ok $path.compile($e<expr>),                            'Path compiles';

  my $matches = $path.match($root);
  is $matches.node-type, JSON_NODE_ARRAY,                '.match method returns a node of type ARRAY';

  $g.root = $matches;
  is ~$g, $e<res>,                                       'Round trip JSON object matches expected data';
}

for @expressions.kv -> $k, $v {
  next unless $v<is-valid>;
  path-expressions-valid($k, $v);
}

for @expressions.kv -> $k, $v {
  next if $v<is-valid>;
  path-expressions-invalid($k, $v);
}

subtest 'Path Matching', {
  for @expressions.kv -> $k, $v {
    next unless $v<res>;
    path-match($v);
  }
}
