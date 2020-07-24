#############################################################################
##
#W  pcppcgs.gi                   Polycyc                         Bettina Eick
#W                                                              Werner Nickel
##

#############################################################################
##
## At the moment the pcgs of a pcp group is called pcp. This is to keep
## it separated from the GAP library.
##

#############################################################################
##
#F UpdateCounter( ind, gens, c )  . . . . . . . . . . . . small help function
##
UpdateCounter := function( ind, gens, c )
    local i, g;

    # first reset c by ind
    i := c - 1;
    while i > 0 and not IsBool(ind[i]) and LeadingExponent(ind[i]) = 1 do
        i := i - 1;
    od;

    if IsSortedList(gens) and not IsEmpty(gens) and 
       Depth(gens[Length(gens)]) < i then
        return i + 1;
    fi;

    # now try to add elements from gens
    repeat
        g := First( gens, x -> Depth(x) = i and LeadingExponent(x) = 1 );
        if not IsBool( g ) then
            ind[i] := g;
            i := i - 1;
        fi;
    until IsBool( g );

    # return value for counter
    return i + 1;
end;

#############################################################################
##
#F TailLimit
##
TailLimit := function( ind, c )
    local k, i;
    k := List(ind, x -> not IsBool(x) and LeadingExponent(x)=1);
    i := c-1; while i > 0 and k[i]=true do i := i-1; od; i := i+1;
    return i;
end;

#############################################################################
##
#F ReduceExpo
##
ReduceExpo := function( ind, gen, rel )
    local i, j, a, b, q, f, k;

    for i in [1..Length(ind)] do
        if not IsBool(ind[i]) and rel[i]=0 then
            b := LeadingExponent(ind[i]);
            for j in [1..i-1] do
                if not IsBool( ind[j] ) then
                    a := Exponents(ind[j])[i];
                    q := QuoInt(a,b);
                    if q <> 0 then
                        ind[j] := ind[j]*ind[i]^-q;
                    fi;
                fi;
            od;
            for j in [1..Length(gen)] do
                a := Exponents(gen[j])[i];
                q := QuoInt(a,b);
                if q <> 0 then
                    gen[j] := gen[j]*ind[i]^-q;
                fi;
            od;
        fi;
    od;
end;

#############################################################################
##
#F CheckIgs
##
CheckIgs := function( igs, gen )
    local i, g, e, j;
    for i in [1..Length(igs)] do
        g := igs[i]^RelativeOrderPcp(igs[i]);
        e := ExponentsByIgs(igs, g);
        if e = fail then return i; fi;
        for j in [1..i-1] do
            g := Comm(igs[i], igs[j]);
            e := ExponentsByIgs(igs,g);
            if e = fail then return [i,j]; fi;
        od;
    od;
    for i in [1..Length(gen)] do
        e := ExponentsByIgs(igs, gen[i]);
        if e = fail then return [i]; fi;
    od;
    return true;
end;

#############################################################################
##
#F ValFuns
##
IGSValFun1 := function(g) return 0; end;
IGSValFun2 := function(g) return AbsInt(LeadingExponent(g)); end;
IGSValFun3 := function(g)
    return [AbsInt(LeadingExponent(g)),Length(Exponents(g))-Depth(g)];
end;
IGSValFun4 := function(g)
    return [Length(Exponents(g))-Depth(g), AbsInt(LeadingExponent(g))];
end;
IGSValFun := IGSValFun4;

#############################################################################
##
#F AddToIgs( <igs>, <gens> )
##
InstallGlobalFunction(AddToIgs, function(igs, gens)
    local coll, rels, n, c, ind, g, d, todo, val, j, f, h, e, a, k, b, u, t, r;

    if Length(gens) = 0 then return igs; fi;

    # get information
    coll := Collector(gens[1]);
    rels := RelativeOrders(coll);
    n    := NumberOfGenerators(coll);
    c    := n+1;

    # set up
    ind  := ListWithIdenticalEntries(n, false);
    for g in igs do ind[Depth(g)] := g; od;

    # do a reduction step
    c := TailLimit(ind, c);
    todo := Set(Filtered(gens, x -> Depth(x) < c));
    val := List(todo, x -> IGSValFun(x));

    # loop over to-do list until it is empty
    while Length(todo) > 0 and c > 1 do
        j := Position(val, Minimum(val));
        g := Remove(todo, j);
        d := Depth(g);
        f := [];

        # shift g into ind
        while d < c do

            h := ind[d];
            r := FactorOrder(g);
            a := LeadingExponent(g);

            # shift in
            if IsBool(h) then 
                ind[d] := NormedPcpElement(g);
                Add(f,d);
                h := ind[d];
            elif not IsPrime(r) then
                b := LeadingExponent(h);
                e := Gcdex(a, b);
                if e.coeff1 <> 0 then 
                    ind[d] := NormedPcpElement((g^e.coeff1)*(h^e.coeff2));
                    Add(f,d);
                fi;
            fi;

            # divide off
            if g = h then 
                g := g^0;
            else
                b := LeadingExponent(h);
                e := Gcdex(a,b);
                g := g^e.coeff3 * h^e.coeff4;
            fi;
            d := Depth(g);
        od;

        # adjust
        c := TailLimit(ind, c);
        ReduceExpo(ind, todo, rels);

        # add powers and commutators
        for d in f do
            g := ind[d];
            if rels[d] > 0 then
                k := g ^ RelativeOrderPcp(g);
                if Depth(k) < c then Add(todo, k); fi;
            fi;
            for j in [1..c-1] do
                if not IsBool(ind[j]) then
                    k := Comm(g, ind[j]);
                    if Depth(k) < c then Add(todo, k); fi;
                    if rels[j] = 0 then
                        k := Comm(g, ind[j]^-1);
                        if Depth(k) < c then Add(todo, k); fi;
                    fi;
                fi;
            od;
        od;

        # reduce
        todo := Filtered(todo, x -> Depth(x)<c);
        val := List(todo, x -> IGSValFun(x));
        Info(InfoPcpGrp, 3, Length(val)," versus ", ind);
    od;

    # return resulting list
    ind := Filtered(ind, x -> not IsBool(x));
    if CHECK_IGS@ then
        Info(InfoPcpGrp, 1, "checking igs ");
        t := CheckIgs(ind, gens);
        if t <> true then Error("igs is incorrect at ",t); fi;
    fi;
    return ind;
end);

AddToIgs_Old := function(igs, gens)
    local coll, rels, todo, n, ind, g, d, h, k, a, b, e, f, c, i, l;

    if Length(gens) = 0 then return igs; fi;

    # get information
    coll := Collector(gens[1]);
    rels := RelativeOrders(coll);
    n    := NumberOfGenerators(coll);

    # create new list from igs
    ind  := ListWithIdenticalEntries(n, false);
    for g in igs do ind[Depth(g)] := g; od;

    # set counter and add tail as far as possible
    c := UpdateCounter(ind, gens, n+1);

    # create a to-do list and a pointer
    todo := Set(Filtered(gens, x -> Depth(x) < c));

    # loop over to-do list until it is empty
    while Length(todo) > 0 and c > 1 do

        g := Remove(todo);
        d := Depth(g);
        f := [];

        # shift g into ind
        while d < c do
            h := ind[d];
            if IsBool(h) then
                ind[d] := g;
                g := g^0;
                Add(f, d);
            else
                # reduce g with h
                a := LeadingExponent(g);
                b := LeadingExponent(h);
                e := Gcdex(a, b);

                # adjust ind[d] by gcd
                ind[d] := (g^e.coeff1) * (h^e.coeff2);
                if e.coeff1 <> 0 then
                    Add(f, d);
                fi;

                # adjust g
                g := (g^e.coeff3) * (h^e.coeff4);
            fi;
            d := Depth(g);
            c := UpdateCounter(ind, todo, c);
        od;

        # add powers and commutators
        for d in f do
            g := ind[d];
            if d <= Length(rels) and rels[d] > 0 and d < c then
                k := g ^ RelativeOrderPcp(g);
                if Depth(k) < c then Add(todo, k); fi;
            fi;
            for l in [1..n] do
                if not IsBool(ind[l]) and (d < c  or l < c) then
                    k := Comm(g, ind[l]);
                    if Depth(k) < c then Add(todo, k); fi;
                    k := Comm(g, ind[l]^-1);
                    if Depth(k) < c then Add(todo, k); fi;
                fi;
            od;
        od;

        # try sorting
        Sort(todo);

    od;

    # return resulting list
    return Filtered(ind, x -> not IsBool(x));
end;

#############################################################################
##
#F Igs( <gens> )
##
InstallOtherMethod( Igs, [IsList],
function( gens ) return AddToIgs( [], gens ); end );

#############################################################################
##
#F Ngs( <igs> )  . . .  . . . . . . . . . . . . compute normed version of igs
##
InstallOtherMethod( Ngs, [IsList],
function( igs ) return List( igs, x -> NormedPcpElement( x ) ); end );

#############################################################################
##
#F Cgs( <igs> ) . . . . . .. . . . . . . . . compute canonical version of igs
##
InstallOtherMethod( Cgs, [IsList],
function( igs )
    local ind, can, i, e, j, l, d, r, s;

    # first norm leading coefficients
    can := List( igs, x -> NormedPcpElement( x ) );

    # reduce entries in matrix
    for i in [1..Length(can)] do
        e := LeadingExponent( can[i] );
        d := Depth( can[i] );
        for j in [1..i-1] do
            l := Exponents( can[j] )[d];
            if l > 0 then
                r := QuoInt( l, e );
                can[j] := can[j] * can[i]^-r;
            elif l < 0 then
                r := QuoInt( -l, e );
                s := RemInt( -l, e );
                if s = 0 then
                    can[j] := can[j] * can[i]^r;
                else
                    can[j] := can[j] * can[i]^(r+1);
                fi;
            fi;
        od;
    od;

    # set flag `normed' and return
    for i in [1..Length(can)] do can[i]!.normed := true; od;
    return can;
end );

#############################################################################
##
#F AddIgsToIgs( pcs1, pcs2 );
##
## Combines an igs <pcs2> of a normal subgroup with an igs <pcs1> of a
## factor. Typically, <pcs1> is induced wrt to a pcp and <pcs2> is the
## denominator of this pcp.
##
# FIXME: This function is documented and should be turned into a GlobalFunction
AddIgsToIgs := function( pcs1, pcs2 )
    local coll, rels, n, ind, todo, g, c, h, eg, eh, e, d;

    if Length( pcs1 ) = 0 then
        return AsList( pcs2 );
    elif Length( pcs2 ) = 0 then
        return AsList( pcs1 );
    elif Depth( pcs1[Length(pcs1)] ) < Depth( pcs2[1] ) then
        return Concatenation( AsList( pcs1 ), AsList( pcs2 ) );
    elif Depth( pcs2[Length(pcs2)] ) < Depth( pcs1[1] ) then
        return Concatenation( AsList( pcs2 ), AsList( pcs1 ) );
    fi;

    # merge the two pcs'
    coll := Collector( pcs1[1] );
    rels := RelativeOrders( coll );
    n    := NumberOfGenerators( coll );
    ind  := List( [1..n], x -> false );
    todo := [];
    for g in pcs2 do ind[Depth(g)] := g; od;
    for g in pcs1 do
        if IsBool( ind[Depth(g)] ) then
            ind[Depth(g)] := g;
        else
            Add( todo, g );
        fi;
    od;

    # set counter
    c := UpdateCounter( ind, todo, n+1 );

    # create a to-do list and a pointer
    todo := Filtered( todo, x -> Depth( x ) < c );

    # loop over to-do list until it is empty
    while Length( todo ) > 0 and c > 1 do
        g := Remove(todo);
        d := Depth( g );

        # shift g into ind
        while d < c do
            h := ind[d];
            if not IsBool( h ) then

                # reduce g with h
                eg := LeadingExponent( g );
                eh := LeadingExponent( h );
                e  := Gcdex( eg, eh );

                # adjust g and ind[d] by gcd
                ind[d] := (g^e.coeff1) * (h^e.coeff2);
                g      := (g^e.coeff3) * (h^e.coeff4);
            else
                ind[d] := g;
                g      := g^0;
            fi;
            c := UpdateCounter( ind, todo, c );
            d := Depth( g );
        od;
    od;
    return Filtered( ind, x -> not IsBool( x ) );
end;

#############################################################################
##
#F ModuloInfo( igsH, igsN )
##
## igsH and igsN are igs'ses for H and N. We assume N <= H and N normal
## in H. The function computes information for the factor H/N.
##
ModuloInfo := function( igsH, igsN )
    local depN, gens, rels, h, r, j, l, e;

    depN := List( igsN, Depth );
    gens := [];
    rels := [];

    # get modulo generators and their relative orders
    for h in igsH do
        r := RelativeOrderPcp( h );
        j := PositionSet( depN, Depth(h) );
        if IsBool( j ) then
            Add( rels, r );
            Add( gens, h );
        elif r > 0 then
            if not IsPrime( r ) then
                l := RelativeOrderPcp( igsN[j] );
                if l <> r then
                    Add( rels, r / l );
                    Add( gens, h );
                fi;
            fi;
        else
            e := AbsInt( LeadingExponent( igsN[j] ) / LeadingExponent( h ) );
            if e > 1 then
                Add( rels, e );
                Add( gens, h );
            fi;
        fi;
    od;

    return rec( gens := gens, rels := rels );
end;

#############################################################################
##
#F CyclicDecomposition( pcp )
##
CyclicDecomposition := function( pcp )
    local  rels, n, mat, i, row, new, cyc, ord, chg, inv, g, tmp, imgs, prei;

    # catch a trivial case
    if Length( pcp ) = 0 then
        return rec( gens := [], rels := [], chg  := [], inv := [] );
    fi;

    # set up
    rels := RelativeOrdersOfPcp( pcp );
    n    := Length( pcp );

    # create relator matrix for power relators - this is in upper
    # triangular form
    mat := [];
    for i in [1..n] do
        if rels[i] > 0 then
            row := ExponentsByPcp( pcp, pcp[i]^rels[i] );
            row[i] := row[i] - rels[i];
            Add( mat, row );
        else
            Add( mat, List( [1..n], x -> 0 ) );
        fi;
    od;

    # solve matrix
    # new := SmithNormalFormSQ( mat );
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
            g := MappedVector( prei[i], pcp );
            Add( cyc, g );
            Add( ord, new.normal[i][i] );
            Add( chg, prei[i] );
            if new.normal[i][i] > 0 then
                Add( inv, List( imgs[i], x -> x mod new.normal[i][i] ) );
            else
                Add( inv, imgs[i] );
            fi;
        fi;
    od;
    return rec( gens := cyc,
                rels := ord,
                chg  := chg,
                inv  := TransposedMat( inv ) );
end;

#############################################################################
##
#F AddTailInfo( pcp ) . . . . . . .
##
##           The info in pcp!.tail is used to compute exponent vectors.
##           1.) pcp!.tail is a list, then exponents are just looked up.
##           2.) pcp!.tail is an integer, then the computation of exponents
##               stops at pcp!.tail-1;
##
AddTailInfo := function( pcp )
    local gens, sub, n, deps, depg, i, d, mult;

    gens := pcp!.gens;
    sub  := pcp!.denom;

    # if there are no gens, then it does not matter
    if Length( gens ) = 0 then return; fi;
    n := NumberOfGenerators( Collector( gens[1] ) );

    # get depths
    deps := List( sub, Depth );
    depg := List( gens, Depth );
    # if not IsSortedList( deps ) then Error("add tail info"); fi;

    # set tail to an integer 
    pcp!.tail := Maximum( depg ) + 1;

    # FIXME: the remainder of this function does not what it is supposed to
    # do, so we skip it for now
    return;

    if not IsSortedList( deps ) then return; fi;

    # now figure out whether we can do better
    for i in [1..Length(sub)] do
        if deps[i] < pcp!.tail - 1 then
           d := IsPowerOfGenerator( sub[i], pcp!.tail );
           if IsBool( d ) then return; fi;
        fi;
    od;

    # add multiplication list
    mult := [];
    for i in [1..Length(gens)] do
        if depg[i] < pcp!.tail then
           d := IsPowerOfGenerator( gens[i], pcp!.tail );
           if IsBool( d ) then return; fi;
           Add( mult, d );
        fi;
    od;

    # if we arrive here, then we may read off exponents
    pcp!.tail := depg;
    if ForAny( mult, x -> x <> 1 ) then pcp!.mult := mult; fi;
end;

#############################################################################
##
#F Creation function for pcp's.
##
## Pcp( U )                         pcp for U
## Pcp( U, N )                      pcp for U mod N
## Pcp( U, "snf" )                  pcp for abelian group U in SNF
## Pcp( U, N, "snf" )               pcp for abelian factor U mod N in SNF
##
InstallGlobalFunction( Pcp, function( arg )
    local U, gens, rels, denom, numer, info, pcp;

    # catch arguments U and N
    U := arg[1];
    if Length( arg ) = 1 or IsString( arg[2] ) then
        denom := [];
    elif Length( arg ) > 1 and IsGroup( arg[2] ) then
        denom := arg[2];
    fi;

    # do we want to norm the pcs or make it canonical?
    if USE_CANONICAL_PCS@ then
        numer := Cgs( U );
        denom := Cgs( denom );
    elif USE_NORMED_PCS@ then
        numer := Ngs( U );
        denom := Ngs( denom );
    else
        numer := Igs( U );
        denom := Igs( denom );
    fi;

    # set up modulo info
    if Length( denom ) > 0 then
        info  := ModuloInfo( numer, denom );
        gens  := info.gens;
        rels  := info.rels;
    else
        gens  := numer;
        rels  := List( gens, RelativeOrderPcp );
    fi;

    # create pcp record and objectify
    pcp := rec( gens  := gens,
                rels  := rels,
                denom := denom,
                numer := numer,
                one   := One( U ),
                group := U );

    pcp := Objectify( PcpType, pcp );

    # add info on tails
    AddTailInfo( pcp );

    # add info on snf if desired
    if arg[Length(arg)] = "snf" then
        pcp!.cyc := CyclicDecomposition( pcp );
    fi;

    # return
    return pcp;
end );

#############################################################################
##
#F Basic attributes and properties - for IsPcpRep
##
InstallGlobalFunction( RelativeOrdersOfPcp, function( pcp )
    if IsBound( pcp!.cyc ) then
        return pcp!.cyc.rels;
    else
        return pcp!.rels;
    fi;
end );

InstallGlobalFunction( GeneratorsOfPcp, function( pcp )
    if IsBound( pcp!.cyc ) then
        return pcp!.cyc.gens;
    else
        return pcp!.gens;
    fi;
end );

InstallGlobalFunction( DenominatorOfPcp, pcp -> pcp!.denom );
InstallGlobalFunction( NumeratorOfPcp,   pcp -> pcp!.numer );
InstallGlobalFunction( OneOfPcp,         pcp -> pcp!.one );
InstallGlobalFunction( GroupOfPcp,       pcp -> pcp!.group );
InstallGlobalFunction( IsSNFPcp,         pcp -> IsBound(pcp!.cyc) );
InstallGlobalFunction( IsTailPcp,        pcp -> IsList(pcp!.tail) );

#############################################################################
##
#F Higher-level attributes and properties - to make pcp's look like lists
##

#############################################################################
##
#M  Length( <pcp> )
##
InstallOtherMethod( Length, [ IsPcp ],
    pcp -> Length( GeneratorsOfPcp( pcp ) ) );


#############################################################################
##
#M  AsList( <pcp> )
##
InstallOtherMethod( AsList, [ IsPcp ],
    pcp -> GeneratorsOfPcp( pcp ) );

#############################################################################
##
#M  Position( <pcp>, <elm>, <from> )
##
InstallOtherMethod( Position,
    [ IsPcp, IsPcpElement, IsInt ],
function( pcp, elm, from )
    return Position( AsList( pcp ), elm, from );
end );

#############################################################################
##
#M  ListOp( pcp, function )
##
InstallOtherMethod( ListOp,
    [ IsPcp, IsObject ],
function( pcp, f )
    return List( AsList(pcp), f );
end );

#############################################################################
##
#M  <pcp> [ <pos> ]
##
InstallOtherMethod( \[\],
    [ IsPcp, IsPosInt ],
function( pcp, pos )
    return GeneratorsOfPcp(pcp)[pos];
end );

#############################################################################
##
#M  <pcp>{[ <pos> ]}
##
InstallOtherMethod( ELMS_LIST, [ IsPcp, IsDenseList ],
function( pcp, ran )
    return GeneratorsOfPcp( pcp ){ran};
end );

#############################################################################
##
#M Print pcp
##
InstallMethod( PrintObj, "for pcp", [IsPcp],
function( pcp )
    Print( "Pcp ", GeneratorsOfPcp( pcp ), " with orders ",
           RelativeOrdersOfPcp(pcp));
end );

InstallMethod( ViewObj, [ IsPcp ], SUM_FLAGS, PrintObj );

#############################################################################
##
#F  small helper
##
WordByExps := function( exp )
    local w, i;
    w := [];
    for i in [1..Length(exp)] do
        if exp[i] <> 0 then
            Add( w, i );
            Add( w, exp[i] );
        fi;
    od;
    return w;
end;

#############################################################################
##
#M a small helper
##
PrintWord := function(gen,exp)
    local w, i, g;
    w := WordByExps(exp);
    if Length(w) = 0 then
        Print("id ");
    else
        for i in [1,3..Length(w)-1] do
            g := Concatenation(gen,String(w[i]));
            if w[i+1] = 1 then
                Print(g);
            else
                Print(g,"^",w[i+1]);
            fi;
            if i < Length(w)-1 then
                Print(" * ");
            fi;
        od;
    fi;
    Print("\n");
end;

#############################################################################
##
#M Print pcp presentation
##
PrintPresentationByPcp := function( pcp, flag )
    local gens, rels, i, r, g, j, h, c;

    gens := GeneratorsOfPcp( pcp );
    rels := RelativeOrdersOfPcp( pcp );

    # print relations
    for i in [1..Length(gens)] do
        if rels[i] > 0 then
            r := rels[i];
            g := gens[i];
            Print("g",i,"^",r," = ");
            PrintWord("g",ExponentsByPcp(pcp, g^r));
        fi;
    od;

    for i in [1..Length(gens)] do
        for j in [1..i-1] do
            g := gens[i];
            h := gens[j];
            c := gens[i]^gens[j];
            if c <> g or flag = "all" then
                Print("g",i," ^ g",j," = ");
                PrintWord("g",ExponentsByPcp(pcp, c));
            fi;
            if rels[j] = 0 or flag = "all" then
                c := gens[i]^(gens[j]^-1);
                if c <> g or flag = "all" then
                    Print("g",i," ^ g",j,"^-1 = ");
                    PrintWord("g",ExponentsByPcp(pcp, c));
                fi;
            fi;
        od;
    od;
end;

#############################################################################
##
#M Print pcp presentation
##
# FIXME: This function is documented and should be turned into a GlobalFunction
PrintPcpPresentation := function( arg )
    local G, flag;
    G := arg[1];
    if Length(arg) = 2 then
        flag := arg[2];
    else
        flag := false;
    fi;
    if IsGroup(G) then
        PrintPresentationByPcp( Pcp(G), flag );
    else
        PrintPresentationByPcp( G, flag );
    fi;
end;

#############################################################################
##
#M GapInputPcpGroup( file, pcp )
##
GapInputPcpGroup := function( file, pcp )
    local gens, rels, i, j, obj;

    gens := GeneratorsOfPcp( pcp );
    rels := RelativeOrdersOfPcp( pcp );
    PrintTo(file, "coll := FromTheLeftCollector( ", Length(gens)," );\n");
    for i in [1..Length(rels)] do
        if rels[i] > 0 then
            obj := WordByExps(ExponentsByPcp( pcp, gens[i]^rels[i] ));
            AppendTo(file, "SetRelativeOrder( coll, ",i,", ",rels[i]," );\n");
            AppendTo(file, "SetPower( coll, ",i,", ",obj," );\n");
        fi;
    od;

    for i in [1..Length(rels)] do
        for j in [1..i-1] do
            obj := WordByExps(ExponentsByPcp( pcp, gens[i]^gens[j] ));
            if obj <> [ i, 1 ] then
                AppendTo(file,
                        "SetConjugate( coll, ",i,", ",j,", ",obj," );\n");
            fi;

            obj := WordByExps(ExponentsByPcp( pcp, gens[i]^(gens[j]^-1) ));
            if obj <> [ i, 1 ] then
                AppendTo(file,
                        "SetConjugate( coll, ",i,", ",-j,", ",obj," );\n");
            fi;
        od;
    od;

    AppendTo(file, "UpdatePolycyclicCollector( coll );\n" );
    AppendTo(file, "G := PcpGroupByCollectorNC( coll ); \n");
    if HasIsNilpotentGroup( GroupOfPcp(pcp) ) and
       IsNilpotentGroup( GroupOfPcp(pcp) ) then
        AppendTo(file, "SetIsNilpotentGroup( G, true );\n" );
    fi;
end;

#############################################################################
##
#M PcpGroupByPcp( pcp )  . . . . . . . . . . . . . . . . . create a new group
##
# FIXME: This function is documented and should be turned into a GlobalFunction
PcpGroupByPcp := function( pcp )
    local g, r, n, coll, i, j, h, e, w, G;

    # write down a presentation
    g := GeneratorsOfPcp( pcp );
    r := RelativeOrdersOfPcp( pcp );
    n := Length( g );

    # create a collector
    coll := FromTheLeftCollector( n );
    for i in [1..n] do
        if r[i] > 0 then
            SetRelativeOrder( coll, i, r[i] );
            h := g[i] ^ r[i];
            e := ExponentsByPcp( pcp, h );
            w := ObjByExponents( coll, e );
            if Length( w ) > 0 then SetPower( coll, i, w ); fi;
        fi;
        for j in [1..i-1] do
            h := g[i]^g[j];
            e := ExponentsByPcp( pcp, h );
            w := ObjByExponents( coll, e );
            if Length( w ) > 0 then SetConjugate( coll, i, j, w ); fi;

            h := g[i]^(g[j]^-1);
            e := ExponentsByPcp( pcp, h );
            w := ObjByExponents( coll, e );
            if Length( w ) > 0 then SetConjugate( coll, i, -j, w ); fi;
        od;
    od;
    UpdatePolycyclicCollector( coll );
    G := PcpGroupByCollectorNC( coll );
    return G;
end;

DisplayPcpGroup :=  function( G )
    local   collector,  gens,  rods,  n,  g,  h,  conj;

    collector := Collector( G );
    gens := Pcp( G );
    rods := RelativeOrdersOfPcp( gens );
    n := Length( gens );

    Print( "<" );
    for g in [1..n] do Print( " ", gens[g] ); od;
    Print( " | \n\n" );
    for g in [1..n] do
        if rods[g] <> 0 then
            ##  print the power relation for g.
            Print( "    ", gens[g], "^", rods[g], " = ",
                   gens[g]^rods[g], "\n" );
        fi;
    od;
    if rods <> 0 * rods then Print( "\n" ); fi;

    for h in [1..n] do
        for g in [1..h-1] do
            conj := gens[h]^gens[g];
            if conj <> gens[h] then
                ##  print the conjuagte relation for h^g.
                Print( "    ", gens[h], "^", gens[g], " = ",
                       gens[h]^gens[g], "\n" );
            fi;
        od;
    od;
    Print( ">\n" );

end;

