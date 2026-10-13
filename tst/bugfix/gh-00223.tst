gap> START_TEST( "gh-00223.tst" );

#
# Fix a bug in IsElementaryAbelian for trivial subgroups
# <https://github.com/gap-packages/polycyclic/issues/223>
#
gap> G := CyclicGroup( IsPcpGroup, 2 );;
gap> H := Subgroup( G, [ G.1 ^ 2 ] );;
gap> IsElementaryAbelian( H );
true

#
gap> STOP_TEST( "gh-00223.tst" );
