#############################################################################
##
#W  pcpelms.gd                   Polycyc                         Bettina Eick
##

#############################################################################
##
## Introduce the category of pcp elements
##
DeclareCategory( "IsPcpElement", IsMultiplicativeElementWithInverse );
DeclareCategoryFamily( "IsPcpElement" );
DeclareCategoryCollections( "IsPcpElement" );


#############################################################################
##
## Operations
##
DeclareOperation( "Exponents",       [ IsObject ] );
DeclareOperation( "NameTag",         [ IsObject ] );
DeclareOperation( "GenExpList",      [ IsObject ] );
DeclareOperation( "Depth",           [ IsObject ] );
DeclareOperation( "Tail",            [ IsObject ] );
DeclareOperation( "LeadingExponent", [ IsObject ] );


#############################################################################
##
## Introduce the representation of pcp elements
##
DeclareRepresentation( "IsPcpElementRep", 
                        IsComponentObjectRep,
                        ["collector", 
                         "exponents", 
                         "depth",
                         "leading",
                         "name" ] );

#############################################################################
##
## Some functions
##
DeclareGlobalFunction( "PcpElementConstruction" );
DeclareGlobalFunction( "PcpElementByExponentsNC" );
DeclareGlobalFunction( "PcpElementByExponents" );
DeclareGlobalFunction( "PcpElementByGenExpListNC" );
DeclareGlobalFunction( "PcpElementByGenExpList" );

#############################################################################
##
## Some attributes
##
DeclareAttribute( "RelativeOrderPcp", IsPcpElement );
DeclareAttribute( "RelativeIndex", IsPcpElement );
DeclareAttribute( "FactorOrder",   IsPcpElement );
 

