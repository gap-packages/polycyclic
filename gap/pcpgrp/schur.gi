#############################################################################
##
#A ReduceTail
##
ReduceTail := function( w, n, Q, d, f )
    local   i,  a,  v;

    i := 1;
    while i < Length(w) and w[i] <= n do i := i+2; od;

    a := w{[1..i-1]};

    v := Q[1] * 0;
    while i < Length(w) do
        v := v + Q[ w[i] - n ] * w[i+1];
        i := i+2;
    od;

    for i in [1..Length(v)] do
        if d[i] > 1 then v[i] := v[i] mod d[i]; fi;
    od;

    for i in [1..Length(f)] do
        Add( a, n+i ); Add( a, v[ f[i] ] );
    od;

    return a;
end;

#############################################################################
##
#A SchurExtensionEpimorphism(G) . . . . . . . epimorphism from F/R to F/[R,F]
##
InstallMethod( SchurExtensionEpimorphism, "for pcp groups", [IsPcpGroup], function(G)
    local g, r, n, y, coll, k, i, j, e, sys, ext, extgens, images, epi, ker;

    # handle the trivial group
    if IsTrivial(G) then
    	return IdentityMapping(G);
    fi;

    # set up
    g := Igs(G);
    n := Length(g);
    r := List(g, x -> RelativeOrderPcp(x));

    if n = 1 then
        ext := AbelianPcpGroup(1, [0]); # the infinite cyclic group
        return GroupHomomorphismByImagesNC( ext, G, GeneratorsOfGroup(ext), GeneratorsOfGroup(G) );;
    fi;

    # get collector for extension
    y := n*(n-1)/2 + Number(r, x -> x>0);
    coll := FromTheLeftCollector(n+y);

    # add a tail to each power and each positive conjugate relation
    k := n;
    for i in [1..n] do
        SetRelativeOrder(coll, i, r[i]);

        if r[i] > 0 then
            e := ObjByExponents(coll, ExponentsByIgs(g, g[i]^r[i]));
            k := k+1;
            Append(e, [k,1]);
            SetPower(coll,i,e);
        fi;

        for j in [1..i-1] do
            e := ObjByExponents(coll, ExponentsByIgs(g, g[i]^g[j]));
            k := k+1;
            Append(e, [k,1]);
            SetConjugate(coll,i,j,e);
        od;
    od;

    # update
    UpdatePolycyclicCollector(coll);

    # evaluate consistency
    sys := CRSystem(1, y, 0);
    EvalConsistency( coll, sys );

    # determine quotient
    ext := QuotientBySystem( coll, sys, n );

    # construct quotient epimorphism
    extgens := Igs( ext );
    images := ListWithIdenticalEntries( Length(extgens), One(G) );
    images{[1..n]} := g;

    epi := GroupHomomorphismByImagesNC( ext, G, extgens, images );
    SetIsSurjective( epi, true );
    ker := Subgroup( ext, extgens{[n+1..Length(extgens)]} );
    SetKernelOfMultiplicativeGeneralMapping( epi, ker );

    return epi;
end );

#############################################################################
##
#A SchurExtension(G) . . . . . . . . . . . . . . . . . . . . . . . .  F/[R,F]
##
InstallMethod( SchurExtension, "for groups", [IsGroup], function(G)
    return Source( SchurExtensionEpimorphism( G ) );
end );

#############################################################################
##
#A AbelianInvariantsMultiplier(G) . . . . . . . . . . . . . . . . . . .  M(G)
##
InstallMethod( AbelianInvariantsMultiplier, "for pcp groups", [IsPcpGroup], function(G)
    local epi, H, M, T, D, I;

    # a simple check
    if IsCyclic(G) then return []; fi;

    # otherwise compute
    epi := SchurExtensionEpimorphism(G);
    H := Source(epi);
    M := KernelOfMultiplicativeGeneralMapping(epi);

    # the finite case
    if IsFinite(G) then
        T := TorsionSubgroup(M);
        return AbelianInvariants(T);
    fi;

    # the general case
    D := DerivedSubgroup(H);
    I := Intersection(M, D);
    return AbelianInvariants(I);
end );

#############################################################################
##
#A EpimorphismSchurCover(G) . . . . . . . . . . . . . . .  M(G) extended by G
##
InstallMethod( EpimorphismSchurCover, "for pcp groups", [IsPcpGroup], function(G)
    local epi, H, M, I, C, cover, g, n, extgens, images, ker;

    if IsCyclic(G) then return IdentityMapping( G ); fi;

    # get full extension F/[R,F]
    epi := SchurExtensionEpimorphism(G);
    H := Source(epi);

    # get R/[R,F]
    M := KernelOfMultiplicativeGeneralMapping(epi);

    # get R cap F'
    I := Intersection(M, DerivedSubgroup(H));

    # get complement to I in M
    C := Subgroup(H, GeneratorsOfPcp( Pcp(M,I,"snf")));

    if not IsFreeAbelian(C) then Error("wrong complement"); fi;

	# get Schur cover (R cap F') / [R,F]
    cover := H/C;

    # construct quotient epimorphism
    g := Igs(G);
    n := Length(g);
    extgens := Igs( cover );
    images := ListWithIdenticalEntries( Length(extgens), One(G) );
    images{[1..n]} := g;

    epi := GroupHomomorphismByImagesNC( cover, G, extgens, images );
    SetIsSurjective( epi, true );
    ker := Subgroup( cover, extgens{[n+1..Length(extgens)]} );
    SetKernelOfMultiplicativeGeneralMapping( epi, ker );

    return epi;
end );

#############################################################################
##
#A NonAbelianExteriorSquareEpimorphism(G) . . . . . . . . .  G wegde G --> G'
##
# FIXME: This function is documented and should be turned into a attribute
NonAbelianExteriorSquareEpimorphism := function( G )
    local   lift,  D,  gens,  imgs,  epi,  lambda;

    if Size(G) = 1 then return IdentityMapping( G ); fi;

    lift := SchurExtensionEpimorphism(G);
    D    := DerivedSubgroup( Source(lift) );

    gens := GeneratorsOfGroup( D );
    imgs := List( gens, g->Image( lift, g ) );
    epi  := GroupHomomorphismByImagesNC( D, DerivedSubgroup(G), gens, imgs );
    SetIsSurjective( epi, true );

    lambda := function( g, h )
        return Comm( PreImagesRepresentative( lift, g ),
                     PreImagesRepresentative( lift, h ) );
    end;

    D!.epimorphism := epi;
    # TODO: Make the crossedPairing accessible via an attribute!
    D!.crossedPairing := lambda;

    return epi;
end;

#############################################################################
##
#A NonAbelianExteriorSquare(G) . . . . . . . . . . . . . . . . . .(G wegde G)
##
InstallMethod( NonAbelianExteriorSquare, "for pcp groups", [IsPcpGroup], function(G)
    return Source( NonAbelianExteriorSquareEpimorphism( G ) );
end );

#############################################################################
##
#A NonAbelianExteriorSquarePlus(G) . . . . . . . . . . (G wegde G) by (G x G)
##
## This is the group tau(G) in our paper.
##
## The following function computes the embedding of the non-abelian exterior
## square of G into tau(G).
##
# FIXME: This function is documented and should be turned into an attribute
NonAbelianExteriorSquarePlusEmbedding := function(G)
    local   g,  n,  r,  w,  extlift,  F,  f,  D,  d,  m,  s,  c,  i,
            e,  j,  gens,  imgs,  k,  alpha,  S,  embed;

    if Size(G) = 1 then return G; fi;

    # set up
    g := Igs(G);
    n := Length(g);
    r := List(g, x -> RelativeOrderPcp(x));
    w := List([1..2*n], x -> 0);

    extlift := NonAbelianExteriorSquareEpimorphism( G );

    # F/[R,F] = G*
    F := Parent( Source( extlift ) );
    f := Pcp(F);

    # the non-abelian exterior square D = G^G
    D := Source( extlift );
    d := Pcp(D);
    m := Length(d);
    s := RelativeOrdersOfPcp(d);

#    Print( "#  NonAbelianExteriorSquarePlus: Setting up collector with ", 2*n+m,
#           " generators\n" );

    # set up collector for non-abelian exterior square plus
    c := FromTheLeftCollector(2*n+m);

    # the relators of GxG
    for i in [1..n] do

        # relative order and power
        if r[i] > 0 then
            SetRelativeOrder(c, i, r[i]);
            e := ExponentsByIgs(g, g[i]^r[i]);
            SetPower(c, i, ObjByExponents(c,e));

            SetRelativeOrder(c, n+i, r[i]);
            e := Concatenation(0*e, e);
            SetPower(c, n+i, ObjByExponents(c,e));
        fi;

        # conjugates
        for j in [1..i-1] do
            e := ExponentsByIgs(g, g[i]^g[j]);
            SetConjugate(c, i, j, ObjByExponents(c,e));

            e := Concatenation(0*e, e);
            SetConjugate(c, n+i, n+j, ObjByExponents(c,e));

            if r[j] = 0 then
                e := ExponentsByIgs(g, g[i]^(g[j]^-1));
                SetConjugate(c, i, -j, ObjByExponents(c,e));
                e := Concatenation(0*e, e);
                SetConjugate(c, n+i, -(n+j), ObjByExponents(c,e));
            fi;

        od;
    od;

    # the relators of G^G
    for i in [1..m] do

        # relative order and power
        if s[i] > 0 then
            SetRelativeOrder(c, 2*n+i, s[i]);
            e := ExponentsByPcp(d, d[i]^s[i]);
            e := Concatenation(w, e);
            SetPower(c, 2*n+i, ObjByExponents(c,e));
        fi;

        # conjugates
        for j in [1..i-1] do
            e := ExponentsByPcp(d, d[i]^d[j]);
            e := Concatenation(w, e);
            SetConjugate(c, 2*n+i, 2*n+j, ObjByExponents(c,e));

            if s[j] = 0 then
                e := ExponentsByPcp(d, d[i]^(d[j]^-1));
                e := Concatenation(w, e);
                SetConjugate(c, 2*n+i, -(2*n+j), ObjByExponents(c,e));
            fi;
        od;
    od;

    # the extension of G^G by GxG
    #
    # This is the computation of \lambda in our paper: For (g_i,g_j) we take
    # preimages (f_i,f_j) in G* and calculate the image of (g_i,g_j) under
    # \lambda as the commutator [f_i,f_j].
    for i in [1..n] do
        for j in [1..n] do
            e := ExponentsByPcp(d, Comm(f[j], f[i]));
            e := Concatenation(w, e); e[n+j] := 1;
            SetConjugate(c, n+j, i, ObjByExponents(c,e));

            if r[i] = 0 then
                e := ExponentsByPcp(d, Comm(f[j], f[i]^-1));
                e := Concatenation(w, e); e[n+j] := 1;
                SetConjugate(c, n+j, -i, ObjByExponents(c,e));
            fi;
        od;
    od;

    # the action on G^G by GxG
    for i in [1..n] do

        # create action homomorphism
        # G^G is generated by commutators of G*
        # G acts on G^G via conjugation with preimages in G*.
        gens := []; imgs := [];
        for k in [1..n] do
            for j in [1..n] do
                Add(gens, Comm(f[k], f[j]));
                Add(imgs, Comm(f[k]^f[i], f[j]^f[i]));
            od;
        od;
        alpha := GroupHomomorphismByImagesNC(D,D,gens,imgs);

        # compute conjugates
        for j in [1..m] do
            e := ExponentsByPcp(d, Image(alpha, d[j]));
            e := Concatenation(w, e);
            SetConjugate(c, 2*n+j, i, ObjByExponents(c,e));
            SetConjugate(c, 2*n+j, n+i, ObjByExponents(c,e));
        od;

        if r[i] = 0 then
            # create action homomorphism
            gens := []; imgs := [];
            for k in [1..n] do
                for j in [1..n] do
                    Add(gens, Comm(f[k], f[j]));
                    Add(imgs, Comm(f[k]^(f[i]^-1), f[j]^(f[i]^-1)));
                od;
            od;
            alpha := GroupHomomorphismByImagesNC(D,D,gens,imgs);

            # compute conjugates
            for j in [1..m] do
                e := ExponentsByPcp(d, Image(alpha, d[j]));
                e := Concatenation(w, e);
                SetConjugate(c, 2*n+j, -i, ObjByExponents(c,e));
                SetConjugate(c, 2*n+j, -(n+i), ObjByExponents(c,e));
            od;

        fi;

    od;

    if CHECK_SCHUR_PCP@ then
        S := PcpGroupByCollector(c);
    else
        UpdatePolycyclicCollector(c);
        S := PcpGroupByCollectorNC(c);
    fi;
    S!.group := G;

    gens := GeneratorsOfGroup(S){[2*n+1..2*n+m]};
    embed := GroupHomomorphismByImagesNC( D, S, GeneratorsOfPcp(d), gens );

    return embed;
end;

NonAbelianExteriorSquarePlus := function( G )
    return Range( NonAbelianExteriorSquarePlusEmbedding( G ) );
end;

#############################################################################
##
#A Epicentre
##
InstallMethod(Epicentre, "for pcp groups", [IsPcpGroup],
function (G)
	local epi;
	epi := SchurExtensionEpimorphism(G);
	return Image(epi,Centre(Source(epi)));
end);
