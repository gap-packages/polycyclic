gap> START_TEST( "CheckIgs.tst" );

# trivial cases
gap> G := ExamplesOfSomePcpGroups( 5 );;
gap> CheckIgs( [] );
true
gap> CheckIgs( [], [] );
true
gap> CheckIgs( [], [ One( G ) ] );
true

# good cases
gap> CheckIgs( [ G.2, G.3, G.1^2 ] );
true
gap> CheckIgs( [ G.1, G.2, G.4 ], [ G.1 ^ -3 * G.2 ] );
true

# identity
gap> CheckIgs( [ G.1, One( G ), G.4 ] );
"igs contains the identity"
gap> CheckIgs( [ G.1 ^ 2 * G.4 ^ -1, G.2 ] );
"igs contains the identity"

# upper triangularity
gap> CheckIgs( [ G.2, G.2 ^ 2] );
"igs depths must be strictly increasing"
gap> CheckIgs( [ G.4, G.3 ] );
"igs depths must be strictly increasing"
gap> CheckIgs( [ G.1^2, G.2, G.3, G.4 ] );
"igs depths must be strictly increasing"
gap> CheckIgs( [ G.3, G.3, G.4 ] );
"igs depths must be strictly increasing"

# powers and commutators
gap> CheckIgs( [ G.1 ] );
"power of igs[1] does not sift"
gap> CheckIgs( [ G.2, G.3 ] );
"commutator of igs[2] and igs[1] does not sift"

# gens not contained
gap> CheckIgs( [ G.2, G.3, G.4 ^ 2 ], [ G.4 ] );
"gens[1] does not sift"

gap> STOP_TEST( "CheckIgs.tst" );
