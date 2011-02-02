#!/usr/bin/perl
use FindBin;                 # locate this script
use lib "$FindBin::Bin/.";  # use the parent directory
use Kompilator;
use strict;
use warnings;

my $kompilator = new Kompilator( \@ARGV );
$kompilator->kompiluj();
