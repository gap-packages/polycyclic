NewUnitriangularPcpGroup := function( n, F )
    local base, gens, exps, coll, d, m, p, i, j, k, r, a, b, o, c, t, G, H;
 
    # get arguments
    base := Basis(F);
    d := Length(base);
    m := d*n*(n-1)/2;
    p := Characteristic(F);

    # set up 
    gens := [];
    exps := [];
    coll := FromTheLeftCollector( m );

    # matrix generators
    for i in [1..n-1] do
        for j in [1..n-i] do
            for k in [1..d] do
                r := IdentityMat( n );
                r[j][i+j] := base[k];
                r := r * One(F);
                Add( gens, r );
                Add( exps, [j,i+j,k] );
            od;
        od;
    od;

    # pc group
    for i in [1..m] do
        SetRelativeOrder( coll, i, p ); 

        # commutators
        for j in [i+1..m] do
            a := exps[i];
            b := exps[j];
            o := false;
            
            if a[1] = b[2] then 
                c := Coefficients(base, base[a[3]]*base[b[3]]);
                t := First([1..m],x -> exps[x]{[1,2]}=[b[1],a[2]])-1;
                o := [j,1];
                for k in [1..d] do
                    if c[k] <> 0*c[k] then 
                        Append(o, [t+k, IntFFE(c[k])]);
                    fi;
                od;
            elif a[2] = b[1] then 
                c := Coefficients(base, -base[a[3]]*base[b[3]]);
                t := First([1..Length(exps)],x->exps[x]{[1,2]}=[a[1],b[2]])-1;
                o := [j,1];
                for k in [1..d] do
                    if c[k] <> 0*c[k] then 
                        Append(o, [t+k, IntFFE(c[k])]);
                    fi;
                od;
            fi;

            if not IsBool(o) then SetConjugate( coll, j, i, o ); fi;
        od;
    od;

    # translate from collector to group
    UpdatePolycyclicCollector( coll );
    #if not IsConfluent(coll) then Error("collector not confluent"); fi;
    G := PcpGroupByCollectorNC( coll );
    H := Group(gens);
    G!.mats := gens;
    G!.isomorphism := GroupHomomorphismByImagesNC( G, H, Igs(G), gens);
    #if not IsPcpGroupHomomorphism(G!.isomorphism) then Error("no isom"); fi;

    return G;
end;


