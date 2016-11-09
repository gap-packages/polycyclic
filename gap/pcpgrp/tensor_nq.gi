##
## This file contains code to compute non-abelian tensor squares
## of nilpotent groups via nq, by brute force.
##
## This is used by the function CheckGroupsByOrder to verify that
## the polycyclic NonAbelianTensorSquare operation yields correct
## results for groups in the small groups library.
##
## Note that this code is not loaded by polycyclic, it is only here
## for reference and debugging purposes.
## 

# We need NqEpimorphismNilpotentQuotient from nq


#############################################################################
##
#F NonAbelianTensorSquareFp(G) . . . . . . . . . . . . . . . . . (G otimes G)
##
NonAbelianTensorSquareFp := function(G)
    local e, F, f, r, i, j, k, a, b1, b2, b, c, c1, c2, T, t;

    if not IsFinite(G) then return fail; fi;

    # set up
    e := Elements(G);
    F := FreeGroup(Length(e)^2);
    f := GeneratorsOfGroup(F);
    r := [];

    # collect relators
    for i in [1..Length(e)] do
        for j in [1..Length(e)] do
            for k in [1..Length(e)] do

                # e[i]*e[j] tensor e[k]
                a := Position(e, e[i]*e[j]);
                a := (a-1)*Length(e)+k;
                b1 := Position(e, e[i]*e[j]*e[i]^-1);
                b2 := Position(e, e[i]*e[k]*e[i]^-1);
                b := (b1-1)*Length(e)+b2;
                c := (i-1)*Length(e)+k;
                Add(r, f[a]/(f[b]*f[c]));

                # e[i] tensor e[j]*e[k]
                a := Position(e, e[j]*e[k]);
                a := (i-1)*Length(e)+a;
                b := (i-1)*Length(e)+j;
                c1 := Position(e, e[j]*e[i]*e[j]^-1);
                c2 := Position(e, e[j]*e[k]*e[j]^-1);
                c := (c1-1)*Length(e)+c2;
                Add(r, f[a]/(f[b]*f[c]));
            od;
        od;
    od;

    # the tensor
    T := F/r;
    t := GeneratorsOfGroup(T);
    T!.elements := e;
    T!.group := G;
    return T;
end;


#############################################################################
##
#F NonAbelianTensorSquarePlusFp(G)  . . . . . .(G otimes G) split (G times G)
##
NonAbelianTensorSquarePlusFp := function(G)
    local IComm, IActs, g, e, n, F, f, r, i, j, k, w, v, M, m, u;

    IComm := function(g,h) return g*h*g^-1*h^-1; end;
    IActs := function(g,h) return h*g*h^-1; end;

    # set up
    g := Igs(G);
    n := Length(g);
    e := List(g, RelativeOrderPcp);

    # construct
    F := FreeGroup(2*n);
    f := GeneratorsOfGroup(F);
    r := [];

    # relators of GxG
    for i in [1..n] do

        # powers
        w := Exponents(g[i]^e[i]);
        Add(r, f[i]^e[i] / MappedVector( w, f{[1..n]}) );
        Add(r, f[n+i]^e[i] / MappedVector( w, f{[n+1..2*n]}) );

        # commutators
        for j in [1..i-1] do
            w := Exponents(Comm(g[i], g[j]));
            Add(r, Comm(f[i],f[j]) / MappedVector( w, f{[1..n]}) );
            Add(r, Comm(f[n+i],f[n+j]) / MappedVector( w, f{[n+1..2*n]}) );
        od;
    od;

    # commutator-relators
    for i in [1..n] do
        for j in [1..n] do
            for k in [1..n] do

                # the right hand side
                v := IComm(IActs(f[i], f[k]), IActs(f[n+j],f[n+k]));

                # the left hand sides
                w := IActs(IComm(f[i], f[n+j]),f[k]);
                Add( r, w/v );

                w := IActs(IComm(f[i], f[n+j]),f[n+k]);
                Add( r, w/v );
            od;
        od;
    od;

    # the tensor square plus as fp group
    M := F/r;

    # the tensor square as subgroup
    m := GeneratorsOfGroup(M);
    u := Flat(List([1..n], x -> List([1..n], y -> IComm(m[x], m[n+y]))));
    M!.tensor := Subgroup(M, u);

    # that's it
    return M;
end;

NonAbelianTensorSquareViaNq := function( G )
    local   tsfp,  phi;

    if LoadPackage("nq") = fail then
        Error( "NQ package is not installed" );
    fi;

    if not IsNilpotent( G ) then
        Error( "NonAbelianTensorSquareViaNq: Group is not nilpotent, ",
               "therefore nq might not terminate\n" );
    fi;

    tsfp := NonAbelianTensorSquarePlusFp( G );
    phi  := NqEpimorphismNilpotentQuotient( tsfp );

    return Image( phi, tsfp!.tensor );
end;


#############################################################################
##
#F CheckGroupsByOrder(n, full)
##
CheckGroupsByOrder := function(n,full)
    local m, i, G, A, B, t;
    m := NumberSmallGroups(n);
    for i in [1..m] do
        G := PcGroupToPcpGroup(SmallGroup(n,i));
        if full or not IsAbelian(G) then
            Print("check ",i,"\n");
            t := Runtime();
            A := NonAbelianTensorSquare(G);
            Print(" ",Runtime() - t, " for pcp method \n");
            if full then
                t := Runtime();
                B := NonAbelianTensorSquareFp(G); Size(B);
                Print(" ",Runtime() - t, " for fp method \n");
                if Size(A) <> Size(B) then Error(n," ",i,"\n"); fi;
            fi;
            Print(" got group of order ",Size(A),"\n\n");
        fi;
    od;
end;

