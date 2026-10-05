gap> START_TEST( "gh-00059.tst" );

#
# Fix a bug causing Random to fail for the trivial group
# <https://github.com/gap-packages/polycyclic/issues/59>
#
gap> Random( TrivialGroup( IsPcpGroup ) );
id

#
gap> STOP_TEST( "gh-00059.tst" );
