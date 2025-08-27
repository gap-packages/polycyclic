#############################################################################
##
#W  orbstab.gi                   Polycyc                         Bettina Eick
##
##  The orbit-stabilizer algorithm for elements of Z^d.
##

#############################################################################
##
#F CheckStabilizer( G, S, mats, v )
##
BindGlobal( "CheckStabilizer", function( G, S, mats, v )
    local actS, m, R;

    # first check that S is stabilizing
    actS := InducedByPcp( Pcp(G), Pcp(S), mats );
    for m in actS do if v*m <> v then return false; fi; od;

    # now consider the random stabilizer
    R := RandomPcpOrbitStabilizer( v, Pcp(G), mats, OnRight );
    if ForAny( R.stab, x -> not x in S ) then return false; fi;

    return true;
end );

#############################################################################
##
#F CheckOrbit( G, g, mats, e, f )
##
BindGlobal( "CheckOrbit", function( G, g, mats, e, f )
    return e * InducedByPcp( Pcp(G), g, mats ) = f;
end );

#############################################################################
##
#F OrbitStabilizerTranslationAction( K, derK ) . . . . . for transl. subgroup
##
BindGlobal( "OrbitStabilizerTranslationAction", function( K, derK )
    local base, gens, orbit, trans, stabl;

    # the first case is that image is trivial
    if ForAll( derK, x -> x = 0*x ) then
        return rec( stabl := K, trans := [], orbit := [] );
    fi;

    # now compute orbit in standart form
    gens := AsList( Pcp(K) );
    base := FreeGensAndKernel( derK );
    if Length( base.kern ) > 0 then
        base.kern := NormalFormIntMat( base.kern, 2 ).normal;
    fi;

    # set up result
    orbit := base.free;
    trans := List( base.trsf, x -> MappedVector( x, gens ) );
    stabl := List( base.kern, x -> MappedVector( x, gens ) );

    return rec( stabl := stabl, trans := trans, orbit := orbit );
end );

#############################################################################
##
#F InducedDerivation( g, G, linG, derG ) . . . . . . . . . value of derG on g
##
BindGlobal( "InducedDerivation", function( g, G, linG, derG )
    local pcp, exp, der, i, e, j, inv;
    pcp := Pcp( G );
    exp := ExponentsByPcp( pcp, g );
    der := 0 * derG[1];
    for i in [1..Length(exp)] do
        e := exp[i];
        if linG[i] = linG[i]^0 then
            der := der + e*derG[i];
        elif e > 0 then
            for j in [1..e] do
                der := der * linG[i] + derG[i];
            od;
        elif e < 0 then
            inv := linG[i]^-1;
            for j in [1..-e] do
                der := (der - derG[i]) * inv;
            od;
        fi;
    od;
    return der;
end );

#############################################################################
##
#F StabilizerIrreducibleAction( G, K, linG, derG ) . . . . . . kernel of derG
##
BindGlobal( "StabilizerIrreducibleAction", function( G, K, linG, derG )
    local derK, stabK, OnAffMod, affG, e, h, H, gens, i, f, k;

    # catch the trivial case first
    if ForAll( derG, x -> x = 0 * x ) then return G; fi;

    # now we are in a non-trivial case - compute derivations of K
    derK := List( Pcp(K), x -> InducedDerivation( x, G, linG, derG ) );

    # compute orbit and stabilizer under K
    stabK := OrbitStabilizerTranslationAction( K, derK );
    Info( InfoIntStab, 3, "  translation orbit: ", stabK.orbit);

    # if derK = 0, then K is the kernel
    if Length( stabK.orbit ) = 0 then return K; fi;
    
    # define affine action
    OnAffMod := function( pt, aff )
        local im;
        im := pt * aff[1] + aff[2];
        return VectorModLattice( im, stabK.orbit );
    end;

    # use finite orbit stabilizer to determine block-stab
    affG := List( [1..Length(linG)], x -> [linG[x], derG[x]] );
    e := derG[1] * 0;
    h := PcpOrbitStabilizer( e, Pcp(G), affG, OnAffMod ).stab;
    H := SubgroupByIgs( G, h );
    Info( InfoIntStab, 3, "  finite orbit has length ", Index(G,H));

    # now we have to compute the complement
    gens := ShallowCopy( AsList( Pcp( H, K ) ) );
    for i in [1..Length( gens )] do
        f := InducedDerivation( gens[i], G, linG, derG );
        e := MemberBySemiEchelonBase( f, stabK.orbit );
        k := MappedVector( e, stabK.trans );
        gens[i] := gens[i] * k^-1;
    od;
    Info( InfoIntStab, 3, "  determined complement ");
    gens := AddIgsToIgs( gens, stabK.stabl );
    return SubgroupByIgs( G, gens );
end );

#############################################################################
##
#F OrbitIrreducibleActionTrivialKernel( G, K, linG, derG, v ) .  v^g in derG?
##
## returns an element g in G with v^g in derG and ker(derG) if g exists.
## returns false otherwise.
##
BindGlobal( "OrbitIrreducibleActionTrivialKernel", function( G, K, linG, derG, v )
    local I, d, lin, der, g, t, a, m;

    # set up
    I := linG[1]^0;
    d := Length(I);

    # compute basis of Q[G] and corresponding derivations
    lin := StructuralCopy(linG);
    der := StructuralCopy(derG);
    while RankMat(der) < d do
        g := Random(G);
        t := InducedDerivation( g, G, linG, derG );
        if t <> 0 * t and IsBool( SolutionMat( der, t ) ) then
            Add( der, t );
            Add( lin, InducedByPcp( Pcp(G), g, linG ) );
        fi;
    od;

    # find linear combination
    a := SolutionMat( der, v );
    if IsBool( a ) then Error("derivations do not span"); fi;

    # translate combination
    m := Sum(List( [1..Length(a)], x -> a[x] * (lin[x] - I))) + I;

    # check if a preimage of m is in g
    g := MemberByCongruenceMatrixAction( G, linG, m );

    # now return
    if IsBool( g ) then return false; fi;
    return rec( stab := K, prei := g );
end );

#############################################################################
##
#F OrbitIrreducibleAction( G, K, linG, derG, v ) . . . . . . . . v^g in derG?
##
## returns an element g in G with v^g in derG and ker(derG) if g exists.
## returns false otherwise.
##
BindGlobal( "OrbitIrreducibleAction", function( G, K, linG, derG, v )
    local derK, stabK, I, a, m, g, OnAffMod, affG, e, h, i, c, k, H, f, gens,
          found, w;

    # catch some trivial cases first
    if v = 0 * v then
        return rec( stab := StabilizerIrreducibleAction( G, K, linG, derG ),
                    prei := One(G) );
    fi;
    if ForAll( derG, x -> x = 0 * x ) then return false; fi;

    # now we are in a non-trivial case - compute derivations of K
    derK := List( Pcp(K), x -> InducedDerivation( x, G, linG, derG ) );

    # compute orbit and stabilizer under K
    stabK := OrbitStabilizerTranslationAction( K, derK );
    Info( InfoIntStab, 3, "  translation orbit: ", stabK.orbit);

    # if derK = 0, then K is the kernel and g is a linear combination
    if Length( stabK.orbit ) = 0 then
        return OrbitIrreducibleActionTrivialKernel( G, K, linG, derG, v );
    fi;
    
    # define affine action
    OnAffMod := function( pt, aff )
        local im;
        im := pt * aff[1] + aff[2];
        return VectorModLattice( im, stabK.orbit );
    end;

    # use finite orbit stabilizer to determine block-stab
    affG := List( [1..Length(linG)], x -> [linG[x], derG[x]] );
    e := derG[1] * 0;
    h := PcpOrbitStabilizer( e, Pcp(G), affG, OnAffMod );
    H := SubgroupByIgs( G, h.stab );

    # get preimage
    found := false; i := 0;
    while not found and i < Length( h.orbit ) do
        i := i + 1;
        c := PcpSolutionIntMat( stabK.orbit, v-h.orbit[i] );
        if not IsBool( c ) then
            g := TransversalElement( i, h, One(G) );
            w := InducedDerivation( g, G, linG, derG );
            c := PcpSolutionIntMat( stabK.orbit, v-w);
            k := MappedVector( c, stabK.trans );
            g := g * k;
            found := true;
        fi;
    od;
    if not found then return false; fi;

    # get stabilizer as complement
    gens := ShallowCopy( AsList( Pcp( H, K ) ) );
    for i in [1..Length( gens )] do
        f := InducedDerivation( gens[i], G, linG, derG );
        e := MemberBySemiEchelonBase( f, stabK.orbit );
        k := MappedVector( e, stabK.trans );
        gens[i] := gens[i] * k^-1;
    od;
    gens := AddToIgs( stabK.stabl, gens );
    return rec( stab := SubgroupByIgs( G, gens ), prei := g);
end );

#############################################################################
##
#F StabilizerCongruenceAction( G, mats, e, ser )
##
BindGlobal( "StabilizerCongruenceAction", function( G, mats, e, ser )
    local S, d, actS, derS, nath, K, T, actT, derT, full, subs, bas, tak,
          act, der, U, f, comp, i, inv;

    # catch the trivial case
    if ForAll( mats, x -> e * x = e ) then return G; fi;

    # set up
    S := G;

    # now use induction on this series
    for i in [1..Length(ser)-1] do
        d := Length( ser[i] ) - Length( ser[i+1] );
        Info( InfoIntStab, 2, "   consider layer ", i, " of dim ",d);

        # reset
        actS := InducedByPcp( Pcp(G), Pcp(S), mats );
        derS := List( actS, x -> e*x - e );

        # get layer
        nath := NaturalHomomorphismByLattices( ser[i], ser[i+1] );
        actS := List( actS, x -> InducedActionFactorByNHLB( x, nath ) );
        derS := List( derS, x -> ImageByNHLB( x, nath ) );

        # the current layer is a semisimple S-module -- get kernel
        Info( InfoIntStab, 2, "  computing kernel of linear action");
        K := KernelOfCongruenceMatrixAction( S, actS );

        # set up for iteration
        T := S; actT := actS; derT := derS;
        full := IdentityMat(d);
        subs := RefineSplitting( actT, [full]  );
        subs := List( subs, PurifyRationalBase );
        comp := [];
        
        # now loop over irreducible submodules and compute stab T
        while Length(subs)>0 do
            Info( InfoIntStab, 2, "  layer: ", List(subs,Length));

            bas := Concatenation(subs); Append(bas, comp); inv := bas^-1;
            tak := Remove(subs, 1); f := Length(tak); Append(comp, tak);

            act := List(actT, x -> bas*x*inv);
            act := List(act, x -> x{[1..f]}{[1..f]});
            der := List(derT, x -> x*inv);
            der := List(der, x -> x{[1..f]});
            
            # stabilize
            U := StabilizerIrreducibleAction( T, K, act, der );

            # reset
            if Index(T,U) > 1 then
                T := SubgroupByIgs( G, Cgs(U) );
                K := NormalIntersection( K, T );
                actT := InducedByPcp( Pcp(S), Pcp(T), actS );
                derT := List(Pcp(T),x->InducedDerivation(x, S, actS, derS));
                if Length(subs) > 0 then
                    subs := RefineSplitting( actT, subs );
                    subs := List( subs, PurifyRationalBase );
                fi;
            fi;

            # do a check
            if Length( Pcp( T ) ) = 0 then return T; fi;
        od;
        S := T;

    od;
    return S;
end );

#############################################################################
##
#F OrbitCongruenceAction := function( G, mats, e, f, ser )
##
## returns Stab_G(e) and g in G with e^g = f if g exists.
## returns false otherwise.
##
BindGlobal( "OrbitCongruenceAction", function( G, mats, e, f, ser )
    local S, d, actS, derS, nath, K, T, actT, derT, full, subs, bas, tak,
          act, der, U, j, comp, g, t, o, u, inv, i;

    # catch some trivial cases
    if e = f then
        return rec( stab := StabilizerCongruenceAction(G, mats, e, ser),
                    prei := One( G ) );
    fi;
    if RankMat( [e,f] ) = 1 or ForAll( mats, x -> e*x = e) then
        return false;
    fi;

    # set up
    S := G;
    g := One( G );

    # now use induction on this series
    for i in [1..Length(ser)-1] do
        d := Length( ser[i] ) - Length( ser[i+1] );
        Info( InfoIntStab, 2, "  consider layer ", i, " with dim ",d);

        # reset
        actS := InducedByPcp( Pcp(G), Pcp(S), mats );
        derS := List( actS, x -> e*x - e );

        # get layer
        nath := NaturalHomomorphismBySemiEchelonBases( ser[i], ser[i+1] );
        actS := List( actS, x -> InducedActionFactorByNHSEB( x, nath ) );
        derS := List( derS, x -> ImageByNHSEB( x, nath ) );

        # the current layer is a semisimple S-module -- get kernel
        Info( InfoIntStab, 2, "  computing kernel of linear action");
        K := KernelOfCongruenceMatrixAction( S, actS );

        # set up for iteration
        T := S; actT := actS; derT := derS;
        full := IdentityMat( Length(actS[1]) );
        subs := RefineSplitting( actT, [full] );
        subs := List(subs, PurifyRationalBase );
        comp := [];

        # now loop over irreducible submodules and compute stab T
        while Length( subs ) > 0 do
            Info( InfoIntStab, 2, "  layer: ", List(subs,Length));

            bas := Concatenation(subs); Append(bas, comp); inv := bas^-1;
            tak := Remove(subs, 1); j := Length(tak); Append(comp, tak);

            act := List(actT, x -> bas*x*inv);
            act := List(act, x -> x{[1..j]}{[1..j]});
            der := List(derT, x -> x*inv);
            der := List(der, x -> x{[1..j]});

            # set up element and do a check
            t := InducedByPcp(Pcp(G), g, mats)^-1;
            u := f*t-e;
            if Length(Pcp(T)) = 0 and u = 0*u then
                return rec( stab := T, prei := g );
            elif Length(Pcp(T)) = 0 then
                return false;
            fi;

            # induce to layer
            u := ImageByNHSEB( u, nath ) * inv;
            u := u{[1..j]};

            # find preimage h with u = h^der if it exists
            o := OrbitIrreducibleAction( T, K, act, der, u );
            if IsBool(o) then return false; fi;
            g := o.prei * g;
            U := o.stab;

            # reset
            if Index(T, U) > 1 then
                T := SubgroupByIgs(G, Cgs(U));
                K := NormalIntersection( K, T );
                actT := InducedByPcp( Pcp(S), Pcp(T), actS );
                derT := List(Pcp(T), x->InducedDerivation(x, S, actS, derS));
                if Length(subs) > 0 then
                    subs := RefineSplitting( actT, subs );
                    subs := List( subs, PurifyRationalBase );
                fi;
            fi;;
        od;
        S := T;
    od;
    return rec( stab := S, prei := g );
end );

#############################################################################
##
#F FindPosition( orbit, pt, K, actK, orbfun )
##
BindGlobal( "FindPosition", function( orbit, pt, K, actK, orbfun )
    local j, k;
    for j in [1..Length(orbit)] do
        k := orbfun( K, actK, pt, orbit[j] );
        if not IsBool( k ) then return j; fi;
    od;
    return false;
end );

#############################################################################
##
#F ExtendOrbitStabilizer( e, K, actK, S, actS, orbfun, op )
##
## K has finite index in S and and orbfun solves the orbit problem for K.
##
BindGlobal( "ExtendOrbitStabilizer", function( e, K, actK, S, actS, orbfun, op )
    local gens, rels, mats, orbit, trans, trels, stab, i, f, j, n, t, s, g;

    # get action
    gens := Pcp(S,K);
    rels := RelativeOrdersOfPcp( gens );
    mats := InducedByPcp( Pcp(S), gens, actS );

    # set up
    orbit := [e];
    trans := [];
    trels := [];
    stab  := [];

    # construct orbit and stabilizer
    for i in Reversed( [1..Length(gens)] ) do

        # get new point
        f := op( e, mats[i] );
        j := FindPosition( orbit, f, K, actK, orbfun );

        # if it is new, add all blocks
        n := orbit;
        t := [];
        s := 1;
        while IsBool( j ) do
            n := List( n, x -> op( x, mats[i] ) );
            Append( t, n );
            j := FindPosition( orbit, op( n[1], mats[i]), K, actK, orbfun );
            s := s + 1;
        od;

        # add to orbit
        Append( orbit, t );

        # add to transversal
        if s > 1 then
            Add( trans, gens[i]^-1 );
            Add( trels, s );
        fi;

        # compute stabiliser element
        if rels[i] = 0 or s < rels[i] then
            g := gens[i]^s;
            if j > 1 then
                t := TransversalInverse(j, trels);
                g := g * SubsWord( t, trans );
            fi;
            f := op( e, InducedByPcp( Pcp(S), g, actS ) );
            g := g * orbfun( K, actK, f, e );
            Add( stab, g );
        fi;
    od;
    return rec( stab := Reversed( stab ), orbit := orbit,
                trels := trels, trans := trans );
end );

#############################################################################
##
#F StabilizerModPrime( G, mats, e, p )
##
BindGlobal( "StabilizerModPrime", function( G, mats, e, p )
    local F, t, S;
    F := GF(p);
    t := InducedByField( mats, F );
    S := PcpOrbitStabilizer( e*One(F), Pcp(G), t, OnRight );
    return SubgroupByIgs( G, S.stab );
end );

#############################################################################
##
#F StabilizerIntegralAction( G, mats, e ) . . . . . . . . . . . . . Stab_G(e)
##
BindGlobal( "StabilizerIntegralAction", function( G, mats, e )
    local p, S, actS, K, actK, T, stab, ser, orbf;
    
    # reduce e
    e := e / Gcd( e );

    # catch the trivial case
    if ForAll( mats, x -> e*x = e ) then return G; fi;

    # compute modulo 3 first
    S := G;
    actS := mats;
    for p in USED_PRIMES@ do
        Info( InfoIntStab, 1, "reducing by stabilizer mod ",p);
        T := StabilizerModPrime( S, actS, e, p );
        Info( InfoIntStab, 1, "  obtained reduction by ",Index(S,T));
        S := T;
        actS := InducedByPcp( Pcp(G), Pcp(S), mats );
    od;

    # use congruence kernel
    Info( InfoIntStab, 1, "determining 3-congruence subgroup");
    K := KernelOfFiniteMatrixAction( S, actS, GF(3) );
    actK := InducedByPcp( Pcp(G), Pcp(K), mats );
    Info( InfoIntStab, 1, "  obtained subgroup of index ",Index(S,K));

    # compute homogeneous series
    Info( InfoIntStab, 1, "computing module series");
    ser := HomogeneousSeriesOfRationalModule( mats, actK, Length(e) );
    ser := List( ser, x -> PurifyRationalBase(x) );

    # get Stab_K(e)
    Info( InfoIntStab, 1, "adding stabilizer for congruence subgroup");
    T := StabilizerCongruenceAction( K, actK, e, ser );

    # set up orbit stabilizer function for K
    orbf := function( K, actK, a, b )
            local o;
            o := OrbitCongruenceAction( K, actK, a, b, ser );
            if IsBool(o) then return o; fi;
            return o.prei;
            end;

    # compute block stabilizer
    Info( InfoIntStab, 1, "constructing block orbit-stabilizer");
    stab := ExtendOrbitStabilizer( e, K, actK, S, actS, orbf, OnRight );
    Info( InfoIntStab, 1, "  obtained ",Length(stab.orbit)," blocks");
    stab := AddIgsToIgs( stab.stab, Igs(T) );
    stab := SubgroupByIgs( G, stab );

    # do a temporary check
    if CHECK_INTSTAB@ then
        Info( InfoIntStab, 1, "checking results");
        if not CheckStabilizer(G, stab, mats, e) then
            Error("wrong stab in integral action");
        fi;
    fi;

    # now return
    return stab;
end );

#############################################################################
##
#F OrbitIntegralAction( G, mats, e, f ) . . . . . . . . . . . . . . .e^g = f?
##
## returns Stab_G(e) and g in G with e^g = f if g exists.
## returns false otherwise.
##
BindGlobal( "OrbitIntegralAction", function( G, mats, e, f )
    local c, F, t, os, j, g, S, actS, K, actK, ser, orbf, h, T, l;

    # reduce e and f
    c := Gcd(e); e := e/c; f := f/c;
    if not ForAll( f, IsInt ) or AbsInt(Gcd(f)) <> 1 then return false; fi;

    # catch some trivial cases
    if e = f then
        return rec( stab := StabilizerIntegralAction(G, mats, e),
                    prei := One( G ) );
    fi;

    # This is a temporary fix, see bugfix.tst
    # if RankMat( [e,f] ) = 1 or ForAll( mats, x -> e*x = e) then
    #     return false;
    # fi;

    # compute modulo 3 first
    Info( InfoIntStab, 1, "reducing by orbit-stabilizer mod 3");
    F := GF(3);
    t := InducedByField( mats, F );
    os := PcpOrbitStabilizer( e*One(F), Pcp(G), t, OnRight );
    j := Position( os.orbit, f*One(F) );
    if IsBool(j) then return false; fi;

    # extract infos
    g := TransversalElement( j, os, One(G) );
    l := f * InducedByPcp( Pcp(G), g, mats )^-1;
    S := SubgroupByIgs( G, os.stab );
    actS := InducedByPcp( Pcp(G), Pcp(S), mats );

    # use congruence kernel
    Info( InfoIntStab, 1, "determining 3-congruence subgroup");
    K := KernelOfFiniteMatrixAction( S, actS, F );
    actK := InducedByPcp( Pcp(G), Pcp(K), mats );

    # compute homogeneous series
    Info( InfoIntStab, 1, "computing module series");
    ser := HomogeneousSeriesOfRationalModule( mats, actK, Length(e) );
    ser := List( ser, x -> PurifyRationalBase(x) );

    # set up orbit stabilizer function for K
    orbf := function( K, actK, a, b )
            local o;
            o := OrbitCongruenceAction( K, actK, a, b, ser );
            if IsBool(o) then return o; fi;
            return o.prei;
            end;

    # determine block orbit and stabilizer
    Info( InfoIntStab, 1, "constructing block orbit-stabilizer");
    os := ExtendOrbitStabilizer( e, K, actK, S, actS, orbf, OnRight );

    # get orbit element and preimage
    j := FindPosition( os.orbit, l, K, actK, orbf );
    if IsBool(j) then return false; fi;
    h := TransversalElement( j, os, One(G) );
    l := l * InducedByPcp( Pcp(S), h, actS )^-1;
    g := orbf( K, actK, e, l ) * h * g;

    # get Stab_K(e) and thus Stab_G(e)
    Info( InfoIntStab, 1, "adding stabilizer for congruence subgroup");
    T := StabilizerCongruenceAction( K, actK, e, ser );
    t := AddIgsToIgs( os.stab, Igs(T) );
    T := SubgroupByIgs( T, t );

    # do a temporary check
    if CHECK_INTSTAB@ then
        Info( InfoIntStab, 1, "checking results");
        if not CheckStabilizer(G, T, mats, e) then
            Error("wrong stab in integral action");
        elif not CheckOrbit(G, g, mats, e, f) then
            Error("wrong orbit in integral action");
        fi;
    fi;

    # now return
    return rec( stab := T, prei := g );
end );

