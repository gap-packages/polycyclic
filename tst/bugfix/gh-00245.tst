gap> START_TEST( "gh-00245.tst" );

#
# Fix a nonidentity generator in the cyclic group of order 1
# <https://github.com/gap-packages/polycyclic/issues/245>
#
gap> G := CyclicGroup( IsPcpGroup, 1 );;
gap> Size( G );
1
gap> IsTrivial( G );
true
gap> IsOne( G.1 );
true
gap> Order( G.1 );
1

#
gap> STOP_TEST( "gh-00245.tst" );
