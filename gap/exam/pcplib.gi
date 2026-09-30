#############################################################################
##
#W pcplib.gi                    Polycyc                          Bettina Eick
#W                                                              Werner Nickel
##

#############################################################################
##
#F ExamplesOfSomePcpGroups(n)
##
InstallGlobalFunction( ExamplesOfSomePcpGroups, function(n)
    if not IsInt(n) then return fail; fi;
    if n < 1 or n > 16 then return fail; fi;
    if n <= 13 then return PcpExamples(n); fi;
    return NqExamples(n-13);
end );

#############################################################################
##
#F PcpExamples(n)
##
InstallGlobalFunction( PcpExamples, function( n )
    local FTL;

    ##
    ##                                             [ 0 1 ]   [ -1  0 ]
    ##  The semidirect product of the matrices     [ 1 1 ],  [  0 -1 ]
    ##
    ##  and Z^2.  We let the generator corresponding to the second matrix
    ##  have infinite order.
    ##
    if n = 1 then
        return SplitExtensionPcpGroup( AbelianPcpGroup( 2, [] ),
                             [ [[0,1],[1,1]], [[-1,0],[0,-1]] ] );
    fi;

    ##
    ##  The following matrices are a basis of the fundamental units of the
    ##  order defined by the polynomials x^4 - x - 1
    ##
    if n = 2 then
        return SplitExtensionPcpGroup( AbelianPcpGroup( 2, [] ),
       [ [ [ 0,1,0,0 ],  [ 0,0,1,0 ],  [ 0,0,0,1 ],  [ 1,1,0,0 ] ],
       [ [ 1,1,0,-1 ], [ -1,0,1,0 ], [ 0,-1,0,1 ], [ 1,1,-1,0 ] ] ] );
    fi;

    ##
    ##  Z split Z
    ##
    if n = 3 then
        FTL := FromTheLeftCollector( 2 );
        SetConjugateNC( FTL, 2,  1, [2,-1] );
        SetConjugateNC( FTL, 2, -1, [2,-1] );
        UpdatePolycyclicCollector(FTL);
        return PcpGroupByCollectorNC(FTL);
    fi;

    ##
    ##  A gr oup of Hirsch length 3.  Interesting because the exponents in
    ##  words can become large very quickly.
    ##
    if n = 4 then
        FTL := FromTheLeftCollector( 3 );
        SetConjugateNC( FTL, 2, 1, [3, 1] );
        SetConjugateNC( FTL, 3, 1, [2, 1, 3, 7] );
        UpdatePolycyclicCollector(FTL);
        return PcpGroupByCollectorNC(FTL);
    fi;

    ##
    ##  A torsion free polycyclic group which is not nilpotent. It is
    ##  taken vom Robinson's book, page 158.
    ##
    if n = 5 then
        FTL := FromTheLeftCollector( 4 );
        SetRelativeOrderNC( FTL, 1, 2 );
        SetPowerNC( FTL, 1, [4,1] );
        SetConjugateNC( FTL, 2,1, [2,-1] );
        SetConjugateNC( FTL, 3,1, [3,-1] );
        SetConjugateNC( FTL, 3,2, [3,1,4,2] );
        UpdatePolycyclicCollector(FTL);
        return PcpGroupByCollectorNC(FTL);
    fi;

    ##
    ## The next 4 groups are from Lo/Ostheimer paper on finding matrix reps
    ## for pc groups. They are all non-nilpotent, but poly-Z
    ##
    if n = 6 then
        FTL := FromTheLeftCollector( 3 );
        SetConjugateNC( FTL, 2, 1, [2,2,3,1]);
        SetConjugateNC( FTL, 3, 1, [2,1,3,1]);
        UpdatePolycyclicCollector(FTL);
        return PcpGroupByCollectorNC(FTL);
    fi;

    if n = 7 then
        FTL := FromTheLeftCollector( 4 );
        SetConjugateNC( FTL, 2, 1, [3,1] );
        SetConjugateNC( FTL, 3, 1, [2,-1, 3,3, 4,1] );
        SetConjugateNC( FTL, 3, 2, [3,1,4,-1]);
        UpdatePolycyclicCollector(FTL);
        return PcpGroupByCollectorNC(FTL);
    fi;

    if n = 8 then
        FTL := FromTheLeftCollector( 5 );
        SetConjugateNC( FTL, 2, 1, [2,1,4,-1]);
        SetConjugateNC( FTL, 3, 2, [5,1]);
        SetConjugateNC( FTL, 4, 2, [3,1,4,-1,5,1]);
        SetConjugateNC( FTL, 5, 2, [4,1]);
        UpdatePolycyclicCollector(FTL);
        return PcpGroupByCollectorNC(FTL);
    fi;

    if n = 9 then
        FTL := FromTheLeftCollector( 3 );
        SetConjugateNC( FTL, 2, 1, [2,1,3,-3] );
        SetConjugateNC( FTL, 3, 1, [3,-1] );
        SetConjugateNC( FTL, 3, 2, [3,-1] );
        UpdatePolycyclicCollector(FTL);
        return PcpGroupByCollectorNC(FTL);
    fi;

    ##
    ## A pc group from Eddie's preprint on `low index for pc groups'
    ##
    if n = 10 then
        FTL := FromTheLeftCollector( 4 );
        SetConjugateNC( FTL, 2, 1, [2,-1] );
        SetConjugateNC( FTL, 4, 1, [4,-1] );
        SetConjugateNC( FTL, 3, 2, [3,2,4,1]);
        SetConjugateNC( FTL, 4, 2, [3,3,4,2]);
        UpdatePolycyclicCollector(FTL);
        return PcpGroupByCollectorNC(FTL);
    fi;

    ##
    ## The free nilpotent group of rank 2 and class 3.
    ##
    if n = 11 then
        FTL := FromTheLeftCollector( 5 );
        SetConjugateNC( FTL, 2, 1, [2,1,3, 1] );
        SetConjugateNC( FTL, 3, 1, [3,1,4, 1] );
        SetConjugateNC( FTL, 3, 2, [3,1,5, 1] );
        UpdatePolycyclicCollector( FTL );
        return PcpGroupByCollectorNC( FTL );
    fi;

    ##
    ## The free nilpotent group of rank 3 and class 2.
    ##
    if n = 12 then
        FTL := FromTheLeftCollector( 6 );
        SetConjugateNC( FTL, 2, 1, [2,1,4, 1] );
        SetConjugateNC( FTL, 3, 1, [3,1,5, 1] );
        SetConjugateNC( FTL, 3, 2, [3,1,6, 1] );
        UpdatePolycyclicCollector( FTL );
        return PcpGroupByCollectorNC( FTL );
    fi;

    ##
    ## A nilpotent group from Eick/Fernandez paper on canonical conjugates
    ##

    if n = 13 then
        FTL := FromTheLeftCollector( 21 );
        SetRelativeOrderNC( FTL, 1, 255 );
        SetPowerNC( FTL, 1, [  ] );
        SetRelativeOrderNC( FTL, 2, 585 );
        SetPowerNC( FTL, 2, [ 3, -3 ] );
        SetRelativeOrderNC( FTL, 7, 15 );
        SetPowerNC( FTL, 7, [ 8, 30 ] );
        SetRelativeOrderNC( FTL, 8, 51 );
        SetPowerNC( FTL, 8, [  ] );
        SetRelativeOrderNC( FTL, 9, 3 );
        SetPowerNC( FTL, 9, [  ] );
        SetRelativeOrderNC( FTL, 10, 255 );
        SetPowerNC( FTL, 10, [  ] );
        SetRelativeOrderNC( FTL, 11, 585 );
        SetPowerNC( FTL, 11, [ 12, -3 ] );
        SetRelativeOrderNC( FTL, 13, 255 );
        SetPowerNC( FTL, 13, [  ] );
        SetRelativeOrderNC( FTL, 14, 585 );
        SetPowerNC( FTL, 14, [ 15, -3 ] );
        SetRelativeOrderNC( FTL, 17, 255 );
        SetPowerNC( FTL, 17, [  ] );
        SetRelativeOrderNC( FTL, 18, 585 );
        SetPowerNC( FTL, 18, [ 19, -3 ] );
        SetConjugateNC( FTL, 2, 1, [ 2, 1, 7, 1 ] );
        SetConjugateNC( FTL, 2, -1, [ 2, 1, 7, 14, 8, 21 ] );
        SetConjugateNC( FTL, 3, 1, [ 3, 1, 8, 1 ] );
        SetConjugateNC( FTL, 3, -1, [ 3, 1, 8, 50 ] );
        SetConjugateNC( FTL, 3, 2, [ 3, 1, 9, 1 ] );
        SetConjugateNC( FTL, 3, -2, [ 3, 1, 9, 2 ] );
        SetConjugateNC( FTL, 4, 1, [ 4, 1, 10, 1 ] );
        SetConjugateNC( FTL, 4, -1, [ 4, 1, 10, 254 ] );
        SetConjugateNC( FTL, 4, 2, [ 4, 1, 11, 1 ] );
        SetConjugateNC( FTL, 4, -2, [ 4, 1, 11, 584, 12, 3 ] );
        SetConjugateNC( FTL, 4, 3, [ 4, 1, 12, 1 ] );
        SetConjugateNC( FTL, 4, -3, [ 4, 1, 12, -1 ] );
        SetConjugateNC( FTL, 5, 1, [ 5, 1, 13, 1 ] );
        SetConjugateNC( FTL, 5, -1, [ 5, 1, 13, 254 ] );
        SetConjugateNC( FTL, 5, 2, [ 5, 1, 14, 1 ] );
        SetConjugateNC( FTL, 5, -2, [ 5, 1, 14, 584, 15, 3 ] );
        SetConjugateNC( FTL, 5, 3, [ 5, 1, 15, 1 ] );
        SetConjugateNC( FTL, 5, -3, [ 5, 1, 15, -1 ] );
        SetConjugateNC( FTL, 5, 4, [ 5, 1, 16, 1 ] );
        SetConjugateNC( FTL, 5, -4, [ 5, 1, 16, -1 ] );
        SetConjugateNC( FTL, 6, 1, [ 6, 1, 17, 1 ] );
        SetConjugateNC( FTL, 6, -1, [ 6, 1, 17, 254 ] );
        SetConjugateNC( FTL, 6, 2, [ 6, 1, 18, 1 ] );
        SetConjugateNC( FTL, 6, -2, [ 6, 1, 18, 584, 19, 3 ] );
        SetConjugateNC( FTL, 6, 3, [ 6, 1, 19, 1 ] );
        SetConjugateNC( FTL, 6, -3, [ 6, 1, 19, -1 ] );
        SetConjugateNC( FTL, 6, 4, [ 6, 1, 20, 1 ] );
        SetConjugateNC( FTL, 6, -4, [ 6, 1, 20, -1 ] );
        SetConjugateNC( FTL, 6, 5, [ 6, 1, 21, 1 ] );
        SetConjugateNC( FTL, 6, -5, [ 6, 1, 21, -1 ] );
        UpdatePolycyclicCollector( FTL );
        return PcpGroupByCollectorNC( FTL );
    fi;


    return fail;

end );

