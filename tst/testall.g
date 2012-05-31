LoadPackage( "polycyclic" );
dirs := DirectoriesPackageLibrary( "polycyclic", "tst" );
ReadTest( Filename( dirs, "homs.tst" ) );
ReadTest( Filename( dirs, "isom.tst" ) );
ReadTest( Filename( dirs, "bugfix.tst" ) );
