############################################################################
##
#W  normcon.gi                  Polycyc                         Bettina Eick
##
##  Computing normalizers of subgroups.
##  Solving the conjugacy problem for subgroups.
##

#############################################################################
##
#F AffineActionOnH1( CR, cc )
##
BindGlobal( "AffineActionOnH1", function( CR, cc )
    local aff, l, i, lin, trl, j;
    aff := OperationOnH1( CR, cc );
    l   := Length( cc.factor.rels );
    for i in [1..Length(aff)] do
        if aff[i] = 1 then
            aff[i] := IdentityMat( l+1 );
        else
            lin := List( aff[i].lin, x -> cc.CocToFactor( cc, x ) );
            trl := cc.CocToFactor( cc, aff[i].trl );
            for j in [1..l] do Add( lin[j], 0 ); od;
            Add( trl, 1 );
            aff[i] := Concatenation( lin, [trl] );
        fi;
    od;
    if not IsBool(cc.fld) then aff := aff * One(cc.fld); fi;
    return aff;
end );

#############################################################################
##
#F VectorByComplement( CR, U )
##
##  not such a bad hack any more
##
BindGlobal( "VectorByComplement", function( CR, U )
    local igs;
    igs := Igs(U);
    # CR.factor and igs must match as cosets of the numerator of CR.normal
    # We enforce this by using ReducedByIgs
    return Flat( List( CR.factor, g ->
        ExponentsByPcp( CR.normal, ReducedByIgs( igs, g^-1 ) ) ) );
end );

#############################################################################
##
#F LiftBlockToPointNormalizer( CR, cc, C, H, HN, c )
##
BindGlobal( "LiftBlockToPointNormalizer", function( CR, cc, C, H, HN, c )
    local b, r, t, i, d, igs;

    # set up b and t
    b := AddIgsToIgs( Igs(H), DenominatorOfPcp( CR.normal ) );
    r := List( cc.rls, x -> MappedVector( x, CR.normal ) );
    # do not use AddIgsToIgs: r may not be an igs
    b := AddToIgs( b, r );
    t := ShallowCopy( AsList( Pcp( C, HN ) ) );

    # catch a special case
    if Length(cc.gcb) = 0 then return SubgroupByIgsAndIgs( C, t, b ); fi;

    # add normalizer to centralizer and complement
    for i in [1..Length(t)] do
        d := VectorByComplement( CR, H^t[i] );
        if not IsBool( cc.fld ) then d := d * One( cc.fld ); fi;
        d := cc.CocToCBElement( cc, d-c ) * cc.trf;
        t[i] := t[i] * MappedVector( d, CR.normal );
    od;
    # do not use AddIgsToIgs: t may not be an igs
    return SubgroupByIgs( C, b, t );
end );

#############################################################################
##
#F NormalizerOfIntersection( C, N, I )
##
BindGlobal( "NormalizerOfIntersection", function( C, N, I )
    local pcp, int, fac, act, p, d, F, stb, ind;

    # catch trivial cases
    if Size(I) = 1 or IndexNC(N,I) = 1 then return C; fi;

    # set up
    pcp := Pcp(N, "snf");
    int := List( Igs(I), x -> ExponentsByPcp( pcp, x ) );
    fac := Pcp( C, N );
    act := LinearActionOnPcp( fac, pcp );
    p := RelativeOrdersOfPcp( pcp )[1];
    d := Length( pcp );
    Info( InfoPcpGrp, 2,"  normalize intersection in layer of type ",p,"^",d);

    # the finite case
    if p > 0 then
        F := GF(p);
        act := InducedByField( act, F );
        int := VectorspaceBasis( int*One(F) );
        stb := PcpOrbitStabilizer( int, fac, act, OnSubspacesByCanonicalBasis );
        return SubgroupByIgsAndIgs( C, stb.stab, AsList(pcp) );

    # the infinite case
    else
        ind := NaturalHomomorphismByPcp( fac );
        int := LatticeBasis( int );
        C := ImagesSource( ind );
        C := NormalizerIntegralAction( C, act, int );
        return PreImagesSetNC( ind, C );
    fi;
end );

#############################################################################
##
#F StabilizerOfCocycle( CR, cc, C, elm )
##
BindGlobal( "StabilizerOfCocycle", function( CR, cc, C, elm )
    local aff, s, l, D, nat, act, e, oper, stb;

    # determine operation and catch trivial case
    aff := AffineActionOnH1( CR, cc );
    if ForAll( aff, x -> x = x^0 ) then return C; fi;

    # determine stabilizer of free abelian part
    s := Position( cc.factor.rels, 0 );
    l := Length( cc.factor.rels );
    D := C;
    if not IsBool(s) then
        nat := NaturalHomomorphismByPcp( CR.super );
        act := List( aff, x -> x{[s..l+1]}{[s..l+1]} );
        e := elm{[s..l]}; Add( e, 1 );
        D := ImagesSource( nat );
        D := StabilizerIntegralAction( D, act, e );
        D := PreImagesSetNC( nat, D );
    fi;
    if Size(D) = 1 or s = 1 then return D; fi;

    # now it remains to do an affine finite os calculation
    Add( elm, 1 );

    # set up action for D
    if IndexNC(C,D) > 1 then
        act := Pcp( D, CR.group );
        aff := InducedByPcp( CR.super, act, aff );
    else
        act := CR.super;
    fi;

    # set up operation
    if IsBool(cc.fld) then
        oper := function( pt, aff )
            local im, i;
            im := pt * aff;
            for i in [1..l] do
                if cc.factor.rels[i] > 0 then
                    im[i] := im[i] mod cc.factor.rels[i];
                fi;
            od;
            return im;
        end;
    else
        elm := elm * One(cc.fld);
        oper := OnRight;
    fi;

    # compute stabilizer
    stb := PcpOrbitStabilizer( elm, act, aff, oper );
    return SubgroupByIgsAndIgs( C, stb.stab, Igs(CR.group) );
end );

#############################################################################
##
#F PcpsOfAbelianFactor( N, I )
##
BindGlobal( "PcpsOfAbelianFactor", function( N, I )
    local ser, sub, pcp, rel, tor, gen, M, p, T;

    # set up
    ser := [];
    sub := Igs(I);
    pcp := Pcp(N, I, "snf");
    rel := RelativeOrdersOfPcp( pcp );
    tor := pcp{Filtered([1..Length(rel)], x -> rel[x] > 0 )};

    # the factor mod torsion
    # do not use AddIgsToIgs: lifts may not be an igs
    T := SubgroupByIgs( N, sub, tor );
    if IndexNC(N,T) > 1 then
        Add( ser, Pcp(N,T,"snf") );
        pcp := Pcp(T, I);
        rel := RelativeOrdersOfPcp( pcp );
    fi;

    # now the torsion parts
    while Length(pcp) > 0 do
        p := Factors(rel[1])[1];
        gen := List( pcp, x -> x^p );
        gen := Filtered( gen, x -> x <> One(N) );
        # do not use AddIgsToIgs: powers may not be an igs
        M := SubgroupByIgs( N, sub, gen );
        Add( ser, Pcp(T,M,"snf") );
        T := M;
        pcp := Pcp(T, I);
        rel := RelativeOrdersOfPcp( pcp );
    od;

    return ser;
end );

#############################################################################
##
#F NormalizerOfComplement( C, H, N, I )
##
BindGlobal( "NormalizerOfComplement", function( C, H, N, I )
    local pcps, pcp, M, L, CR, cc, c, e;

    # catch the trivial case
    if IndexNC(H,I) = 1 or IndexNC(N,I) = 1 then return C; fi;
    Info( InfoPcpGrp, 2, "  normalize complement");

    # compute efa series through N / I
    pcps := PcpsOfAbelianFactor( N, I );

    # loop over series
    for pcp in pcps do

        M := SubgroupByIgs( C, NumeratorOfPcp( pcp ) );
        L := SubgroupByIgsAndIgs( C, Igs(H), Igs(M) );

        # set up H^1
        CR := rec( group  := L,
                   super  := Pcp( C, L ),
                   factor := Pcp( L, M ),
                   normal := pcp );
        AddFieldCR( CR );
        AddRelatorsCR( CR );
        AddOperationCR( CR );
        AddInversesCR( CR );

        # determine 1-cohomology
        cc := OneCohomologyEX( CR );
        if IsBool( cc ) then Error("no complement \n"); fi;
        c := VectorByComplement( CR, H );
        if not IsBool( cc.fld ) then c := c * One( cc.fld ); fi;

        # stabilize vector
        if Length( cc.factor.rels ) > 0 then
            Info( InfoPcpGrp, 2, "  H1 is of type ",cc.factor.rels);
            e := cc.CocToFactor( cc, c - cc.sol );
            C := StabilizerOfCocycle( CR, cc, C, e );
        fi;

        # lift to point normalizer
        C := LiftBlockToPointNormalizer( CR, cc, C, H, L, c );
    od;
    return C;
end );

#############################################################################
##
#F NormalizerBySeries( G, U, efa )
##
BindGlobal( "NormalizerBySeries", function( G, U, efa )
    local C, i, N, M, hom, H, I, nat, k;

    # do a simple check
    if Size(U) = 1 or G = U then return G; fi;

    # loop over series
    C := G;
    for i in [2..Length(efa)-1] do
        Info( InfoPcpGrp, 1, "start layer ",i);

        # get layer
        N := efa[i];
        M := efa[i+1];

        # determine factor C/M
        hom := NaturalHomomorphismByNormalSubgroupNC( G, M );
        if Size(M) > 1 then
            N := ImagesSet( hom, N );
            C := Image( hom, C );
        fi;
        H := ImagesSet( hom, U );

        # first normalize the intersection I = N cap H
        I := NormalIntersection( N, H );
        C := NormalizerOfIntersection( C, N, I );

        # now normalize complement
        C := NormalizerOfComplement( C, H, N, I );

        # add checking if required
        if POLYCYCLIC_CHECK_NORM then
            Info( InfoPcpGrp, 1, "  check result ");
            H := ImagesSet( hom, U );
            if ForAny( Igs(C), x -> H^x <> H ) then
               Error("normalizer is not normalizing");
            fi;
        fi;

        if Size(M) > 1 then C := PreImagesSetNC( hom, C ); fi;
    od;
    return C;
end );

#############################################################################
##
#F Normalizer
##
BindGlobal( "NormalizerPcpGroup", function( G, U )
    local GG, UU, NN;

    # translate
    GG  := PcpGroupByEfaSeries(G);
    UU  := PreImagesSetNC(GG!.bijection,U);

    # compute
    NN := NormalizerBySeries( GG, UU, EfaSeries(GG) );

    # translate back
    return Image(GG!.bijection, NN );
end );

InstallMethod( NormalizerOp, "for a pcp group", IsIdenticalObj,
        [IsPcpGroup, IsPcpGroup],
function( G, U )
    local H;

    # catch a special case
    if IsSubgroup( G, U ) then
        return NormalizerPcpGroup( G, U );
    fi;

     # find a common overgroup of G and U and compute the normalizer in there
     H := PcpGroupByCollectorNC( Collector( G ) );
     H := SubgroupByIgs( H, Igs(G), Igs(U) );
     return Intersection( G, NormalizerPcpGroup( H, U ) );
end );

#############################################################################
##
#F ConjugacyOfIntersections( C, N, I, J, contained )
##
##  Dual of NormalizerOfIntersection, but does not assume N is a subgroup of
##  C. The argument 'contained' is true if and only if N is a subgroup of C.
##
BindGlobal( "ConjugacyOfIntersections", function( C, N, I, J, contained )
    local pcp, int, jnt, C_N, fac, act, p, F, stb, j, t, ind, os;

    # catch trivial cases
    if Size( I ) = 1 or Size( J ) = 1 or
       IndexNC( N, I ) = 1 or IndexNC( N, J ) = 1 then
        if I = J then
            return rec( stab := C, prei := One( C ) );
        fi;
        return false;
    fi;

    # set up
    pcp := Pcp( N, "snf" );
    int := List( Igs( I ), x -> ExponentsByPcp( pcp, x ) );
    jnt := List( Igs( J ), x -> ExponentsByPcp( pcp, x ) );
    if contained then
        C_N := N;
    else
        C_N := NormalIntersection( N, C );
    fi;
    fac := Pcp( C, C_N );
    act := LinearActionOnPcp( fac, pcp );
    p := RelativeOrdersOfPcp( pcp )[ 1 ];
    Info(
        InfoPcpGrp, 2, "  conjugate intersections in layer of type ", p, "^",
        Length( pcp )
    );

    # the finite case
    if p > 0 then
        F := GF( p );
        act := InducedByField( act, F );
        int := VectorspaceBasis( int * One( F ) );
        jnt := VectorspaceBasis( jnt * One( F ) );
        stb := PcpOrbitStabilizer( int, fac, act, OnSubspacesByCanonicalBasis );
        j := Position( stb.orbit, jnt );
        if IsBool( j ) then
            return false;
        fi;
        t := TransversalElement( j, stb, One( C ) );
        stb := List( stb.stab, x -> x ^ t );
        return rec(
            stab := SubgroupByIgsAndIgs( C, stb, Igs( C_N ) ),
            prei := t
        );

    # the infinite case
    else
        ind := NaturalHomomorphismByPcp( fac );
        int := LatticeBasis( int );
        jnt := LatticeBasis( jnt );
        os := ConjugacyIntegralAction( ImagesSource( ind ), act, int, jnt );
        if IsBool( os ) then
            return false;
        fi;
        return rec(
            stab := PreImagesSetNC( ind, os.stab ^ os.prei ),
            prei := PreImagesRepresentativeNC( ind, os.prei )
        );
    fi;
end );

#############################################################################
##
#F OrbitOfCocycle( CR, cc, C, e, f )
##
##  Dual of StabilizerOfCocycle.
##
BindGlobal( "OrbitOfCocycle", function( CR, cc, C, e, f )
    local aff, s, l, D, t, nat, act, ee, ff, os, oper, stb, j, u, K;

    # determine operation and catch trivial case
    aff := AffineActionOnH1( CR, cc );
    if ForAll( aff, IsOne ) then
        if e = f then
            return rec( stab := C, prei := One(C) );
        fi;
        return false;
    fi;

    # determine orbit on free abelian part
    s := Position( cc.factor.rels, 0 );
    l := Length( cc.factor.rels );
    D := C;
    t := One( C );
    if not IsBool( s ) then
        nat := NaturalHomomorphismByPcp( CR.super );
        act := List( aff, x -> x{ [ s .. l + 1 ] }{ [ s .. l + 1] } );
        ee := e{ [ s .. l ] };
        Add( ee, 1 );
        ff := f{ [ s .. l ] };
        Add( ff, 1 );
        os := OrbitIntegralAction( ImagesSource( nat ), act, ee, ff );
        if IsBool( os ) then
            return false;
        fi;
        t := PreImagesRepresentativeNC( nat, os.prei );
        D := PreImagesSetNC( nat, os.stab ^ os.prei );
    fi;
    if s = 1 then
        return rec( stab := D, prei := t );
    fi;

    # now it remains to do an affine finite os calculation
    e := ShallowCopy( e );
    Add( e, 1 );
    f := ShallowCopy( f );
    Add( f, 1 );

    # set up action for D
    if IndexNC( C, D ) > 1 then
        act := Pcp( D, SubgroupByIgs( C, DenominatorOfPcp( CR.super ) ) );
        # cannot use InducedByPcp here, group need not be efa
        # recompute the action instead
        CR := ShallowCopy( CR );
        CR.super := act;
        Unbind( CR.smats );
        AddOperationCR( CR );
        aff := AffineActionOnH1( CR, cc );
    else
        act := CR.super;
    fi;

    # set up operation
    if IsBool( cc.fld ) then
        oper := function( pt, aff )
            local im, i;
            im := pt * aff;
            for i in [ 1 .. l ] do
                if cc.factor.rels[ i ] > 0 then
                    im[ i ] := im[ i ] mod cc.factor.rels[ i ];
                fi;
            od;
            return im;
        end;
    else
        e := e * One( cc.fld );
        f := f * One( cc.fld );
        oper := OnRight;
    fi;

    # move e by t such that e and f agree modulo torsion
    # avoid using InducedByPcp since rational inverses of integer matrices
    # will give incorrect results or errors
    if not IsOne( t ) then
        K := ComplementByH1Element( CR, cc, e{ [ 1 .. l ] } );
        e := cc.CocToFactor( cc, VectorByComplement( CR, K ^ t ) - cc.sol );
        Add( e, 1 );
    fi;

    # compute orbit and stabilizer
    stb := PcpOrbitStabilizer( e, act, aff, oper );
    j := Position( stb.orbit, f );
    if IsBool( j ) then
        return false;
    fi;
    u := TransversalElement( j, stb, One( C ) );
    stb := List( stb.stab, x -> x ^ u );
    return rec(
        stab := SubgroupByIgsAndIgs( C, stb, DenominatorOfPcp( CR.super ) ),
        prei := t * u
    );
end );

#############################################################################
##
#F ConjugacyOfComplements( C, H, K, N, I, contained )
##
##  Dual of NormalizerOfComplement, but does not assume HN is a subgroup of
##  C. The argument 'contained' is true if and only if HN is a subgroup of C.
##
BindGlobal( "ConjugacyOfComplements", function( C, H, K, N, I, contained )
    local pcps, pcp, k, M, L, CR, cc, c, d, e, f, os, m;

    # catch the trivial cases
    if IndexNC( H, I ) = 1 or IndexNC( N, I ) = 1 then
        return rec( stab := C, prei := One( C ) );
    fi;
    Info( InfoPcpGrp, 2, "  conjugate complements");

    # compute efa series through N / I
    pcps := PcpsOfAbelianFactor( N, I );

    # loop over series
    k := One( C );
    for pcp in pcps do

        M := SubgroupByIgs( C, NumeratorOfPcp( pcp ) );
        L := SubgroupByIgsAndIgs( C, Igs( H ), Igs( M ) );

        # factor out L when it is contained in C and we act on H^1
        # otherwise, use the whole acting group
        # (computing intersection of C and L would be too expensive)
        CR := rec(
            group  := L,
            factor := Pcp( L, M ),
            normal := pcp
        );
        if contained then
            CR.super := Pcp( C, L );
        else
            CR.super := Pcp( C );
        fi;
        AddFieldCR( CR );
        AddRelatorsCR( CR );
        AddOperationCR( CR );
        AddInversesCR( CR );

        # determine 1-cohomology
        cc := OneCohomologyEX( CR );
        if IsBool( cc ) then Error("no complement \n"); fi;
        if not contained then
            cc.factor := AdditiveFactorPcp( cc.gcc, [], CR.char );
        fi;
        c := VectorByComplement( CR, H );
        d := VectorByComplement( CR, K );
        if not IsBool( cc.fld ) then
            c := c * One( cc.fld );
            d := d * One( cc.fld );
        fi;

        # conjugate
        if Length( cc.factor.rels ) > 0 then
            Info( InfoPcpGrp, 2, "  cocycle factor is of type ", cc.factor.rels );
            e := cc.CocToFactor( cc, c - cc.sol );
            f := cc.CocToFactor( cc, d - cc.sol );
            os := OrbitOfCocycle( CR, cc, C, e, f );
            if IsBool( os ) then
                return false;
            fi;
            C := os.stab;
            if not IsOne( os.prei ) then
                H := H ^ os.prei;
                k := k * os.prei;
                c := VectorByComplement( CR, H );
                if not IsBool( cc.fld ) then
                    c := c * One( cc.fld );
                fi;
            fi;
        fi;

        if contained then
            if Length( cc.gcb ) > 0 then
                m := cc.CocToCBElement( cc, c - d ) * cc.trf;
                m := MappedVector( m, CR.normal );
                H := H ^ m;
                k := k * m;
            fi;

            # lift to point normalizer
            C := LiftBlockToPointNormalizer( CR, cc, C, K, L, d );
        fi;
    od;
    return rec( stab := C, prei := k );
end );

#############################################################################
##
#F ConjugacySubgroupsBySeries( G, U, V, efa )
##
##  Dual of NormalizerBySeries.
##
BindGlobal( "ConjugacySubgroupsBySeries", function( G, U, V, efa )
    local P, contained, k, C, i, N, M, hom, homC, H, K, I, J, os, t;

    # top layer is abelian so conjugacy = equality
    P := efa[ 1 ];
    contained := IsSubgroup( G, U ) and IsSubgroup( G, V );
    hom := NaturalHomomorphismByNormalSubgroupNC( P, efa[2] );
    if ImagesSet( hom, U ) <> ImagesSet( hom, V ) then
        return false;
    fi;

    # loop over series
    k := One( G );
    C := G;
    for i in [2..Length(efa)-1] do
        Info( InfoPcpGrp, 1, "start layer ",i);

        # get layer
        N := efa[ i ];
        M := efa[ i + 1 ];

        # determine factor P/M
        # restrict map to C if necessary
        hom := NaturalHomomorphismByNormalSubgroupNC( P, M );
        if contained or Size( M ) = 1 then
            homC := hom;
        else
            homC := GroupHomomorphismByImagesNC(
                C, ImagesSource( hom ),
                Igs( C ), List( Igs( C ), x -> ImagesRepresentative( hom, x ) )
            );
            SetKernelOfMultiplicativeGeneralMapping(
                homC, NormalIntersection( M, C )
            );
        fi;
        if Size( M ) > 1 then
            N := ImagesSet( hom, N );
            C := ImagesSet( hom, C );
        fi;
        H := ImagesSet( hom, U ^ k );
        K := ImagesSet( hom, V );

        # first conjugate the intersections with N
        I := NormalIntersection( N, H );
        J := NormalIntersection( N, K );
        os := ConjugacyOfIntersections( C, N, I, J, contained );
        if IsBool( os ) then
            return false;
        fi;
        C := os.stab;
        t := os.prei;
        H := H ^ t;

        # now conjugate the complements
        os := ConjugacyOfComplements( C, H, K, N, J, contained );
        if IsBool( os ) then
            return false;
        fi;
        C := os.stab;
        t := t * os.prei;

        # add checking if required
        if POLYCYCLIC_CHECK_NORM then
            Info( InfoPcpGrp, 1, "  check result ");
            if H ^ os.prei <> K then
                Error( "subgroups are not conjugated" );
            fi;
            if ForAny( Igs( C ), x -> K ^ x <> K ) then
               Error( "normalizer is not normalizing" );
            fi;
        fi;

        k := k * PreImagesRepresentativeNC( homC, t );
        if Size( M ) > 1 then
            C := PreImagesSetNC( homC, C );
        fi;
    od;
    return k;
end );

#############################################################################
##
#F ConjugacySubgroupsPcpGroup( G, U, V )
##
##  Dual of NormalizerPcpGroup.
##
BindGlobal( "ConjugacySubgroupsPcpGroup", function( G, U, V )
    local P, PP, GG, UU, VV, k;

    # cheap checks before changing the presentation
    if U = V then
        return One( G );
    fi;
    if Size( G ) = 1 or Size( U ) <> Size( V ) or
       HirschLength( U ) <> HirschLength( V ) then
        return false;
    fi;

    # find a common overgroup of G, U and V
    if IsSubgroup( G, U ) and IsSubgroup( G, V ) then
        P := G;
    else
        P := PcpGroupByCollectorNC( Collector( G ) );
        P := SubgroupByIgs( P, Igs( G ), Concatenation( Igs( U ), Igs( V ) ) );
    fi;

    # translate
    PP := PcpGroupByEfaSeries( P );
    GG := PreImagesSetNC( PP!.bijection, G );
    UU := PreImagesSetNC( PP!.bijection, U );
    VV := PreImagesSetNC( PP!.bijection, V );

    # compute
    k := ConjugacySubgroupsBySeries( GG, UU, VV, EfaSeries( PP ) );

    # translate back
    if k = false then
        return false;
    fi;
    return ImagesRepresentative( PP!.bijection, k );
end );

#############################################################################
##
#F RepresentativeActionOp( G, U, V, act )
##
InstallOtherMethod( RepresentativeActionOp, "for OnPoints and pcp groups",
        true, [IsPcpGroup, IsPcpGroup, IsPcpGroup, IsFunction],
function( G, U, V, act )
    local c;
    if act <> OnPoints then TryNextMethod(); fi;
    c := ConjugacySubgroupsPcpGroup( G, U, V );
    if c = false then return fail; fi;
    return c;
end );
