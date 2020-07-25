This file describes changes in the GAP package 'polycyclic'.

2.16 (2020-07-25)
  - Fix a bug in `NormalIntersection` which could lead to wrong results;
    this also affected other operations, such `Core`, `Intersection`
  - Fix `PreImagesRepresentative` for trivial homomorphisms (it used to return
    the identity fo the source as preimage for all elements in the range,
    instead of returning fail for all but the identity of the range)
  - Fix some bugs in `AddToIgs` and `AddTailInfo`
  - Some janitorial changes

2.15.1 (2019-10-03)

  - Fix a regression that could lead to an infinite loop in IsomorphismPcGroup

2.15 (2019-09-27)

  - Added license information to package metadata
  - Add support for random sources to Random method for pcp-groups
  - Documented IsPcpGroup and IsPcpElementCollection
  - Increased rank for IsomorphismPcGroup and IsomorphismFpGroup methods for
    pcp-groups, to ensure they are still used when all GAP packages are loaded
  - Some janitorial changes

2.14 (2018-05-12)

  * Fixed a bug in OneCoboundariesCR which lead to an error in OneCohomologyCR
  * Fixed a bug where the normal closure of an abelian subgroup could end up
    being flagged as abelian, even though it was not
  * Restored compatibility with GAP versions before 4.9

2.13.1 (2018-04-27)

  * Removed a regression test case which failed if no other packages are loaded

2.13 (2018-04-26)

  * Fixed bug in IsConjugate
  * Fixed building the manual via makedoc.g on case-sensitive file systems
  * Replaced immediate methods for IsTorsionFree and IsFreeAbelian by
    implications, which have zero overhead, while immediate methods can slow
    down GAP
  * Improved performance of UnitriangularPcpGroup for large n

2.12 (2018-03-18)

  * Improved performance of some orbit algorithms by using dictionaries
  * Improved performance of AddToIgs for some examples where it previously
    performed very badly
  * Added custom IsSingleValued method for group homomorphisms whose Source is
    an polycyclic groups, which can avoid an endless loop when the range is an
    infinite group
  * Fixed bug in NormalizerPcpGroup which could result in a break loop
  * Fixed bug in ComplementClassesCR which could result in a break loop
  * Fixed bug in OrbitIntegralAction which could result in a break loop
  * Fixed bug in StabilizerIntegralAction which could result in a break loop
  * Fixed bug in AddToIgs for infinite groups which could result in an invalid
    output leading to strange results
  * Fixed IsConjugate for pcp group elements to always return true and false
    (instead of an element which conjugates the inputs to each other)
  * Corrected documentation for HeisenbergPcpGroup to give correct number
    of generators, an correct Hirsch length
  * Corrected and clarified InfiniteMetacyclicPcpGroup documentation
  * Deprecated NaturalHomomorphism, use NaturalHomomorphismByNormalSubgroup
    instead (which is a standard GAP operation)
  * Removed left-over traces of Schur towers in the manual and elsewhere
  * Added more tests cases
  * Changed tests to using TestDirectory
  * Various minor tweaks

2.11 (2013-03-07)

  * Added a fast SylowSubgroup method (via IsomorphismPcGroup)
  * Add FreeAbelianGroup constructor method (feature will only be available
    in a future GAP release)
  * Replaced some internal code dealing with integer matrices with calls
    to equivalent GAP functions; for some things (e.g. inverting a matrix),
    this can be a lot faster
  * Fixed regressions in 2-cohomology code (introduced in 2.9), which caused
    TwoCoboundariesCR and TwoCohomologyCR to produce errors or wrong results
  * Fixed infinite recursion in LowerCentralSeriesOfGroup for non-nilpotent
    pcp groups (thanks to Andreas Distler for noticing and fixing this)
  * Removed support for GAP 4.4, now GAP 4.5 or newer is required
  * Removed some obsolete code
  * Removed or hid multiple undocumented internal functions (such as AsMat,
    IntMat, OnVectorspace, VERIFY, ...) to reduce the pollution of the
    global namespace
  * Various minor tweaks

2.10.1 (2012-06-01)

  * Fixed generic IsFreeAbelian method to only apply to finitely
    generated groups
  * Removed "name strings" from two InstallImmediateMethod calls;
    this should have no effect on any user, and is done to silence
    some pedantic warnings in the GAP test suite

2.10 (2012-05-31)

  * Added methods for GAP's Epicentre and EpimorphismSchurCover attribute
  * Added group constructors that allow construction extraspecial groups
    as well as alternating and symmetric groups of degree <= 4 as pcp groups
  * Changed SchurExtension and SchurExtensionEpimorphism into attributes
  * Changed IsomorphismPcpGroup for pcp groups, now returns identity map
  * Changed SchurCovering to be a synonym for GAP's SchurCover attribute
  * Fixed regression in AddFieldCR which caused incorrect errors
    (e.g. when testing whether a pcp group is torsion free)
  * Fixed some warnings by adding a IsGeneratorsOfMagmaWithInverses
    method for pcp element collections
  * Fixed several bugs resulting in errors when computing Schur extensions,
    nonabelian exterior and tensor squares, and so on, but only if the
    argument was a subgroup of a pcp group
  * Fixed computing Schur extensions, nonabelian exterior and tensor squares
    etc. of the infinite cyclic group
  * Fixed bug in direct products of pcp groups that could result in
    wrong embedding and projection maps
  * Fixed error triggered when calling NormalizerOp on two groups
    that have differing Parent() groups, yet still are subgroups
    of a common overgroup
  * Removed some dead obsolete code

2.9 (2012-01-12)

  * Updated README
  * Added GPL license text
  * Added this CHANGES file
  * Added Max Horn to authors / maintainer list
  * Removed Werner Nickel from maintainer list
  * Removed compatibility with GAP versions before 4.4
  * Removed redundant IsomorphismPermGroup method
  * Removed redundant IsPcpGHBI group mapping representation
  * Added various group constructors (TrivialGroupCons etc.),
    so that it is now possible to construct Pcp groups with e.g.
    TrivialGroup(IsPcpGroup) or DihedralGroup(IsPcpGroup, infinity).
    Specifically, this works now for cyclic, (elementary) abelian,
    dihedral, and quaternion groups
  * Added implementations of IndependentGeneratorsOfAbelianGroup and
    IndependentGeneratorExponents for pcp groups
  * Improved handling of homomorphisms between pcp groups and non-pcp
    groups
  * Improved validation of input for various functions / methods
  * Improved AbelianPcpGroup to flag the constructed group as abelian
  * Fixed AbelianInvariants to return values that match what the GAP
    documentation promises the user
  * Fixed a bug that caused TwoCohomologyCR and many related operations
    to error out if the cohomology record was obtained using
    CRRecordBySubgroup or CRRecordByPcp
  * Fixed bug comparing homomorphisms between pcp groups by removing
    the (incorrect) method for this; the default method provided by
    GAP is now used and returns correct results
  * Fixed ClosureGroup method to not make invalid assumptions about
    a group's Parent (and thus no longer return incorrect results)
  * Fixed bug causing general mappings from/to pcp groups to be
    always marked as total, even if they were in fact not
  * Added IsNilpotentByFinite methods for finite and nilpotent groups
  * Added immediate IsTorsionFree method for finite groups
  * Added IsFreeAbelian method for arbitrary groups, turned it into
    a property
  * Converted documentation to GAPDoc format
  * Replaced internal function DepthOfVec by GAP's PositionNonZero
  * Added (trivial) IsomorphismPcpGroup method for pcp groups
  * Added a String method for pcp elements

2.8.1 (2011-05-24)

  * Use Calcreps2 instead of calcreps2 for compatibility with GAP 4.5
  * Updated homepage URLs

2.8 (2011-01-26)

  * Improved and corrected parts of the manual
  * Removed IsomorphismPcpGroup method for fpgroups, and instead
    provide and document it as a regular function under the name
    IsomorphismPcpGroupFromFpGroupWithPcPres
  * Use "-u" option when creating the HTML manual to produce unicode
    output
  * Removed SchurMultiplicator method and instead install a method
    for AbelianInvariantsMultiplier

2.7: Never released

2.6 (2009-02-18)

  * Disabled (and removed any mention from the documentation) some code
    dealing with Schur towers of p-groups of fixed coclass.
  * Fixed email address of Bettina Eick

2.5 (2008-11-25)

  * Added SchurCovers
  * Added dependency on autpgrp package
  * Added GroupHomomorphismByImagesNC implementation for when the source
    is a Pcp group, but the range is possibly not.
  * Compute size of newly constructed group in PcpGroupByCollectorNC
  * Various other fixes and improvements

2.4 (2008-11-12)

  * Fixed a bug in DirectProduct for PcpGroups

2.3 (2008-11-09)

  * Removed compatibility with GAP versions before 4.3
  * Added WhiteheadQuadraticFunctor
  * Added IsPolycyclicPresentation
  * Added IsomorphismPermGroup
  * Renamed DepthVector -> DepthOfVec
  * Renamed PrintFullPresentation -> PrintPcpPresentation
  * Renamed Tail -> TailOfElm
  * Replaced many uses of BindGlobal by InstallGlobalFunction
  * Improved group homomorphism code
  * Implemented Embedding and Projection for DirectProduct
  * Implemented Embedding for WreathProduct
  * Extended AbelianPcpGroup to accept types of arguments (undocumented)
  * Various other fixes and improvements

2.2 (2007-06-22)

  * Added support for non-abelian tensor and exterior squares
  * TODO:  Schur extensions code was also touched?
  * Various other fixes and improvements

2.1 (2006-11-07)

  * Declare in PackageInfo.g that nq is a suggested (but not required)
    external package, and try harder to work when nq is missing.
  * Rewrote SchurExtension
  * Changed IsomorphismPcGroup to first convert the group to a refined
    pcp group; also, the resulting homomorphism is now marked as being
    a group homomorphism.
  * Several existing functions now are "properly" installed via
    InstallMethod or InstallGlobalFunction
  * Various other fixes and improvements

2.0 (2006-10-23)

1.1 (2003-10-15)

1.0 (???)
