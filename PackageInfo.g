#############################################################################
##
#W  PackageInfo.g       GAP 4 Package `polycyclic'               Bettina Eick
#W                                                              Werner Nickel
#W                                                                   Max Horn
##

SetPackageInfo( rec(

PackageName := "Polycyclic",
Subtitle    := "Computation with polycyclic groups",
Version     := "2.16",
Date        := "25/07/2020", # dd/mm/yyyy format
License     := "GPL-2.0-or-later",

Persons          := [
  rec( LastName      := "Eick",
       FirstNames    := "Bettina",
       IsAuthor      := true,
       IsMaintainer  := true,
       Email         := "beick@tu-bs.de",
       WWWHome       := "http://www.iaa.tu-bs.de/beick",
       PostalAddress := Concatenation(
               "Institut Analysis und Algebra\n",
               "TU Braunschweig\n",
               "Universitätsplatz 2\n",
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
       Email         := "horn@mathematik.uni-kl.de",
       WWWHome       := "https://www.quendi.de/math",
       PostalAddress := Concatenation(
                          "Fachbereich Mathematik\n",
                          "TU Kaiserslautern\n",
                          "Gottlieb-Daimler-Straße 48\n",
                          "67663 Kaiserslautern\n",
                          "Germany" ),
       Place         := "Kaiserslautern, Germany",
       Institution   := "TU Kaiserslautern"
     )
    ],

Status         := "accepted",
CommunicatedBy := "Charles Wright (Eugene)",
AcceptDate     := "01/2004",

PackageWWWHome  := "https://gap-packages.github.io/polycyclic/",
README_URL      := Concatenation( ~.PackageWWWHome, "README.md" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/gap-packages/polycyclic",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/polycyclic-", ~.Version ),
ArchiveFormats := ".tar.gz",

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
  GAP                    := ">= 4.9",
  NeededOtherPackages    := [["alnuth", "3.0"],
                             ["autpgrp","1.6"]],
  SuggestedOtherPackages := [ ],
  ExternalConditions     := [ ]
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

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
  ],

AutoDoc := rec(
    TitlePage := rec(
        Copyright := "<Index>License</Index>\
&copyright; 2003-2018 by Bettina Eick, Max Horn and Werner Nickel<P/>\
The &Polycyclic; package is free software;\
you can redistribute it and/or modify it under the terms of the\
<URL Text=\"GNU General Public License\">http://www.fsf.org/licenses/gpl.html</URL>\
as published by the Free Software Foundation; either version 2 of the License,\
or (at your option) any later version.",

        Acknowledgements := "\
We appreciate very much all past and future comments, suggestions and\
contributions to this package and its documentation provided by &GAP;\
users and developers.",
    )
),

));

