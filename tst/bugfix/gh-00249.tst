gap> START_TEST( "gh-00249.tst" );

#
# Fix UnitriangularMatrixRepresentation for pcp subgroups
# <https://github.com/gap-packages/polycyclic/issues/249>
#
gap> G := UnitriangularPcpGroup( 3, 0 );;
gap> H := Subgroup( G, [ G.1^2, G.2, G.3 ] );;
gap> IsNilpotentGroup( H );;
gap> phi := UnitriangularMatrixRepresentation( H );;
gap> Comm( H.1, H.2 )^phi = Comm( H.1^phi, H.2^phi );
true

#
gap> G := AbelianPcpGroup( [ 2, 0 ] );;
gap> K := Subgroup( G, [ G.2, G.2^2 ] );;
gap> IsNilpotentGroup( K );;
gap> rep := UnitriangularMatrixRepresentation( K );;
gap> gensimgs := MappingGeneratorsImages( rep );;
gap> GroupHomomorphismByImages( K, Image(rep),
>        gensimgs[1], gensimgs[2] ) <> fail;
true

#
gap> G := AbelianPcpGroup( [ 2, 0 ] );;
gap> H := Subgroup( G, [ G.1 * G.2 ] );;
gap> IsNilpotentGroup( H );;
gap> RelativeOrdersOfPcp( Pcp( H ) );
[ 2, 0 ]
gap> phi := UnitriangularMatrixRepresentation( H );;
gap> Image( phi, H.1 ) ^ 2 = Image( phi, H.1 ^ 2 );
true

#
gap> STOP_TEST( "gh-00249.tst" );
