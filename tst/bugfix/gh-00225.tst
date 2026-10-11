gap> START_TEST( "gh-00225.tst" );

#
# Fix hangs caused by infinite pcp-group sorting
# <https://github.com/gap-packages/polycyclic/issues/225>
#
gap> G := DirectProduct( DihedralPcpGroup( 6 ), AbelianPcpGroup( 1 ) );;
gap> U := Subgroup( G, [ G.1, G.3 ] );;
gap> p := Pcp( G );;
gap> orbstab := PcpOrbitStabilizer( U, p, p, OnPoints );;
gap> Length( orbstab.orbit );
3
gap> R := RandomNormalizerPcpGroup( G, U );;
gap> IsNormal( R, U );
true
gap> S := SymmetricGroup( IsPcpGroup, 4 );;
gap> G := DirectProduct( S, S, AbelianPcpGroup( 1 ) );;
gap> N := NilpotentByAbelianNormalSubgroup( G );;
gap> Index( G, N ) < infinity and IsNormal( G, N ) and IsNilpotent( DerivedSubgroup( N ) );
true

#
gap> STOP_TEST( "gh-00225.tst" );
