gap> START_TEST( "gh-00190.tst" );

#
# Fix a bug in ComplementClasses
# <https://github.com/gap-packages/polycyclic/issues/190>
#
gap> G := AbelianPcpGroup( 2 );;
gap> N := Subgroup( G, [ G.2 ] );;
gap> ComplementClasses( G, N );
infinitely many complements to lift
fail

#
gap> STOP_TEST( "gh-00190.tst" );
