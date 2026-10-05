gap> START_TEST( "gh-00040.tst" );

#
# Fix a bug in AddToIgs causing a wrong kernel of a homomorphism
# <https://github.com/gap-packages/polycyclic/issues/40>
#
gap> H := ExamplesOfSomePcpGroups( 15 );;
gap> G := H/LowerCentralSeriesOfGroup( H )[8];;
gap> g := (G.2^-2*G.3^3*G.5^2*G.8^-6*G.9^45*G.10^-24);;
gap> srcs := [ G.2*G.5^-1, G.3, G.6, G.7, G.8, G.9, G.10 ];;
gap> M := Subgroup( G, srcs );;
gap> N := LowerCentralSeriesOfGroup( G )[7];;
gap> idG := Identity( G );;
gap> imgs := [ G.9^-3*G.10^-3, G.9^-2, G.9^4, G.10^-2, idG, idG, idG ];;
gap> diff := GroupHomomorphismByImages( M, N, srcs, imgs);;
gap> Ker := Kernel( diff );;
gap> g in Ker;
true
gap> HirschLength( Ker );
5

#
gap> STOP_TEST( "gh-00040.tst" );
