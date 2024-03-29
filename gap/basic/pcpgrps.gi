#############################################################################
##
#W  pcpgrps.gi                   Polycyc                         Bettina Eick
##

#############################################################################
##
#F Create a pcp group by collector
##
## The trivial group is missing.
##
InstallGlobalFunction( PcpGroupByCollectorNC, function( coll )
    local n, l, e, f, G, rels;
    n := coll![ PC_NUMBER_OF_GENERATORS ];

    if n > 0 then
        l := IdentityMat( n );
    fi;

    e := List( [1..n], x -> PcpElementByExponentsNC( coll, l[x] ) );
    f := PcpElementByGenExpListNC( coll, [] );
    G := GroupWithGenerators( e, f );
    SetCgs( G, e );
    SetIsWholeFamily( G, true );

    if 0 in RelativeOrders( coll ) then
      SetIsFinite( G, false );
    else
      SetIsFinite( G, true );
      SetSize( G, Product( RelativeOrders( coll ) ) );
    fi;

    return G;
end );

InstallGlobalFunction( PcpGroupByCollector, function( coll )
    UpdatePolycyclicCollector( coll );
    if not IsConfluent( coll ) then
        return fail;
    else
        return PcpGroupByCollectorNC( coll );
    fi;
end );

#############################################################################
##
#F Print( <G> )
##
InstallMethod( PrintObj, "for a pcp group", [ IsPcpGroup ],
function( G )
    Print("Pcp-group with orders ",  List( Igs(G), RelativeOrderPcp ) );
end );

InstallMethod( ViewObj, "for a pcp group", [ IsPcpGroup ], SUM_FLAGS,
function( G )
    Print("Pcp-group with orders ",  List( Igs(G), RelativeOrderPcp ) );
end );

#############################################################################
##
#M Igs( <pcpgrp> )
#M Ngs( <pcpgrp> )
#M Cgs( <pcpgrp> )
##
InstallMethod( Igs, [ IsPcpGroup ],
function( G )
    if HasCgs( G ) then return Cgs(G); fi;
    if HasNgs( G ) then return Ngs(G); fi;
    return Igs( GeneratorsOfGroup(G) );
end );

InstallMethod( Ngs, [ IsPcpGroup ],
function( G )
    if HasCgs( G ) then return Cgs(G); fi;
    return Ngs( Igs( GeneratorsOfGroup(G) ) );
end );

InstallMethod( Cgs, [ IsPcpGroup ],
function( G )
    return Cgs( Igs( GeneratorsOfGroup(G) ) );
end );

#############################################################################
##
#M Membershiptest for pcp groups
##
InstallMethod( \in, "for a pcp element and a pcp group",
               IsElmsColls, [IsPcpElement, IsPcpGroup],
function( g, G )
    return ReducedByIgs( Igs(G), g ) = One(G);
end );

#############################################################################
##
#M Random( G )
##
InstallMethodWithRandomSource( Random, "for a random source and a pcp group",
                               [ IsRandomSource, IsPcpGroup ],
function( rs, G )
    local pcp, rel, g, i;
    pcp := Pcp(G);
    if Length( pcp ) = 0 then
        return One( G );
    fi;
    rel := RelativeOrdersOfPcp( pcp );
    g   := [];
    for i in [1..Length(rel)] do
        if rel[i] = 0 then
            g[i] := Random( rs, Integers );
        else
            g[i] := Random( rs, 0, rel[i]-1 );
        fi;
    od;
    return MappedVector( g, pcp );
end );

#############################################################################
##
#M SubgroupByIgs( G, igs [, gens] )
##
## create a subgroup and set igs. If gens is given, compute pcs defined
## by <gens, pcs> and use this. Note: this function does not check if the
## generators are in G.
##
InstallGlobalFunction( SubgroupByIgs,
   function( arg )
    local U, pcs;
    if Length( arg ) = 3 then
        pcs := AddToIgs( arg[2], arg[3] );
    else
        pcs := arg[2];
    fi;
    U := SubgroupNC( Parent(arg[1]), pcs );
    SetIgs( U, pcs );
    return U;
end);

#############################################################################
##
#M SubgroupByIgsAndIgs( G, fac, nor )
##
## fac and nor are igs for a factor and a normal subgroup. This function
## computes an igs for the subgroups generated by fac and nor and sets it
## in the subgroup. This is a no-check function
##
BindGlobal( "SubgroupByIgsAndIgs", function( G, fac, nor )
    return SubgroupByIgs( G, AddIgsToIgs( fac, nor ) );
end );

#############################################################################
##
#M IsSubset for pcp groups
##
InstallMethod( IsSubset, "for pcp groups",
               IsIdenticalObj, [ IsPcpGroup, IsPcpGroup ], SUM_FLAGS,
function( H, U )
    if Parent(U) = H then return true; fi;
    return ForAll( GeneratorsOfGroup(U), x -> x in H );
end );

#############################################################################
##
#M Size( <pcpgrp> )
##
InstallMethod( Size, [ IsPcpGroup ],
function( G )
    local pcs, rel;
    pcs := Igs( G );
    rel := List( pcs, RelativeOrderPcp );
    if ForAny( rel, x -> x = 0 ) then
        return infinity;
    else
        return Product( rel );
    fi;
end );

#############################################################################
##
#M CanComputeIndex( <pcpgrp>, <pcpgrp> )
#M CanComputeSize( <pcpgrp> )
#M CanComputeSizeAnySubgroup( <pcpgrp> )
##
InstallMethod( CanComputeIndex, IsIdenticalObj, [IsPcpGroup, IsPcpGroup], ReturnTrue );
InstallTrueMethod( CanComputeSize, IsPcpGroup );
InstallTrueMethod( CanComputeSizeAnySubgroup, IsPcpGroup );

#############################################################################
##
#M IndexNC/Index( <pcpgrp>, <pcpgrp> )
##
InstallMethod( IndexNC, "for pcp groups",
               IsIdenticalObj, [IsPcpGroup, IsPcpGroup],
function( H, U )
    local pcp, rel;
    pcp := Pcp( H, U );
    rel := RelativeOrdersOfPcp( pcp );
    if ForAny( rel, x -> x = 0 ) then
        return infinity;
    else
        return Product( rel );
    fi;
end );

InstallMethod( IndexOp, "for pcp groups",
               IsIdenticalObj, [IsPcpGroup, IsPcpGroup],
function( H, U )
    if not IsSubgroup( H, U ) then
        Error("H must be contained in G");
    fi;
    return IndexNC( H, U );
end );

#############################################################################
##
#M <pcpgrp> = <pcpgrp>
##
InstallMethod( \=, "for pcp groups",
               IsIdenticalObj, [IsPcpGroup, IsPcpGroup],
function( G, H )
    return Cgs( G ) = Cgs( H );
end);

#############################################################################
##
#M ClosureGroup( <pcpgrp>, <pcpgrp> )
##
InstallMethod( ClosureGroup, "for pcp groups",
               IsIdenticalObj, [IsPcpGroup, IsPcpGroup],
function( G, H )
    local P;
    P := PcpGroupByCollectorNC( Collector(G) );
    return SubgroupByIgs( P, Igs(G), GeneratorsOfGroup(H) );
end );

#############################################################################
##
#F HirschLength( <G> )
##
InstallMethod( HirschLength, [ IsPcpGroup ],
function( G )
    local pcs, rel;
    pcs := Igs( G );
    rel := List( pcs, RelativeOrderPcp );
    return Length( Filtered( rel, x -> x = 0 ) );
end );

#############################################################################
##
#M CommutatorSubgroup( G, H )
##
InstallMethod( CommutatorSubgroup, "for pcp groups",
               IsIdenticalObj, [ IsPcpGroup, IsPcpGroup],
function( G, H )
    local pcsG, pcsH, coms, i, j, U, u;

    pcsG := Igs(G);
    pcsH := Igs(H);

    # if G = H then we need fewer commutators
    coms := [];
    if pcsG = pcsH then
        for i in [1..Length(pcsG)] do
            for j in [1..i-1] do
                Add( coms, Comm( pcsG[i], pcsH[j] ) );
            od;
        od;
        coms := Igs( coms );
        U    := SubgroupByIgs( Parent(G), coms );
    else
        for u in pcsG do
            coms := AddToIgs( coms, List( pcsH, x -> Comm( u, x ) ) );
        od;
        U    := SubgroupByIgs( Parent(G), coms );

        # In order to conjugate with fewer elements, compute <U,V>. If one is
        # normal than we do not need the normal closure, see Glasby 1987.
        if not (IsBound( G!.isNormal ) and G!.isNormal) and
           not (IsBound( H!.isNormal ) and H!.isNormal) then
            U := NormalClosure( ClosureGroup( G, H ), U );
        fi;
    fi;
    return U;
end );

#############################################################################
##
#M DerivedSubgroup( G )
##
InstallMethod( DerivedSubgroup, "for a pcp group",
               [ IsPcpGroup ], G -> CommutatorSubgroup(G, G) );

#############################################################################
##
#M PRump( G, p ). . . . . smallest normal subgroup N of G with G/N elementary
##                        abelian p-group.
##
InstallMethod( PRumpOp, "for a pcp group and a prime",
               [IsPcpGroup, IsPosInt],
function( G, p )
    local D, pcp, new;
    D := DerivedSubgroup(G);
    pcp := Pcp( G, D );
    new := List( pcp, x -> x^p );
    return SubgroupByIgs( G, Igs(D), new );
end );

#############################################################################
##
#M IsNilpotentGroup( <pcpgrp> )
##
InstallMethod( IsNilpotentGroup, "for a pcp group with known lower central series",
               [ IsPcpGroup and HasLowerCentralSeriesOfGroup ],
function( G )
    local   lcs;

    lcs := LowerCentralSeriesOfGroup( G );
    return IsTrivial( lcs[ Length(lcs) ] );
end );

InstallMethod( IsNilpotentGroup, "for a pcp group",
               [IsPcpGroup],
function( G )
    local l, U, V, pcp, n;

    l := HirschLength(G);
    U := ShallowCopy( G );

    repeat

        # take next term of lc series
        U!.isNormal := true;
        V := CommutatorSubgroup( G, U );

        # if we arrive at the trivial group
        if Size( V ) = 1 then return true; fi;

        # get quotient U/V
        pcp := Pcp( U, V );

        # if U=V then the series has terminated at a non-trivial group
        if Length( pcp ) = 0 then
            return false;
        fi;

        # get the Hirsch length of U/V
        n := Length( Filtered( RelativeOrdersOfPcp( pcp ), x -> x = 0));

        # compare it with l
        if n = 0 and l <> 0  then return false; fi;
        l := l - n;

        # iterate
        U := ShallowCopy( V );
    until false;
end );

#############################################################################
##
#M IsElementaryAbelian( <pcpgrp> )
##
InstallMethod( IsElementaryAbelian, "for a pcp group",
               [ IsPcpGroup ],
function( G )
    local rel, p;
    if not IsFinite(G) or not IsAbelian(G) then return false; fi;
    rel := List( Igs(G), RelativeOrderPcp );
    if Length(Set(rel)) > 1 then return false; fi;
    if ForAny( rel, x -> not IsPrime(x) ) then return false; fi;
    p := rel[1];
    return ForAll( RelativeOrdersOfPcp( Pcp( G, "snf" ) ), x -> x = p );
end );

#############################################################################
##
#F AbelianInvariants( <pcpgrp > )
##
InstallMethod( AbelianInvariants, "for a pcp group",
               [ IsPcpGroup ],
function( G )
    return AbelianInvariantsOfList( RelativeOrdersOfPcp( Pcp(G, DerivedSubgroup(G), "snf") ) );
end );

InstallMethod( AbelianInvariants, "for an abelian pcp group",
               [IsPcpGroup and IsAbelian],
function( G )
    return AbelianInvariantsOfList( RelativeOrdersOfPcp( Pcp(G, "snf") ) );
end );


#############################################################################
##
#M  CanEasilyComputeWithIndependentGensAbelianGroup( <pcpgrp> )
##
if IsBound(CanEasilyComputeWithIndependentGensAbelianGroup) then
# CanEasilyComputeWithIndependentGensAbelianGroup was introduced in GAP 4.5.x
InstallTrueMethod(CanEasilyComputeWithIndependentGensAbelianGroup,
    IsPcpGroup and IsAbelian);
fi;

BindGlobal( "ComputeIndependentGeneratorsOfAbelianPcpGroup", function ( G )
    local pcp, id, mat, base, ord, i, g, o, cf, j;

	# Get a pcp in Smith normal form
	if not IsBound( G!.snfpcp ) then
		pcp := Pcp(G, "snf");
		G!.snfpcp := pcp;
	else
		pcp := G!.snfpcp;
	fi;

	if IsBound( G!.indgens ) and IsBound( G!.indgenmat ) then
		return;
	fi;

	# Unfortunately, this is not *quite* what we need; in order to match
	# the Abelian invariants, we now have to further refine the generator
	# list to ensure only generators of prime power order are in the list.
	id := IdentityMat( Length(pcp) );
	mat := [];
	base := [];
	ord := [];
	for i in [1..Length(pcp)] do
		g := pcp[i];
		o := Order(g);
		if o = 1 then continue; fi;
		if o = infinity then
			Add(base, g);
			Add(mat, id[i]);
			Add(ord, 0);
			continue;
		fi;
		cf:=Collected(Factors(o));
		if Length(cf) > 1 then
			for j in cf do
				j := j[1]^j[2];
				Add(base, g^(o/j));
				Add(mat, id[i] * (j/o mod j));
				Add(ord, j);
			od;
		else
			Add(base, g);
			Add(mat, id[i]);
			Add(ord, o);
		fi;
	od;
	SortParallel(ShallowCopy(ord),base);
	SortParallel(ord,mat);

	mat := TransposedMat( mat );

	G!.indgens := base;
	G!.indgenmat := mat;
end );

#############################################################################
##
#A  IndependentGeneratorsOfAbelianGroup( <A> )
##
InstallMethod(IndependentGeneratorsOfAbelianGroup, "for an abelian pcp group",
               [IsPcpGroup and IsAbelian],
function( G )
	if not IsBound( G!.indgens ) then
		ComputeIndependentGeneratorsOfAbelianPcpGroup( G );
	fi;
	return G!.indgens;
end );


#############################################################################
##
#O  IndependentGeneratorExponents( <G>, <g> )
##
if IsBound( IndependentGeneratorExponents ) then
# IndependentGeneratorExponents was introduced in GAP 4.5.x

InstallMethod(IndependentGeneratorExponents, "for an abelian pcp group and an element",
               IsCollsElms,
               [IsPcpGroup and IsAbelian, IsPcpElement],
function( G, elm )
	local exp, rels, i;

	# Ensure everything has been set up
	if not IsBound( G!.indgenmat ) then
		ComputeIndependentGeneratorsOfAbelianPcpGroup( G );
	fi;

	# Convert elm into an exponent vector with respect to a snf pcp
	exp := ExponentsByPcp( G!.snfpcp, elm );
	rels := AbelianInvariants( G );

	# Convert the exponent vector with respect to pcp into one
	# with respect to our independent abelian generators.
	exp := exp * G!.indgenmat;
    for i in [1..Length(exp)] do
        if rels[i] > 0 then exp[i] := exp[i] mod rels[i]; fi;
    od;
	return exp;
end);

fi;

#############################################################################
##
#F NormalClosure( K, U )
##
InstallMethod( NormalClosureOp, "for pcp groups",
               IsIdenticalObj, [IsPcpGroup, IsPcpGroup],
function( K, U )
    local tmpN, newN, done, id, gensK, pcsN, k, n, c, N;

    # take initial pcs
    pcsN := ShallowCopy( Cgs(U) );
    if Length( pcsN ) = 0 then return U; fi;

    # take generating sets
    id := One( K );
    gensK := GeneratorsOfGroup(K);
    gensK := List( gensK, x -> ReducedByIgs( pcsN, x ) );
    gensK := Filtered( gensK, x -> x <> id );

    repeat
        done := true;
        tmpN := ShallowCopy( pcsN );
        for k in gensK do
            for n in tmpN do
                c := ReducedByIgs( pcsN, Comm( k, n ) );
                if c <> id then
                    newN := AddToIgs( pcsN, [c] );
                    if newN <> pcsN then
                        done := false;
                        pcsN := Cgs( newN );
                    fi;
                fi;
            od;
        od;
        #Print(Length(pcsN)," obtained \n");
    until done;

    # set up result
    N := Group( pcsN );
    SetIgs( N, pcsN );
    return N;
end);

#############################################################################
##
#F ExponentsByRels . . . . . . . . . . . . . . .elements written as exponents
##
BindGlobal( "ExponentsByRels", function( rel )
    local exp, idm, i, t, j, e, f;
    exp := [List( rel, x -> 0 )];
    idm := IdentityMat( Length( rel ) );
    for i in Reversed( [1..Length(rel)] ) do
        t := [];
        for j in [1..rel[i]] do
            for e in exp do
                f := ShallowCopy( e );
                f[i] := j-1;
                Add( t, f );
            od;
        od;
        exp := t;
    od;
    return exp;
end );
