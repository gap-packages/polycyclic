gap> START_TEST( "properties.tst" );

# trivial group
gap> G := TrivialGroup( IsPcpGroup );;
gap> IsTorsionFree( G );
true
gap> IsElementaryAbelian( G );
true
gap> IsFreeAbelian( G );
true
gap> IsAbelian( G );
true
gap> IsAbelianByFinite( G );
true
gap> IsCrystallographic( G );
true
gap> IsBieberbachGroup( G );
true
gap> IsNilpotentGroup( G );
true
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
true
gap> IsAlmostBieberbachGroup( G );
true
gap> IsNilpotentByAbelian( G );
true

#
gap> G := AbelianPcpGroup( [ 2, 2 ] );;
gap> IsTorsionFree( G );
false
gap> IsElementaryAbelian( G );
true
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
true
gap> IsAbelianByFinite( G );
true
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
true
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
false
gap> IsAlmostBieberbachGroup( G );
false
gap> IsNilpotentByAbelian( G );
true

#
gap> G := AbelianPcpGroup( [ 4, 2 ] );;
gap> IsTorsionFree( G );
false
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
true
gap> IsAbelianByFinite( G );
true
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
true
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
false
gap> IsAlmostBieberbachGroup( G );
false
gap> IsNilpotentByAbelian( G );
true

# free abelian group
gap> G := AbelianPcpGroup( 2 );;
gap> IsTorsionFree( G );
true
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
true
gap> IsAbelian( G );
true
gap> IsAbelianByFinite( G );
true
gap> IsCrystallographic( G );
true
gap> IsBieberbachGroup( G );
true
gap> IsNilpotentGroup( G );
true
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
true
gap> IsAlmostBieberbachGroup( G );
true
gap> IsNilpotentByAbelian( G );
true

# infinite non-free abelian group
gap> G := AbelianPcpGroup( [ 0, 2 ] );;
gap> IsTorsionFree( G );
false
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
true
gap> IsAbelianByFinite( G );
true
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
true
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
false
gap> IsAlmostBieberbachGroup( G );
false
gap> IsNilpotentByAbelian( G );
true

# infinite dihedral group
gap> G := DihedralPcpGroup( infinity );;
gap> IsTorsionFree( G );
false
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
false
gap> IsAbelianByFinite( G );
true
gap> IsCrystallographic( G );
true
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
false
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
true
gap> IsAlmostBieberbachGroup( G );
false
gap> IsNilpotentByAbelian( G );
true

# Klein bottle group
gap> G := ExamplesOfSomePcpGroups( 3 );;
gap> IsTorsionFree( G );
true
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
false
gap> IsAbelianByFinite( G );
true
gap> IsCrystallographic( G );
true
gap> IsBieberbachGroup( G );
true
gap> IsNilpotentGroup( G );
false
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
true
gap> IsAlmostBieberbachGroup( G );
true
gap> IsNilpotentByAbelian( G );
true

# Heisenberg group
gap> G := HeisenbergPcpGroup( 1 );;
gap> IsTorsionFree( G );
true
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
false
gap> IsAbelianByFinite( G );
false
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
true
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
true
gap> IsAlmostBieberbachGroup( G );
true
gap> IsNilpotentByAbelian( G );
true

#
gap> G := ExamplesOfSomePcpGroups( 5 );;
gap> IsTorsionFree( G );
true
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
false
gap> IsAbelianByFinite( G );
false
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
false
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
true
gap> IsAlmostBieberbachGroup( G );
true
gap> IsNilpotentByAbelian( G );
true

#
gap> G := ExamplesOfSomePcpGroups( 6 );;
gap> IsTorsionFree( G );
true
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
false
gap> IsAbelianByFinite( G );
false
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
false
gap> IsNilpotentByFinite( G );
false
gap> IsAlmostCrystallographic( G );
false
gap> IsAlmostBieberbachGroup( G );
false
gap> IsNilpotentByAbelian( G );
true

#
gap> G := ExamplesOfSomePcpGroups( 8 );;
gap> IsTorsionFree( G );
true
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
false
gap> IsAbelianByFinite( G );
false
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
false
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
true
gap> IsAlmostBieberbachGroup( G );
true
gap> IsNilpotentByAbelian( G );
true

#
gap> G := ExamplesOfSomePcpGroups( 10 );;
gap> IsTorsionFree( G );
true
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
false
gap> IsAbelianByFinite( G );
false
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
false
gap> IsNilpotentByFinite( G );
false
gap> IsAlmostCrystallographic( G );
false
gap> IsAlmostBieberbachGroup( G );
false
gap> IsNilpotentByAbelian( G );
false

# free nilpotent group
gap> G := ExamplesOfSomePcpGroups( 11 );;
gap> IsTorsionFree( G );
true
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
false
gap> IsAbelianByFinite( G );
false
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
true
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
true
gap> IsAlmostBieberbachGroup( G );
true
gap> IsNilpotentByAbelian( G );
true

# quaternion group
gap> G := QuaternionGroup( IsPcpGroup, 8 );;
gap> IsTorsionFree( G );
false
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
false
gap> IsAbelianByFinite( G );
true
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
true
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
false
gap> IsAlmostBieberbachGroup( G );
false
gap> IsNilpotentByAbelian( G );
true

# symmetric group
gap> G := SymmetricGroup( IsPcpGroup, 4 );;
gap> IsTorsionFree( G );
false
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
false
gap> IsAbelianByFinite( G );
true
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
false
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
false
gap> IsAlmostBieberbachGroup( G );
false
gap> IsNilpotentByAbelian( G );
false

#
gap> G := DirectProduct( AbelianPcpGroup( [ 2 ] ), DihedralPcpGroup( infinity ) );;
gap> IsTorsionFree( G );
false
gap> IsElementaryAbelian( G );
false
gap> IsFreeAbelian( G );
false
gap> IsAbelian( G );
false
gap> IsAbelianByFinite( G );
true
gap> IsCrystallographic( G );
false
gap> IsBieberbachGroup( G );
false
gap> IsNilpotentGroup( G );
false
gap> IsNilpotentByFinite( G );
true
gap> IsAlmostCrystallographic( G );
false
gap> IsAlmostBieberbachGroup( G );
false
gap> IsNilpotentByAbelian( G );
true

gap> STOP_TEST( "properties.tst" );
