#############################################################################
##
#W  latbases.gi                                                  Bettina Eick
##
##  Methods to compute with lattice bases.
##

#############################################################################
##
#F  LatticeBasis( gens )
##
BindGlobal( "LatticeBasis", function( gens )
    local b, j;
    if Length(gens) = 0 or ForAll(gens, x -> Length(x)=0 ) then return []; fi;
    b := NormalFormIntMat( gens, 2 ).normal;
    if Length(b) = 0 then return b; fi;
    j := Position( b, 0*b[1] );
    if not IsBool( j ) then b := b{[1..j-1]}; fi;
    return b;
end );

#############################################################################
##
#F  FactorLattice( V, U )
##
BindGlobal( "FactorLattice", function( V, U )
    local d, g, r, i, j, e;
    d := List( U, PositionNonZero );
    g := [];
    r := [];
    for i in [1..Length(V)] do
        j := Position( d, PositionNonZero(V[i]) );
        if IsBool(j) then
            Add( g, V[i] );
            Add( r, 0 );
        else
            e := AbsInt( U[j][d[j]] / V[i][d[j]] );
            if e > 1 then
                Add( g, V[i] );
                Add( r, e );
            fi;
        fi;
    od;
    return rec( gens := g, rels := r, kern := U );
end );

#############################################################################
##
#F  CoefficientsByFactorLattice( F, v )
##
BindGlobal( "CoefficientsByFactorLattice", function( F, v )
    local df, dk, cf, ck, z, l, j, e;
    v  := ShallowCopy(v);
    df := List( F.gens, PositionNonZero );
    dk := List( F.kern, PositionNonZero );
    cf := List( df, x -> 0 );
    ck := List( dk, x -> 0 );
    z := 0 * v;
    while v <> z do
        l := PositionNonZero(v);

        # reduce with factor
        j := Position( df, l );
        if not IsBool( j ) then
            if F.rels[j] > 0 then
                e := Gcdex( F.rels[j], F.gens[j][l] );
                cf[j] := (v[l]/e.gcd * e.coeff2) mod F.rels[j];
            else
                cf[j] := v[l]/F.gens[j][l];
            fi;
            AddRowVector( v, F.gens[j], -cf[j] );
        fi;

        # reduce with kernel
        if PositionNonZero(v) = l then
            j := Position( dk, l );
            ck[j] := v[l]/F.kern[j][l];
            AddRowVector( v, F.kern[j], -ck[j] );
        fi;
    od;
    return rec( fcoeff := cf, kcoeff := ck );
end );

#############################################################################
##
#F  NaturalHomomorphismByLattices( V, U ). . . . . . . includes normalisation
##
BindGlobal( "NaturalHomomorphismByLattices", function( V, U )
    local F, n, mat, i, row, new, cyc, ord, chg, inv, imgs, prei;

    # get the factor
    F := FactorLattice( V, U );
    n := Length(F.gens);

    # normalize the factor
    mat := [];
    for i in [1..n] do
        if F.rels[i] > 0 then
            row := CoefficientsByFactorLattice(F,F.rels[i]*F.gens[i]).fcoeff;
            row[i] := row[i] - F.rels[i];
            Add( mat, row );
        else
            Add( mat, List( [1..n], x -> 0 ) );
        fi;
    od;

    # solve matrix
    new := NormalFormIntMat( mat, 9 );

    # get new generators, relators and the basechange
    cyc := [];
    ord := [];
    chg  := [];
    inv  := [];

    imgs := TransposedMat( new.coltrans );
    prei := Inverse( new.coltrans );
    for i in [1..n] do
        if new.normal[i][i] <> 1 then
            Add( cyc, LinearCombination( F.gens, prei[i] ) );
            Add( ord, new.normal[i][i] );
            Add( chg, prei[i] );
            if new.normal[i][i] > 0 then
                Add( inv, List( imgs[i], x -> x mod new.normal[i][i] ) );
            else
                Add( inv, imgs[i] );
            fi;
        fi;
    od;

    cyc := rec( gens := cyc,
                rels := ord,
                base := chg,
                inv  := TransposedMat( inv ) );

    return rec( fac := F, cyc := cyc );
end );

#############################################################################
##
#F TranslateExp( cyc, exp ) . . . . . . . . .  translate to decomposed factor
##
BindGlobal( "TranslateExp", function( cyc, exp )
    local new, i;
    new := exp * cyc.inv;
    for i in [1..Length(new)] do
        if cyc.rels[i] > 0 then new[i] := new[i] mod cyc.rels[i]; fi;
    od;
    return new;
end );


#############################################################################
##
#F  CoefficientsByNHLB( v, hom )
##
BindGlobal( "CoefficientsByNHLB", function( v, hom )
    local cf;
    cf := CoefficientsByFactorLattice( hom.fac, v );
    cf.fcoeff := TranslateExp( hom.cyc, cf.fcoeff );
    return cf;
end );

#############################################################################
##
#F  ProjectionByNHLB( vec, hom )
##
BindGlobal( "ProjectionByNHLB", function( vec, hom )
    return CoefficientsByNHLB( vec, hom ).kcoeff;
end );

#############################################################################
##
#F  ImageByNHLB( vec, hom )
##
BindGlobal( "ImageByNHLB", function( vec, hom )
    return CoefficientsByNHLB( vec, hom ).fcoeff;
end );

#############################################################################
##
#F  ImageOfNHLB( hom )
##
BindGlobal( "ImageOfNHLB", function( hom )
    return hom.cyc.base;
end );

#############################################################################
##
#F  KernelOfNHLB( hom )
##
BindGlobal( "KernelOfNHLB", function( hom )
    return hom.fac.kern;
end );

#############################################################################
##
#F  PreimagesBasisOfNHLB( hom )
##
BindGlobal( "PreimagesBasisOfNHLB", function( hom )
    return hom.cyc.gens;
end );

#############################################################################
##
#F  PreimagesRepresentativeByNHLB( vec, hom )
##
BindGlobal( "PreimagesRepresentativeByNHLB", function( vec, hom )
    return vec * hom.cyc.gens;
end );

#############################################################################
##
#F  PreimageByNHLB( base, hom )
##
BindGlobal( "PreimageByNHLB", function( base, hom )
    local new;
    new := List( base, x -> x * hom.cyc.gens );
    Append( new, hom.fac.kern );
    return LatticeBasis( new );
end );

#############################################################################
##
#F  InducedActionByNHLB( mat, hom )
##
BindGlobal( "InducedActionByNHLB", function( mat, hom )
    local fac, sub;
    fac := List( hom.cyc.gens, x -> CoefficientsByNHLB(x*mat, hom).fcoeff );
    sub := List( hom.fac.kern, x -> CoefficientsByNHLB(x*mat, hom).kcoeff );
    return rec( factor := fac, subsp := sub );
end );

#############################################################################
##
#F  InducedActionFactorByNHLB( mat, hom )
##
BindGlobal( "InducedActionFactorByNHLB", function( mat, hom )
    return List( hom.cyc.gens, x -> CoefficientsByNHLB(x*mat, hom).fcoeff );
end );

#############################################################################
##
#F  InducedActionSubspaceByNHLB( mat, hom )
##
BindGlobal( "InducedActionSubspaceByNHLB", function( mat, hom )
    return List( hom.fac.kern, x -> CoefficientsByNHLB(x*mat, hom).kcoeff );
end );

