#############################################################################
##
#F ExtensionCR( A, c ) . . . . . . . . . . . . . . . . . . . . .one extension
##
InstallGlobalFunction( ExtensionCR, function( A, c )
    local n, m, coll, i, j, g, e, r, o, x, k, v, G, rels;

    # get dimensions
    n := Length( A.mats );
    m := A.dim;
    rels := RelativeOrdersOfPcp( A.factor );

    # in case c is ffe
    if IsBool( c ) then c := List( [1..m*Length(A.enumrels)], x -> 0 ); fi;
    if Length( c ) > 0 and IsFFE( c[1] ) then c := IntVecFFE(c); fi;

    # the free group
    coll := FromTheLeftCollector( n+m );
    
    # the relators of G
    for i in [1..Length(A.enumrels)] do
        e := A.enumrels[i];
        r := VectorOfWordCR( A.relators[e[1]][e[2]], n );
        v := c{[(i-1)*m+1..i*m]};
        Append(r, v);
        o := ObjByExponents( coll, r );
        
        if e[1] = e[2] then
            SetRelativeOrder( coll, e[1], rels[e[1]] );
            SetPower( coll, e[1], o );
        elif e[1] > e[2] then
            SetConjugate( coll, e[1], e[2], o );
        else
            SetConjugate( coll, e[1], -e[2]+e[1], o );
        fi;
    od;
        
    # power relators of A
    if A.char > 0 then
        for i in [n+1..n+m] do
            SetRelativeOrder( coll, i, A.char );
        od;
    fi;

    # conjugate relators - G acts on A
    for i in [1..n] do
        for j in [n+1..n+m] do
            x := List( [1..n], x -> 0 );
            if A.char = 0 then
                Append( x, A.mats[i][j-n] );
            else
                Append( x, IntVecFFE( A.mats[i][j-n] ) );
            fi;
            SetConjugate( coll, j, i, ObjByExponents( coll, x ) );
        od;
    od;
    
    UpdatePolycyclicCollector( coll );
    G := PcpGroupByCollectorNC( coll );
    G!.module := Subgroup( G, Igs(G){[n+1..n+m]} );
    return G;
 
end );

#############################################################################
##
#F ExtensionsCR( C ) . . . . . . . . . . . . . . . . . . . . . all extensions
##
ExtensionsCR := function( C )
    local cc, new, elm, rel;

    # compute cocycles
    cc := TwoCocyclesCR( C );

    # if there are infinitely many extensions
    if C.char = 0 and Length( cc ) > 0 then
        Print("infinitely many extensions \n");
        return fail;
    fi;

    # otherwise compute all elements
    new := [];
    if Length( cc ) = 0 then
        elm := ExtensionCR( C, false );
        Add( new, elm );
    else
        rel := ExponentsByRels( List( cc, x -> C.char ) );
        elm := List( rel, x -> IntVector( x * cc ) );
        elm := List( elm, x -> ExtensionCR( C, x ) );
        Append( new, elm );
    fi;
    return new;
end;

#############################################################################
##
#F ExtensionClassesCR( C ) . . . . . . . . . . . . . .  all up to equivalence
##
ExtensionClassesCR := function( C )
    local cc, elms;

    # compute H^2( U, A/B ) and return if there is no complement
    cc := TwoCohomologyCR( C );
    if IsBool( cc ) then return []; fi;

    # check the finiteness of H^1
    if ForAny( cc.factor.rels, x -> x = 0 ) then
        Print("infinitely many extensions \n");
        return fail;
    fi;

    # catch a trivial case
    if Length( cc.factor.rels ) = 0 then 
        return [ ExtensionCR( C, false ) ];
    fi;

    # create elements of cc.factor
    elms := ExponentsByRels( cc.factor.rels );
    if C.char > 0 then elms := elms * One( C.field ); fi;


    # loop over orbit and extract information
    return List( elms, x -> ExtensionCR( C, IntVector( x * cc.factor.prei )));
end;


#############################################################################
##
#F SplitExtensionPcpGroup( G, mats ) . . . . . . . . . . . . . . .G split Z^n
##
SplitExtensionPcpGroup := function( G, mats )
    return ExtensionCR( CRRecordByMats( G, mats ), false );
end;

#############################################################################
##
#F SplitExtensionByAutomorphisms( G, H, auts )
##
SplitExtensionByAutomorphisms := function( G, H, auts )
    local g, h, n, m, rg, rh, zn, zm, coll, o, i, j, k;

    # get dimensions
    g := Pcp(G);
    h := Pcp(H);
    n := Length( g );
    m := Length( h );
    rg := RelativeOrdersOfPcp( g );
    rh := RelativeOrdersOfPcp( h );
    zn := List( [1..n], x -> 0 );
    zm := List( [1..m], x -> 0 );

    # the free group
    coll := FromTheLeftCollector( n+m );

    # the relators of G
    for i in [1..n] do
        for j in [i..n] do
            if i = j then 
                if rg[i] > 0 then
                    o := Exponents( g[i]^rg[i] );
                    o := ObjByExponents( coll, Concatenation( zm, o ) );
                    SetRelativeOrder( coll, m+i, rg[i] );
                    SetPower( coll, m+i, o );
                fi;
            else
                o := Exponents( g[j]^g[i] );
                o := ObjByExponents( coll, Concatenation( zm, o ) );
                SetConjugate( coll, m+j, m+i, o );
            fi;
        od;
    od;
   
    # the relators of H
    for i in [1..m] do
        for j in [i..m] do
            if i = j then 
                if rh[i] > 0 then 
                    o := Exponents( h[i]^rh[i] );
                    o := ObjByExponents( coll, Concatenation( o, zn ) );
                    SetRelativeOrder( coll, i, rh[i] );
                    SetPower( coll, i, o );
                fi;
            else
                o := Exponents( h[j]^h[i] );
                o := ObjByExponents( coll, Concatenation( o, zn ) );
                SetConjugate( coll, j, i, o );
            fi;
        od;
    od;

    # the action of H on G
    for i in [1..m] do
        k := List( g, x -> Image( auts[i], x ) );
        for j in [1..n] do
            o := Exponents( k[j] );
            o := ObjByExponents( coll, Concatenation( zm, o ) );
            SetConjugate( coll, m+j, i, o );
        od;
    od;

    UpdatePolycyclicCollector(coll);
    G := PcpGroupByCollectorNC( coll );
    return G;
end;

