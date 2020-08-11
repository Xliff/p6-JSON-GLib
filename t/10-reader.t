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

subtest 'Base Array', {
  my ($p, $r) = (JSON::GLib::Parser, JSON::GLib::Reader)».new;
  $p.load-from-data($base_array);
  nok $ERROR,                                                  'No errors detected from parser';

  $r.root = $p.root;
  ok  $r.is-array,                                             'Reader currently points to an ARRAY';
  is $r.elems,               7,                                'ARRAY on reader currently has the proper number of members';

  $r.read-element(0);
  ok  $r.is-value,                                             'Element 0 is a VALUE type';
  is  $r.int,                0,                                'Element 0 contains the proper value';
  $r.end-element;

  $r.read-element(1);
  ok  $r.is-value,                                             'Element 1 is a VALUE type';
  is  $r.bool,               True,                             'Element 1 contains the proper value';
  $r.end-element;

  $r.read-element(3);
  ok  $r.is-value,                                             'Element 3 is a VALUE type';
  is  $r.string,             'foo',                            'Element 3 contains the proper value';
  $r.end-element;

  $r.read-element(5);
  $r.is-value,                                                 'Element 5 IS NOT a VALUE type';
  nok $r.is-object,                                            'Element 5 IS NOT an OBJECT type';
  ok  $r.is-array,                                             'Element 5 is an ARRAY type';

  $r.end-element;

  $r.read-element(6);
  ok $r.is-object,                                             'Element 6 is an OBJECT type';
  $r.read-member('bar');
  ok $r.is-value,                                              q«Element 6, member 'bar' is a VALUE type»;
  is $r.int,                 42,                               q«Element 6, member 'bar' contains the correct value»;
  $r.end-member;
  $r.end-element;

  nok $r.read-element(7),                                      'Element 7 cannot be read';
  my $e = $r.get-error;
  is  $e.domain,         JSON::GLib::Reader.error,             'ERROR contains the proper domain';
  is  $e.code,           JSON_READER_ERROR_INVALID_INDEX.Int,  'ERROR contains the proper code';
  $r.end-element;
  my $e = $r.get-error;
  nok $e,                                                      'ERROR cleared after call to .end-element';
}

subtest 'Reader Level', {
  my ($p, $r) = (JSON::GLib::Parser, JSON::GLib::Reader)».new;
  $p.load-from-data($reader_level);
  nok $ERROR,                                                  'No errors detected from parser';

  $r.root = $p.root;

  ok  $r.m-elems > 0,                                          'Reader contains at least one member';
  ok  $r.read-member('list'),                                  q«Can read from member 'list'»;
  is  $r.member, 'list',                                       q«Can confirm that current member is called 'list'»;

  ok  (my $members = $r.list-members),                         'Member list is NOT Nil';

  ok  $r.read-member('181195771'),                             q«Can read from member '181195771'»;
  is  $r.member, '181195771',                                  q«Can confirm that current member is called '181195771'»;

  nok $r.read-member('resolved_url'),                          q«Can NOT read from member 'resolved_url'»;
  nok $r.member,                                               'Current member name is Nil';
  $r.end-member;
  is  $r.member, '181195771',                                  q«Current member is called '181195771', after call to .end-member»;

  ok  $r.read-member('given_url'),                             q«Can read from member 'given_url'»;
  is  $r.member, 'given_url',                                  q«Can confirm that current member is 'given_url'»;
  is  $r.string, 'http://www.gnome.org/json-glib-test',        'String value at current node matches expected value';
  $r.end-member;

  is  $r.member, '181195771',                                  q«Current member is called '181195771', after call to .end-member»;
  $r.end-member;
  is  $r.member, 'list',                                       q«Current member is called 'list', after call to .end-member»;
  $r.end-member;
  nok $r.member,                                               'Current member is undefined after call to .end-mamber';
}
