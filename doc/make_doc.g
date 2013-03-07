LoadPackage("gapdoc");;

# Locate GAP installation
if IsRecord(GAPInfo.SystemEnvironment) and
   IsBound(GAPInfo.SystemEnvironment.GAPROOT) then
	GAPROOT:=GAPInfo.SystemEnvironment.GAPROOT;
else
	GAPROOT:="../../..";
fi;
Print("Using GAPROOT = '", GAPROOT, "'\n");

# List of files to scan (tries to include all .gd files)
files := [ "../PackageInfo.g" ];;
basedir:=Directory("../gap");;
for dirname in [".", "action", "basic", "cohom", "cover", "exam", "matrep", "matrix", "pcpgrp"] do
	dir := Filename(basedir, dirname);
	candidates := Filtered(DirectoryContents(dir), function(fname)
			local n; n := Length(fname);
			return n > 3 and fname{[n-2..n]}=".gd";
		end);
	dir := Directory(dir);
	Append(files, List(candidates, fname -> Filename(dir, fname)));
od;

main := "polycyclic";;
bookname := "polycyclic";;
MakeGAPDocDoc( ".", main, files, bookname, GAPROOT, "MathJax" );;

# Copy over the style files (only available in newer GAPDoc versions)
if IsBound(CopyHTMLStyleFiles) then
	CopyHTMLStyleFiles(".");
fi;
