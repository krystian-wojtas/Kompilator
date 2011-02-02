#!/usr/bin/perl
package Kompilator::Java::Synteza;
use Kompilator::Api::Synteza::SyntezaBaza;
use strict;
use warnings;
use feature "switch";

our @ISA = qw(Kompilator::Api::Synteza::SyntezaBaza);


sub proceduraWywolana
{
	my $self = shift;
	my $prWNr = shift;
	#$self->_classP->("invoke $prWNr");
	$self->_classP->invoke( $prWNr );
	return $self;
}


sub alokacja
{
	my $self = shift;
	$self->dzialajOperatorem2('alokacja');
	return $self;
}


sub zwolnienie
{} #Garbage collector


sub wrzuc
{
	my $self = shift;
	my $operand = shift;
	given($operand->{maska}) {
		when(/^1\d\d$/) {
			my $wartosc = $operand->{nazwa};
			my $pozycja = $self->_staleP->zdejmijStala( $wartosc );
			$self->_classP->ldc( $pozycja );
			$operand->{pozycja} = $pozycja; 
		}
		when(/^2\d\d$/) {
			$self->_classP->getfield( $operand->{pozycja} );
		}
		when(/^301$/) {			
			$self->_classP->iload( $operand->{pozycja} );
		}
		when(/^302$/) {			
			$self->_classP->fload( $operand->{pozycja} );
		}
		when(/^303$/) {			
			$self->_classP->bload( $operand->{pozycja} );
		}
		when(/^304$/) {			
			$self->_classP->aload( $operand->{pozycja} );
		}
		when(/^311$/) {
			#TODO		
			$self->_classP->iaload( $operand->{pozycja} );
		}
	}
}


sub zapiszWartosc
{
	my $self = shift;
	my $operand = shift;
	given($operand->{maska}) {
		when(/^2\d\d$/) {
			$self->_classP->putfield( $operand->{pozycja} );
		}
		when(/^301$/) {			
			$self->_classP->istore( $operand->{pozycja} );
		}
		when(/^302$/) {			
			$self->_classP->fstore( $operand->{pozycja} );
		}
		when(/^303$/) {			
			$self->_classP->bstore( $operand->{pozycja} );
		}
		when(/^304$/) {	
			$self->_classP->astore( $operand->{pozycja} );
		}
		when(/^311$/) {
			#TODO
			$self->_classP->iastore( $operand->{pozycja} );
		}
	}
}


sub dzialajOperatorem2
{
	my $self = shift;
	my $operator = shift;
	my $z1 = shift;
	my $z2 = shift;
	given($operator) {
		when(/^and$/) {
			
		}
		when(/^or$/) {
			
		}
		when(/^(==|<>|<=|>=|<|>)$/) {
			
		}
		when(/^\+$/) {
			$self->konwertuj21D($z1, $z2);
			if($z1->{maska} =~ /^\d0(\d)$/) {
				given($1) {
					when(/^1$/) {
						$self->_classP->iadd();
					}
					when(/^2$/) {
						$self->_classP->fadd();
					}
					when(/^(3|4)$/) {
						die "Nie mozna dodawac do stringow lub booleanow";
					}
				}
			}
			else {
				die "Nie mozna dodawac do referencji tablicy";
			}
		}
		when(/^-$/) {
			$self->konwertuj21D($z1, $z2);
			if($z1->{maska} =~ /^\d0(\d)$/) {
				given($1) {
					when(/^1$/) {
						$self->_classP->isub();
					}
					when(/^2$/) {
						$self->_classP->fsub();
					}
					when(/^(3|4)$/) {
						die "Nie mozna dodawac do stringow lub booleanow";
					}
				}
			}
			else {
				die "Nie mozna dodawac do referencji tablicy";
			}
		}
		when(/^\*$/) {
			$self->konwertuj21D($z1, $z2);
			if($z1->{maska} =~ /^\d0(\d)$/) {
				given($1) {
					when(/^1$/) {
						$self->_classP->imul();
					}
					when(/^2$/) {
						$self->_classP->fmul();
					}
					when(/^(3|4)$/) {
						die "Nie mozna mnozyc stringow lub booleanow";
					}
				}
			}
			else {
				die "Nie mozna mnozyc referencji tablicy";
			}
		}
		when(/^\/$/) {
			$self->konwertuj21D($z1, $z2);
			if($z1->{maska} =~ /^\d0(\d)$/) {
				given($1) {
					when(/^1$/) {
						$self->_classP->idiv();
					}
					when(/^2$/) {
						$self->_classP->fdiv();
					}
					when(/^(3|4)$/) {
						die "Nie mozna dzielic stringow lub booleanow";
					}
				}
			}
			else {
				die "Nie mozna dzielic referencji tablicy";
			}			
		}
		when(/^=$/) {
			$self->konwertuj21D($z1, $z2);
			$self->zapiszWartoscD($z1);
		}
		when(/^\}$/) {
			my $pustyInt = { maska => '201' };
			$self->konwertuj21D( $pustyInt, $z2 );
			given($z1->{maska}) {
				when(/^\d2(\d)$/) {
					given($1) {
						when(/^1$/) {
							$self->_classP->iaload();
						}
						when(/^2$/) {
							$self->_classP->faload();
						}
						when(/^3$/) {
							$self->_classP->baload();
						}
						when(/^4$/) {
							$self->_classP->aaload();
						}
					}
				}
				when(/^\d1\d$/) {
					die "Do tablicy nie zostala zaalokowana pamiec";
				}
				when(/^\d0\d$/) {
					die "Nie mozna dereferencjowac zmiennej skalarnej";
				}
			}
			my $a = 3;
		}
		when(/^alokacja$/) {
			my $pustyInt = { maska => '201' };
			$self->konwertuj21D( $pustyInt, $z2 );
			given($z1->{maska}) {
				when(/^\d\d1$/) {
					$self->_classP->newarrayInt();
				}
				when(/^\d\d2$/) {
					$self->_classP->newarrayFloat();
				}
				when(/^\d\d3$/) {
					$self->_classP->newarrayBoolean();
				}
				when(/^\d\d4$/) {
					$self->_classP->newarrayString();
				}
			}
		}
	}
	return $z2;
}


sub konwertuj21
{
	my $self = shift;
	my $z1 = shift;
	my $z2 = shift;
	if(not defined $z1->{maska} or not defined $z2->{maska}) {
		my $a = 0;
	}
	if($z1->{maska} =~ /^\d1\d$/ or $z2->{maska} =~ /^\d1\d$/) {
		die 'Operand jest typu tablicowego o niezaalokowanej pamieci';
	}
	if($z1->{maska} =~ /^\d2\d$/ or $z2->{maska} =~ /^\d2\d$/) {
		die 'Operand typu tablicowego nie zostal zdereferencjonowany';
	}
	if($z1->{maska} =~ /^200$/ and defined $z2) {
		die 'Zadeklarowana funkcja nie zwraca wartosci';
	}
	if($z2->{maska} =~ /^\d\d2$/ and $z1->{maska} =~ /^(\d)\d1$/) {
		$z2->{maska} = "${1}01";
		$self->_classP->f2i();
	}
	elsif($z2->{maska} =~ /^\d\d1$/ and $z1->{maska} =~ /^(\d)\d2$/) {
		$z2->{maska} = "${1}02";
		$self->_classP->i2f();
	}
	elsif($z2->{maska} =~ /^\d\d1$/ and $z1->{maska} =~ /^(\d)\d3$/) {
		$z2->{maska} = "${1}03";
		$self->_classP->i2b();
	}
	elsif($z2->{maska} =~ /^\d\d3$/ and $z1->{maska} =~ /^(\d)\d1$/) {
		$z2->{maska} = "${1}01";
		$self->_classP->b2i();
	}
	elsif($z2->{maska} =~ /^\d\d(\d)$/ and $z1->{maska} =~ /^(\d)\d(${1})$/) {
		$z2->{maska} = "${1}0${2}";
	}
}

1;