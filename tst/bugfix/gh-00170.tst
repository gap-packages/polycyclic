gap> START_TEST( "gh-00170.tst" );

#
# Fix two bugs in the integral orbit machinery
# <https://github.com/gap-packages/polycyclic/pull/170>
#
# ConjugacyIntegralAction compared unnormalised lattice bases in the block
# orbit and so missed the conjugating element for lattices swapped by the
# action; and it returned a record with field `norm` instead of `stab` for
# equal lattices
gap> G := AbelianPcpGroup(1);;
gap> A := [[0,1],[1,0]];;
gap> ConjugacyIntegralAction( G, [ A ], [[2,0],[0,1]], [[1,0],[0,2]] ).prei;
g1
gap> ConjugacyIntegralAction( G, [ A ], [[6,0],[0,3]], [[3,0],[0,6]] ).prei;
g1
gap> ConjugacyIntegralAction( G, [ A ], [[1,0],[0,2]], [[1,0],[0,3]] );
false
gap> IsBound( ConjugacyIntegralAction( G, [ A ], [[2,0],[0,1]], [[2,0],[0,1]] ).stab );
true

# OrbitCongruenceAction crashed when the stabilizer became trivial between
# two layers of the module series
gap> A := [[1,0,0],[1,1,0],[-1,-2,1]];;
gap> os := OrbitIntegralAction( G, [ A ], [-1,1,1], [-3,3,1] );;
gap> os.prei;
g1^-1
gap> Igs( os.stab );
[  ]
gap> OrbitIntegralAction( G, [ A ], [-1,1,1], [-6,3,1] );
false

#
gap> STOP_TEST( "gh-00170.tst" );
