(* ::Package:: *)

(* Autogenerated Package *)

RegisterDataStructure::usage="Handles efficient structure boiler plate";


Begin["`Private`"];


(* ::Subsection:: *)
(*RegisterDataStructure*)



(* ::Subsubsection::Closed:: *)
(*Constructor*)



(* ::Subsubsubsection::Closed:: *)
(*iRegisterConstructor*)



iRegisterConstructor[
  head_,
  head_[args___],
  validator_,
  unconstructedQ_,
  dataPrepper_,
  dataValidQ_
  ]:=
  head[args]?(Function[Null, unconstructedQ@Unevaluated[#], HoldFirst]):=
    With[{newData=dataPrepper[args]},
      Replace[{newData},
        {
          {HoldComplete[d___]}:>
            validator@Unevaluated@head[d],
          {d___}:>
            validator@Unevaluated@head[d]
          }
        ]/;dataValidQ[newData]
      ];


(* ::Subsubsubsection::Closed:: *)
(*iRegisterFastConstructor*)



iRegisterFastConstructor[
  head_,
  head_[args___],
  validator_,
  fastConstructor_
  ]:=
  fastConstructor[args]:=
    validator@Unevaluated[head[args]]


(* ::Subsubsection::Closed:: *)
(*ValidQ*)



iRegisterValidQ[
  head_,
  constructedQ_,
  validQ_
  ]:=
  (
    validQ[h_head]:=
      constructedQ[h];
    validQ[___]:=
      False;
    head[h_head?constructedQ]:=h;
    )


(* ::Subsubsection::Closed:: *)
(*Destructors*)



iRegisterDestructor[
  head_,
  head_[argPat_],
  destructor_
  ]:=(
    destructor[head[p:argPat]]:=p
    );
 iRegisterDestructor[
  head_,
  head_[args___],
  destructor_
  ]:=(
    destructor[head[p:args]]:={p}
    );


(* ::Subsubsection::Closed:: *)
(*Formatting*)



iRegisterFormatter[
  head_,
  validQ_,
  icon_,
  fields_Association?AssociationQ,
  belowTheFold_Association?AssociationQ
  ]:=
  (
    Format[q_head?validQ, StandardForm]:=
      RawBoxes@
        BoxForm`ArrangeSummaryBox[
          head,
          q,
          icon,
          KeyValueMap[
            BoxForm`MakeSummaryItem[{Row@{#, ":"}, #2[q]}, StandardForm]&,
            fields
            ],
          KeyValueMap[
            BoxForm`MakeSummaryItem[{Row@{#, ":"}, #2[q]}, StandardForm]&,
            belowTheFold
            ],
          StandardForm
          ];
    Format[q_head?validQ, TextForm]:=
      "StackQueue[<>]";
    )


(* ::Subsubsection::Closed:: *)
(*RegisterDataStructure*)



(* ::Subsubsubsection::Closed:: *)
(*RegisterDataStructure*)



Options[RegisterDataStructure]=
  {
    "Atomic"->True,
    "Formatted"->Automatic,
    "FormattingRules"-><|
      "Icon"->None,
      "DisplayedFields"-><|"Size"->(Quantity[ByteCount[#], "Bytes"]&)|>,
      "HiddenFields"-><||>
      |>,
    "DataPrepper"->Automatic,
    "DataValidator"->Automatic,
    "Destructor"->Automatic,
    "Validator"->Automatic,
    "FastConstructor"->Automatic,
    "Protect"->False
    };
RegisterDataStructure[
  head_Symbol,
  pat:(head_[args___]),
  ops:OptionsPattern[]
  ]:=
  Module[
    {
      validator,
      unconstructedQ,
      constructedQ,
      validQ,
      destructor,
      fastConstruct,
      prepper,
      dataValidQ,
      format,
      frs
      },
    Unprotect[head];
    ClearAll[head];
    If[TrueQ@OptionValue["Atomic"],
      unconstructedQ = System`Private`EntryQ;
      validator = System`Private`SetNoEntry;
      constructedQ = System`Private`NoEntryQ,
      unconstructedQ = System`Private`ValidQ;
      validator = System`Private`SetValid;
      constructedQ = System`Private`NotValidQ;
      ];
    prepper = OptionValue["DataPrepper"];
    If[prepper===Automatic, prepper=HoldComplete];
    dataValidQ = OptionValue["DataValidator"];
    If[dataValidQ===Automatic, dataValidQ=(True&)];
    iRegisterConstructor[
      head,
      pat,
      validator,
      unconstructedQ,
      prepper,
      dataValidQ
      ];
    fastConstruct = OptionValue["FastConstructor"];
    If[fastConstruct===Automatic, 
      fastConstruct = 
        Symbol[Context[head]<>SymbolName[head]<>"`New"]
      ];
    If[fastConstruct=!=None,
      iRegisterFastConstructor[
        head,
        pat,
        validator,
        fastConstruct
        ]
      ];
    validQ = OptionValue["Validator"];
    If[validQ===Automatic, 
      validQ = 
        Symbol[Context[head]<>SymbolName[head]<>"`ValidQ"]
      ];
    If[validQ=!=None,
      iRegisterValidQ[
        head,
        constructedQ,
        validQ
        ]
      ];
    destructor = OptionValue["Destructor"];
    If[destructor===Automatic, 
      destructor = 
        Symbol[Context[head]<>SymbolName[head]<>"`Data"]
      ];
    If[destructor=!=None,
      iRegisterDestructor[
        head,
        pat,
        destructor
        ]
      ];
    format = OptionValue["Formatted"];
    frs = OptionValue["FormattingRules"];
    Which[
      TrueQ[format], 
        frs=Association@If[!(OptionQ[frs]||AssociationQ[frs]), <||>, frs],
      format=!=Automatic,
        frs=None
      ];
    If[AssociationQ[frs],
      iRegisterFormatter[
        head,
        validQ,
        Lookup[frs, "Icon", None],
        If[!AssociationQ[#], <||>, #]&@
          Association@Lookup[frs, "DisplayedFields", <||>],
        If[!AssociationQ[#], <||>, #]&@
          Association@Lookup[frs, "HiddenFields", <||>]
        ]
      ];
    If[OptionValue["Protect"], Protect[head]];
    head
    ]


End[];


