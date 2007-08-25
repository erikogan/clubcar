#!/usr/bin/perl

use strict;

use FileHandle;

use XML::Twig;

my $file = shift;

# Since these are embedded in style attributes, it doesn't make much
# sense to use the parser to try to extract them.
my $fh = new FileHandle $file;

die "Can't read $file: $!\n" unless ref $fh;

my %found;

{
    local $/ = ">";

    while (<$fh>) {
	#next if /<(linear|radial)Gradient/;
	while (/#((linear|radial)Gradient[-\w]+)/g) {
	    $found{$1}++;
	}
  }
}

close $fh;

my $t= new XML::Twig (
		      empty_tags => 'html',
		      twig_roots => {
				     'radialGradient' => \&doGradient,
				     'linearGradient' => \&doGradient,
				    },
		      twig_print_outside_roots => 1, # print the rest
#		      output_encoding => "US-ASCII",
		     );

$t->parsefile($file);

sub doGradient {
    my $tree = shift;
    my $el = shift;

    my $id = $el->{att}->{id};
    if (exists $found{$id}) {
	$el->print;
    } else {
	$el->delete;
    }
}
