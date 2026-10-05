gap> START_TEST( "gh-00193.tst" );

#
# Fix a bug in TorsionByPolyEFSeries
# <https://github.com/gap-packages/polycyclic/issues/193>
#
gap> G := ExamplesOfSomePcpGroups( 1 );;
gap> TorsionByPolyEFSeries( G )[ 1 ] = G;
true

#
gap> STOP_TEST( "gh-00193.tst" );
