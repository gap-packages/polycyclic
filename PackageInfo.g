#############################################################################
##
#W  PackageInfo.g       GAP 4 Package `polycyclic'               Bettina Eick
#W                                                              Werner Nickel
##  
#H  @(#)$Id: PackageInfo.g,v 1.22 2007/06/22 15:36:47 werner Exp $
##

SetPackageInfo( rec(

PackageName := "Polycyclic",
Subtitle    := "Computation with polycyclic groups",
Version     := "2.2",
Date        := "22/06/2007",

ArchiveFormats := ".tar.gz",
ArchiveURL     := 
"http://www.icm.tu-bs.de/ag_algebra/software/eick/polycyclic/polycyclic-2.2",

Persons          := [ 
  rec( LastName      := "Eick",
       FirstNames    := "Bettina",
       IsAuthor      := true,
       IsMaintainer  := true,
       Email         := "b.eick@tu-bs.de",
       WWWHome       := "http://www.tu-bs.de/~beick",
       PostalAddress := Concatenation([
               "Institut Computational Mathematics\n",
               "TU Braunschweig\n",
               "Pockelsstr. 14 \n D-38106 Braunschweig \n Germany"] ),
       Place         := "Braunschweig",
       Institution   := "TU Braunschweig"),

  rec( LastName      := "Nickel",
       FirstNames    := "Werner",
       IsAuthor      := true,
       IsMaintainer  := true,
       Email         := "nickel@mathematik.tu-darmstadt.de",
       WWWHome       := "http://www.mathematik.tu-darmstadt.de/~nickel",
       PostalAddress := Concatenation( 
               "Fachbereich Mathematik\n",
               "TU Darmstadt\n",
               "Schlossgartenstr. 7\n",
               "64289 Darmstadt\n",
               "Germany" ),
       Place         := "Darmstadt, Germany",
       Institution   := "Fachbereich Mathematik, TU Darmstadt") ],

Status              := "accepted",
CommunicatedBy   := "Charles Wright (Eugene)",
AcceptDate       := "01/2004",

README_URL := 
"http://www.icm.tu-bs.de/ag_algebra/software/eick/polycyclic/README",
PackageInfoURL :=
"http://www.icm.tu-bs.de/ag_algebra/software/eick/polycyclic/PackageInfo.g",

AbstractHTML     :=
"This package provides various algorithms for computations with polycyclic groups defined by polycyclic presentations.",

PackageWWWHome := "http://www.mathematik.tu-darmstadt.de/~nickel/software/polycyclic/",

PackageDoc     := rec(
                BookName  := "polycyclic",
                ArchiveURLSubset   := [ "doc", "htm" ],
                HTMLStart := "htm/chapters.htm",
                PDFFile   := "doc/manual.pdf",
                SixFile   := "doc/manual.six",
                LongTitle := "Computation with polycyclic groups",
                Autoload  := true),

Dependencies    := rec(
                GAP                    := ">= 4.3fix4",
                NeededOtherPackages    := [["alnuth", "1.0"]],
                SuggestedOtherPackages := [["nq","1.0"]],
                ExternalConditions     := [ ]),

AvailabilityTest := ReturnTrue,
BannerString     := Concatenation( "Loading polycyclic ",
                            String( ~.Version ), " ...\n" ),
Autoload         := true,
Keywords         := [ 
 "finitely generated nilpotent groups",
 "metacyclic groups",
 "collection",
 "consistency check",
 "solvable word problem",
 "normalizers","centralizers", "intersection",
 "conjugacy problem",
 "subgroups of finite index",
 "torsion subgroup", "finite subgroups",
 "extensions",
 "complements",
 "cohomology groups",
 "orbit-stabilizer algorithms",
 "fitting subgroup",
 "center",
 "infinite groups",
 "polycyclic generating sequence",
 "polycyclic presentation",
 "polycyclic group",
 "polycyclically presented group",
 "polycyclic presentation",
 "maximal subgroups" ]
));

