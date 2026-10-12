gap> START_TEST("Test of semidirect products");

#
# two pcp-groups
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
gap> IsOne( e1 * p );
true
gap> ClosureGroup( Image( e1, G ), Image( e2, N ) ) = S;
true

#
# finite permutation group acting on an infinite pcp group
#
gap> G := Group( [ (1,2,3) ] );;
gap> N := AbelianPcpGroup( 2 );;
gap> a := GroupHomomorphismByImagesNC(
>     N, N,
>     [ N.1, N.2 ], [ N.2, N.1^-1*N.2^-1 ]
> );;
gap> SetIsBijective( a, true );
gap> alpha := GroupHomomorphismByImagesNC( G, Group( [ a ] ), [ G.1 ], [ a ] );;
gap> S := SemidirectProduct( G, alpha, N );
Pcp-group with orders [ 3, 0, 0 ]
gap> e1 := Embedding( S, 1 );;
gap> e2 := Embedding( S, 2 );;
gap> p := Projection( S );;
gap> IsOne( e1 * p );
true
gap> ClosureGroup( Image( e1, G ), Image( e2, N ) ) = S;
true
gap> Image( e2, N.1 ) ^ Image( e1, G.1 ) = Image( e2, N.2 );
true

#
# finite group acting on an infinite pcp group, but finiteness unknown
#
gap> F := FreeGroup( 1 );;
gap> G := F / [ F.1^3 ];;
gap> alpha := GroupHomomorphismByImagesNC( G, Group( [ a ] ), [ G.1 ], [ a ] );;
gap> S := SemidirectProduct( G, alpha, N );
Pcp-group with orders [ 3, 0, 0 ]
gap> e1 := Embedding( S, 1 );;
gap> e2 := Embedding( S, 2 );;
gap> p := Projection( S );;
gap> IsOne( e1 * p );
true
gap> ClosureGroup( Image( e1, G ), Image( e2, N ) ) = S;
true
gap> Image( e2, N.1 ) ^ Image( e1, G.1 ) = Image( e2, N.2 );
true

#
# finite abelian automorphism group acting on an infinite pcp group
#
gap> Aut := Group( [ a ] );;
gap> S := SemidirectProduct( Aut, N );
Pcp-group with orders [ 3, 0, 0 ]
gap> e1 := Embedding( S, 1 );;
gap> e2 := Embedding( S, 2 );;
gap> p := Projection( S );;
gap> IsOne( e1 * p );
true
gap> ClosureGroup( Image( e1, Aut ), Image( e2, N ) ) = S;
true
gap> Image( e2, N.1 ) ^ Image( e1, Aut.1 ) = Image( e2, N.2 );
true

#
# finite non-abelian automorphism group acting on an infinite pcp group
#
gap> b := GroupHomomorphismByImagesNC( N, N, [ N.1, N.2 ], [ N.2, N.1 ] );;
gap> SetIsBijective( b, true );
gap> Aut := Group( a, b );;
gap> S := SemidirectProduct( Aut, N );
Pcp-group with orders [ 2, 3, 0, 0 ]
gap> e1 := Embedding( S, 1 );;
gap> e2 := Embedding( S, 2 );;
gap> p := Projection( S );;
gap> IsOne( e1 * p );
true
gap> ClosureGroup( Image( e1, Aut ), Image( e2, N ) ) = S;
true
gap> Image( e1, a*b ) = Image( e1, a )*Image( e1, b );
true
gap> Image( e1, b^-1*a^-1 ) = Image( e1, a*b )^-1;
true
gap> PreImagesRepresentative( e1, Image( e1, a*b ) ) = a*b;
true
gap> Image( p, Image( e1, b*a ) ) = b*a;
true
gap> Kernel( p ) = Image( e2 );
true

#
# infinite pcp group acting on a finite permgroup
#
gap> G := AbelianPcpGroup( 1 );;
gap> N := Group( (1,2,3,4,5) );;
gap> a := GroupHomomorphismByImages( N, N, [ N.1 ], [ N.1^2 ] );;
gap> alpha := GroupHomomorphismByImagesNC( G, Group( [ a ] ), [ G.1 ], [ a ] );;
gap> S := SemidirectProduct( G, alpha, N );
Pcp-group with orders [ 0, 5 ]
gap> e1 := Embedding( S, 1 );;
gap> e2 := Embedding( S, 2 );;
gap> p := Projection( S );;
gap> IsOne( e1 * p );
true
gap> Image( e2, N.1 ) ^ Image( e1, G.1 ) = Image( e2, N.1^2 );
true

#
# finite automorphism group acting on a finite pcp group
#
gap> N := AbelianPcpGroup( [ 5 ] );;
gap> a := GroupHomomorphismByImages( N, N, [ N.1 ], [ N.1^2 ] );;
gap> Aut := Group( [ a ] );;
gap> S := SemidirectProduct( Aut, N );
Pcp-group with orders [ 2, 2, 5 ]
gap> Size( S );
20
gap> e1 := Embedding( S, 1 );;
gap> e2 := Embedding( S, 2 );;
gap> p := Projection( S );;
gap> IsOne( e1 * p );
true
gap> ClosureGroup( Image( e1, Aut ), Image( e2, N ) ) = S;
true
gap> Image( Embedding( S, 2 ), N.1 ) ^ Image( Embedding( S, 1 ), a )
>    = Image( Embedding( S, 2 ), N.1^2 );
true
gap> Kernel( Projection( S ) ) = Image( Embedding( S, 2 ) );
true

#
gap> STOP_TEST( "semidirect.tst", 10000000);
