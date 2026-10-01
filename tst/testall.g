LoadPackage("polycyclic");
TestDirectory(
    DirectoriesPackageLibrary("polycyclic", "tst"),
    rec(exitGAP := true, testOptions := rec( compareFunction := "uptowhitespace" )));
FORCE_QUIT_GAP(1);
