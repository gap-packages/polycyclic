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
## Apply GcdPcp( g, h ), and apply the same operations on i and j.
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

        t := x * y ^ -q;
        x := y;
        y := t;

        u := z * w ^ -q;
        z := w;
        w := u;

        r := a - q * b;
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
    local i, j, a, b, q, ci, cg;
    ci := [];
    cg := [];
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
                        AddSet( ci, j );
                    fi;
                fi;
            od;
            for j in [ 1 .. Length( gen ) ] do
                a := Exponents( gen[j] )[i];
                q := QuoInt( a, b );
                if q <> 0 then
                    gen[j] := gen[j] * ind[i] ^ (- q);
                    pgen[j] := pgen[j] * indd[i] ^ (- q);
                    AddSet( cg, j );
                fi;
            od;
        fi;
    od;
    return [ ci, cg ];
end );

#############################################################################
##
#F ReduceExpoElmPara( ind, g, indd, gg, rel )
##
## Parallel version of  ReduceExpoElm.
##
BindGlobal( "ReduceExpoElmPara", function ( ind, g, indd, gg, rel )
    local i, q;
    for i in [ Depth( g ) .. Length( ind ) ] do
        if not IsBool( ind[i] ) and rel[i] = 0 then
            q := QuoInt( Exponents( g )[i], LeadingExponent( ind[i] ) );
            if q <> 0 then
                g  := g  * ind[i]  ^ (- q);
                gg := gg * indd[i] ^ (- q);
            fi;
        fi;
    od;
    return [ g, gg ];
end );

#############################################################################
##
#F AddToIgsParallel( <pcs>, <gens>, <ppcs>, <pgens> )
##
## This function adds the elements in <gens> to the induced pcs <pcs>.
## It acts simultaneously on <pcs> and <ppcs> as well as <gens> and <pgens>.
## See AddToIgs for the algorithm.
##
InstallGlobalFunction( AddToIgsParallel,
function( pcs, gens, ppcs, pgens )
    local coll, rels, n, inf, bnd, c, ind, indd, pows, ppows, sub, keep, idx,
          queue, pqueue, qpos, todo, tododo, val, added, g, gg, d, f, h, hh,
          a, b, q, r, k, nrmd, pairs, oldc, chg, t, i, j;

    if Length( gens ) = 0 then return [pcs, ppcs]; fi;

    # get information
    coll := Collector( gens[1] );
    rels := RelativeOrders( coll );
    n    := NumberOfGenerators( coll );
    inf  := 0 in rels;
    bnd  := fail;

    # set up; pows[d] and ppows[d] cache negative powers of ind[d], indd[d]
    ind  := ListWithIdenticalEntries(n, false);
    indd := ListWithIdenticalEntries(n, false);
    for i in [1..Length(pcs)] do
        d := Depth( pcs[i] );
        ind[d]  := pcs[i];
        indd[d] := ppcs[i];
    od;
    pows  := List([1..n], i -> []);
    ppows := List([1..n], i -> []);
    c     := TailLimit(ind, n+1);

    # gens wait in queue, keeping the first of equal elements; todo holds
    # powers and commutators
    sub   := Filtered([1..Length(gens)], i -> Depth(gens[i]) < c);
    queue := gens{sub};
    StableSortParallel(queue, sub);
    keep  := Filtered([1..Length(sub)], i -> i = 1 or queue[i] <> queue[i-1]);
    sub   := Set(sub{keep});
    queue  := gens{sub};
    pqueue := pgens{sub};
    idx := [1..Length(sub)];
    StableSortParallel(List(queue, IGSValFun), idx);
    queue  := queue{idx};
    pqueue := pqueue{idx};
    qpos   := 1;
    todo   := [];
    tododo := [];
    val    := [];
    added  := false;

    while c > 1 do

        # take the next element, from queue only once todo is empty
        if Length( todo ) > 0 then
            j  := PositionMinimum(val);
            g  := Remove(todo, j);
            gg := Remove(tododo, j);
            Remove(val, j);
        else
            while qpos <= Length(queue) and Depth(queue[qpos]) >= c do
                qpos := qpos+1;
            od;
            if qpos > Length(queue) then break; fi;
            g  := queue[qpos];
            gg := pqueue[qpos];
            qpos := qpos+1;
            # sifting g unreduced can blow up its exponents
            if inf then
                pairs := ReduceExpoElmPara(ind, g, indd, gg, rels);
                g  := pairs[1];
                gg := pairs[2];
            fi;
        fi;
        d := Depth( g );
        f := [];

        # shift g into ind
        while d < c do

            h  := ind[d];
            hh := indd[d];
            if IsBool( h ) then
                nrmd := NormedPcpElementPara( g, gg );
                ind[d]  := nrmd[1];
                indd[d] := nrmd[2];
                pows[d]  := [];
                ppows[d] := [];
                AddSet(f,d);
                h  := ind[d];
                hh := indd[d];
            fi;
            if g = h then
                g  := g^0;
                gg := gg^0;
            else
                a := LeadingExponent(g);
                b := LeadingExponent(h);
                if a > 0 and b > 0 and a mod b = 0 then
                    # GcdPcpPara would leave h and hh unchanged
                    q  := a/b;
                    g  := g  * IgsNegativePower(ind,  pows,  d, q);
                    gg := gg * IgsNegativePower(indd, ppows, d, q);
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
                        pows[d]  := [];
                        ppows[d] := [];
                        AddSet(f, d);
                    fi;
                fi;
            fi;
            d := Depth(g);
        od;

        # adjusting is a no-op unless ind or todo changed
        if Length(f) = 0 and not added then continue; fi;

        # adjust
        oldc := c;
        c := TailLimit(ind, c);
        chg := [];
        if inf then
            t := ReduceExpoPara(ind, todo, indd, tododo, rels);
            for i in t[1] do
                pows[i]  := [];
                ppows[i] := [];
            od;
            chg := t[2];
            for i in chg do
                if Depth(todo[i]) < c then val[i] := IGSValFun(todo[i]); fi;
            od;
        fi;

        # add powers and commutators
        added := false;
        for d in f do
            g :=  ind[d];
            gg := indd[d];
            # skip infinite factors and powers in the tail
            if d < c-1 and rels[d] > 0 then
                r := RelativeOrderPcp(g);
                k := g ^ r;
                if Depth(k) < c then
                    Add(todo,   k);
                    Add(tododo, gg^r);
                    Add(val, IGSValFun(k));
                    added := true;
                fi;
            fi;
            for j in [1..n] do
                # skip trivial commutators and those in the tail
                if j = d or Minimum( d, j ) >= c-1 or IsBool(ind[j]) then
                    continue;
                fi;
                if bnd = fail then bnd := CommutatorDepthBounds(coll); fi;
                if bnd[Minimum(d, j)][Maximum(d, j)] >= c then continue; fi;
                k := Comm(g, ind[j]);
                if Depth(k) < c then
                    Add(todo, k);
                    Add(tododo, Comm(gg, indd[j]));
                    Add(val, IGSValFun(k));
                    added := true;
                fi;
                if rels[j] = 0 then
                    k := Comm(g, ind[j]^-1);
                    if Depth(k) < c then
                        Add(todo, k);
                        Add(tododo, Comm(gg, indd[j]^-1));
                        Add(val, IGSValFun(k));
                        added := true;
                    fi;
                fi;
            od;
        od;

        # reduce
        if c < oldc or Length(chg) > 0 then
            t      := Filtered([1..Length(todo)], i -> Depth(todo[i]) < c);
            todo   := todo{t};
            tododo := tododo{t};
            val    := val{t};
        fi;
        Info(InfoPcpGrp, 3, Length(todo)," versus ", ind);
    od;

    # return resulting lists
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
