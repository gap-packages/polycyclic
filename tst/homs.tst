gap> START_TEST("Test of homs between various group types");

gap> TestHomHelper := function(A,B,gens_A,gens_B)
>   local map, inv, H;
>   
>   map:=GroupGeneralMappingByImages(A,B,gens_A,gens_B);
>   inv:=GroupGeneralMappingByImages(B,A,gens_B,gens_A);
>   
>   Display(HasIsAbelian(ImagesSource(map)));
>   Display(HasIsAbelian(PreImagesRange(map)));
> 
>   Display(inv = InverseGeneralMapping(map));
>   Display(List([IsTotal,IsSingleValued,IsSurjective,IsInjective], f->f(map)));
>   Display(List([IsTotal,IsSingleValued,IsSurjective,IsInjective], f->f(inv)));
>   Display(List([PreImagesRange(map),CoKernel(map),ImagesSource(map),Kernel(map)],Size));
>   Display(List([PreImagesRange(inv),CoKernel(inv),ImagesSource(inv),Kernel(inv)],Size));
> end;;
gap> TestHomFromFilterToFilter := function(f1, f2)
>   local A, B, iA, iB, gens_A, gens_B;
>   A:=AbelianGroup(f1,[35,15]);;
>   B:=AbelianGroup(f2,[35,15]);;
>   iA := IndependentGeneratorsOfAbelianGroup(A);
>   iB := IndependentGeneratorsOfAbelianGroup(B);
>   
>   TestHomHelper(A,B,iA,iB);
>   
>   gens_A:=ShallowCopy(iA);
>   gens_B:=ShallowCopy(iB);
>   gens_A:=gens_A{[1..3]};
>   gens_B:=gens_B{[1..3]};
>   TestHomHelper(A,B,gens_A,gens_B);
>   
>   gens_A[1]:=One(gens_A[1]);;
>   gens_A[2]:=MappedVector([ 0, 1, 0, 6 ], iA);;
>   gens_B[3]:=One(gens_B[3]);;
>   
>   TestHomHelper(A,B,gens_A,gens_B);
>   
>   gens_A[1]:=MappedVector([ 2, 1, 1, 0 ], iA);
>   TestHomHelper(A,B,gens_A,gens_B); 
> end;;


gap> TestHomFromFilterToFilter(IsPermGroup,IsPermGroup);
true
true
true
[ true, true, true, true ]
[ true, true, true, true ]
[ 525, 1, 525, 1 ]
[ 525, 1, 525, 1 ]
true
true
true
[ false, true, false, true ]
[ false, true, false, true ]
[ 75, 1, 75, 1 ]
[ 75, 1, 75, 1 ]
true
true
true
[ false, false, false, false ]
[ false, false, false, false ]
[ 175, 3, 15, 35 ]
[ 15, 35, 175, 3 ]
true
true
true
[ true, false, false, false ]
[ false, false, true, false ]
[ 525, 5, 15, 175 ]
[ 15, 175, 525, 5 ]
gap> TestHomFromFilterToFilter(IsPermGroup,IsPcGroup);
true
true
true
[ true, true, true, true ]
[ true, true, true, true ]
[ 525, 1, 525, 1 ]
[ 525, 1, 525, 1 ]
true
true
true
[ false, true, false, true ]
[ false, true, false, true ]
[ 75, 1, 75, 1 ]
[ 75, 1, 75, 1 ]
true
true
true
[ false, false, false, false ]
[ false, false, false, false ]
[ 175, 3, 15, 35 ]
[ 15, 35, 175, 3 ]
true
true
true
[ true, false, false, false ]
[ false, false, true, false ]
[ 525, 5, 15, 175 ]
[ 15, 175, 525, 5 ]
gap> TestHomFromFilterToFilter(IsPermGroup,IsPcpGroup);
true
true
true
[ true, true, true, true ]
[ true, true, true, true ]
[ 525, 1, 525, 1 ]
[ 525, 1, 525, 1 ]
true
true
true
[ false, true, false, true ]
[ false, true, false, true ]
[ 75, 1, 75, 1 ]
[ 75, 1, 75, 1 ]
true
true
true
[ false, false, false, false ]
[ false, false, false, false ]
[ 175, 3, 15, 35 ]
[ 15, 35, 175, 3 ]
true
true
true
[ true, false, false, false ]
[ false, false, true, false ]
[ 525, 5, 15, 175 ]
[ 15, 175, 525, 5 ]
gap> TestHomFromFilterToFilter(IsPcGroup,IsPermGroup);
true
true
true
[ true, true, true, true ]
[ true, true, true, true ]
[ 525, 1, 525, 1 ]
[ 525, 1, 525, 1 ]
true
true
true
[ false, true, false, true ]
[ false, true, false, true ]
[ 75, 1, 75, 1 ]
[ 75, 1, 75, 1 ]
true
true
true
[ false, false, false, false ]
[ false, false, false, false ]
[ 175, 3, 15, 35 ]
[ 15, 35, 175, 3 ]
true
true
true
[ true, false, false, false ]
[ false, false, true, false ]
[ 525, 5, 15, 175 ]
[ 15, 175, 525, 5 ]
gap> TestHomFromFilterToFilter(IsPcGroup,IsPcGroup);
true
true
true
[ true, true, true, true ]
[ true, true, true, true ]
[ 525, 1, 525, 1 ]
[ 525, 1, 525, 1 ]
true
true
true
[ false, true, false, true ]
[ false, true, false, true ]
[ 75, 1, 75, 1 ]
[ 75, 1, 75, 1 ]
true
true
true
[ false, false, false, false ]
[ false, false, false, false ]
[ 175, 3, 15, 35 ]
[ 15, 35, 175, 3 ]
true
true
true
[ true, false, false, false ]
[ false, false, true, false ]
[ 525, 5, 15, 175 ]
[ 15, 175, 525, 5 ]
gap> TestHomFromFilterToFilter(IsPcGroup,IsPcpGroup);
true
true
true
[ true, true, true, true ]
[ true, true, true, true ]
[ 525, 1, 525, 1 ]
[ 525, 1, 525, 1 ]
true
true
true
[ false, true, false, true ]
[ false, true, false, true ]
[ 75, 1, 75, 1 ]
[ 75, 1, 75, 1 ]
true
true
true
[ false, false, false, false ]
[ false, false, false, false ]
[ 175, 3, 15, 35 ]
[ 15, 35, 175, 3 ]
true
true
true
[ true, false, false, false ]
[ false, false, true, false ]
[ 525, 5, 15, 175 ]
[ 15, 175, 525, 5 ]
gap> TestHomFromFilterToFilter(IsPcpGroup,IsPermGroup);
true
true
true
[ true, true, true, true ]
[ true, true, true, true ]
[ 525, 1, 525, 1 ]
[ 525, 1, 525, 1 ]
true
true
true
[ false, true, false, true ]
[ false, true, false, true ]
[ 75, 1, 75, 1 ]
[ 75, 1, 75, 1 ]
true
true
true
[ false, false, false, false ]
[ false, false, false, false ]
[ 175, 3, 15, 35 ]
[ 15, 35, 175, 3 ]
true
true
true
[ true, false, false, false ]
[ false, false, true, false ]
[ 525, 5, 15, 175 ]
[ 15, 175, 525, 5 ]
gap> TestHomFromFilterToFilter(IsPcpGroup,IsPcGroup);
true
true
true
[ true, true, true, true ]
[ true, true, true, true ]
[ 525, 1, 525, 1 ]
[ 525, 1, 525, 1 ]
true
true
true
[ false, true, false, true ]
[ false, true, false, true ]
[ 75, 1, 75, 1 ]
[ 75, 1, 75, 1 ]
true
true
true
[ false, false, false, false ]
[ false, false, false, false ]
[ 175, 3, 15, 35 ]
[ 15, 35, 175, 3 ]
true
true
true
[ true, false, false, false ]
[ false, false, true, false ]
[ 525, 5, 15, 175 ]
[ 15, 175, 525, 5 ]
gap> TestHomFromFilterToFilter(IsPcpGroup,IsPcpGroup);
true
true
true
[ true, true, true, true ]
[ true, true, true, true ]
[ 525, 1, 525, 1 ]
[ 525, 1, 525, 1 ]
true
true
true
[ false, true, false, true ]
[ false, true, false, true ]
[ 75, 1, 75, 1 ]
[ 75, 1, 75, 1 ]
true
true
true
[ false, false, false, false ]
[ false, false, false, false ]
[ 175, 3, 15, 35 ]
[ 15, 35, 175, 3 ]
true
true
true
[ true, false, false, false ]
[ false, false, true, false ]
[ 525, 5, 15, 175 ]
[ 15, 175, 525, 5 ]


gap> G:=AbelianGroup(IsPcpGroup,[2,3,2]);;
gap> map:=GroupGeneralMappingByImages(G,G,[G.1],[G.3]);;
gap> Size(PreImagesSet(map,G));
2
gap> List([IsTotal,IsSingleValued,IsSurjective,IsInjective], f->f(map));
[ false, true, false, true ]
gap> map2:=map*map;;
gap> Size(PreImagesSet(map2,G));
1
gap> Size(ImagesSet(map2,G));
1
gap> Size(ImagesSource(map2));
1
gap> Size(PreImagesRange(map2));
1

gap> STOP_TEST( "homs.tst", 10000000);

