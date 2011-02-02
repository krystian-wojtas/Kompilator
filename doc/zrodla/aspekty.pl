#!/usr/bin/perl
use Aspect;

sub dodaj
{
	my ( $a, $b ) = @_;
	return $a + $b;
}

after { # rada 'after'
	my $a = $_[0]->{params}->[0];
	my $b = $_[0]->{params}->[1];
	$_[0]->{return_value} = '5' if($a == 2 and $b == 2);
} call qr/dodaj/; # punkt zlaczenia - metoda 'dodaj'

print '1+1='.dodaj(1, 1)."\n";
print '2+2='.dodaj(2, 2)."\n";