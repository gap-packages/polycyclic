gap> START_TEST("Test of semidirect products");

#
gap> N := DihedralPcpGroup( 0 );;
gap> A := Group([
>    InnerAutomorphism( N, N.1 ),
>    InnerAutomorphism( N, N.2 ),
>    GroupHomomorphismByImagesNC( N, N, [ N.1, N.2 ], [ N.1*N.2, N.2^-1 ] )
> ]);;
gap> G := AbelianPcpGroup( [ 0 ] );;
gap> alpha := GroupHomomorphismByImagesNC( G, A, [ G.1 ], [ A.1*A.3 ] );;
gap> S := SemidirectProduct( G, alpha, N );
Pcp-group with orders [ 0, 2, 0 ]
gap> e1 := Embedding( S, 1 );;
gap> e2 := Embedding( S, 2 );;
gap> p := Projection( S );;
gap> e1 * p = IdentityMapping( G );
true
gap> ClosureGroup( Image( e1, G ), Image( e2, N ) ) = S;
true

#
gap> STOP_TEST( "semidirect.tst", 10000000);
