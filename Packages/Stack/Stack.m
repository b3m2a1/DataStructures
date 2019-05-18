(* ::Package:: *)

(* Autogenerated Package *)

StackQueue::usage="A Stack but I can't use the name Stack...";


StackExtend::usage="";
StackPush::usage="";
StackDrop::usage="";
StackPop::usage="";


StackPeek::usage="";


StackSize::usage="";
StackData::usage="";
StackEmptyQ::usage="";
StackQ::usage="";


Begin["`Private`"];


(* ::Subsection:: *)
(*Stack*)



(* ::Subsubsection::Closed:: *)
(*Constructor*)



StackQueue//ClearAll;
StackQueue[]:=StackQueue[Null, 0];
unconstructedQ=Function[Null, System`Private`EntryQ[Unevaluated[#]], HoldFirst];
q:StackQueue[l:_List|Null, ct_]?unconstructedQ:=
System`Private`SetNoEntry[Unevaluated@q]


newStack[stackData_, ctNew_]:=
  System`Private`SetNoEntry@
    Unevaluated[StackQueue[stackData, ctNew]]


(* ::Subsubsection::Closed:: *)
(*Destructor Operations*)



(* basic destructors *)
StackQ[q_StackQueue]:=System`Private`NoEntryQ[q];
StackSize[StackQueue[data_, ct_]]:=ct;
StackData[StackQueue[data_, ct_]]:=data;
StackEmptyQ[q_StackQueue]:=StackSize[q]===0;


(* ::Subsubsection::Closed:: *)
(*Push*)



StackExtend[StackQueue[data_, ct_], dataList_]:=
  newStack[
    Fold[{#2, #}&, data, dataList], 
    ct+Length@dataList
    ];
StackPush[StackQueue[data_, ct_], push_]:=
  newStack[
    {push, data}, 
    ct+1
    ];


(* ::Subsubsection::Closed:: *)
(*Pop*)



StackDrop[s:StackQueue[data_, 0], n_Integer?Positive]:=
  {Null, s};
StackDrop[StackQueue[data_, ct_], n_Integer?Positive]:=
  If[ct>=n,
    {Most@Flatten@data, newStack[Null, 0]},
    With[{pos=ConstantArray[2, n]},
      {
        Flatten@Delete[data, pos],
        newStack[data[[Sequence@@pos]], ct-n]
        }
      ]
    ];
StackPop[s:StackQueue[data_, ct_]]:=
  If[ct>0,
    {
      data[[1]],
      newStack[data[[2]], ct-1]
      },
    {Null, s}
    ]


(* ::Subsubsection::Closed:: *)
(*Peek*)



Peek[StackQueue[data_, ct_], n_Integer?Positive:1]:=
  If[ct>=n,
    Most@Flatten@data,
    With[{pos=ConstantArray[2, n]},
      Flatten@Delete[data, pos]
      ]
    ];


(* ::Subsubsection::Closed:: *)
(*Formatting*)



Format[q_StackQueue?StackQ, StandardForm]:=
RawBoxes@
BoxForm`ArrangeSummaryBox[
StackQueue,
q,
None,
{
BoxForm`MakeSummaryItem[{"Size:", StackSize[q]}, StandardForm]
},
{},
StandardForm
];
Format[q_StackQueue?StackQ, TextForm]:=
"StackQueue[<>]"


End[];



