#!/usr/bin/perl -n

use strict;

our %found;

while (/url\(#((linear|radial)[^)]+)/g) {
    $found{$1}++;
}


END {$, = "\n"; print sort keys %found}
