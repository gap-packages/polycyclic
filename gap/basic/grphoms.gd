#############################################################################
##
#W  grphoms.gd                   Polycyc                         Bettina Eick
#W                                                              Werner Nickel
##

#############################################################################
##
#R  IsPcpGHBI( <map> )
##
DeclareRepresentation( "IsPcpGHBI",
      IsGroupGeneralMappingByImages,
      [ "generators", "genimages", "impcp", "prpcp" ] );

#############################################################################
##
#R  IsToPcpGHBI( <map> )
##
DeclareRepresentation( "IsToPcpGHBI",
      IsGroupGeneralMappingByImages,
      [ "generators", "genimages", "impcp", "prpcp" ] );


#############################################################################
##
#R  Compatibility mode
##
##
##    With 4.3 the components !.generators and !.genimages of a
##    group general mapping were moved into one component called
##    MappingGeneratorsImages.  To remain compatible with 4.1
##    and 4.2 we keep the old components as well.  This affects
##    the methods in gap/basic/grphoms.gi that build a general
##    group mapping.
##
##    Since the attribute MappingGeneratorsImages is used in
##    the code, we have to declare it here.
##

if not CompareVersionNumbers( VERSION, "4.3" ) then
    if not IsBound( MappingGeneratorsImages ) then
        DeclareAttribute( "MappingGeneratorsImages", IsGeneralMapping );
    fi;
fi;

