#############################################################################
##
#W  grphoms.gi                   Polycyc                         Bettina Eick
##

#############################################################################
##
## Functions to deal with homomorphisms from pcp groups to pcp groups and
## from arbitrary groups to pcp groups.
##

#############################################################################
##
#M GGMBI( G, H ) . . . . . . . . . . . . . . . . . . . for G and H pcp groups
##
InstallMethod( GroupGeneralMappingByImages,
               true, [IsPcpGroup, IsPcpGroup, IsList, IsList], 0,
function( G, H, gens, imgs )
    local new, filt, type, hom;
 
    if Length( gens ) <> Length( imgs ) then
        Error("gens and imgs must have same length");
    fi;

    if gens <> Igs(G) then
        new := IgsParallel( gens, imgs );
    else
        new := [gens, imgs];
    fi;

    filt := IsGroupGeneralMappingByImages and IsMapping and IsTotal
            and IsPcpGHBI and IsToPcpGHBI and HasSource and HasRange
            and HasMappingGeneratorsImages;

    type := NewType( GeneralMappingsFamily( ElementsFamily( FamilyObj( G ) ),
                     ElementsFamily( FamilyObj( H ) ) ), filt );

    hom  := rec( );
    ##
    ## With version 4.3 the components !.generators and !.geninages were
    ## moved into the component MappingGeneratorsImages.  To remain
    ## compatible with 4.1 and 4.2 we keep the old components as well.
    ##
    if not CompareVersionNumbers( VERSION, "4.3" ) then
        hom.generators := new[1]; 
        hom.genimages  := new[2];
    fi;

    ObjectifyWithAttributes( hom, type, Source, G, Range, H,
                             MappingGeneratorsImages, new );
    SetIsMapping( hom, true );
    return hom;
end );

#############################################################################
##
#M GGMBI( G, H ) . . . . . . . . . . . . . . . . . . . .only H is a pcp group
##
InstallMethod( GroupGeneralMappingByImages,
               true, [IsGroup, IsPcpGroup, IsList, IsList], 0,
function( G, H, gens, imgs )
    local new, filt, type, hom;

    if Length( gens ) <> Length( imgs ) then
        Error("gens and imgs must have same length");
    fi;

    filt := IsGroupGeneralMappingByImages and IsMapping and IsTotal
            and IsToPcpGHBI and HasSource and HasRange
            and HasMappingGeneratorsImages;

    type := NewType( GeneralMappingsFamily( ElementsFamily( FamilyObj( G ) ),
                     ElementsFamily( FamilyObj( H ) ) ), filt );

    hom  := rec( );
    ##
    ## With version 4.3 the components !.generators and !.geninages were
    ## moved into the component MappingGeneratorsImages.  To remain
    ## compatible with 4.1 and 4.2 we keep the old components as well.
    ##
    if not CompareVersionNumbers( VERSION, "4.3" ) then
        hom.generators := gens;
        hom.genimages := imgs;
    fi;

    ObjectifyWithAttributes( hom, type, Source, G, Range, H,
                             MappingGeneratorsImages, [ gens, imgs ] );

    SetIsMapping( hom, true );
    return hom;
end );

#############################################################################
##
#M IsGroupHomomorphism( <map> )
##
#InstallMethod( IsGroupHomomorphism, true, [IsPcpGHBI], 0,
#function( hom )
#    local gens, imgs, i, a, b, j;
#
#    # check relators 
#    gens := MappingGeneratorsImages( hom )[1];
#    imgs := MappingGeneratorsImages( hom )[2];
#   
#    for i in [1..Length( gens )] do
#        if RelativeOrderPcp( gens[i] ) > 0 then
#            a := gens[i]^RelativeOrderPcp( gens[i] );
#            b := imgs[i]^RelativeOrderPcp( gens[i] );
#            if Image(hom, a) <> b then return false; fi;
#        fi;
#        for j in [1..i-1] do
#            a := gens[i] ^ gens[j];
#            b := imgs[i] ^ imgs[j];
#            if Image(hom, a) <> b then return false; fi;
#
#            a := gens[i] ^ (gens[j]^-1);
#            b := imgs[i] ^ (imgs[j]^-1);
#            if Image(hom, a) <> b then return false; fi;
#        od;
#    od;
#    return true;
#end );

#############################################################################
##
#M GHBI( G, H )
##
InstallMethod( GroupHomomorphismByImagesNC,
               true, [IsGroup, IsPcpGroup, IsList, IsList], 0,
function( G, H, gens, imgs )
    local hom;
    hom := GroupGeneralMappingByImages( G, H, gens, imgs );
    SetIsGroupHomomorphism( hom, true );
    return hom;
end );

#############################################################################
##
#M  \=
##
InstallMethod( \=,
               IsIdenticalObj, [ IsPcpGHBI, IsPcpGHBI ], 0,
function( a, b )
    if a!.Source <> b!.Source then
        return false;
    elif a!.Range <> b!.Range then
        return false;
    elif MappingGeneratorsImages( a ) <> MappingGeneratorsImages( b ) then
        return false;
    fi;
    return true;
end );

#############################################################################
##
#M  \*
##
InstallMethod( CompositionMapping2,
               FamSource1EqFamRange2, [ IsPcpGHBI, IsPcpGHBI ], 0,
function( a, b )
  local hom;
  hom := GroupHomomorphismByImagesNC( Source(b), Range(a), 
                 MappingGeneratorsImages( b )[1],
                 List( MappingGeneratorsImages( b )[2], 
                       x -> ImagesRepresentative(a, x) ) );
  return hom;
end );

#############################################################################
##
#M  \^-1
##
#InstallMethod( InverseGeneralMapping,
#               true, [ IsGroupGeneralMappingByImages ], 0,
#    function( hom )
#    return GroupGeneralMappingByImages( Range( hom ),   Source( hom ),
#                                        MappingGeneratorsImages( home )[2],
#                                        MappingGeneratorsImages( home )[1] );
#    end );

#############################################################################
##
#M  Images
##
InstallMethod( ImagesRepresentative, 
               FamSourceEqFamElm,
               [ IsPcpGHBI, IsMultiplicativeElementWithInverse ], 0,
function( hom, elm )
    if MappingGeneratorsImages( hom )[1] = Igs(Parent(hom!.Source)) then
        return MappedVector( Exponents(elm), 
                             MappingGeneratorsImages( hom )[2] );
    fi;
    return MappedVector( ExponentsByIgs( MappingGeneratorsImages(hom)[1], 
                                         elm ), 
                         MappingGeneratorsImages(hom)[2] );
end );

#############################################################################
##
#M  PreImages
##
InstallMethod( PreImagesRepresentative,
               "for pcp groups",
               FamRangeEqFamElm,
               [ IsToPcpGHBI, IsMultiplicativeElementWithInverse ], 0,
function( hom, elm )
    local new;
    if not IsBound( hom!.impcp ) then
        new := IgsParallel( MappingGeneratorsImages(hom)[2],
                            MappingGeneratorsImages(hom)[1] );
        hom!.impcp := new[1];
        hom!.prpcp := new[2];
    fi;
    if Length( hom!.impcp ) = 0 then
        return One( hom!.Source );
    fi;
    return MappedVector( ExponentsByIgs(hom!.impcp, elm), hom!.prpcp );
end );

InstallMethod( PreImagesSet,
               true,
               [ IsPcpGHBI, IsPcpGroup ], 0,
function( hom, U )
    local prei, kern;
    prei := List( Igs(U), x -> PreImagesRepresentative(hom,x) );
    kern := Igs( Kernel( hom ) );
    return SubgroupByIgs( Source(hom), kern, prei );
end );

InstallMethod( PreImagesSet,
               true,
               [ IsToPcpGHBI and IsInjective, IsPcpGroup ], 0,
function( hom, U )
    local gens, prei;
    gens := GeneratorsOfGroup( U );
    prei := List( gens, x -> PreImagesRepresentative(hom,x) );
    return Subgroup( Source(hom), prei );
end );

#############################################################################
##
#M  Kernel
##
InstallMethod( KernelOfMultiplicativeGeneralMapping,
               true, [ IsPcpGHBI ], 0,
function( hom )
    local gens, imgs, new, kern, i, e, l;
    
    gens := MappingGeneratorsImages(hom)[1];
    imgs := MappingGeneratorsImages(hom)[2];
    if not IsBound( hom!.impcp ) then
        new := IgsParallel( imgs, gens );
        hom!.impcp := new[1];
        hom!.prpcp := new[2];
    fi;

    kern := [];
    for i in [1..Length(gens)] do
        e := ExponentsByIgs( hom!.impcp, imgs[i] );
        l := gens[i] * MappedVector( e, hom!.prpcp )^-1; 
        Add( kern, l );
    od; 
 
    return Subgroup( Source( hom ), kern );
end );

#############################################################################
##
#M  IsInjective( <hom> )  . . . . . . . . . . . . . . . . . . . . .  for GHBI
##
InstallMethod( IsInjective,
               true, [ IsPcpGHBI ], 0,
function( hom )
    return Size( KernelOfMultiplicativeGeneralMapping(hom) ) = 1;
end );
