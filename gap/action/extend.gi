#############################################################################
##
#W  extend.gi                                                    Bettina Eick
##
#W  Enlarge a base pcgs by normalizing elements.
##

#############################################################################
##
#F SubsWordPlus( w, gens, invs, id ) . . . . . . . .use inverses and identity
##
BindGlobal( "SubsWordPlus", function( w, gens, invs, id )
    local g, v;
    g := id;
    for v in w do
        if v[2] = 1 then
            g := g * gens[v[1]];
        elif v[2] = -1 then
            g := g * invs[v[1]];
        elif v[2] > 1 then
            g := g * gens[v[1]] ^ v[2];
        elif v[2] < -1 then
            g := g * invs[v[1]] ^ -v[2];
        fi;
    od;
    return g;
end );

#############################################################################
##
#F SubsAndInvertDefn( w, defns ) . . . . . . . . . . . .substitute and invert
##
BindGlobal( "SubsAndInvertDefn", function( w, defns )
    local v, l;
    v := [];
    for l in w do
        Add( v, [defns[l[1]], -l[2]] );
    od;
    return Reversed( v );
end );

#############################################################################
##
#F TransWord( j, trels ) . . . . . . . . . . . . . determine transversal word
##
BindGlobal( "TransWord", function( j, trels )
    local l, g, s, p, t, w;
    l := Product( trels );
    j := j - 1;
    w := [];
    for s in Reversed( [1..Length( trels )] ) do
        p := trels[s];
        l := l/p;
        t := QuoInt( j, l );
        j := RemInt( j, l );
        if t > 0 then Add( w, [s, t] ); fi;
    od;
    return Reversed( w );
end );

#############################################################################
##
#F  EnlargeOrbit( orbit, g, p, op ) . . . . enlarge orbit by p images under g
##
BindGlobal( "EnlargeOrbit", function( orbit, g, p, op )
    local l, s, k, t, h;
    l := Length( orbit );
    orbit[p*l] := true;
    s := 0;
    for k  in [ 1 .. p - 1 ]  do
        t := s + l;
        for h  in [ 1 .. l ]  do
            orbit[h+t] := op( orbit[h+s], g );
        od;
        s := t;
    od;
end );

#############################################################################
##
#F  SmallOrbitPoint( pcgs, g )
##
BindGlobal( "SmallOrbitPoint", function( pcgs, g )
    local b;
    repeat
        b := Random(pcgs.acton);
    until pcgs.oper( b, g ) <> b;
    return b;
end );

#############################################################################
##
#F  ExtendedBasePcgs( pcgs, g, d ) . . . . . . . . . . . . extend a base pcgs
##
##  g normalizes <pcgs> and we compute a new pcgs for <pcgs, g>.
##
BindGlobal( "ExtendedBasePcgs", function( pcgs, g, d )
    local h, e, i, o, b, m, c, l, w, j, k;

    # change in place - but unbind not updated information
    Unbind(pcgs.pcgs);
    Unbind(pcgs.rels);

    # set up
    h := g;
    e := ShallowCopy( d );
    i := 0;

    # loop over base and divide off
    while not pcgs.trivl( h ) do
        i := i + 1;

        # take base point (if necessary, add new base point)
        if i > Length( pcgs.orbit ) then
            b := SmallOrbitPoint( pcgs, g );
            Add( pcgs.orbit, [b] );
            Add( pcgs.trans, [] );
            Add( pcgs.defns, [] );
            Add( pcgs.trels, [] );
        else
            b := pcgs.orbit[i][1];
        fi;

        # compute the relative orbit length of h
        m := 1;
        c := pcgs.oper( b, h );
        while not c in pcgs.orbit[i] do
            m := m + 1;
            c := pcgs.oper( c, h );
        od;

        # enlarge pcgs, if necessary
        if m > 1 then
            #Print(" enlarge basic orbit ",i," by ",m," copies \n");
            Add( pcgs.trans[i], h );
            Add( pcgs.defns[i], e );
            Add( pcgs.trels[i], m );
            EnlargeOrbit( pcgs.orbit[i], h, m, pcgs.oper );
            Add( pcgs.pcref, [i, Length(pcgs.trans[i])] );
        fi;

        # divide off
        j := Position( pcgs.orbit[i], c );
        if j > 1 then
            w := TransWord( j, pcgs.trels[i] );
            h := h^m * SubsWord( w, pcgs.trans[i] )^-1;
            e := [[e,m], SubsAndInvertDefn( w, pcgs.defns[i] ) ];
        else
            h := h^m;
            e := [e,m];
        fi;
    od;
end );

