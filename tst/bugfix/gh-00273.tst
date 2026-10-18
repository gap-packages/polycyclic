gap> START_TEST( "gh-00273.tst" );

#
# Fix hang in NilpotentByAbelianNormalSubgroup
# <https://github.com/gap-packages/polycyclic/issues/273>
#
gap> N := AbelianGroup( [ 3, 3 ] );;
gap> Aut := AutomorphismGroup( N );;
gap> G := PcGroupToPcpGroup( SemidirectProduct( Aut, N ) );;
gap> N := NilpotentByAbelianNormalSubgroup( G );;
gap> IsNormal( G, N ) and IsNilpotent( DerivedSubgroup( N ) );
true

#
gap> STOP_TEST( "gh-00273.tst" );
