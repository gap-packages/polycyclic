gap> START_TEST( "gh-00199.tst" );

#
# Fix a bug in UpperCentralSeriesNilpotentPcpGroup
# <https://github.com/gap-packages/polycyclic/issues/199>
#
gap> T := TrivialGroup( IsPcpGroup );;
gap> UpperCentralSeries( T );
[ Pcp-group with orders [  ] ]

#
gap> STOP_TEST( "gh-00199.tst" );
