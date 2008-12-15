#!/usr/bin/perl

use strict;
use Text::CSV;
use IO::File;

my @colors = qw{base ln rn compl};
my @variations = ('', qw{pale paler dark darker darkPale darkPaler});

my $csv = Text::CSV->new();

my $in = shift;
my $out = shift;

my $inH = new IO::File($in);
die "Can't read $in: $!\n" unless ref $inH;

my $outH = new IO::File($out, "w");
die "Can't write $out: $!\n" unless ref $outH;

$csv->column_names(@variations);

until ($csv->eof) {
    my $color = shift @colors;
    my $row = $csv->getline_hr($inH);
    foreach my $var (@variations) {
	printf $outH "%-24s = #%s\n", "!color_$color" . ($var ? "_$var" : ''),
	    $row->{$var};
    }
    print $outH "\n";
}
