#############################################################################
##
#W  PackageInfo.g       GAP 4 Package `polycyclic'               Bettina Eick
#W                                                              Werner Nickel
#W                                                                   Max Horn
##
#H  @(#)$Id$
##

SetPackageInfo( rec(

PackageName := "Polycyclic",
Subtitle    := "Computation with polycyclic groups",
Version     := "2.11",
Date        := "07/03/2013",
##  <#GAPDoc Label="PKGVERSIONDATA">
##  <!ENTITY VERSION "2.11">
##  <!ENTITY RELEASEDATE "07 March 2013">
##  <#/GAPDoc>

Persons          := [
  rec( LastName      := "Eick",
       FirstNames    := "Bettina",
       IsAuthor      := true,
       IsMaintainer  := true,
       Email         := "beick@tu-bs.de",
       PostalAddress := Concatenation(
               "AG Algebra und Diskrete Mathematik\n",
               "Institut Computational Mathematics\n",
               "TU Braunschweig\n",
               "Pockelsstr. 14\n",
               "D-38106 Braunschweig\n",
               "Germany" ),
       Place         := "Braunschweig",
       Institution   := "TU Braunschweig"
     ),

  rec( LastName      := "Nickel",
       FirstNames    := "Werner",
       IsAuthor      := true,
       IsMaintainer  := false,
       # MH: Werner rarely (if at all) replies to emails sent to this
       # old email address. To discourage users from sending bug reports
       # there, I have disabled it here.
       #Email         := "nickel@mathematik.tu-darmstadt.de",
       WWWHome       := "http://www.mathematik.tu-darmstadt.de/~nickel/",
     ),

  rec( LastName      := "Horn",
       FirstNames    := "Max",
       IsAuthor      := true,
       IsMaintainer  := true,
       Email         := "max.horn@math.uni-giessen.de",
       WWWHome       := "http://www.quendi.de/math.php",
       PostalAddress := Concatenation( "AG Algebra\n",
                                       "Mathematisches Institut\n",
                                       "Justus-Liebig-Universität Gießen\n",
                                       "Arndtstrasse 2\n",
                                       "35392 Gießen\n",
                                       "Germany" ),
       Place         := "Gießen, Germany",
       Institution   := "Justus-Liebig-Universität Gießen"
     )
    ],

Status         := "accepted",
CommunicatedBy := "Charles Wright (Eugene)",
AcceptDate     := "01/2004",

PackageWWWHome := "http://www.icm.tu-bs.de/ag_algebra/software/polycyclic/",

ArchiveFormats := ".tar.gz .tar.bz2",
ArchiveURL     := Concatenation( ~.PackageWWWHome, "polycyclic-", ~.Version ),
README_URL     := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

AbstractHTML   := Concatenation(
  "This package provides various algorithms for computations ",
  "with polycyclic groups defined by polycyclic presentations."
  ),

PackageDoc     := rec(
  BookName  := "polycyclic",
  ArchiveURLSubset := [ "doc" ],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Computation with polycyclic groups",
  Autoload  := true
),

Dependencies    := rec(
  GAP                    := ">= 4.5",
  NeededOtherPackages    := [["alnuth", "1.0"],
                             ["autpgrp","1.4"]],
  SuggestedOtherPackages := [ ],
  ExternalConditions     := [ ]
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

Autoload         := true,

Keywords := [
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
  "maximal subgroups",
  "Schur cover",
  "Schur multiplicator",
  ]
));

