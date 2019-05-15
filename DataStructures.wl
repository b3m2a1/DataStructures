(* ::Subsection::Closed:: *)
(*Temp Loading Flag Code*)


Temp`PackageScope`DataStructuresLoading`Private`$PackageLoadData=
  If[#===None, <||>, Replace[Quiet@Get@#, Except[_?OptionQ]-><||>]]&@
    Append[
      FileNames[
        "LoadInfo."~~"m"|"wl",
        FileNameJoin@{DirectoryName@$InputFileName, "Config"}
        ],
      None
      ][[1]];
Temp`PackageScope`DataStructuresLoading`Private`$PackageLoadMode=
  Lookup[Temp`PackageScope`DataStructuresLoading`Private`$PackageLoadData, "Mode", "Primary"];
Temp`PackageScope`DataStructuresLoading`Private`$DependencyLoad=
  TrueQ[Temp`PackageScope`DataStructuresLoading`Private`$PackageLoadMode==="Dependency"];


(* ::Subsection:: *)
(*Main*)


If[Temp`PackageScope`DataStructuresLoading`Private`$DependencyLoad,
  If[!TrueQ[Evaluate[Symbol["`DataStructures`PackageScope`Private`$LoadCompleted"]]],
    Get@FileNameJoin@{DirectoryName@$InputFileName, "DataStructuresLoader.wl"}
    ],
  If[!TrueQ[Evaluate[Symbol["DataStructures`PackageScope`Private`$LoadCompleted"]]],
    <<DataStructures`DataStructuresLoader`,
   BeginPackage["DataStructures`"];
   EndPackage[];
   ]
  ]