#!/usr/bin/perl -p

use strict;
use Regexp::Common;

use vars qw{$re};

BEGIN {
  $re = $RE{balanced}{-parens => '<>'}{'-keep'};
}

s{^\s*</\w+>\n}{};
s{\s*</\w+>}{};
s{<%\s*end\s*%>\n?}{};
s{(<%=?\s*.*?\s*%>)}{elAttr($1)}e;
s{$re}{elAttr($1)}e;
# Keep these for unbalanced brackets (greater than less than?
s{((\w) )?<%=(.*?) ?%>}{$2=$3};
s{<%\s*(.*?)\s*%>}{-$1};
# clean up
s{(%\w+) ([\{=])}{$1$2};

sub elAttr {
  my $tag = shift;

  if ($tag =~ /^(\s*)<%(=?)\s*(.*?)\s*%>/) {
      my $prefix = $2 || '-';
      return "$1$prefix $3";
  }

  my ($el, $attr) = $tag =~ /^<(\w+) ?(.*)>$/;
  #my $el = shift;
  #my $attr = shift;

  $el = $el eq 'div' ? '' : "%$el";

  my %attrs;
  while ($attr =~ /(\w+)="(<%[^%]+%>|[^"]+)"/g) {
    $attrs{$1} = $2
  }

  foreach my $vec ([id => '#'], [class => '.']) {
    my ($name, $sep) = @$vec;

    my $val = delete $attrs{$name};
    if (defined $val) {
      if ($val =~ /^<%/) {
        $attrs{$name} = $val
        } else {
          $el .= "$sep$val"
        }
      }
    }

  my $attrs = '';

  if (%attrs) {
    $attrs = ' { ';
    my @keys = sort keys %attrs;
    foreach my $key (@keys) {
      $attrs .= ":$key => ";
      my $val = $attrs{$key};
      if ($val =~ s{<%=\s*(.*?)\s*%>}{$1}) {
        $attrs .= $val;
      } else {
        $attrs .= qq{'$val'};
      }
      $attrs .= ',' unless $key eq $keys[-1];
      $attrs .= ' ';
    }
    $attrs .= "}";
  }


  "$el$attrs "
}
