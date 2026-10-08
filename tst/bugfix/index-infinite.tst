gap> START_TEST( "index-infinite.tst" );

#
# Index of a finite subgroup in an infinite group raised an error once
# both had a stored Size
#
gap> G := AbelianPcpGroup( [ 2, 0 ] );;
gap> N := Subgroup( G, [ G.1 ] );;
gap> Size( G );
infinity
gap> Size( N );
2
gap> Index( G, N );
infinity
gap> IndexNC( G, N );
infinity

# finite group, both sizes known
gap> G := AbelianPcpGroup( [ 2, 4 ] );;
gap> N := Subgroup( G, [ G.1 ] );;
gap> Size( G );
8
gap> Size( N );
2
gap> Index( G, N );
4
gap> IndexNC( G, N );
4

#
gap> STOP_TEST( "index-infinite.tst" );
