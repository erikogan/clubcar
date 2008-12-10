#!/usr/bin/perl

use strict;
use POSIX qw{floor};
use Text::CSV;
use IO::File;

my $csv = Text::CSV->new();

my $in = shift;
my $out = shift;

my $inH = new IO::File($in);
die "Can't read $in: $!\n" unless ref $inH;

my $outH = new IO::File($out, "w");
die "Can't write $out: $!\n" unless ref $outH;

until ($csv->eof) {
    my $row = $csv->getline($inH);
    my @base = rgb2hsv(parse(shift @$row));
    my $out = [];
    while (@$row) {
	my @v = rgb2hsv(parse(shift @$row));
	for (my $i = 0 ; $i < @base ; $i++) {
	    $v[$i] -= $base[$i];
	    $v[$i] = int ($v[$i] / 255 * 100) if $i;
	}
	push @$out, @v, undef;
    }
    #pop @$out;
    $csv->print($outH, $out);
    $outH->print("\n");
}

sub parse {
    my $color = shift;
    my ($r,$g,$b) = $color =~ /#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})/;
    my @debug = map {hex lc $_} $r, $g, $b;
    print "COLOR: @debug\n";
    return @debug
}

#------------------------------------------------------------------------
# Stolen from Template::Plugin::Colour::{HSV,RGB}
#------------------------------------------------------------------------

sub rgb2hsv {
    my ($r, $g, $b) = @_;
    my ($h, $s, $v);
    my ($min, $max) = (256,0);

    foreach my $v ($r, $g, $b) {
	$min = $v if $v < $min;
	$max = $v if $v > $max;
    }

    my $delta = $max - $min;
    $v = $max;

    return (0,0,$v) unless ($delta);

    $s = $delta / $max;
    if ($r == $max) {
	$h = 60 * ($g - $b) / $delta;
    }
    elsif ($g == $max) {
	$h = 120 + (60 * ($b - $r) / $delta);
    }
    else { # if $b == $max 
	$h = 240 + (60 * ($r - $g) / $delta);
    }
	
    $h += 360 if $h < 0;  # hue is in the range 0-360
    $h = int( $h + 0.5 ); # smooth out rounding errors
    $s = int($s * 255);   # expand saturation to 0-255

    printf "R2H %3d %3d %3d => %3d %3d %3d\n", $r,$g,$b, $h,$s,$v;
    return ($h, $s, $v);
}


sub hsv2rgb {
    my ($h, $s, $v) = @_;
    my ($r, $g, $b);

    if ($s == 0) {
	# TODO: make this truly achromatic
	return (($v) x 3);
    }

    # normalize
    if ($h < 0) {
	warn "hue $h -> ", $h+360;
	$h+= 360;
    }

    if ($s > 255) {
	warn "saturation $s ceiling 255";
	$s = 255;
    }

    if ($v > 255) {
	warn "value $v ceiling 255";
	$v = 255;
    }

    # normalise saturation from range 0-255 to 0-1
    $s /= 255;
	
    $h /= 60;                          ## sector 0 to 5
    my $i = POSIX::floor( $h );
    my $f = $h - $i;                   ## factorial part of h
    my $p = $v * ( 1 - $s );
    my $q = $v * ( 1 - $s * $f );
    my $t = $v * ( 1 - $s * ( 1 - $f ) );

    if    ($i == 0) { $r = $v; $g = $t; $b = $p }
    elsif ($i == 1) { $r = $q; $g = $v; $b = $p }
    elsif ($i == 2) { $r = $p; $g = $v; $b = $t }
    elsif ($i == 3) { $r = $p; $g = $q; $b = $v }
    elsif ($i == 4) { $r = $t; $g = $p; $b = $v }
    else            { $r = $v; $g = $p; $b = $q }

    foreach my $v (\($r, $g, $b)) {
	$$v = int $$v;
	if ($$v < 0) {
	    warn "negative value ($$v), substituting 0";
	    $$v = 0;
	}
    }
    printf "H2R %3d %3d %3d => %3d %3d %3d\n", $h,$s,$v, $r,$g,$b;
    return ($r, $g, $b);
}

