#############################################################################
##
#W  generic.gi                   Polycyc                         Bettina Eick
##

#############################################################################
##
#M AbelianPcpGroup
##
InstallGlobalFunction( AbelianPcpGroup, function( arg )
    local coll, i, n, r, grp;

    # catch arguments
    if Length(arg) = 1 and IsInt(arg[1]) then
        n := arg[1];
        r := List([1..n], x -> 0);
    elif Length(arg) = 1 and IsList(arg[1]) then
        n := Length(arg[1]);
        r := arg[1];
    elif Length(arg) = 2 then
        n := arg[1];
        r := arg[2];
    fi;

    # construct group
    coll := FromTheLeftCollector( n );
    for i in [1..n] do
        if IsBound( r[i] ) and r[i] > 0 then
            SetRelativeOrder( coll, i, r[i] );
        fi;
    od;
    UpdatePolycyclicCollector(coll);
    grp := PcpGroupByCollectorNC( coll );
    SetIsAbelian( grp, true );
    return grp;
end );

#############################################################################
##
#M DihedralPcpGroup
##
InstallGlobalFunction( DihedralPcpGroup, function( n )
    local coll, m;
    coll := FromTheLeftCollector( 2 );
    SetRelativeOrder( coll, 1, 2 );
    if IsInt( n ) then
        m := n/2;
        if not IsInt( m ) then return fail; fi;
        SetRelativeOrder( coll, 2, m );
        SetConjugate( coll, 2,  1, [2,m-1] );
    else
        SetConjugate( coll, 2,  1, [2,-1] );
        SetConjugate( coll, 2, -1, [2,-1] );
    fi;
    UpdatePolycyclicCollector(coll);
    return PcpGroupByCollectorNC( coll );
end );

#############################################################################
##
#M UnitriangularPcpGroup( n, p ) . . . . . . . . for p = 0 we take UT( n, Z )
##
InstallGlobalFunction( UnitriangularPcpGroup, function( n, p )
    local F, l, c, e, g, r, pairs, i, j, k, o, G;

    if not IsPosInt(n) then return fail; fi;
    if p = 0 then
        F := Rationals;
    elif IsPrimeInt(p) then
        F := GF(p);
    else
        return fail;
    fi;
    l := n*(n-1)/2;
    c := FromTheLeftCollector( l );

    # compute matrix generators
    g := [];
    e := One(F);
    for i in [1..n-1] do
        for j in [1..n-i] do
            r := IdentityMat( n, F );
            r[j][i+j] := e;
            Add( g, r );
        od;
    od;

    # read of pc presentation
    pairs := ListX([1..n-1], i -> [1..n-i], function(i,j) return [j, i+j]; end);
    for i in [1..l] do

        # commutators
        for j in [i+1..l] do
            if pairs[i][1] = pairs[j][2] then
                k := Position(pairs, [pairs[j][1], pairs[i][2]]);
                o := [j,1,k,1];
                SetConjugate( c, j, i, o );
            elif pairs[i][2] = pairs[j][1] then
                k := Position(pairs, [pairs[i][1], pairs[j][2]]);
                o := [j,1,k,-1];
                if p > 0 then o[4] := o[4] mod p; fi;
                SetConjugate( c, j, i, o );
            else
                # commutator is trivial
            fi;
        od;

        # powers
        if p > 0 then
            SetRelativeOrder( c, i, p );
        fi;
    od;

    # translate from collector to group
    UpdatePolycyclicCollector( c );
    G := PcpGroupByCollectorNC( c );
    G!.mats := g;

    # check
    # IsConfluent(c);

    return G;
end );

#############################################################################
##
#M SubgroupUnitriangularPcpGroup( mats )
##
InstallGlobalFunction( SubgroupUnitriangularPcpGroup, function( mats )
    local n, p, G, g, i, j, r, h, m, e, v, c;

    # get the dimension, the char and the full unitriangluar group
    n := Length( mats[1] );
    p := Characteristic( mats[1][1][1] );
    G := UnitriangularPcpGroup( n, p );

    # compute corresponding generators
    g := [];
    for i in [1..n-1] do
        for j in [1..n-i] do
            r := IdentityMat( n );
            r[j][i+j] := 1;
            Add( g, r );
        od;
    od;

    # get exponents for each matrix
    h := [];
    for m in mats do
        e := [];
        c := 0;
        for i in [1..n-1] do
            v := List( [1..n-i], x -> m[x][x+i] );
            r := MappedVector( v, g{[c+1..c+n-i]} );
            m := r^-1 * m;
            c := c + n-i;
            Append( e, v );
        od;
        Add( h, MappedVector( e, Pcp(G) ) );
    od;

    return Subgroup( G, h );
end );

#############################################################################
##
#M HeisenbergPcpGroup( m )
##
InstallGlobalFunction( HeisenbergPcpGroup, function( m )
    local FLT, i;
    FLT := FromTheLeftCollector( 2*m+1 );
    for i in [1..m] do
        SetConjugate( FLT, m+i, i, [m+i, 1, 2*m+1, 1] );
    od;
    UpdatePolycyclicCollector( FLT );
    return PcpGroupByCollectorNC( FLT );
end );

#############################################################################
##
#M MaximalOrderByUnitsPcpGroup(f)
##
InstallGlobalFunction( MaximalOrderByUnitsPcpGroup, function(f)
    local m, F, O, U, i, G, u, a;

    # check
    if Length(Factors(f)) > 1 then return fail; fi;

    # create field
    m := CompanionMat(f);
    F := FieldByMatricesNC([m]);

    # get order and units
    O := MaximalOrderBasis(F);
    U := UnitGroup(F);

    # get pcp groups
    i := IsomorphismPcpGroup(U);
    G := Image(i);

    # get action of U on O
    u := List( Pcp(G), x -> PreImagesRepresentative(i,x) );
    a := List( u, x -> List( O, y -> Coefficients(O, y*x)));

    # return split extension
    return SplitExtensionPcpGroup( G, a );
end);

#############################################################################
##
#F PDepth(G, e)
##
PDepth := function(G, e)
    local l, i;
    l := PCentralSeries(G);
    for i in Reversed([1..Length(l)]) do
        if e in l[i] then
            return i;
        fi;
    od;
end;

#############################################################################
##
#F BlowUpPcpPGroup(G)
##
BlowUpPcpPGroup := function(G)
    local p, e, f, c, i, j, k;

    # set up
    p := PrimePGroup(G);
    e := ShallowCopy(AsList(G));
    f := function(a,b) return PDepth(G,a)<PDepth(G,b); end;
    Sort(e, f);

    # fill up collector
    c := FromTheLeftCollector(Length(e)-1);
    for i in [1..Length(e)-1] do
        SetRelativeOrder(c,i,p);

        # power
        j := Position(e, e[i]^p);
        if j < Length(e) then
            SetPower(c,i,[j,1]);
        fi;

        # commutators
        for k in [1..i-1] do
            j := Position(e, Comm(e[i], e[k]));
            if j < Length(e) then
                SetCommutator(c,i,k,[j,1]);
            fi;
        od;
    od;
    return PcpGroupByCollector(c);
end;

