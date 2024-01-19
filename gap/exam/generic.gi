#############################################################################
##
#W  generic.gi                   Polycyc                         Bettina Eick
##

#############################################################################
##
#M AbelianPcpGroup
##
InstallGlobalFunction( AbelianPcpGroup, function( arg )
    local r, n;

    # catch arguments
    if Length(arg) = 1 and IsInt(arg[1]) then
      r:= ListWithIdenticalEntries(arg[1], 0);
    elif Length(arg) = 1 and IsList(arg[1]) then
      r:= arg[1];
    elif Length(arg) = 2 then
      n:= arg[1];
      r:= arg[2];
      if n < Length(r) then
        r:= r{[1..n]};
      elif Length(r) < n then
        r:= Concatenation(r, ListWithIdenticalEntries(n-Length(r), 0));
      fi;
    fi;

    # construct group
    return AbelianGroupCons(IsPcpGroup, r);
end );

#############################################################################
##
#M DihedralPcpGroup
##
InstallGlobalFunction( DihedralPcpGroup, function( n )
    if n = 0 then
      n:= infinity;
    fi;
    return DihedralGroupCons( IsPcpGroup, n );
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
    u := List( Pcp(G), x -> PreImagesRepresentativeNC(i,x) );
    a := List( u, x -> List( O, y -> Coefficients(O, y*x)));

    # return split extension
    return SplitExtensionPcpGroup( G, a );
end);

#############################################################################
##
#F PDepth(G, e)
##
BindGlobal( "PDepth", function(G, e)
    local l, i;
    l := PCentralSeries(G);
    for i in Reversed([1..Length(l)]) do
        if e in l[i] then
            return i;
        fi;
    od;
end );

#############################################################################
##
#F BlowUpPcpPGroup(G)
##
BindGlobal( "BlowUpPcpPGroup", function(G)
    local p, e, f, c, i, j, k;

    # set up
    p := PrimePGroup(G);
    e := ShallowCopy(AsList(G));
    SortBy(e, a -> PDepth(G, a));

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
end );

