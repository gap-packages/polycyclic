gap> START_TEST( "gh-00221.tst" );

#
# Fix a bug in NilpotentByAbelianNormalSubgroup
# <https://github.com/gap-packages/polycyclic/issues/221>
#
gap> G := PcGroupToPcpGroup( PcGroupCode( 701877802289202019676077281529158051, 216 ) );;
gap> IsNormal( G, NilpotentByAbelianNormalSubgroup( G ) );
true

#
gap> STOP_TEST( "gh-00221.tst" );
