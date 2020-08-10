use v6.c;

use Test;

use JSON::GLib::Raw::Types;

use JSON::GLib::Parser;
use JSON::GLib::Reader;

my $base_array   = '[ 0, true, null, "foo", 3.14, [ false ], { "bar" : 42 } ]';
my $base_object  = '{ "text" : "hello, world!", "foo" : null, "blah" : 47, "double" : 42.47 }';
my $reader_level = ' { "list": { "181195771": { "given_url": "http://www.gnome.org/json-glib-test" } } }';

# https://bugzilla.gnome.org/show_bug.cgi?id=758580
my $null_value_data   = '{ "v": null }';

my @expected_member_name = <text foo blah double>;

subtest 'Base Object', {
  my ($p, $r) = (JSON::GLib::Parser, JSON::GLib::Reader)».new;

  $p.load-from-data($base_object);
  nok $ERROR,                                            'No errors detected from parser';

  $r.root = $p.root;
  ok $r.is-object,                                       'Reader currently points to an OBJECT';
  is $r.m-elems,             4,                          'OBJECT on reader currently has the proper number of members';

  my @m = $r.members;
  ok +@m > 0,                                            'Members list contains elements';

  for @m.kv -> $k, $v {
    is $v, @expected_member_name[$k], "Member ⌗{ $k } matches expected name of '{ @expected_member_name[$k] }'";
  }

  ok $r.read-member('text'),                             q«Can read data from the 'text' member»;
  ok $r.is-value,                                        q«Value associated with the 'text' member is a VALUE»;
  is $r.string,              'hello, world!',            'Text member contains the proper value';
  $r.end-member;

  nok $r.read-member('bar'),                             q«Can NOT read data from the 'bar' member»;
  ok  (my $e = $r.get-error),                            'Can retrieve error from reader';
  ok  $e.domain == JSON::GLib::Reader.error,             'Error domain is JSON_READER_ERROR';
  ok  $e.code   == JSON_READER_ERROR_INVALID_MEMBER,     'Error codfe is JSON_READER_ERROR_INVALID_MEMBER';
  $r.end-member;
  nok $r.get-error,                                      'Error value cleared after call to .end-member';

  ok  $r.read-element(2),                                'Can read 2nd element from reader';
  is  $r.member,             'blah',                     q«Member name is 'blah'»;
  ok  $r.is-value,                                       'Current member is a VALUE element';
  is  $r.int,                47,                         'Current member contains the proper integer value';
  $r.end-member;
  nok $r.get-error,                                      'Error value cleared after call to .end-member';

  $r.read-member('double');
  ok  $r.double =~= 42.47,                               q«Double value retrieved from member 'double' matches expected value»;
  $r.end-member;
}
