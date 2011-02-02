#!/usr/bin/perl
package Kompilator::Api::Synteza::ONP;
use strict;
use warnings;


sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	
	$self->_syntezaP( shift );
	$self->_staleP( shift );
	$self->_stosWrzutowP( [] );
	$self->_stosOpP( [] );
	$self->_hierarchiaOpP( [ # TODO zew plik
		[ '=' ],
		[ 'and' ],
		[ 'or' ],
		[ '==', '<>', '<=', '>=', '<', '>' ],
		[ '\+', '-' ],
		[ '\*', '/' ],
		[ '}' ],
	] );
	
	return $self;
}

sub _syntezaP { $_[0]->{synteza}=$_[1] if defined $_[1]; $_[0]->{synteza} }
sub _staleP { $_[0]->{stale}=$_[1] if defined $_[1]; $_[0]->{stale} }
sub _stosWrzutowP { $_[0]->{stosWrzutow}=$_[1] if defined $_[1]; $_[0]->{stosWrzutow} }
sub _stosOpP { $_[0]->{stosOp}=$_[1] if defined $_[1]; $_[0]->{stosOp} }
sub _hierarchiaOpP { $_[0]->{hierarchiaOp}=$_[1] if defined $_[1]; $_[0]->{hierarchiaOp} }

sub zdejmij
{
	my $self = shift;
	return pop @{$self->_stosWrzutowP};
}

sub wloz
{
	my $self = shift;
	my $a = shift;
	push @{$self->_stosWrzutowP}, $a;
	return $self; # moze zwrocic ref do tego co wrzucil?
}

sub czyNiepusty
{
	my $self = shift;
	return @{ $self->_stosOpP->[ $#{$self->_stosOpP} ] } ? 1 : 0;
}

sub noweWyrazenie
{
	my $self = shift;
	push @{ $self->_stosOpP }, [];
	return $self;
}

sub koniecWyrazenia
{
	my $self = shift;
	my @opR = @{ pop @{ $self->_stosOpP } };
	while(@opR) {
		my $opZ = pop @opR;
		$self->_syntezaP->dzialajOperatorem2D( $opZ->{op} );
	}
}



sub operator2
{
	my $self = shift;
	my $opP = shift;
	my $opS = shift;
	my @aktOp = ();
	my @a = @_;
	for( my $pietro = 0; $pietro < @{ $self->_hierarchiaOpP }; $pietro++) {
		foreach my $opH (@{ $self->_hierarchiaOpP->[$pietro] }) {
			if($opS =~ /^$opH$/) {
				if(@{ $self->_stosOpP}) {
					@aktOp = @{ pop @{ $self->_stosOpP } };
					while(@aktOp) {
						if($aktOp[$#aktOp]->{pietro} > $pietro) {
							my $opZ = pop @aktOp;
							$self->_syntezaP->dzialajOperatorem2D( $opZ->{op} );
						}
						else {
							last;
						}
					}
				}
				push @aktOp, { op => $opS, pietro => $pietro };
				push @{ $self->_stosOpP}, \@aktOp; # TODO break
			}
		}
	}
	return $self;
}

sub operator1
{
	my $self = shift;
	my $opP = shift;
	my $opS = shift;
	if($opS =~ /^-$/) {
		my $operand = $self->zdejmij;
		$self->wloz( $self->_staleP->zdejmijZero );
		$self->_syntezaP->operator2D($opP, $opS );
	}
	return $self;
}

1;