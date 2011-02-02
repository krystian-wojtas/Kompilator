#!/usr/bin/perl
package Kompilator::Debug::Api::DrzewoSvg;
use strict;
use warnings;
use XML::DOM;

sub new
{
	my $class = shift;
	my $self = {};
	bless $self, $class;
	$self->_drzewo( shift );
	$self->_wyjsciePlik( shift );
	$self->_drzewoSvgTpl( shift );
	$self->_init();
	return $self;
}

sub _drzewo { $_[0]->{drzewo}=$_[1] if defined $_[1]; $_[0]->{drzewo} }
#aktualna produkcje sciagam z drzewa semantykyki ktora w tym czasie operuje na zywym orgnizmie
sub _produkcja { $_[0]->_drzewo->produkcja }
sub _wyjsciePlik { $_[0]->{wyjsciePlik}=$_[1] if defined $_[1]; $_[0]->{wyjsciePlik} }
sub _drzewoSvgTpl { $_[0]->{drzewoSvgTpl}=$_[1] if defined $_[1]; $_[0]->{drzewoSvgTpl} }
sub _docP { $_[0]->{doc}=$_[1] if defined $_[1]; $_[0]->{doc} }
sub _nodeP { $_[0]->{node}=$_[1] if defined $_[1]; $_[0]->{node} }

sub _init
{
	my $self = shift;
	my $parser = new XML::DOM::Parser;
	$self->_docP( $parser->parsefile( $self->_drzewoSvgTpl ) );
 	$self->_nodeP( ${$self->_docP->getElementsByTagName ("svg")}[0] );

	return $self;
}

sub appendChild
{
	my $self = shift;
	my $nodeG = $self->_docP->createElement('g');
	my $nodeT = $self->_docP->createElement('text');
	$nodeT->addText( $self->_produkcja );
	$nodeG->appendChild( $nodeT );
	my $nodeL = $self->_docP->createElement('line');
	$nodeG->appendChild( $nodeL );
	$self->_nodeP->appendChild( $nodeG );
	$self->_nodeP( $nodeG );
	
	return $self;
}

sub parent
{
	my $self = shift;
	$self->_nodeP( $self->_nodeP->getParentNode );
	
	return $self;
}

sub textNode
{
	my $self = shift;
	my $leksemP = shift;
	my $nodeG = $self->_docP->createElement('g');
	my $nodeT = $self->_docP->createElement('text');
	if(defined $leksemP->{slowo}) { # TODO dosyc brzydki sposob, trzeba tu sprawdzac cos ogolniejszego, wykorzystac EPSILON
		$nodeT->addText( $leksemP->{slowo} );
	}
	else {
		$nodeT->addText( 'EPSILON' );
	}
	$nodeG->appendChild( $nodeT );
	my $nodeL = $self->_docP->createElement('line');
	$nodeG->appendChild( $nodeL );
	my $a = $self->_docP->toString;
	$self->_nodeP->appendChild( $nodeG );
	my $b = $self->_docP->toString;
	
	return $self;
}

sub wyjscie
{
	my $self = shift;
	my $wyjsciePlik = $self->_wyjsciePlik;

	 # Print doc file
	 $self->_docP->printToFile( $wyjsciePlik );
	 # Avoid memory leaks - cleanup circular references for garbage collection
	 $self->_docP->dispose;
 
	return $self;
}


1;