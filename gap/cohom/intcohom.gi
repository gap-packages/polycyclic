#############################################################################
##
#W  intcohom.gi                  Polycyc                         Bettina Eick
##

#############################################################################
##
## IntKernelCR( A, sys, lat, bat )
##
BindGlobal( "IntKernelCR", function( A, sys, lat, bat )
    local l, n, d, mat, null;

    # get sizes
    l := Length(sys.base)/sys.dim;
    n := sys.len;
    d := sys.dim;

    # catch two trivial cases
    if n = 0 or l = 0 then return IdentityMat(d*n); fi;

    # transpose and blow up system
    mat := MutableTransposedMat( sys.base );
    Append( mat, DirectSumMat( List( [1..l], x -> lat ) ) );

    # compute kernel
    # Print("  solve system ",Length(mat)," by ",Length(mat[1]),"\n");
    null := PcpNullspaceIntMat( mat );

    # cut and add
    null := List( null, x -> x{[1..d*n]} );
    null := Concatenation( null, bat );

    # find basis
    # Print("  reduce system ",Length(null)," by ",Length(null[1]),"\n");
    return BaseIntMat( null );
end );

#############################################################################
##
#F IntTwoCocycleSystemCR( A )
##
BindGlobal( "IntTwoCocycleSystemCR", function( A )
    local l, d, sys;

    # set up system
    l := Length( A.enumrels );
    d := A.dim;
    sys := CRSystem( d, l, A.char );
    sys.full := true;

    # check
    if not A.char = 0 then return fail; fi;

    AddTwoCocycleEquationsCR( A, sys );

    # return system
    return sys;
end );

#############################################################################
##
#F TwoCohomologyModCR( A, lat )
##
BindGlobal( "TwoCohomologyModCR", function( A, lat )
    local cb, cc, bat;

    if A.char <> 0 then return fail; fi;

    # two cobounds
    cb := TwoCoboundariesCR( A );

    # two cocycle system
    cc := IntTwoCocycleSystemCR( A );

    # big lattice
    bat := DirectSumMat( List( [1..cc.len], y -> lat ) );

    # add lattice to cb and cc
    cb := BaseIntMat( Concatenation( cb, bat ) );
    cc := IntKernelCR( A, cc, lat, bat );

    return rec( gcc := cc, gcb := cb,
                factor := AdditiveFactorPcp( cc, cb, 0 ) );
end );

