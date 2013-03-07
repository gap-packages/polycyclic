#############################################################################
##
#W  construct.gi               Polycyclic                            Max Horn
##


#############################################################################
##
#M  TrivialGroupCons( <IsPcpGroup> )
##
InstallMethod( TrivialGroupCons,
    "pcp group",
    [ IsPcpGroup and IsFinite ],
function( filter )
    return PcpGroupByCollectorNC( FromTheLeftCollector( 0 ) );
end );


#############################################################################
##
#M  AbelianGroupCons( <IsPcpGroup>, <ints> )
##
InstallMethod( AbelianGroupCons,
    "pcp group",
    [ IsPcpGroup, IsList ],
function( filter, ints )
    local coll, i, n, r, grp;

    if not ForAll( ints, IsInt )  then
        Error( "<ints> must be a list of integers" );
    fi;
    # We allow 0, and interpret it as indicating an infinite factor.
    if not ForAll( ints, x -> 0 <= x )  then
        TryNextMethod();
    fi;

    n := Length(ints);
    r := ints;

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
#M  ElementaryAbelianGroupCons( <IsPcpGroup>, <size> )
##
InstallMethod( ElementaryAbelianGroupCons,
	"pcp group",
    [ IsPcpGroup and IsFinite, IsPosInt ],
function(filter,size)

    local grp;

    if size = 1 or IsPrimePowerInt( size )  then
        grp := AbelianGroup( filter, Factors(size) );
    else
        Error( "<n> must be a prime power" );
    fi;
    SetIsElementaryAbelian( grp, true );
    return grp;
end);


#############################################################################
##
#M  FreeAbelianGroupCons( <IsPcpGroup>, <rank> )
##

if IsBound(FreeAbelianGroupCons) then

InstallMethod( FreeAbelianGroupCons,
    "pcp group",
    [ IsPcpGroup,  IsInt and IsPosRat ],
function( filter, rank )
    local coll, grp;
    # construct group
    coll := FromTheLeftCollector( rank );
    UpdatePolycyclicCollector( coll );
    grp := PcpGroupByCollectorNC( coll );
    SetIsFreeAbelian( grp, true );
    return grp;
end );

fi;


#############################################################################
##
#M  CyclicGroupCons( <IsPcpGroup>, <n> )
##
InstallMethod( CyclicGroupCons,
    "pcp group",
    [ IsPcpGroup and IsFinite, IsPosInt ],
function( filter, n )
    local coll, grp;

    # construct group
    coll := FromTheLeftCollector( 1 );
    SetRelativeOrder( coll, 1, n );
    UpdatePolycyclicCollector(coll);
    grp := PcpGroupByCollectorNC( coll );

    if n > 1 then
        SetMinimalGeneratingSet(grp, [grp.1]);
    else
        SetMinimalGeneratingSet(grp, []);
    fi;
    return grp;
end );

#############################################################################
##
#M  CyclicGroupCons( <IsPcpGroup>, infinity )
##
InstallOtherMethod( CyclicGroupCons,
    "pcp group",
    [ IsPcpGroup, IsInfinity ],
function( filter, n )
    local coll, grp;

    # construct group
    coll := FromTheLeftCollector( 1 );
    UpdatePolycyclicCollector(coll);
    grp := PcpGroupByCollectorNC( coll );

    SetMinimalGeneratingSet(grp, [grp.1]);
    return grp;
end );

#############################################################################
##
#M  DihedralGroupCons( <IsPcpGroup>, <n> )
##
InstallMethod( DihedralGroupCons,
    "pcp group",
    [ IsPcpGroup and IsFinite, IsPosInt ],
function( filter, n )
    local coll, grp;

    if n mod 2 = 1  then
        TryNextMethod();
    elif n = 2 then
        return CyclicGroup( filter, 2 );
    fi;

    coll := FromTheLeftCollector( 2 );
    SetRelativeOrder( coll, 1, 2 );
    SetRelativeOrder( coll, 2, n/2 );
    SetConjugate( coll, 2,  1, [2,n/2-1] );
    UpdatePolycyclicCollector(coll);
    grp := PcpGroupByCollectorNC( coll );
    return grp;
end );

#############################################################################
##
#M  DihedralGroupCons( <IsPcpGroup>, infinity )
##
InstallOtherMethod( DihedralGroupCons,
    "pcp group",
    [ IsPcpGroup, IsInfinity ],
function( filter, n )
    local coll, grp;

    coll := FromTheLeftCollector( 2 );
    SetRelativeOrder( coll, 1, 2 );
    SetConjugate( coll, 2,  1, [2,-1] );
    SetConjugate( coll, 2, -1, [2,-1] );
    UpdatePolycyclicCollector(coll);
    grp := PcpGroupByCollectorNC( coll );
    return grp;
end );

#############################################################################
##
#M  QuaternionGroupCons( <IsPcpGroup>, <n> )
##

InstallMethod( QuaternionGroupCons,
    "pcp group",
    [ IsPcpGroup and IsFinite, IsPosInt ],
function( filter, n )
    local coll, grp;

    if 0 <> n mod 4  then
        TryNextMethod();
    elif n = 4 then return
        CyclicGroup( filter, 4 );
    fi;

    coll := FromTheLeftCollector( 2 );
    SetRelativeOrder( coll, 1, 2 );
    SetRelativeOrder( coll, 2, n/2 );
    SetPower( coll, 1, [2, n/4] );
    SetConjugate( coll, 2,  1, [2,n/2-1] );
    UpdatePolycyclicCollector(coll);
    grp := PcpGroupByCollectorNC( coll );
    return grp;
end );

#############################################################################
##
#M  ExtraspecialGroupCons( <IsPcpGroup>, <order>, <exponent> )
##
InstallMethod( ExtraspecialGroupCons,
    "pcp group",
    [ IsPcpGroup and IsFinite,
      IsInt,
      IsObject ],
function( filters, order, exp )
    local G;
    G := ExtraspecialGroupCons( IsPcGroup and IsFinite, order, exp );
    return PcGroupToPcpGroup( G );
end );

#############################################################################
##
#M  AlternatingGroupCons( <IsPcpGroup>, <deg> )
##
InstallMethod( AlternatingGroupCons,
    "pcp group with degree",
    [ IsPcpGroup and IsFinite,
      IsPosInt ],
function( filter, deg )
    local   alt;
    if 4 < deg  then
        Error( "<deg> must be at most 4" );
    fi;
    alt := AlternatingGroupCons(IsPcGroup and IsFinite,deg);
    alt := PcGroupToPcpGroup(alt);
    SetIsAlternatingGroup( alt, true );
    return alt;
end );


#############################################################################
##
#M  SymmetricGroupCons( <IsPcpGroup>, <deg> )
##
InstallMethod( SymmetricGroupCons,
    "pcp group with degree",
    [ IsPcpGroup and IsFinite,
      IsPosInt ],
function( filter, deg )
    local sym;
    if 4 < deg  then
        Error( "<deg> must be at most 4" );
    fi;
    sym := SymmetricGroupCons(IsPcGroup and IsFinite,deg);
    sym := PcGroupToPcpGroup(sym);
    SetIsSymmetricGroup( sym, true );
    return sym;
end );
