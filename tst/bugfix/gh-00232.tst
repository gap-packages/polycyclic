gap> START_TEST( "gh-00232.tst" );

#
# Fix missing components of exterior and tensor squares of trivial groups
# <https://github.com/gap-packages/polycyclic/issues/232>
#
gap> G := TrivialGroup( IsPcpGroup );;
gap> phi := NonAbelianTensorSquarePlusEpimorphism( G );;
gap> S := Range( phi );;
gap> IsBound( S!.group ) and IsBound( S!.embedding );
true
gap> D := Source( S!.embedding );;
gap> IsBound( D!.epimorphism ) and IsBound( D!.crossedPairing );
true
gap> G := TrivialGroup( IsPcpGroup );;
gap> alpha := NonAbelianTensorSquareEpimorphism( G );;
gap> D := Range( alpha );;
gap> IsBound( D!.epimorphism ) and IsBound( D!.crossedPairing );
true

#
gap> STOP_TEST( "gh-00232.tst" );
