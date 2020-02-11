#############################################################################
##
#W  grpint.gi                  Polycyc                           Bettina Eick
##

#############################################################################
##
#F NormalIntersection( N, U ) . . . . . . . . . . . . . . . . . . .  U \cap N
##
## The core idea here is that the intersection U \cap N equals the kernel of
## the natural homomorphism \phi : U \to UN/N ; see also section 8.8.1 of
## the "Handbook of computational group theory".
## So we can apply the methods for computing kernels of homomorphisms, but we
## need the group UN for this as well, at least implicitly.
##
## The resulting algorithm is quite similar to the Zassenhaus algorithm for
## simultaneously computing the intersection and sum of two vector spaces.
InstallMethod( NormalIntersection, "for pcp groups",
               IsIdenticalObj, [IsPcpGroup, IsPcpGroup],
function( N, U )
    local G, igs, igsN, igsU, n, s, I, id, ls, rs, is, g, d, al, ar, e, tm;

	# get common overgroup of N and U
	G := PcpGroupByCollector( Collector( N ) );

    igs  := Igs(G);
    igsN := Cgs( N );
    igsU := Cgs( U );
    n    := Length( igs );

    # if N or U is trivial
    if Length( igsN ) = 0 then
        return N;
    elif Length( igsU ) = 0 then
        return U;
    fi;

    # if N or U are equal to G
    if Length( igsN ) = n and ForAll(igsN, x -> LeadingExponent(x) = 1) then
        return U;
    elif Length(igsU) = n and ForAll(igsU, x -> LeadingExponent(x) = 1) then
        return N;
    fi;

    # if N is a tail, we can read off the result directly
    s := Depth( igsN[1] );
    if Length( igsN ) = n-s+1 and
       ForAll( igsN, x -> LeadingExponent(x) = 1 ) then
        I := Filtered( igsU, x -> Depth(x) >= s );
        return SubgroupByIgs( G, I );
    fi;

    # otherwise compute
    id := One(G);
    ls := ListWithIdenticalEntries( n, id ); # ls = left side
    rs := ListWithIdenticalEntries( n, id ); # rs = right side
    is := ListWithIdenticalEntries( n, id ); # is = intersection

    for g in igsU do
        d := Depth( g );
        ls[d] := g;
        rs[d] := g;
    od;

    I := [];
    for g in igsN do
        d := Depth( g );
        if ls[d] = id then
            ls[d] := g;
        else
            Add( I, [ g, id ] );
        fi;
    od;

    # enter the pairs [ ar, al ] of <I> into [ <ls>, <rs> ]
    for tm in I do
        al := tm[1];
        ar := tm[2];
        d  := Depth( al );

        # compute sum and intersection
        while al <> id and ls[d] <> id do
            e := Gcdex( LeadingExponent(ls[d]), LeadingExponent(al) );
            tm := ls[d]^e.coeff1 * al^e.coeff2;
            al := ls[d]^e.coeff3 * al^e.coeff4;
            ls[d] := tm;
            tm := rs[d]^e.coeff1 * ar^e.coeff2;
            ar := rs[d]^e.coeff3 * ar^e.coeff4;
            rs[d] := tm;
            d := Depth( al );
        od;

        # we have a new sum generator
        if al <> id then
            Assert(1, ls[d] = id);
            ls[d] := al; # new generator of UN
            rs[d] := ar;

            tm := RelativeOrder( al );
            if tm > 0 then
                al := al^tm;
                ar := ar^tm;
                Add( I, [ al, ar ] );
            fi;

        # we have a new intersection generator
        elif ar <> id then
            Assert(1, al = id);
            # here we have al=id; so ar is in the intersection;
            # filter it into the polycyclic sequence `is`
            d := Depth( ar );
            while ar <> id and is[d] <> id  do
                e  := Gcdex(LeadingExponent( is[d] ), LeadingExponent( ar ));
                tm := is[d]^e.coeff1 * ar^e.coeff2;
                ar := is[d]^e.coeff3 * ar^e.coeff4;
                is[d] := tm;
                d  := Depth( ar );
            od;
            if ar <> id then
                is[d] := ar;
            fi;
        fi;
    od;

    # sum := Filtered( ls, x -> x <> id );
    I := Filtered( is, x -> x <> id );
    return Subgroup( G, I );
end );

#############################################################################
##
#M Intersection( N, U )
##
InstallMethod( Intersection2, "for pcp groups",
               IsIdenticalObj, [IsPcpGroup, IsPcpGroup],
function( U, V )
    # check for trivial cases
    if IsInt(Size(U)) and IsInt(Size(V)) then
        if IsInt(Size(V)/Size(U)) and ForAll(Igs(U), x -> x in V ) then
            return U;
        elif Size(V)<Size(U) and IsInt(Size(U)/Size(V))
             and ForAll( Igs(V), x -> x in U ) then
            return V;
        fi;
    fi;

    # test if one the groups is known to be normal
    if IsNormal( V, U ) then
        return NormalIntersection( U, V );
    elif IsNormal( U, V ) then
        return NormalIntersection( V, U );
    fi;

    Error("sorry: intersection for non-normal groups not yet installed");
end );
