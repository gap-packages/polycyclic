LoadPackage("polycyclic");
dirs := DirectoriesPackageLibrary("polycyclic", "tst");

# Also test the manual examples. They are extracted into a temporary
# directory by AutoDocExtractExamples, which older AutoDoc versions lack.
if LoadPackage("AutoDoc", ">= 2026.09.09") = true then
    Add(dirs, AutoDocExtractExamples("polycyclic"));
else
    Print("#I  AutoDoc >= 2026.09.09 not available, skipping manual examples\n");
fi;

TestDirectory(dirs,
    rec(exitGAP := true, testOptions := rec( compareFunction := "uptowhitespace" )));
FORCE_QUIT_GAP(1);
