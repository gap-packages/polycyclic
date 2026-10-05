gap> START_TEST( "gh-00079.tst" );

#
# Fix a bug in the AbelianGroupCons method for IsPcpGroup.
# (Generators of order 1 are in principle supported,
# but we got an error when all generators had order 1,
# and the group was corrupted when some but not all generators had order 1.)
# <https://github.com/gap-packages/polycyclic/pull/79>
#
gap> AbelianGroup( IsPcpGroup, [ 1 ] );
Pcp-group with orders [  ]
gap> g:= AbelianGroup( IsPcpGroup, [ 1, 2 ] );
Pcp-group with orders [ 2 ]
gap> List( GeneratorsOfGroup( g ), Order );
[ 1, 2 ]

#
gap> STOP_TEST( "gh-00079.tst" );
