#############################################################################
##
#F AddSystem( sys, t1, t2)
##
AddSystem := function( sys, t1, t2 )
    if t1 = t2 then return; fi;
    t1 := t1 - t2;
    if not t1 in sys.base then Add(sys.base, t1); fi;
end;

#############################################################################
##
#F EvalConsistency( coll, sys )
##
InstallGlobalFunction( EvalConsistency, function( coll, sys )
    local y, x, e, z, gn, gi, ps, a, w1, w2, i, j, k;

    # set up
    y := sys.len;
    x := NumberOfGenerators(coll)-y;
    e := RelativeOrders(coll);

    # set up zero
    z := List([1..x+y], x -> 0);

    # set up generators and inverses
    gn := []; gi := [];
    for i in [1..x] do
        a := ShallowCopy(z); a[i] := 1; gn[i] := a;
        a := ShallowCopy(z); a[i] := -1; gi[i] := a;
    od;

    # precompute pairs (i^e[i]) and (ij) and (i -j) for i > j
    ps := List( [1..x], x -> [] );
    for i in [1..x]  do
        if e[i] > 0 then
            a := ShallowCopy(z); a[i] := e[i]-1;
            CollectWordOrFail( coll, a, [i,1] );
            ps[i][i] := a;
        fi;
        for j  in [1..i-1]  do
            a := ShallowCopy(gn[i]);
            CollectWordOrFail( coll, a, [j,1] );
            ps[i][j] := a;

            a := ShallowCopy(gn[i]);
            CollectWordOrFail( coll, a, [j,-1] );
            ps[i][i+j] := a;
        od;
    od;

    # consistency 1:  k(ji) = (kj)i
    for i  in [ x, x-1 .. 1 ]  do
        for j  in [ x, x-1 .. i+1 ]  do
            for k  in [ x, x-1 .. j+1 ]  do

                # collect
                w1 := ShallowCopy(gn[k]);
                CollectWordOrFail(coll, w1, ObjByExponents(coll,ps[j][i]));
                w2 := ShallowCopy(ps[k][j]);
                CollectWordOrFail(coll, w2, [i,1]);

                # check and add
                if w1{[1..x]} <> w2{[1..x]} then
                    Error( "k(ji) <> (kj)i" );
                else
                    AddSystem( sys, w1{[x+1..x+y]}, w2{[x+1..x+y]} );
                fi;
            od;
        od;
    od;

    # consistency 2: j^(p-1) (ji) = j^p i
    for i  in [x,x-1..1]  do
        for j  in [x,x-1..i+1]  do
            if e[j] > 0 then

                # collect
                w1 := ShallowCopy(z); w1[j] := e[j]-1;
                CollectWordOrFail(coll, w1, ObjByExponents(coll, ps[j][i]));
                w2 := ShallowCopy(ps[j][j]);
                CollectWordOrFail(coll, w2, [i,1]);

                # check and add
                if w1{[1..x]} <> w2{[1..x]} then
                    Error( "j^(p-1) (ji) <> j^p i" );
                else
                    AddSystem( sys, w1{[x+1..x+y]}, w2{[x+1..x+y]} );
                fi;
            fi;
        od;
    od;

    # consistency 3: k (i^p) = (ki) i^p-1
    for i  in [x,x-1..1]  do
        if e[i] > 0 then
            for k  in [x,x-1..i+1]  do

                # collect
                w1 := ShallowCopy(gn[k]);
                CollectWordOrFail(coll, w1, ObjByExponents(coll, ps[i][i]));
                w2 := ShallowCopy(ps[k][i]);
                CollectWordOrFail(coll, w2, [i,e[i]-1]);

                # check and add
                if w1{[1..x]} <> w2{[1..x]} then
                    Error( "k i^p <> (ki) i^(p-1)" );
                else
                    AddSystem( sys, w1{[x+1..x+y]}, w2{[x+1..x+y]} );
                fi;
            od;
        fi;
    od;

    # consistency 4: (i^p) i = i (i^p)
    for i  in [ x, x-1 .. 1 ]  do
        if e[i] > 0 then

            # collect
            w1 := ShallowCopy(ps[i][i]);
            CollectWordOrFail(coll, w1, [i,1]);
            w2 := ShallowCopy(gn[i]);
            CollectWordOrFail(coll, w2, ObjByExponents(coll,ps[i][i]));

            # check and add
            if w1{[1..x]} <> w2{[1..x]} then
                Error( "i i^p-1 <> i^p" );
            else
                AddSystem( sys, w1{[x+1..x+y]}, w2{[x+1..x+y]} );
            fi;
         fi;
    od;

    # consistency 5: j = (j -i) i
    for i  in [x,x-1..1]  do
        for j  in [x,x-1..i+1]  do
            if e[i] = 0 then

                # collect
                w1 := ShallowCopy(ps[j][i+j]);
                CollectWordOrFail( coll, w1, [i,1] );

                # check and add
                if w1{[1..x]} <> gn[j]{[1..x]} then
                    Error( "j <> (j -i) i" );
                else
                    AddSystem( sys, w1{[x+1..x+y]}, 0*w1{[x+1..x+y]} );
                fi;
            fi;
        od;
    od;

    # consistency 6: i = -j (j i)
    for i  in [x,x-1..1]  do
        for j  in [x,x-1..i+1]  do
            if e[j] = 0 then

                # collect
                w1 := ShallowCopy(gi[j]);
                CollectWordOrFail( coll, w1, ObjByExponents(coll, ps[j][i]));

                # check and add
                if w1{[1..x]} <> gn[i]{[1..x]} then
                    Error( "i <> -j (j i)" );
                else
                    AddSystem( sys, w1{[x+1..x+y]}, 0*w1{[x+1..x+y]} );
                fi;
            fi;
        od;
    od;

    # consistency 7: -i = -j (j -i)
    for i  in [x,x-1..1]  do
        for j  in [x,x-1..i+1]  do
            if e[i] = 0 and e[j] = 0 then

                # collect
                w1 := ShallowCopy(gi[j]);
                CollectWordOrFail( coll, w1, ObjByExponents(coll, ps[j][i+j]));

                # check and add
                if w1{[1..x]} <> gi[i]{[1..x]} then
                    Error( "-i <> -j (j -i)" );
                else
                    AddSystem( sys, w1{[x+1..x+y]}, 0*w1{[x+1..x+y]} );
                fi;
            fi;
        od;
    od;

    return sys;
end );

#############################################################################
##
#F EvalMueRelations( coll, sys, n )
##
EvalMueRelations := function( coll, sys, n )
    local y, x, z, g, h, cm, cj1, cj2, ci1, ci2, i, j, k, w, v;

    # set up
    y := sys.len;
    x := NumberOfGenerators(coll)-y;
    z := List([1..x+y], i -> 0);

    # gens and inverses
    g := List([1..2*n], i -> [i,1]);
    h := List([1..2*n], i -> FromTheLeftCollector_Inverse(coll,[i,1]));

    # precompute commutators
    cm := List([1..n], i -> []);
    for i in [1..n] do
        for j in [1..n] do
            w := ShallowCopy(z); w[i] := 1; w[n+j] := 1;
            CollectWordOrFail(coll, w, h[i]);
            CollectWordOrFail(coll, w, h[n+j]);
            cm[i][j] := ObjByExponents(coll, w);
        od;
    od;

    # precompute conjugates and inverses
    cj1 := List([1..n], i -> []);
    ci1 := List([1..n], i -> []);
    cj2 := List([1..n], i -> []);
    ci2 := List([1..n], i -> []);
    for i in [1..n] do
        for j in [1..n] do

            # IActs( j, i )
            if i = j then
                cj1[j][i] := ShallowCopy(g[i]);
                ci1[j][i] := ShallowCopy(h[i]);
            else
                w := ShallowCopy(z); w[i] := 1;
                CollectWordOrFail(coll, w, g[j]);
                CollectWordOrFail(coll, w, h[i]);
                cj1[j][i] := ObjByExponents(coll, w);
                ci1[j][i] := FromTheLeftCollector_Inverse(coll,cj1[j][i]);
            fi;

            # IActs( n+j, n+i )
            if i = j then
                cj2[j][i] := ShallowCopy(g[n+i]);
                ci2[j][i] := ShallowCopy(h[n+i]);
            else
                w := ShallowCopy(z); w[n+i] := 1;
                CollectWordOrFail(coll, w, g[n+j]);
                CollectWordOrFail(coll, w, h[n+i]);
                cj2[j][i] := ObjByExponents(coll, w);
                ci2[j][i] := FromTheLeftCollector_Inverse(coll,cj2[j][i]);
            fi;
        od;
    od;

    # loop over relators
    for i in [1..n] do
        for j in [1..n] do
            for k in [1..n] do

                # the right hand side
                v := ShallowCopy(z);
                CollectWordOrFail(coll, v, cj1[i][k]);
                CollectWordOrFail(coll, v, cj2[j][k]);
                CollectWordOrFail(coll, v, ci1[i][k]);
                CollectWordOrFail(coll, v, ci2[j][k]);

                # first left hand side
                w := ShallowCopy(z); w[k] := 1;
                CollectWordOrFail(coll, w, cm[i][j]);
                CollectWordOrFail(coll, w, h[k]);

                if w{[1..x]} <> v{[1..x]} then
                    Error("no epimorphism");
                else
                    AddSystem( sys, w{[x+1..x+y]}, v{[x+1..x+y]});
                fi;

                # second left hand side
                w := ShallowCopy(z); w[n+k] := 1;
                CollectWordOrFail(coll, w, cm[i][j]);
                CollectWordOrFail(coll, w, h[n+k]);

                if w{[1..x]} <> v{[1..x]} then
                    Error("no epimorphism");
                else
                    AddSystem( sys, w{[x+1..x+y]}, v{[x+1..x+y]});
                fi;
            od;
        od;
    od;
end;


#############################################################################
##
#F CollectorCentralCover(S)
##
CollectorCentralCover:= function(S)
    local s, x, r, y, coll, k, i, j, e, n;

    # get info on G
    n := Length(Igs(S!.group));

    # get info
    s := Pcp(S);
    x := Length(s);
    r := RelativeOrdersOfPcp(s);

    # the size of the extension module
    y := x*(x-1)/2    # one new generator for each conjugate relation,
                      # for each power relation,
         + Number( r{[2*n+1..Length(r)]}, i -> i > 0 )
         - n*(n-1);   # but not for the two copies of relations of the
                      # original group.

#    Print( "#  CollectorCentralCover: Setting up collector with ", x+y,
#           " generators\n" );

    # set up
    coll := FromTheLeftCollector(x+y);

    # add relations of S
    k := x;
    for i in [1..x] do
        SetRelativeOrder(coll, i, r[i]);

        if r[i] > 0 then
            e := ObjByExponents(coll, ExponentsByPcp(s, s[i]^r[i]));
            if i > 2*n then k := k+1; Append(e, [k,1]); fi;
            SetPower(coll,i,e);
        fi;

        for j in [1..i-1] do
            e := ObjByExponents(coll, ExponentsByPcp(s, s[i]^s[j]));
            if (i>n) and (i>2*n or not (j in [n+1..2*n])) then
                k := k+1; Append(e, [k,1]);
            fi;
            SetConjugate(coll,i,j,e);
        od;
    od;

    # update and return
    UpdatePolycyclicCollector(coll);
    return coll;
end;

#############################################################################
##
#F QuotientBySystem( coll, sys, n )
##
InstallGlobalFunction( QuotientBySystem, function(coll, sys, n)
    local y, x, e, z, M, D, P, Q, d, f, l, c, i, k, j, a, b;

    # set up
    y := sys.len;
    x := NumberOfGenerators(coll)-y;
    e := RelativeOrders(coll);
    z := List([1..x], i->0);

    # set up module
    M := sys.base;
    if Length(M) = 0 then M := NullMat(sys.len, sys.len); fi;
    if Length(M) < Length(M[1]) then
         for i in [1..Length(M[1])-Length(M)] do Add(M, 0*M[1]); od;
    fi;

#    Print( "#  QuotientBySystem: Dealing with ",
#           Length(M), "x", Length(M[1]), "-matrix\n" );

    if M = 0*M or USE_NFMI@ then
        D := NormalFormIntMat(M,13);
        Q := D.coltrans;
        D := D.normal;
        d := DiagonalOfMat( D );
    else
        D := NormalFormConsistencyRelations(M);
        Q := D.coltrans;
        D := D.normal;
        d := [1..Length(M[1])] * 0;
        d{List( D, r->PositionNot( r, 0 ) )} :=
          List( D, r->First( r, e->e<>0 ) );
    fi;

    # filter info
    f := Filtered([1..Length(d)], x -> d[x] <> 1);
    l := Length(f);

    # inialize new collector for extension
#    Print( "#  QuotientBySystem: Setting up collector with ", x+l,
#           " generators\n" );
    c := FromTheLeftCollector(x+l);

    # add relative orders of module
    for i in [1..l] do
        SetRelativeOrder(c, x+i, d[f[i]]);
    od;

    # add relations of factor
    k := 0;
    for i in [1..x] do
        SetRelativeOrder(c, i, e[i]);

        if e[i]>0 then
            a := GetPower(coll, i);
            a := ReduceTail( a, x, Q, d, f );
            SetPower(c, i, a );
        fi;

        for j in [1..i-1] do
            a := GetConjugate(coll, i, j);
            a := ReduceTail( a, x, Q, d, f );
            SetConjugate(c, i, j, a );

            if e[j] = 0 then
                a := GetConjugate(coll, i, -j);
                a := ReduceTail( a, x, Q, d, f );
                SetConjugate(c, i, -j, a );
            fi;

        od;
    od;

    if CHECK_SCHUR_PCP@ then
        return PcpGroupByCollector(c);
    else
        UpdatePolycyclicCollector(c);
        return PcpGroupByCollectorNC(c);
    fi;
end );

#############################################################################
##
#F NonAbelianTensorSquarePlus(G) . . . . . . . .  (G otimes G) by (G times G)
##
## This is the group nu(G) in our paper.  The following function computes the
## epimorphisms of nu(G) onto tau(G).
##
# FIXME: This function is documented and should be turned into an attribute
NonAbelianTensorSquarePlusEpimorphism := function(G)
    local   n,  embed,  S,  coll,  y,  sys,  T,  lift;

    if Size(G) = 1 then return IdentityMapping( G ); fi;

    # some info
    n := Length(Igs(G));

    # set up quotient
    embed := NonAbelianExteriorSquarePlusEmbedding(G);
    S := Range( embed );
    S!.embedding := embed;

    # set up covering group
    coll := CollectorCentralCover(S);

    # extract module
    y := NumberOfGenerators(coll) - Length(Igs(S));

    # set up system
    sys := CRSystem(1, y, 0);

    # evaluate
    EvalConsistency( coll, sys );
    EvalMueRelations( coll, sys, n );

    # get group defined by resulting system
    T := QuotientBySystem( coll, sys, n );

    # enforce epimorphism
    T := Subgroup(T, Igs(T){[1..2*n]});

    # construct homomorphism from nu(G) to tau(G)
    lift := GroupHomomorphismByImagesNC( T,S,
                    Igs(T){[1..2*n]},Igs(S){[1..2*n]} );
    SetIsSurjective( lift, true );

    return lift;
end;

# FIXME: This function is documented and should be turned into an attribute
NonAbelianTensorSquarePlus := function( G )
    return Source( NonAbelianTensorSquarePlusEpimorphism( G ) );
end;


#############################################################################
##
#F NonAbelianTensorSquare(G). . . . . . . . . . . . . . . . . . .(G otimes G)
##
# FIXME: This function is documented and should be turned into an attribute
NonAbelianTensorSquareEpimorphism := function( G )
    local   n,  epi,  T,  U,  t,  r,  c,  i,  j,  GoG,  gens,  embed,
            imgs,  alpha;

    if Size(G) = 1 then return IdentityMapping(G); fi;

    # set up
    n := Length(Pcp(G));

    # tensor square plus
    epi := NonAbelianTensorSquarePlusEpimorphism(G);

    T := Source( epi );
    U := Parent(T);
    t := Pcp(U);
    r := RelativeOrdersOfPcp(t);

    # get relevant subgroup using commutators
    c := [];
    for i in [1..n] do
        for j in [1..n] do
            Add(c, Comm(t[i], t[n+j]));
            if r[i]=0 then Add(c, Comm(t[i]^-1, t[n+j])); fi;
            if r[j]=0 then Add(c, Comm(t[i], t[n+j]^-1)); fi;
            if r[i]=0 and r[j]=0 then Add(c, Comm(t[i]^-1, t[n+j]^-1)); fi;
        od;
    od;

    ## construct homomorphism G otimes G --> G^G
    ## we don't just want G^G as a subgroup of tau(G) but we want to go back
    ## to G^G as constructed by NonAbelianExteriorSquarePlus.  (G^G)+ has the
    ## component .embedding which embeds G^G into (G^G)+
    GoG := Subgroup(U, c);
    gens := GeneratorsOfGroup( GoG );
    embed := Image( epi )!.embedding;
    imgs := List( gens, g->PreImagesRepresentative( embed, Image( epi, g ) ) );

    alpha := GroupHomomorphismByImagesNC( GoG, Source( embed ), gens, imgs );
    SetIsSurjective( alpha, true );

    return alpha;
end;

InstallMethod( NonAbelianTensorSquare, [IsPcpGroup], function(G)
    return Source( NonAbelianTensorSquareEpimorphism( G ) );
end );

#############################################################################
##
#F WhiteheadQuadraticFunctor(G) . . . . . . . . . . . . . . . . .  (Gamma(G))
##
# FIXME: This function is documented and should be turned into an attribute
WhiteheadQuadraticFunctor := function(G)
    local invs, news, i;
    invs := AbelianInvariants(G);
    news := [];
    for i in [1..Length(invs)] do
        if IsInt(invs[i]/2) then
            Add(news, 2*invs[i]);
        else
            Add(news, invs[i]);
        fi;
        Append(news, List([1..i-1], x -> Gcd(invs[i], invs[x])));
    od;
    return AbelianPcpGroup(Length(news), news);
end;
