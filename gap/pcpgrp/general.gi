#############################################################################
##
#F ExponentRelationMatrix( pcp )
##
BindGlobal( "ExponentRelationMatrix", function( pcp )
    local rels, relo, i, r;
    rels := [];
    relo := RelativeOrdersOfPcp( pcp );
    for i in [1..Length(pcp)] do
        if relo[i] > 0 then
            r := ExponentsByPcp( pcp, pcp[i]^relo[i] );
            r[i] := -relo[i];
            Add( rels, r );
        fi;
    od;
    return rels;
end );

#############################################################################
##
#F MappedVector( <exp>, <list> ). . . . . . . . . . . . . . . . . . . . local
##
## Redefine this library function such that it works for FFE vectors.
## FIXME: the redefinition will be in the GAP 4.12 library; so at some
## point in the future, we should get rid of our code variant and just
## rely on the library version.
##
MappedVector := function( exp, list )
    local elm, i;

    if Length( list ) = 0 then Error("cannot compute this\n"); fi;
    if IsFFE( exp[1] ) then exp := IntVecFFE(exp); fi;
    elm := list[1]^exp[1];
    for i in [2..Length(list)] do
        elm := elm * list[i]^exp[i];
    od;
    return elm;
end;

#############################################################################
##
#F AbelianIntersection( baseN, baseU )  . . . . . . . . . . . . . . .U \cap N
##
## N and U are subgroups of a free abelian group given by exponents.
##
BindGlobal( "AbelianIntersection", function( baseN, baseU )
    local n, s, id, ls, rs, is, g, I, al, ar, d, l1, l2, e, tm;

    # if N or U is trivial
    if Length( baseN ) = 0 or Length( baseU ) = 0 then return []; fi;
    n := Length( baseN[1] );

    # if N or U are equal to G
    if Length( baseN ) = n then return baseU;
    elif Length( baseU ) = n then return baseN; fi;

    # if N is a tail
    s := PositionNonZero( baseN[1] );
    if Length( baseN ) = n-s+1 and
    ForAll( baseN, x -> x[PositionNonZero(x)] = 1 ) then
        return Filtered( baseU, x -> Depth(x) >= s );
    fi;

    # otherwise compute
    id := List( [1..n], x -> 0 );
    ls := IdentityMat( n );
    rs := IdentityMat( n );
    is := IdentityMat( n );

    for g in baseU do
        d := PositionNonZero( g );
        ls[d] := g;
        rs[d] := g;
    od;

    I := [];
    for g in baseN do
        d := PositionNonZero( g );
        if ls[d] = id  then
            ls[d] := g;
        else
            Add( I, g );
        fi;
    od;

    # enter the pairs [ u, 1 ] of <I> into [ <ls>, <rs> ]
    for al  in I  do
        ar := id;
        d  := Depth( al );

        # compute sum and intersection
        while al <> id and ls[d] <> id  do
            l1 := ls[d][d];
            l2 := al[d];
            e := Gcdex( l1, l2 );
            tm := e.coeff1 * ls[d] +  e.coeff2 * al;
            al := e.coeff3 * ls[d] +  e.coeff4 * al;
            ls[d] := tm;
            tm := e.coeff1 * rs[d] +  e.coeff2 * ar;
            ar := e.coeff3 * rs[d] +  e.coeff4 * ar;
            rs[d] := tm;
            d := Depth( al );
        od;

        # we have a new sum generator
        if al <> id  then
            ls[d] := al;
            rs[d] := ar;

        # we have a new intersection generator
        elif ar <> id then
            d := Depth( ar );
            while ar <> id and is[d] <> id  do
                l1 := is[d][d];
                l2 := ar[d];
                e  := Gcdex( l1, l2 );
                tm := e.coeff1 * is[d] +  e.coeff2 * ar;
                ar := e.coeff3 * is[d] +  e.coeff4 * ar;
                is[d] := tm;
                d  := Depth( ar );
            od;
            if ar <> id  then
                is[d] := ar;
            fi;
        fi;
    od;
    return Filtered( is, x -> x <> id );
end );

#############################################################################
##
#F FrattiniSubgroup( G )
##
InstallMethod( FrattiniSubgroup, "for pcp groups", [IsPcpGroup],
function( G )
    local iso, K, F;

    if not IsFinite(G) then
        Error("Sorry - no algorithm available");
    fi;

    # HACK: Until we write a proper native method, use that for pc groups
    iso := IsomorphismPcGroup(G);
    K := Image(iso);
    F := FrattiniSubgroup(K);
    return PreImagesSet(iso, F);
end );

#############################################################################
##
#F NormalMaximalSubgroups(G)
##
InstallMethod( NormalMaximalSubgroups, "for pcp groups", [IsPcpGroup],
function(G)
    local D, nat, H, prm, max, p, rep;
    D := DerivedSubgroup(G);
    if Index(G,D) = infinity then return fail; fi;
    nat := NaturalHomomorphismByNormalSubgroup(G,D);
    H := Image(nat);
    prm := Set(Factors(Size(H)));
    max := [];
    for p in prm do
        rep := MaximalSubgroupClassesByIndex(H,p);
        rep := List(rep, Representative);
        Append(max,rep);
    od;
    return List(max, x -> PreImage(nat,x));
end);

#############################################################################
##
#F AsList(G)
##
InstallMethod( AsList, "for pcp groups", [IsPcpGroup],
function(G)
    local pcp, exp;
    if Size(G) = infinity then return fail; fi;
    pcp := Pcp(G);
    exp := ExponentsByRels( RelativeOrdersOfPcp(pcp));
    return List(exp, x -> MappedVector(x, pcp));
end);
