
BindGlobal( "IsIsomBySP", function(G, H)
    local g,h,r,s;
    g := GeneratorsOfGroup(FreeGroupOfFpGroup(G));
    h := GeneratorsOfGroup(FreeGroupOfFpGroup(H));
    r := RelatorsOfFpGroup(G);
    s := List(RelatorsOfFpGroup(H), x -> MappedWord(x,h,g));
    return r=s;
end );

BindGlobal( "IdPcpGroup", function(G)
    return IdGroup(PcpGroupToPcGroup(RefinedPcpGroup(G)));
end );

BindGlobal( "ExtensionModule", function(K,H)
    return SubgroupByIgs(K,Igs(K){[Length(Igs(H))+1..Length(Igs(K))]});
end );

BindGlobal( "ReduceMod", function(vec, rels)
    return List([1..Length(vec)], i -> vec[i] mod rels[i]);
end );

BindGlobal( "ProductPcpGroups", function(G, U, V)
    return Subgroup(G, Concatenation(Igs(U), Igs(V)));
end );

BindGlobal( "ExponentAbelianPcpGroup", function( G )
    return Maximum(RelativeOrdersOfPcp(Pcp(G,"snf")));
end );

BindGlobal( "OmegaAbelianPcpGroup", function(G, e)
    return Subgroup(G, List(Igs(G), x -> x^e));
end );

BindGlobal( "AddSExtension", function(G)
    if IsBound(G!.scov) then return; fi;
    G!.scov := SchurExtension(G);
    G!.modu := ExtensionModule(G!.scov, G);
    G!.mult := TorsionSubgroup(G!.modu);
    G!.mord := Size(G!.mult);
end );

BindGlobal( "AddMOrder", function(G)
    if IsBound(G!.mord) then return; fi;
    AddSExtension(G);
end );

BindGlobal( "CoverCode", function(G)
    if IsList(G) then return G; fi;
    AddMOrder(G);
    return [Size(G), G!.mord,
            CodePcGroup(PcpGroupToPcGroup(RefinedPcpGroup(G)))];
end );

BindGlobal( "CodeCover", function(c)
    local G;
    G := PcGroupCode(c[3], c[1]);
    G := PcGroupToPcpGroup(G);
    G!.mord := c[2];
    return G;
end );


