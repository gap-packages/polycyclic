gap> START_TEST( "gh-00033.tst" );

#
# Fix a bug in Intersection where relative orders were not properly taken into
# account, which lead to a too small result.
# <https://github.com/gap-packages/polycyclic/issues/33>
#
gap> free := FreeGroup(4);;
gap> AssignGeneratorVariables(free);
#I  Assigned the global variables [ f1, f2, f3, f4 ]
gap> q := free / [ f1^2*f3^-1*f2^-2,
>  f1^-1*f2*f1*f3^-1*f2^-1,
>  f3^2,
>  f1^-1*f3*f1*f4^-1*f3^-1,
>  f2^-1*f3*f2*f4^-1*f3^-1,
>  f2*f3*f2^-1*f4^-1*f3^-1,
>  f4^2,
>  f1^-1*f4*f1*f4^-1,
>  f2^-1*f4*f2*f4^-1,
>  f2*f4*f2^-1*f4^-1,
>  f3^-1*f4*f3*f4^-1 ];;
gap> pcpq := PcpGroupFpGroupPcPres(q);
Pcp-group with orders [ 2, 0, 2, 2 ]
gap> AssignGeneratorVariables(pcpq);
#I  Assigned the global variables [ g1, g2, g3, g4 ]
gap> sub := Subgroup(pcpq, [pcpq.2, pcpq.4]);
Pcp-group with orders [ 0, 2 ]
gap> sub2 := sub^pcpq.1;
Pcp-group with orders [ 0, 2 ]
gap> Pcp(Intersection(sub, sub2));
Pcp [ g2^2, g4 ] with orders [ 0, 2 ]

#
gap> STOP_TEST( "gh-00033.tst" );
