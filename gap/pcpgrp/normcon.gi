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
#F ConjugacyOfIntersection( C, N, I, J )
##
##  Return the stabilizer of I and an element mapping I to J.
##
BindGlobal( "ConjugacyOfIntersection", function( C, N, I, J )
    local pcp, int, target, fac, act, p, d, F, stb, ind, j, t, content;

    # Trivial and full intersections are fixed under every action.
    if I = J and (Size(I) = 1 or IndexNC(N,I) = 1) then
        return rec( stab := C, prei := One(C) );
    fi;
    if Size(I) = 1 or Size(J) = 1 or
       IndexNC(N,I) = 1 or IndexNC(N,J) = 1 then
        return false;
    fi;

    pcp := Pcp(N, "snf");
    int := List( Igs(I), x -> ExponentsByPcp( pcp, x ) );
    target := List( Igs(J), x -> ExponentsByPcp( pcp, x ) );
    fac := Pcp( C, N );
    act := LinearActionOnPcp( fac, pcp );
    p := RelativeOrdersOfPcp( pcp )[1];
    d := Length( pcp );
    Info( InfoPcpGrp, 2, "  conjugate intersection in layer of type ", p, "^", d );

    if p > 0 then
        F := GF(p);
        act := InducedByField( act, F );
        int := VectorspaceBasis( int * One(F) );
        target := VectorspaceBasis( target * One(F) );
        if Length(int) <> Length(target) then return false; fi;
        stb := PcpOrbitStabilizer( int, fac, act, OnSubspacesByCanonicalBasis );
        j := Position( stb.orbit, target );
        if IsBool(j) then return false; fi;
        t := TransversalElement( j, stb, One(C) );
        return rec( stab := SubgroupByIgsAndIgs( C, stb.stab, Igs(N) ),
                    prei := t );
    else
        int := LatticeBasis( int );
        target := LatticeBasis( target );
        if Length(int) <> Length(target) then return false; fi;
        if ForAll( act, x -> LatticeBasis(int * x) = int ) then
            if int <> target then return false; fi;
            return rec( stab := C, prei := One(C) );
        fi;

        # Integer automorphisms preserve the common content of a lattice.
        # Removing it also keeps reduction modulo 3 from being the zero space.
        content := Gcd( Flat(int) );
        if content <> Gcd( Flat(target) ) then return false; fi;
        int := int / content;
        target := target / content;
        ind := NaturalHomomorphismByPcp( fac );
        if int = target then
            stb := NormalizerIntegralAction( ImagesSource(ind), act, int );
            return rec( stab := PreImagesSetNC( ind, stb ),
                        prei := One(C) );
        fi;
        stb := ConjugacyIntegralAction( ImagesSource(ind), act, int, target );
        if IsBool(stb) then return false; fi;
        return rec( stab := PreImagesSetNC( ind, stb.stab ),
                    prei := PreImagesRepresentativeNC( ind, stb.prei ) );
    fi;
end );

#############################################################################
##
#F ConjugacyOfCocycle( CR, cc, C, elm, target )
##
##  Return the stabilizer of elm and an element mapping elm to target in H1.
##
BindGlobal( "ConjugacyOfCocycle", function( CR, cc, C, elm, target )
    local aff, s, l, D, nat, act, e, f, oper, stb, t, j, u, K, d, newCR;

    aff := AffineActionOnH1( CR, cc );
    if ForAll( aff, x -> x = x^0 ) then
        if elm <> target then return false; fi;
        return rec( stab := C, prei := One(C) );
    fi;

    s := Position( cc.factor.rels, 0 );
    l := Length( cc.factor.rels );
    D := C;
    t := One(C);
    e := ShallowCopy(elm);
    f := ShallowCopy(target);
    Add( e, 1 );
    Add( f, 1 );

    # First map the free projection. D fixes the source free projection.
    if not IsBool(s) then
        nat := NaturalHomomorphismByPcp( CR.super );
        act := List( aff, x -> x{[s..l+1]}{[s..l+1]} );
        stb := OrbitIntegralAction( ImagesSource(nat), act,
                                   e{[s..l+1]}, f{[s..l+1]} );
        if IsBool(stb) then return false; fi;
        D := PreImagesSetNC( nat, stb.stab );
        t := PreImagesRepresentativeNC( nat, stb.prei );
        if s = 1 then return rec( stab := D, prei := t ); fi;

        # Pull a complement representing the target back by t. This avoids
        # inverting integer matrices that are invertible only modulo torsion.
        K := ComplementByH1Element( CR, cc, target );
        d := VectorByComplement( CR, K^(t^-1) );
        f := cc.CocToFactor( cc, d - cc.sol );
        Add( f, 1 );
    fi;

    if IndexNC(C,D) > 1 then
        act := Pcp( D, CR.group );
        newCR := ShallowCopy(CR);
        newCR.super := act;
        Unbind(newCR.smats);
        AddOperationCR(newCR);
        aff := AffineActionOnH1( newCR, cc );
    else
        act := CR.super;
    fi;

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

    stb := PcpOrbitStabilizer( e, act, aff, oper );
    j := Position( stb.orbit, f );
    if IsBool(j) then return false; fi;
    u := TransversalElement( j, stb, One(C) );
    return rec( stab := SubgroupByIgsAndIgs( C, stb.stab, Igs(CR.group) ),
                prei := u * t );
end );

#############################################################################
##
#F ConjugacyOfComplement( C, H, K, N, I )
##
## HN = KN and H cap N = K cap N = I. Return a transporter from H to K
## and the normalizer of K in C, or false if there is no transporter.
##
BindGlobal( "ConjugacyOfComplement", function( C, H, K, N, I )
    local t, pcps, pcp, M, L, CR, cc, c, e, f, os, g, d;

    t := One(C);
    if IndexNC(H,I) = 1 or IndexNC(N,I) = 1 then
        return rec( norm := C, prei := t );
    fi;
    Info( InfoPcpGrp, 2, "  conjugate complements" );

    # N/I can have torsion even when N is free abelian.
    pcps := PcpsOfAbelianFactor( N, I );
    for pcp in pcps do
        M := SubgroupByIgs( C, NumeratorOfPcp(pcp) );
        L := SubgroupByIgsAndIgs( C, Igs(H), Igs(M) );
        CR := rec( group  := L,
                   super  := Pcp( C, L ),
                   factor := Pcp( L, M ),
                   normal := pcp );
        AddFieldCR( CR );
        AddRelatorsCR( CR );
        AddOperationCR( CR );
        AddInversesCR( CR );

        cc := OneCohomologyEX( CR );
        if cc = fail then Error("no complement\n"); fi;
        c := VectorByComplement( CR, K );
        d := VectorByComplement( CR, H );
        if not IsBool(cc.fld) then
            c := c * One(cc.fld);
            d := d * One(cc.fld);
        fi;

        # First transport the complement classes modulo coboundaries.
        if Length(cc.factor.rels) > 0 then
            Info( InfoPcpGrp, 2, "  H1 is of type ", cc.factor.rels );
            e := cc.CocToFactor( cc, d - cc.sol );
            f := cc.CocToFactor( cc, c - cc.sol );
            os := ConjugacyOfCocycle( CR, cc, C, e, f );
            if os = false then return false; fi;
            g := os.prei;
            H := H^g;
            t := t * g;
            C := os.stab^g;
        fi;

        # Lift the class transporter to a transporter of the complements.
        if Length(cc.gcb) > 0 then
            d := VectorByComplement( CR, H );
            if not IsBool(cc.fld) then d := d * One(cc.fld); fi;
            d := cc.CocToCBElement( cc, d - c ) * cc.trf;
            g := MappedVector( d, CR.normal );
            H := H^g;
            t := t * g;
        fi;
        C := LiftBlockToPointNormalizer( CR, cc, C, K, L, c );
    od;
    return rec( norm := C, prei := t );
end );

#############################################################################
##
#F ConjugacySubgroupsBySeries( G, U, V, pcps )
##
## Return an element k of G with U^k = V, or false if none exists.
## As in Section 8.6 of Eick's Algorithms for polycyclic groups, descend
## the series by transporting intersections and then complement classes.
##
BindGlobal( "ConjugacySubgroupsBySeries", function( G, U, V, pcps )
    local C, k, pcp, N, M, hom, H, K, I, J, D, os, t;

    if U = V then return One(G); fi;
    if Size(U) <> Size(V) then return false; fi;

    C := G;
    k := One(G);
    for pcp in pcps do
        Info( InfoPcpGrp, 1, "start subgroup conjugacy layer" );
        N := SubgroupByIgs( G, NumeratorOfPcp(pcp) );
        M := SubgroupByIgs( G, DenominatorOfPcp(pcp) );
        hom := NaturalHomomorphismByNormalSubgroupNC( G, M );
        N := ImagesSet( hom, N );
        D := Image( hom, C );
        H := ImagesSet( hom, U^k );
        K := ImagesSet( hom, V );

        # C normalizes the common image of U^k and V above this layer.
        I := NormalIntersection( N, H );
        J := NormalIntersection( N, K );
        os := ConjugacyOfIntersection( D, N, I, J );
        if os = false then return false; fi;
        t := os.prei;
        H := H^t;
        D := os.stab^t;
        k := k * PreImagesRepresentativeNC( hom, t );

        os := ConjugacyOfComplement( D, H, K, N, J );
        if os = false then return false; fi;
        k := k * PreImagesRepresentativeNC( hom, os.prei );
        C := PreImagesSetNC( hom, os.norm );

        if CHECK_NORM@ then
            if ImagesSet(hom, U^k) <> K then
                Error("conjugating element is incorrect");
            fi;
            if ForAny( Igs(os.norm), x -> K^x <> K ) then
                Error("normalizer is not normalizing");
            fi;
        fi;
    od;
    return k;
end );

#############################################################################
##
#F IsConjugate( G, U, V )
##
InstallMethod( IsConjugate, "for a pcp group", IsFamFamFam,
        [IsPcpGroup, IsPcpGroup, IsPcpGroup],
function( G, U, V )
    if not IsSubgroup(G,U) or not IsSubgroup(G,V) then
        TryNextMethod();
    fi;
    # compute
    return ConjugacySubgroupsBySeries( G, U, V, PcpsOfEfaSeries(G) ) <> false;
end );

