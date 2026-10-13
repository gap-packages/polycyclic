gap> START_TEST( "gh-00230.tst" );

#
# Fix a bug in NonAbelianExteriorSquarePlusEmbedding for trivial groups
# <https://github.com/gap-packages/polycyclic/issues/230>
#
gap> G := TrivialGroup( IsPcpGroup );;
gap> NonAbelianExteriorSquarePlusEmbedding( G );
[  ] -> [  ]

#
gap> STOP_TEST( "gh-00230.tst" );
