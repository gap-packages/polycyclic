#############################################################################
##
#W  pcpattr.gi                 Polycyc                           Bettina Eick
##
##  Some general attributes for pcp groups. Some of them are only available
##  for nilpotent pcp groups.
##

#############################################################################
##
#M MinimalGeneratingSet( G )
##
InstallMethod( MinimalGeneratingSet, "for pcp groups", [IsPcpGroup],
function( G )
    if IsNilpotentGroup( G ) then
        return MinimalGeneratingSetNilpotentPcpGroup(G);
    else
        Error("sorry: function is not installed");
    fi;
end );

#############################################################################
##
#M SmallGeneratingSet( G )
##
InstallMethod( SmallGeneratingSet, "for pcp groups", [IsPcpGroup],
function( G )
    local g, s, U, i, V;
    if Size(G) = 1 then return []; fi;
    g := Igs(G);
    s := [g[1]];
    U := SubgroupNC( G, s );
    i := 1;
    while IndexNC(G,U) > 1 do
        i := i+1;
        Add( s, g[i] );
        V := SubgroupNC( G, s );
        if IndexNC(V, U) > 1 then
            U := V;
        else
            Unbind(s[Length(s)]);
        fi;
    od;
    return s;
end );

#############################################################################
##
#M SylowSubgroup( G, p )
##
InstallMethod( SylowSubgroupOp, [IsPcpGroup, IsPosInt],
function( G, p )
    local iso;
    if not IsFinite(G) then
        Error("sorry: function is not installed");
    fi;
    # HACK: Until we write a proper native method, use that for pc groups
    iso := IsomorphismPcGroup(G);
    return PreImagesSet(iso, SylowSubgroup(Image(iso),p));
end );

