gap> START_TEST( "gh-00009.tst" );

#
# IsWeightedCollector depended on USE_COMBINATORIAL_COLLECTOR, and
# IsPolynomialCollector and UseLibraryCollector raised an error on a plain
# collector
# <https://github.com/gap-packages/polycyclic/issues/9>
# <https://github.com/gap-packages/polycyclic/issues/86>
#
gap> coll := Collector( UnitriangularPcpGroup( 4, 0 ) );;
gap> IsWeightedCollector( coll );
true
gap> IsWeightedCollector( Collector( ExamplesOfSomePcpGroups( 3 ) ) );
false
gap> IsPolynomialCollector( coll );
false
gap> UseLibraryCollector( coll );
false
gap> AddHallPolynomials( coll );
gap> IsPolynomialCollector( coll );
true
gap> IsConfluent( coll );
true

#
gap> STOP_TEST( "gh-00009.tst" );
