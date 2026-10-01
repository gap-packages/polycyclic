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
    b := AddIgsToIgs( r, b );
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
    return SubgroupByIgsAndIgs( C, t, b );
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
        stb := AddIgsToIgs( stb.stab, AsList(pcp) );
        return SubgroupByIgs( C, stb );

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
    T := SubgroupByIgsAndIgs( N, tor, sub );
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
        M := SubgroupByIgsAndIgs( N, gen, sub );
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
        if CHECK_NORM@ then
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
##  N is abelian and normalised by C; I and J are subgroups of N. Returns
##  rec( stab := N_C(J), prei := t ) with t in C and I^t = J, or false.
##  contained indicates that N is a subgroup of C.
##
BindGlobal( "ConjugacyOfIntersections", function( C, N, I, J, contained )
    local pcp, int, jnt, CN, fac, act, p, F, stb, j, t, ind, os;

    # catch trivial cases
    if Size(I) = 1 or Size(J) = 1 or IndexNC(N,I) = 1 or IndexNC(N,J) = 1 then
        if I = J then return rec( stab := C, prei := One(C) ); fi;
        return false;
    fi;

    # set up
    pcp := Pcp(N, "snf");
    int := List( Igs(I), x -> ExponentsByPcp( pcp, x ) );
    jnt := List( Igs(J), x -> ExponentsByPcp( pcp, x ) );
    if contained then CN := N; else CN := NormalIntersection( N, C ); fi;
    fac := Pcp( C, CN );
    act := LinearActionOnPcp( fac, pcp );
    p := RelativeOrdersOfPcp( pcp )[1];
    Info( InfoPcpGrp, 2,"  conjugate intersections in layer of type ",
          p,"^",Length(pcp));

    # the finite case
    if p > 0 then
        F := GF(p);
        act := InducedByField( act, F );
        int := VectorspaceBasis( int*One(F) );
        jnt := VectorspaceBasis( jnt*One(F) );
        stb := PcpOrbitStabilizer( int, fac, act, OnSubspacesByCanonicalBasis );
        j := Position( stb.orbit, jnt );
        if IsBool(j) then return false; fi;
        t := TransversalElement( j, stb, One(C) );
        stb := List( stb.stab, x -> x^t );
        stb := AddIgsToIgs( stb, Igs(CN) );
        return rec( stab := SubgroupByIgs( C, stb ), prei := t );
    fi;

    # the infinite case
    ind := NaturalHomomorphismByPcp( fac );
    int := LatticeBasis( int );
    jnt := LatticeBasis( jnt );
    os := ConjugacyIntegralAction( ImagesSource( ind ), act, int, jnt );
    if IsBool(os) then return false; fi;
    return rec( stab := PreImagesSetNC( ind, os.stab^os.prei ),
                prei := PreImagesRepresentativeNC( ind, os.prei ) );
end );

#############################################################################
##
#F OrbitOfCocycle( CR, cc, C, e, f )
##
##  e and f are elements of H^1 as returned by cc.CocToFactor. Returns
##  rec( stab := Stab_C(f), prei := t ) with t in C and e^t = f under the
##  affine action of C on H^1, or false. CR.super must be a pcp of C modulo
##  a subgroup acting trivially on H^1.
##
BindGlobal( "OrbitOfCocycle", function( CR, cc, C, e, f )
    local aff, s, l, D, t, nat, act, ee, ff, os, oper, stb, j, u;

    # determine operation and catch trivial case
    aff := AffineActionOnH1( CR, cc );
    if ForAll( aff, x -> x = x^0 ) then
        if e = f then return rec( stab := C, prei := One(C) ); fi;
        return false;
    fi;

    # determine orbit on the free abelian part
    s := Position( cc.factor.rels, 0 );
    l := Length( cc.factor.rels );
    D := C;
    t := One(C);
    if not IsBool(s) then
        nat := NaturalHomomorphismByPcp( CR.super );
        act := List( aff, x -> x{[s..l+1]}{[s..l+1]} );
        ee := e{[s..l]}; Add( ee, 1 );
        ff := f{[s..l]}; Add( ff, 1 );
        os := OrbitIntegralAction( ImagesSource( nat ), act, ee, ff );
        if IsBool(os) then return false; fi;
        t := PreImagesRepresentativeNC( nat, os.prei );
        D := PreImagesSetNC( nat, os.stab^os.prei );
        if s = 1 then return rec( stab := D, prei := t ); fi;
    fi;

    # now it remains to do an affine finite os calculation
    e := ShallowCopy( e ); Add( e, 1 );
    f := ShallowCopy( f ); Add( f, 1 );

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
        e := e * One(cc.fld);
        f := f * One(cc.fld);
        oper := OnRight;
    fi;

    # move e by t, so that e and f agree modulo torsion
    if not IsOne(t) then
        e := oper( e, InducedByPcp( CR.super, t, aff ) );
    fi;

    # set up action for D
    if IndexNC(C,D) > 1 then
        if Length( DenominatorOfPcp( CR.super ) ) = 0 then
            act := Pcp( D );
        else
            act := Pcp( D, SubgroupByIgs( C, DenominatorOfPcp( CR.super ) ) );
        fi;
        aff := InducedByPcp( CR.super, act, aff );
    else
        act := CR.super;
    fi;

    # compute orbit and stabilizer
    stb := PcpOrbitStabilizer( e, act, aff, oper );
    j := Position( stb.orbit, f );
    if IsBool(j) then return false; fi;
    u := TransversalElement( j, stb, One(C) );
    stb := List( stb.stab, x -> x^u );
    stb := AddIgsToIgs( stb, DenominatorOfPcp( CR.super ) );
    return rec( stab := SubgroupByIgs( C, stb ), prei := t*u );
end );

#############################################################################
##
#F ConjugacyInCohomologyClass( CR, cc, C, H, K, c, d )
##
##  H and K are complements with cocycles c and d in the same cohomology
##  class, and C stabilizes this class. Returns rec( stab := N_C(KT),
##  prei := t ) with t in C and H^t T = K T, where T is the denominator of
##  CR.normal, or false.
##
##  The complements in the class are K^n for n in CR.normal. We identify
##  them with the coordinates of (cocycle - d) with respect to cc.gcb. C
##  acts on these coordinates affinely: as n g = g n^g, the complement K^n
##  is mapped to K^g conjugated by n^g.
##
BindGlobal( "ConjugacyInCohomologyClass", function( CR, cc, C, H, K, c, d )
    local CB, delta, nks, pcp, aff, g, lin, trl, row, e, f, os, stb, j, u;

    # catch the trivial case
    if Length( cc.gcb ) = 0 then
        return rec( stab := C, prei := One(C) );
    fi;

    # the coboundary map delta: CR.normal -> cocycles, n -> coc(K^n) - d
    CB := function( coc ) return cc.CocToCBElement( cc, coc ); end;
    delta := List( AsList( CR.normal ), n -> VectorByComplement( CR, K^n ) );
    delta := List( delta, x -> x - d );
    if not IsBool( cc.fld ) then delta := delta * One( cc.fld ); fi;

    # preimages of cc.gcb under delta
    if IsBool( cc.fld ) then
        nks := List( cc.gcb, b -> PcpSolutionIntMat( delta, b ) );
    else
        nks := List( cc.gcb, b -> SolutionMat( delta, b ) );
    fi;

    # the affine action of C on the coordinates
    pcp := Pcp( C );
    aff := [];
    for g in AsList( pcp ) do
        lin := List( AsList( CR.normal ), y -> ExponentsByPcp( CR.normal, y^g ) );
        if not IsBool( cc.fld ) then lin := lin * One( cc.fld ); fi;
        lin := List( nks, n -> CB( n * lin * delta ) );
        trl := CB( VectorByComplement( CR, K^g ) - d );
        if not IsBool( cc.fld ) then trl := trl * One( cc.fld ); fi;
        for row in lin do Add( row, 0*trl[1] ); od;
        Add( trl, trl[1]^0 );
        Add( lin, trl );
        Add( aff, lin );
    od;

    # the points corresponding to H and K
    e := CB( c - d ); Add( e, 1 );
    f := 0 * e; f[Length(f)] := 1;
    if not IsBool( cc.fld ) then
        e := e * One( cc.fld );
        f := f * One( cc.fld );
    fi;

    # the infinite case
    if IsBool( cc.fld ) then
        os := OrbitIntegralAction( C, aff, e, f );
        if IsBool(os) then return false; fi;
        return rec( stab := os.stab^os.prei, prei := os.prei );
    fi;

    # the finite case
    stb := PcpOrbitStabilizer( e, pcp, aff, OnRight );
    j := Position( stb.orbit, f );
    if IsBool(j) then return false; fi;
    u := TransversalElement( j, stb, One(C) );
    stb := List( stb.stab, x -> x^u );
    return rec( stab := SubgroupByIgs( C, stb ), prei := u );
end );

#############################################################################
##
#F ConjugacyOfComplements( C, H, K, N, I, contained )
##
##  H and K satisfy HN = KN and H cap N = K cap N = I, and C normalises
##  HN, N and I. Returns rec( stab := N_C(K), prei := t ) with t in C and
##  H^t = K, or false. contained indicates that HN is a subgroup of C.
##
BindGlobal( "ConjugacyOfComplements", function( C, H, K, N, I, contained )
    local pcps, pcp, k, M, L, CR, cc, c, d, e, f, os;

    # catch the trivial cases
    if IndexNC(H,I) = 1 or IndexNC(N,I) = 1 then
        return rec( stab := C, prei := One(C) );
    fi;
    Info( InfoPcpGrp, 2, "  conjugate complements");

    # compute efa series through N / I
    pcps := PcpsOfAbelianFactor( N, I );

    # loop over series
    k := One(C);
    for pcp in pcps do

        M := SubgroupByIgs( C, NumeratorOfPcp( pcp ) );
        L := SubgroupByIgsAndIgs( C, Igs(H), Igs(M) );

        # set up H^1; C cap L acts trivially on it, but computing the
        # intersection is expensive, so only factor it out if it is L
        CR := rec( group  := L,
                   factor := Pcp( L, M ),
                   normal := pcp );
        if contained then CR.super := Pcp( C, L ); else CR.super := Pcp( C ); fi;
        AddFieldCR( CR );
        AddRelatorsCR( CR );
        AddOperationCR( CR );
        AddInversesCR( CR );

        # determine 1-cohomology
        cc := OneCohomologyEX( CR );
        if IsBool( cc ) then Error("no complement \n"); fi;
        c := VectorByComplement( CR, H );
        d := VectorByComplement( CR, K );
        if not IsBool( cc.fld ) then
            c := c * One( cc.fld );
            d := d * One( cc.fld );
        fi;

        # conjugate the cohomology classes
        if Length( cc.factor.rels ) > 0 then
            Info( InfoPcpGrp, 2, "  H1 is of type ",cc.factor.rels);
            e := cc.CocToFactor( cc, c - cc.sol );
            f := cc.CocToFactor( cc, d - cc.sol );
            os := OrbitOfCocycle( CR, cc, C, e, f );
            if IsBool(os) then return false; fi;
            C := os.stab;
            if not IsOne( os.prei ) then
                H := H^os.prei;
                k := k * os.prei;
                c := VectorByComplement( CR, H );
                if not IsBool( cc.fld ) then c := c * One( cc.fld ); fi;
            fi;
        fi;

        # conjugate within the class
        os := ConjugacyInCohomologyClass( CR, cc, C, H, K, c, d );
        if IsBool(os) then return false; fi;
        C := os.stab;
        if not IsOne( os.prei ) then
            H := H^os.prei;
            k := k * os.prei;
        fi;
    od;
    return rec( stab := C, prei := k );
end );

#############################################################################
##
#F ConjugacySubgroupsBySeries( G, U, V, efa )
##
##  efa is an efa series of a group containing G, U and V. Returns k in G
##  with U^k = V, or false.
##
BindGlobal( "ConjugacySubgroupsBySeries", function( G, U, V, efa )
    local P, contained, k, C, i, N, M, hom, homC, H, K, I, J, os, t;

    # the top layer is abelian, so conjugacy means equality there
    P := efa[1];
    contained := IsSubset( G, U ) and IsSubset( G, V );
    hom := NaturalHomomorphismByNormalSubgroupNC( P, efa[2] );
    if ImagesSet( hom, U ) <> ImagesSet( hom, V ) then return false; fi;

    # loop over series
    k := One(G);
    C := G;
    for i in [2..Length(efa)-1] do
        Info( InfoPcpGrp, 1, "start layer ",i);

        # get layer
        N := efa[i];
        M := efa[i+1];

        # determine factor P/M; C need not contain M, so keep a
        # restriction of hom to C for pulling back into C
        hom := NaturalHomomorphismByNormalSubgroupNC( P, M );
        homC := GroupHomomorphismByImagesNC( C, ImagesSource( hom ), Igs(C),
                    List( Igs(C), x -> ImagesRepresentative( hom, x ) ) );
        if contained then
            SetKernelOfMultiplicativeGeneralMapping( homC, M );
        else
            SetKernelOfMultiplicativeGeneralMapping( homC, NormalIntersection( M, C ) );
        fi;
        N := ImagesSet( hom, N );
        C := ImagesSet( hom, C );
        H := ImagesSet( hom, U^k );
        K := ImagesSet( hom, V );

        # first conjugate the intersections with N
        I := NormalIntersection( N, H );
        J := NormalIntersection( N, K );
        os := ConjugacyOfIntersections( C, N, I, J, contained );
        if IsBool(os) then return false; fi;
        C := os.stab;
        t := os.prei;
        H := H^t;

        # now conjugate the complements
        os := ConjugacyOfComplements( C, H, K, N, J, contained );
        if IsBool(os) then return false; fi;
        C := os.stab;
        t := t * os.prei;

        # add checking if required
        if CHECK_NORM@ then
            Info( InfoPcpGrp, 1, "  check result ");
            if H^os.prei <> K then
                Error("subgroups are not conjugated");
            fi;
            if ForAny( Igs(C), x -> K^x <> K ) then
               Error("normalizer is not normalizing");
            fi;
        fi;

        k := k * PreImagesRepresentativeNC( homC, t );
        C := PreImagesSetNC( homC, C );
    od;
    return k;
end );

#############################################################################
##
#F ConjugacySubgroupsPcpGroup( G, U, V )
##
BindGlobal( "ConjugacySubgroupsPcpGroup", function( G, U, V )
    local P, GG, iso, k;

    # translate to a group with an efa series refined by its pcp
    P   := ClosureGroup( ClosureGroup( G, U ), V );
    GG  := PcpGroupByEfaSeries( P );
    iso := GG!.bijection;

    # compute
    k := ConjugacySubgroupsBySeries( PreImagesSetNC( iso, G ),
                                     PreImagesSetNC( iso, U ),
                                     PreImagesSetNC( iso, V ),
                                     EfaSeries( GG ) );

    # translate back
    if k = false then return false; fi;
    return ImagesRepresentative( iso, k );
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
