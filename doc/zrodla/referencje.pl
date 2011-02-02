#!/usr/bin/perl
$liczba = 3;
$literal = 'drugie'.$liczba;
@tab = ( 1, 'dwa', $liczba, \$literal );
#x \@tab
%hash = ( 'atrybut' => 'przykladowy', 'tabP' => \@tab );
$tab2P = [ [ @tab ], \%hash ];
#x $tab2P
