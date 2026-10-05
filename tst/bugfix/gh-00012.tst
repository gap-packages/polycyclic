gap> START_TEST( "gh-00012.tst" );

#
# Deep Thought collection returned the last syllable unreduced when the
# preceding syllables collect to the identity
# <https://github.com/gap-packages/polycyclic/issues/12>
#
gap> code := 368696066528247408067671889674637728343505449437567317498608450551;;
gap> c := Collector( PcGroupToPcpGroup( PcGroupCode( code, 512 ) ) );;
gap> AddHallPolynomials( c );
gap> IsConfluent( c );
true
gap> PcpElementByExponents( c, [ 2, 0, 2, 1, 4, 5, 0, 3, 0 ] );
g8*g9
gap> PcpElementByExponents( c, [ 0, 0, 0, 0, 0, 0, 0, 0, 3 ] );
g9

#
gap> STOP_TEST( "gh-00012.tst" );
