DrawCoverTree := function( G, l )
    local Title, Sheet, grp, nex, des, cap, ter, g, v, i, j, H;

    # set up graphic sheet 
    Title := Concatenation( "Cover tree for ", StringIt(AbelianInvariants(G)));
    Sheet := GraphicSheet( Title, SSIZE[1], SSIZE[2] );

    # set up for iteration
    grp := [[G,[100, 70]]]; AddSExtension(G);

    # init tree
    Disc( Sheet, 100, 70, 3 );
    
    # compute iterated descendants
    for i in [1..l] do
        nex := []; j := 1;
        for H in grp do

            # compute covers 
            des := SchurCovers(H[1]);
            for g in des do AddSExtension(g); od;

            cap := Filtered(des, x -> x!.mord > 1);
            ter := Filtered(des, x -> x!.mord = 1);
            for g in cap do
                repeat
                    v := PrintVertex( Sheet, i, j, false, H[2],2); 
                    j := j + 1;
                until not IsBool(v); 
                Add( nex, [g, v] );
            od;
            if Length(ter) > 0 then 
                repeat
                    v := PrintVertex( Sheet, i, j, Length(ter), H[2],2); 
                    j := j + 1;
                until not IsBool(v); 
            fi;
        od;
        grp := nex;
        if Length(grp) = 0 then return; fi;
    od;
end;

