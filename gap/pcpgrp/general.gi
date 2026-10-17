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
    K := ImagesSource(iso);
    F := FrattiniSubgroup(K);
    return PreImagesSetNC(iso, F);
end );

#############################################################################
##
#F NormalMaximalSubgroups(G)
##
InstallMethod( NormalMaximalSubgroups, "for pcp groups", [IsPcpGroup],
function(G)
    local D, nat, H, prm, max, p, rep;
    D := DerivedSubgroup(G);
    if IndexNC(G,D) = infinity then return fail; fi;
    nat := NaturalHomomorphismByNormalSubgroupNC(G,D);
    H := ImagesSource(nat);
    prm := Set(Factors(Size(H)));
    max := [];
    for p in prm do
        rep := MaximalSubgroupClassesByIndex(H,p);
        rep := List(rep, Representative);
        Append(max,rep);
    od;
    return List(max, x -> PreImagesSetNC(nat,x));
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
