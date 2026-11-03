gap> START_TEST( "gh-00292.tst" );

#
# Fix a bug in StabilizerOfCocycle
# <https://github.com/gap-packages/polycyclic/issues/292>
#
gap> coll := FromTheLeftCollector( 5 );;
gap> SetConjugate( coll, 2, 1, [ 2, 1, 3, -1, 5, 1 ] );;
gap> SetConjugate( coll, 3, 2, [ 3, 1, 4, 1 ] );;
gap> SetConjugate( coll, 4, 2, [ 3, 1 ] );;
gap> SetConjugate( coll, 5, 2, [ 4, 1, 5, 1 ] );;
gap> G := PcpGroupByCollector( coll );;
gap> x := G.1 * G.2 ^ -4;;
gap> H := Subgroup( G, [ x, G.3 ^ -1 * G.5 ] );;
gap> N := Normalizer( G, Subgroup( G, [ x ^ 2 ] ) );
Pcp-group with orders [ 0, 0 ]
gap> N = H;
true

#
gap> STOP_TEST( "gh-00292.tst" );
