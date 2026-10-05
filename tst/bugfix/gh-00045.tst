gap> START_TEST( "gh-00045.tst" );

#
# Fix a bug in NormalizerOfComplement
# <https://github.com/gap-packages/polycyclic/issues/45>
# <https://github.com/gap-packages/polycyclic/issues/88>
#
gap> C := AbelianPcpGroup( [ 2, 3 ] );;
gap> H := Subgroup( C, [ C.1 ] );;
gap> N := Subgroup( C, [ C.2 ] );;
gap> I := NormalIntersection( N, H );;
gap> NormalizerOfComplement( C, H, N, I );
Pcp-group with orders [ 2, 3 ]

# second test case for issue #45 / #88
gap> G:= AbelianPcpGroup( 2, [ 2, 3 ] );;
gap> Length( ConjugacyClassesSubgroups( G ) ) = 4;
true

#
gap> STOP_TEST( "gh-00045.tst" );
