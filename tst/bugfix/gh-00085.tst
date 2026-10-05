gap> START_TEST( "gh-00085.tst" );

#
# Fix bug in FrattiniSubgroup
# Reported by Heiko Dietrich (2024-02-19)
# <https://github.com/gap-packages/polycyclic/pull/85>
#
gap> G:=PcGroupToPcpGroup(PcGroupCode(65691468891906554870039,11025));;
gap> F:=FrattiniSubgroup(G);;
gap> Size(F);  # used to produce a group of order 49
21

#
gap> STOP_TEST( "gh-00085.tst" );
