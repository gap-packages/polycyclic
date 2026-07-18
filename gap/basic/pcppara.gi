#############################################################################
##
#W  pcppara.gi                   Polycyc                         Bettina Eick
#W                                                              Werner Nickel
##
## Parallel versions of the non-commuatative gauss algorithm.
##

#############################################################################
##
#F NormedPcpElementPara( g, gg )
##
## Parallel version of NormedPcpElement.
##
BindGlobal( "NormedPcpElementPara", function( g, gg )
    local e, h, hh;
    e := NormingExponent( g );
    h := g ^ e;
    h!.normed := true;
    hh := gg ^ e;
    return [ h, hh ];
end );

####################################################################
##
#F GcdPcpPara
##
BindGlobal( "GcdPcpPara", function(g, h, i, j)
    local x, y, a, b, q, r, t, z, w, u;

    x := g;
    y := h;

    a := LeadingExponent(x);
    b := LeadingExponent(y);

    z := i;
    w := j;
    
    if a < 0 then
        x := x^-1;
        z := z^-1;
        a := LeadingExponent(x);
    fi;
    if b < 0 then
        y := y^-1;
        w := w^-1;
        b := LeadingExponent(y);
    fi;

    while b <> 0 do
        q := QuoInt(a, b);
        r := a - q * b;

        t := x * y ^ -q;
        x := y;
        y := t;

        u := z * w ^ -q;
        z := w;
        w := u;

        a := b;
        b := r;
    od;

    return [x, y, z, w];
end );

#############################################################################
##
#F ReduceExpoPara( ind, gen, indd, pgen, rel )
##
## Parallel version of  ReduceExpo.
##
BindGlobal( "ReduceExpoPara", function ( ind, gen, indd, pgen, rel )
    local i, j, a, b, q, f, k;
    for i in [ 1 .. Length( ind ) ] do
        if not IsBool( ind[i] ) and rel[i] = 0 then
            b := LeadingExponent( ind[i] );
            for j in [ 1 .. i - 1 ] do
                if not IsBool( ind[j] ) then
                    a := Exponents( ind[j] )[i];
                    q := QuoInt( a, b );
                    if q <> 0 then
                        ind[j] := ind[j] * ind[i] ^ (- q);
                        indd[j] := indd[j] * indd[i] ^ (- q);
                    fi;
                fi;
            od;
            for j in [ 1 .. Length( gen ) ] do
                a := Exponents( gen[j] )[i];
                q := QuoInt( a, b );
                if q <> 0 then
                    gen[j] := gen[j] * ind[i] ^ (- q);
                    pgen[j] := pgen[j] * indd[i] ^ (- q);
                fi;
            od;
        fi;
    od;
    return;
end );

#############################################################################
##
#F AddToIgsParallel( <pcs>, <gens>, <ppcs>, <pgens> )
##
## This function adds the elements in <gens> to the induced pcs <pcs>.
## It acts simultaneously on <pcs> and <ppcs> as well as <gens> and <pgens>.
##
InstallGlobalFunction( AddToIgsParallel,
function( pcs, gens, ppcs, pgens )
    local coll, rels, n, todo, tododo, ind, indd, g, gg, d, h, hh, k,
          e, c, i, r, sub, val, j, f, a, b, nrmd, pairs;

    if Length( gens ) = 0 then return [pcs, ppcs]; fi;

    # get information
    coll := Collector( gens[1] );
    rels := RelativeOrders( coll );
    n    := NumberOfGenerators( coll );
    c    := n+1;

    # set up
    ind  := ListWithIdenticalEntries(n, false);
    indd := ListWithIdenticalEntries(n, false);
    for i in [1..Length(pcs)] do
        d := Depth( pcs[i] );
        ind[d]  := pcs[i];
        indd[d] := ppcs[i];
    od;

    # do a reduction step
    c      := TailLimit(ind, c);
    sub    := Filtered([1..Length(gens)], i -> Depth(gens[i]) < c);
    sub    := Filtered(sub, i -> not gens[i] in gens{[1..i-1]});
    todo   := gens{sub};
    tododo := pgens{sub};
    val    := List(todo, x -> IGSValFun(x));

    # loop over to-do list until it is empty
    while Length( todo ) > 0 and c > 1 do
        j := PositionMinimum(val);
        g  := Remove(todo, j);
        gg := Remove(tododo, j);
        d  := Depth( g );
        f := [];

        # shift g into ind
        while d < c do

            h  := ind[d];
            hh := indd[d];

            # shift in
            if IsBool( h ) then
                nrmd := NormedPcpElementPara( g, gg );
                ind[d]  := nrmd[1];
                indd[d] := nrmd[2];
                AddSet(f,d);
                h  := ind[d];
                hh := indd[d];
            fi;
            if g = h then 
                g  := g^0;
                gg := gg^0;
            else
                pairs := GcdPcpPara(g, h, gg, hh);
                h := pairs[1];
                g := pairs[2];
                hh := pairs[3];
                gg := pairs[4];
                if h <> ind[d] then
                    nrmd := NormedPcpElementPara( h, hh );
                    ind[d]  := nrmd[1];
                    indd[d] := nrmd[2];
                    AddSet(f, d);
                fi;
            fi;
            d := Depth(g);
        od;

        # adjust
        c := TailLimit(ind, c);
        ReduceExpoPara(ind, todo, indd, tododo, rels);

        # add powers and commutators
        for d in f do
            g :=  ind[d];
            gg := indd[d];
            if d < c-1 and rels[d] > 0 then
                r := RelativeOrderPcp(g);
                k := g ^ r;
                if Depth(k) < c then
                    Add(todo,   k);
                    Add(tododo, gg^r);
                fi;
            fi;
            for j in [1..n] do
                if j = d or Minimum( d, j ) >= c-1 then
                    continue;
                fi;
                if not IsBool(ind[j]) then
                    k := Comm(g, ind[j]);
                    if Depth(k) < c then
                        Add(todo, k);
                        Add(tododo, Comm(gg, indd[j]));
                    fi;
                    if rels[j] = 0 then
                        k := Comm(g, ind[j]^-1);
                        if Depth(k) < c then
                            Add(todo, k);
                            Add(tododo, Comm(gg, indd[j]^-1));
                        fi;
                    fi;
                fi;
            od;
        od;

        # reduce
        sub    := Filtered([1..Length(todo)], i -> Depth(todo[i])<c);
        todo   := todo{sub};
        tododo := tododo{sub};
        val    := List(todo, x -> IGSValFun(x));
        Info(InfoPcpGrp, 3, Length(val)," versus ", ind);
    od;

    ind  := Filtered(ind,  x -> not IsBool(x));
    indd := Filtered(indd, x -> not IsBool(x));
    return [ind, indd];
end );

#############################################################################
##
## IgsParallel( <gens>, <pre> )
##
InstallGlobalFunction( IgsParallel, function( gens, pre )
    return AddToIgsParallel( [], gens, [], pre );
end );

#############################################################################
##
## CgsParallel( <gens>, <pre> )
##
## parallel version of Cgs. Note: this function performes an
## induced pcs computation as well.
##
InstallGlobalFunction( CgsParallel, function( gens, pre )
    local   can,  cann,  i,  f,  e,  j,  l,  d,  r, s;

    if Length( gens ) = 0 then return []; fi;

    can  := IgsParallel( gens, pre );
    cann := can[2];
    can  := can[1];

    # first norm leading coefficients
    for i in [1..Length(can)] do
        f := NormingExponent( can[i] );
        can[i]  := can[i]^f;
        cann[i] := cann[i]^f;
    od;

    # reduce entries in matrix
    for i in [1..Length(can)] do
        e := LeadingExponent( can[i] );
        r := Depth( can[i] );
        for j in [1..i-1] do
            l := Exponents( can[j] )[r];
            if l > 0 then
                d := QuoInt( l, e );
                can[j]  := can[j]  * can[i]^-d;
                cann[j] := cann[j] * cann[i]^-d;
            elif l < 0 then
                d := QuoInt( -l, e );
                s := RemInt( -l, e );
                if s = 0 then
                    can[j] := can[j] * can[i]^d;
                    cann[j] := cann[j] * cann[i]^d;
                else
                    can[j] := can[j] * can[i]^(d+1);
                    cann[j] := cann[j] * cann[i]^(d+1);
                fi;

            fi;
        od;
    od;
    return[ can, cann ];
end );
