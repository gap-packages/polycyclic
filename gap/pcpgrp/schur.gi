
if not IsBound( USE_NFMI ) then
    USE_NFMI := false;
fi;

if not IsBound( CHECKPCP ) then
    CHECKPCP := false;
fi;


#############################################################################
##
#A SchurMultiplicator(G) . . . . . . . . . . . . . . . . . . . . . . . . M(G)
##
InstallMethod( SchurMultiplicator, true, [IsPcpGroup], 0,
function(G)
    local C, c, d, f, l, D, e, m;

    if Size(G) = 1 or IsCyclic(G) then return []; fi;
    
    # cohomology record for trivial module
    C := CRRecordByMats(G, List(Igs(G), x -> IdentityMat(1)));

    # cohomology system
    c := IntTwoCocycleSystemCR(C); 
    m := TransposedMat(c.base);

    # Elementary divisors = Invariants of R/[R,F]
    d := DiagonalOfMat( NormalFormIntMat(m, 1).normal ){[1..Length(m)]};

    # the torsion part
    f := Collected( Filtered( d, x -> x > 1 ) );

    # get hirsch length of G/G'
    if IsFinite(G) then 
        e := 0;
    else
        D := DerivedSubgroup(G);
        e := Length(Filtered( RelativeOrdersOfPcp(Pcp(G,D)), x -> x=0));
    fi;

    # subtract F'R/F' = R/(R cap F') from the torsion-free part
    l := Length( Filtered( d, x -> x = 0 ) ) - Length(Igs(G)) + e; 

    # this is it
    if l > 0 then Add( f, [0,l]); fi;
    return f;
end);


#############################################################################
##
#A ReduceVector 
##
ReduceVector := function( v, d, f )
    local i;
    for i in [1..Length(v)] do
        if d[i] > 1 then v[i] := v[i] mod d[i]; fi;
    od;
    return v{f};
end;

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
#A SchurExtension(G) . . . . . . . . . . . . . . . . . . . . . . . . .F/[R,F]
##
SchurExtension := function(G)
    local g, r, n, C, c, M, D, P, Q, d, f, l, I, coll, i, j, e, a, b,
          ocoll;

    # set up
    g := Igs(G);
    r := List(g, x -> RelativeOrderPcp(x));
    n := Length(Igs(G));

    # cohomology record and system
    C := CRRecordByMats(G, List(g, x -> IdentityMat(1)));
    c := IntTwoCocycleSystemCR(C); 
    M := c.base;

    # check
    if c.len = 0 then return G; fi;
    if Length(M) = 0 then M := NullMat(c.len, c.len); fi;
    if Length(M) < Length(M[1]) then 
         for i in [1..Length(M[1])-Length(M)] do
             Add(M, 0*M[1]);
         od;
    fi;

    Print( "#  SchurExtension: Dealing with ", 
           Length(M), "x", Length(M[1]), 
           "-matrix from cohomology calculation\n" );

    # set up
    if USE_NFMI then
        D := NormalFormIntMat(M,13);
        Q := D.coltrans;
        D := D.normal;
        # filter info
        d := DiagonalOfMat( D );
    else
        D := NormalFormConsistencyRelations(M);
        Q := D.coltrans;
        D := D.normal;
        d := [1..Length(M[1])] * 0;
        d{List( D, r->PositionNot( r, 0 ) )} := 
          List( D, r->First( r, e->e<>0 ) ); 
    fi;    

    f := Filtered([1..Length(d)], x -> d[x] <> 1);
    l := Length(f);

    Print( "#  SchurExtension: Setting up collector with ", n+l, 
           " generators\n" );

    # initialize collector
    coll := FromTheLeftCollector(n+l);

    # relative orders
    for i in [1..n] do
        SetRelativeOrder(coll, i, r[i]);
    od;
    for i in [1..l] do
        SetRelativeOrder(coll, n+i, d[f[i]]);
    od;
    
    # relations of G
    ocoll := Collector( G );
    for i in [1..Length(C.enumrels)] do
        e := C.enumrels[i];
        b := ReduceVector(Q[i], d, f);
        if e[1] = e[2] then
            a := ExponentsByObj( ocoll, GetPower( ocoll, e[1] ) );
            SetPower(coll, e[1], ObjByExponents(coll, Concatenation(a,b)));
        elif e[1] > e[2] then
            a := ExponentsByObj( ocoll, GetConjugate( ocoll, e[1], e[2] ) );
            SetConjugate(coll, e[1], e[2], 
                     ObjByExponents(coll, Concatenation(a,b)));
        elif e[1] < e[2] then
            a := ExponentsByObj( ocoll, 
                         GetConjugate( ocoll, e[1], -(e[2]-e[1]) ) );
            SetConjugate(coll, e[1], -(e[2]-e[1]), 
                     ObjByExponents(coll, Concatenation(a,b)));
        fi;
    od;

    UpdatePolycyclicCollector( coll );
    return PcpGroupByCollectorNC(coll);
end;

#############################################################################
##
#A SchurCovering(G) . . . . . . . . . . . . . . . . . . . .M(G) extended by G
##
SchurCovering := function(G)
    local g, H, h, m, M, I, C;

    # set up
    g := Igs(G);

    # get full extension F/[R,F]
    H := SchurExtension(G);
    h := Igs(H);

    # get R/[R,F]
    m := h{[Length(g)+1..Length(h)]};
    M := SubgroupByIgs(H, m);

    # get R cap F'
    I := Intersection(M, DerivedSubgroup(H));

    # get complement
    C := Subgroup(H, GeneratorsOfPcp( Pcp(M,I,"snf")));

    if not IsFreeAbelian(C) 
#       or HirschLength(I)+HirschLength(C)+HirschLength(G) <> HirschLength(H)
       then Error("wrong complement"); fi;

    # get complement to I in M
    return H/C;
end;
    
#############################################################################
##
#A ExteriorSquare(G) . . . . . . . . . . . . . . . . . . . . . . .(G wegde G)
##
ExteriorSquare := function(G)
    local H, D;
    H := SchurExtension(G);
    D := DerivedSubgroup(H);
    return PcpGroupByPcp(Pcp(D));
end;
    
#############################################################################
##
#A ExteriorSquarePlus(G) . . . . . . . . . . . . . (G wegde G) by (G times G)
##
## This is the group tau(G) in our paper.
##
ExteriorSquarePlus := function(G)
    local g, n, r, w, F, f, D, d, m, s, c, i, j, k, e, alpha, gens, imgs, S;

    # set up
    g := Pcp(G);
    n := Length(g);
    r := RelativeOrdersOfPcp(g);
    w := List([1..2*n], x -> 0);

    # F/[R,F]
    F := SchurExtension(G);
    f := Pcp(F);

    # the exterior square D
    D := DerivedSubgroup(F);
    d := Pcp(D);
    m := Length(d);
    s := RelativeOrdersOfPcp(d);

    Print( "#  ExteriorSquarePlus: Setting up collector with ", 2*n+m, 
           " generators\n" );

    # set up collector for exterior square plus
    c := FromTheLeftCollector(2*n+m);

    # the relators of GxG
    for i in [1..n] do

        # relative order and power
        if r[i] > 0 then 
            SetRelativeOrder(c, i, r[i]);
            e := ExponentsByPcp(g, g[i]^r[i]);
            SetPower(c, i, ObjByExponents(c,e));

            SetRelativeOrder(c, n+i, r[i]);
            e := Concatenation(0*e, e);
            SetPower(c, n+i, ObjByExponents(c,e));
        fi;

        # conjugates
        for j in [1..i-1] do
            e := ExponentsByPcp(g, g[i]^g[j]);
            SetConjugate(c, i, j, ObjByExponents(c,e));

            e := Concatenation(0*e, e);
            SetConjugate(c, n+i, n+j, ObjByExponents(c,e));

            if r[j] = 0 then
                e := ExponentsByPcp(g, g[i]^(g[j]^-1));
                SetConjugate(c, i, -j, ObjByExponents(c,e));
                e := Concatenation(0*e, e);
                SetConjugate(c, n+i, -(n+j), ObjByExponents(c,e));
            fi;

        od;
    od;

    # the relators of D
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

    # the extension of D by GxG 
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

    # the action on D by GxG 
    for i in [1..n] do

        # create action homomorphism
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

    if CHECKPCP then
        S := PcpGroupByCollector(c);
    else
        UpdatePolycyclicCollector(c);
        S := PcpGroupByCollectorNC(c);
    fi;
    S!.group := G;
    return S;
end;


