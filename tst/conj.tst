gap> START_TEST("Test of conjugacy");

gap> G := ExamplesOfSomePcpGroups(5);;
gap> H := Subgroup( G, [ G.1 * G.2 ^ -3 * G.3 ^ 2 * G.4 ^ -1,
> G.1 * G.2 ^ -1 * G.3 ^ -1 * G.4 ];;
gap> g := G.2 ^ 2 * G.3 ^ -1 * G.4 ^ -1;;
gap> h := G.2 ^ 2 * G.3 ^ -1 * G.4;;
gap> r := RepresentativeAction( H, g, h );
fail
gap> r := RepresentativeAction( G, g, h );;
gap> g ^ r = h;
true

#
gap> STOP_TEST( "semidirect.tst", 10000000);
