use v6.c;

use Test;

use JSON::GLib::Raw::Types;

use JSON::GLib::Builder;
use JSON::GLib::Generator;

my $complex-object =
'{'                     ~
  '"depth1":['          ~
    '1,'                ~
    '{"depth2":'        ~
      '['               ~
        '3,'            ~
        '[null,false],' ~
        '"after array"' ~
      '],'              ~
      '"value2":true'   ~
    '}'                 ~
  '],'                  ~
  '"object1":{},'       ~
  '"value3":null,'      ~
  '"value4":42,'        ~
  '"":54'               ~
'}';

my $empty-object = '{"a":{}}';
my $reset-object = '{"test":"reset"}';
my $reset-array  = '["reset"]';

subtest 'Complex', {
  with (my $b = JSON::GLib::Builder.new) {
    .begin-object
      .set-member-name('depth1').begin-array
        .add(1)
        .begin-object
          .set-member-name('depth2').begin-array
            .add(3)
            .begin-array
              .add
              .add(False)
            .end-array
            .add('after array')
          .end-array
          .set-member-name('value2').add(True)
        .end-object
      .end-array
      .set-member-name('object1').begin-object.end-object
      .set-member-name('value3').add
      .set-member-name('value4').add(42)
      .set-member-name('').add(54)
    .end-object
  }

  my $g = JSON::GLib::Generator.new;
  $g.root = $b.root;
  my $d =  $g.to-data;

  is $d, $complex-object, 'Serialized data is equivalent to string definition';
}

subtest 'Empty', {
  with (my $b = JSON::GLib::Builder.new) {
    .begin-object
      .set-member-name('a').begin-object.end-object
    .end-object
  }

  my $g = JSON::GLib::Generator.new;
  $g.root = $b.root;
  my $d =  $g.to-data;

  is $d, $empty-object, 'Serialized data is equivalent to string definition';
}

subtest 'Reset', {
    with (my $b = JSON::GLib::Builder.new) {
      .begin-object
        .set-member-name('test').add('reset')
      .end-object
    }

    my $g = JSON::GLib::Generator.new;
    $g.root = $b.root;
    my $d =  $g.to-data;

    is $d, $reset-object, 'Serialized data is equivalent to string definition';

    $b.reset.begin-array.add('reset').end-array;

    $g = JSON::GLib::Generator.new;
    $g.root = $b.root;
    $d = $g.to-data;

    is $d, $reset-array, 'Serialized data is equivalent to string definition';
}
