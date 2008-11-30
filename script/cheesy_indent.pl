#!/usr/bin/perl -pi -0076

BEGIN {
  $indent = '  ';
  $count = 0;
  my @stack;
}

s{^[ \t]*}{$indent x $count}egm;

if (/<(\w+)/) {
  push @stack, $1;
  $count++;
}

if (m{\s*/\s*>}) {
  pop @stack;
  $count--;
}

if (m{</(\w+)}) {
  $old = pop @stack;
  warn "$ARGV: mismatched $old /$1" unless ($1 eq $old);
  $count--;
  s{^[ \t]*</}{($indent x $count) . "</"}egm;
}
