gap> START_TEST( "gh-00220.tst" );

#
# Prevent segfault due to bad input for PcpElementByGenExpList
# <https://github.com/gap-packages/polycyclic/issues/220>
#
gap> coll := Collector( HeisenbergPcpGroup( 2 ) );;
gap> PcpElementByGenExpList( coll, "macaroni" );
Error, invalid generator exponent list
gap> PcpElementByGenExpList( coll, [ 6, 1 ] );
Error, invalid generator exponent list
gap> PcpElementByGenExpList( coll, [ 0, 1 ] );
Error, invalid generator exponent list
gap> PcpElementByGenExpList( coll, [ 1, 1/2 ] );
Error, invalid generator exponent list

#
gap> STOP_TEST( "gh-00220.tst" );
