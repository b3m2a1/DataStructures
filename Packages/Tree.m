(* ::Package:: *)

(* Autogenerated Package *)

Tree::usage="A Tree data structure";


TreeNode::usage="A TreeNode object which exists as a symbolic wrapper on node data";


TreeData::usage="Extracts data from a node";
TreeChildren::usage="Pulls children out of a node";
TreeChildCount::usage="Counts the number of leaves in the tree";


TreeInsert::usage="Inserts a node into a tree";
TreePop::usage="Pops a node (and children) from a tree";
TreeReplace::usage="Replaces a node in a tree";


TreeInsertData::usage="Inserts into the data field of each node";
TreePopData::usage="Deletes from the data field of each node";
TreeReplaceData::usage="Replaces data in a tree";


TreeWalk::usage="Walks a tree";


Begin["`Private`"];


(* ::Text:: *)
(*
	We\[CloseCurlyQuote]ll use a linked-list implementation to get efficient sub-tree-ing
	This will feel rather like our Stack implementation, honestly... but rather than introducing pushes and pops we\[CloseCurlyQuote]ll introduce tree insertion, deletion, rearrangement, and walking
*)



(* ::Subsection:: *)
(*Tree*)



(* ::Subsubsection::Closed:: *)
(*Constructor*)



(* ::Subsubsubsection::Closed:: *)
(*Tree*)



Tree//ClearAll;
Tree[]:=Tree[{{}, {}}];
unconstructedQ=
  Function[Null, System`Private`EntryQ[Unevaluated[#]], HoldFirst];
q:Tree[l_List]?unconstructedQ:=
System`Private`SetNoEntry[Unevaluated@q]


newTree[list_]:=
  System`Private`SetNoEntry@
    Unevaluated[Tree[list]]


(* ::Subsubsubsection::Closed:: *)
(*TreeNode*)



TreeNode//Clear
TreeNode[]:=TreeNode[{}(* data field *), {}(*children field *)];
n:TreeNode[data_List, children_List]?unconstructedQ:=
System`Private`SetNoEntry[Unevaluated@n]
newNode[data_, children_]:=
  System`Private`SetNoEntry@
    Unevaluated[TreeNode[data, children]]


(* ::Subsubsection::Closed:: *)
(*Destructor Operations*)



(* basic destructors *)
TreeQ//Clear
TreeQ[q_Tree]:=System`Private`NoEntryQ[q];
TreeQ[_]:=False;


TreeNodeQ//Clear
TreeNodeQ[q_TreeNode]:=System`Private`NoEntryQ[q];
TreeNodeQ[_]:=False


(* ::Subsubsection::Closed:: *)
(*treePosSpec*)



treePosSpec//Clear
treePosSpec[{}|None]:=
  {};
treePosSpec[pos:{__Integer}]:=
  Prepend[Riffle[pos, 2], 2];
treePosSpec[i_Integer]:=
  treePosSpec[{i}];


(* ::Subsubsection::Closed:: *)
(*treeHasDepth*)



treeHasDepth[t_, posSpec_]:=
  Quiet[Check[t[[Sequence@@posSpec]];True, False, Part::partw], Part::partw];


(* ::Subsubsection::Closed:: *)
(*Children*)



Tree::nochild="Tree doesn't have children at node `` and position ``";
TreeNode::nohild="TreeNode doesn't have children at node `` and position ``";


(* ::Subsubsubsection::Closed:: *)
(*treeChildren*)



treeChildren//Clear
treeChildren[
  head_,
  obj_,
  list_, 
  pos:{___Integer}|_Integer|None,
  children_
  ]:=
  Module[
    {
      ps=Join[treePosSpec[pos], {2, children}],
      $failed,
      c
      },
    c=
      Quiet[
        Check[
          list[[Sequence@@ps]],
          $failed,
          Part::partw], 
        Part::partw
        ];
    If[c=!=$failed,
      c,
      Message[head::nochild, pos, children];
      Failure["NoChild", <|
        "MessageTemplate":>head::nochild,
        "MessageParameters":>{pos, children, obj}
        |>
        ]
      ]
    ];


(* ::Subsubsubsection::Closed:: *)
(*TreeChildren*)



TreeChildren//Clear
TreeChildren[
  n:Tree[t_], 
  pos:{___Integer}|_Integer:1,
  children:{___Integer}|_Integer|_Span|All:All
  ]:=
  With[{l=treeChildren[Tree, n, t, pos, children]},
    Which[
      Not@ListQ@l, 
        l,
      IntegerQ@children,
        newNode@@l,
      True,
        newNode@@@l
      ]
    ];
TreeChildren[
  n:TreeNode[d_, t_], 
  pos:{___Integer}|_Integer:1,
  children:{___Integer}|_Integer|_Span|All:All
  ]:=
  With[{l=treeChildren[TreeNode, n, t, pos, children]},
    Which[
      Not@ListQ@l, 
        l,
      IntegerQ@children,
        newNode@@l,
      True,
        newNode@@@l
      ]
    ];


(* ::Subsubsection::Closed:: *)
(*ChildCount*)



(* ::Subsubsubsection::Closed:: *)
(*TreeChildCount*)



TreeChildCount//Clear
TreeChildCount[
  n:Tree[t_], 
  pos:{___Integer}|_Integer|None:None
  ]:=
  With[{l=treeChildren[Tree, n, t, pos, All]},
    If[ListQ@l, Length@l, l]
    ];
TreeChildCount[
  n:TreeNode[d_, t_], 
  pos:{___Integer}|_Integer|None:None,
  children:{___Integer}|_Integer|_Span|All:All
  ]:=
  With[{l=treeChildren[TreeNode, n, {d, t}, pos, All]},
    If[ListQ@l, Length@l, l]
    ];


(* ::Subsubsection::Closed:: *)
(*Insert*)



Tree::nonode="Tree doesn't have a node at ``";
TreeNode::nohild="TreeNode doesn't have a node at ``";


(* ::Subsubsubsection::Closed:: *)
(*treeInsert*)



treeInsert//Clear
treeInsert[
  head_,
  obj_,
  list_, 
  node:{data_List, children_List}, 
  pos:{___Integer}|_Integer|None,
  where:_Integer
  ]:=
  Module[
    {
      c, 
      $failed, 
      ps=Join[treePosSpec[pos], {2, where}]
      },
    c=
      Quiet[
        Check[
          Insert[list, node, ps],
          $failed,
          Insert::ins
          ],
        Insert::ins
        ];
    If[c===$failed,
      Message[head::nonode, pos];
      Failure["NoNode", <|
        "MessageTemplate":>head::nonode,
        "MessageParameters":>{pos, obj}
        |>
        ],
      c
      ]
    ];
treeInsert[
  head_,
  obj_,
  list_, 
  TreeNode[data_List, children_List], 
  pos:{___Integer}|_Integer|None,
  where:_Integer
  ]:=
  treeInsert[head, obj, list, {data, children}, pos, where];


(* ::Subsubsubsection::Closed:: *)
(*TreeInsert*)



TreeInsert//Clear
TreeInsert[
  n:Tree[t_], 
  node:{data_List, children_List}|_TreeNode?TreeNodeQ, 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1
  ]:=
  With[{l=treeInsert[Tree, n, t, node, pos, where]},
    If[ListQ@l, newTree[l], l]
    ];
TreeInsert[
  n:TreeNode[d_, t_], 
  node:{data_List, children_List}|_TreeNode?TreeNodeQ, 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1
  ]:=
  With[{l=treeInsert[TreeNode, n, {d, t}, node, pos, where]},
    If[ListQ@l, newNode[d, l], l]
    ];
TreeInsert[
  n:_Tree|_TreeNode, 
  data_, 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1
  ]:=
  TreeInsert[n, {{data}, {}}, pos, where]


(* ::Subsubsection::Closed:: *)
(*Replace*)



(* ::Subsubsubsection::Closed:: *)
(*treeReplace*)



treeReplace//Clear
treeReplace[
  head_,
  obj_,
  list_, 
  node:{data_List, children_List}, 
  pos:{___Integer}|_Integer|None,
  where:_Integer
  ]:=
  Module[
    {
      c, 
      $failed, 
      ps=Join[treePosSpec[pos], {2, where}]
      },
    c=
      Quiet[
        Check[
          ReplacePart[list, ps->node],
          $failed,
          Insert::ins
          ],
        Insert::ins
        ];
    If[c===$failed,
      Message[head::nonode, pos];
      Failure["NoNode", <|
        "MessageTemplate":>head::nonode,
        "MessageParameters":>{pos, obj}
        |>
        ],
      c
      ]
    ];
treeReplace[
  head_,
  obj_,
  list_, 
  TreeNode[data_List, children_List], 
  pos:{___Integer}|_Integer|None,
  where:_Integer
  ]:=
  treeInsert[head, obj, list, {data, children}, pos, where];


(* ::Subsubsubsection::Closed:: *)
(*TreeReplace*)



TreeReplace//Clear
TreeReplace[
  n:Tree[t_],  
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1,
  node:{data_List, children_List}|_TreeNode?TreeNodeQ
  ]:=
  With[{l=treeReplace[Tree, n, t, node, pos, where]},
    If[ListQ@l, newTree[l], l]
    ];
TreeReplace[
  n:TreeNode[d_, t_], 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1,
  node:{data_List, children_List}|_TreeNode?TreeNodeQ
  ]:=
  With[{l=treeReplace[TreeNode, n, {d, t}, node, pos, where]},
    If[ListQ@l, newNode[d, l], l]
    ];
TreeReplace[
  n:_Tree|_TreeNode, 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1,
  data_
  ]:=
  TreeReplace[n, {{data}, {}}, pos, where]


(* ::Subsubsection::Closed:: *)
(*InsertData*)



(* ::Subsubsubsection::Closed:: *)
(*treeInsertData*)



treeInsertData//Clear
treeInsertData[
  head_,
  obj_,
  list_, 
  data_, 
  pos:{___Integer}|_Integer|None,
  where:_Integer
  ]:=
  Module[{c, $failed, 
    ps=Join[treePosSpec[pos], {1, where}]
    },
    c=
      Quiet[
        Check[
          Insert[list, data, ps],
          $failed,
          Insert::ins
          ],
        Insert::ins
        ];
    If[c===$failed,
      Message[head::nonode, pos];
      Failure["NoNode", <|
        "MessageTemplate":>head::nonode,
        "MessageParameters":>{pos, obj}
        |>
        ],
      c
      ]
    ];


(* ::Subsubsubsection::Closed:: *)
(*TreeInsertData*)



TreeInsertData//Clear;
TreeInsertData[
  n:Tree[t_], 
  data_, 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1
  ]:=
  With[{l=treeInsertData[Tree, n, t, data, pos, where]},
    If[ListQ@l, newTree[l], l]
    ];
TreeInsertData[
  n:TreeNode[d_, t_], 
  data_,
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1
  ]:=
  With[{l=treeInsertData[TreeNode, n, {d, t}, data, pos, where]},
    If[ListQ@l, newNode[d, l], l]
    ];


(* ::Subsubsection::Closed:: *)
(*ReplaceData*)



(* ::Subsubsubsection::Closed:: *)
(*treeReplaceData*)



treeReplaceData//Clear
treeReplaceData[
  head_,
  obj_,
  list_, 
  data_, 
  pos:{___Integer}|_Integer|None,
  where:_Integer
  ]:=
  Module[{c, $failed, 
    ps=Join[treePosSpec[pos], {1, where}]
    },
    c=
      Quiet[
        Check[
          ReplacePart[list, ps->data],
          $failed,
          Insert::ins
          ],
        Insert::ins
        ];
    If[c===$failed,
      Message[head::nonode, pos];
      Failure["NoNode", <|
        "MessageTemplate":>head::nonode,
        "MessageParameters":>{pos, obj}
        |>
        ],
      c
      ]
    ];


(* ::Subsubsubsection::Closed:: *)
(*TreeReplaceData*)



TreeReplaceData//Clear;
TreeReplaceData[
  n:Tree[t_], 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1,
  data_, 
  ]:=
  With[{l=treeReplaceData[Tree, n, t, data, pos, where]},
    If[ListQ@l, newTree[l], l]
    ];
TreeReplaceData[
  n:TreeNode[d_, t_], 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1,
  data_
  ]:=
  With[{l=treeReplaceData[TreeNode, n, {d, t}, data, pos, where]},
    If[ListQ@l, newNode[d, l], l]
    ];


(* ::Subsubsection::Closed:: *)
(*Pop*)



(* ::Subsubsubsection::Closed:: *)
(*treePop*)



treePop[
  head_,
  obj_,
  list_, 
  pos:{___Integer}|_Integer|None,
  where:_Integer
  ]:=
  Module[
    {
      ps=
        Join[treePosSpec[pos], {2, where}],
      $failed,
      c
      },
    c=
      Quiet[
        Check[list[[Sequence@@ps]], 
          $failed,
          Part::partw], 
        Part::partw
        ];
    If[c=!=$failed,
      {c, Delete[list, ps]},
      Message[head::nochild, pos, where];
      Failure["BadPart", <|
        "MessageTemplate":>head::partw,
        "MessageParameters":>{pos, where, obj}
        |>
        ]
      ]
    ];


(* ::Subsubsubsection::Closed:: *)
(*TreePop*)



TreePop//Clear
TreePop[
  n:Tree[t_], 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1
  ]:=
  With[{l=treePop[Tree, n, t, pos, where]},
    If[ListQ@l, {newNode@@l[[1]], newTree[l[[2]]]}, l]
    ];
TreePop[
  n:TreeNode[d_, t_], 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1
  ]:=
  With[{l=treePop[TreeNode, n, {d, t}, pos, where]},
    If[ListQ@l, {newNode@@l[[1]], newNode@@l[[2]]}, l]
    ]


(* ::Subsubsection::Closed:: *)
(*PopData*)



Tree::nodata="Tree doesn't have data at node `` and position ``";
TreeNode::nodata="TreeNode doesn't have data at node `` and position ``";


(* ::Subsubsubsection::Closed:: *)
(*treePopData*)



treePopData//Clear
treePopData[
  head_,
  obj_,
  list_, 
  pos:{___Integer}|_Integer|None,
  where:_Integer
  ]:=
  Module[
    {
      ps=Join[treePosSpec[pos], {1, where}],
      $failed,
      c
      },
    c=
      Quiet[
        Check[list[[Sequence@@ps]], 
          $failed,
          Part::partw], 
        Part::partw
        ];
    If[c=!=$failed,
      {c, Delete[list, ps]},
      Message[head::nodata, pos, where];
      Failure["NoData", <|
        "MessageTemplate":>head::nodata,
        "MessageParameters":>{pos, where, obj}
        |>
        ]
      ]
    ];


(* ::Subsubsubsection::Closed:: *)
(*TreePopData*)



TreePopData//Clear
TreePopData[
  n:Tree[t_], 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1
  ]:=
  With[{l=treePopData[Tree, n, t, pos, where]},
    If[ListQ@l, {l[[1]], newTree[l[[2]]]}, l]
    ];
TreePopData[
  n:TreeNode[d_, t_], 
  pos:{___Integer}|_Integer|None:None,
  where:_Integer:-1
  ]:=
  With[{l=treePopData[TreeNode, n, {d, t}, pos, where]},
    If[ListQ@l, {l[[1]], newNode@@l[[2]]}, l]
    ]


(* ::Subsubsection::Closed:: *)
(*TreeWalk*)



(* ::Text:: *)
(*

We\[CloseCurlyQuote]ll provide like three events?
	- \[OpenCurlyDoubleQuote]EnterNode\[CloseCurlyDoubleQuote]
	- \[OpenCurlyDoubleQuote]ProcessNode\[CloseCurlyDoubleQuote]
	- \[OpenCurlyDoubleQuote]ExitNode\[CloseCurlyDoubleQuote]
	
*)



(* ::Subsubsubsection::Closed:: *)
(*walkTreeDF*)



(* ::Text:: *)
(*
	Simple depth-first traversal of a node
*)



walkTreeDF[node_, handlers:{body_, enter_, exit_}]:=  
  Module[{children = node[[2]], res},
    node = enter[node];
    res=
      body[
        {
          node[[1]],
          walkASTNodeDF[#, handlers]&/@children
          },
        node
        ];
    exit[res, node]
    ];


(* ::Subsubsubsection::Closed:: *)
(*walkTreeBF*)



walkTreeBF[root_, handlers:{body_, enter_, exit_}]:=  
    Module[
      {
        node = root,
        children, 
        res,
        q = Queue[]
        },
      Reap[
        q = QueuePush[q, node];
        While[!QueueEmptyQ[q],
          node = QueuePop[q];
          node = enter[node];
          children = root["Children"];
          q = QueueExtend[q, children];
          res = body[node, node];
          exit[res, node];
          ];
        "WalkTree"
        ][[2]]
    ];


(* ::Subsubsubsection::Closed:: *)
(*TreeWalk*)



(* ::Subsubsubsubsection::Closed:: *)
(*$TreeTraversalFunctions*)



$TreeTraversalFunctions=
  <|
    "DepthFirst"-><|
      "EnterNode"->#&,
      "ExitNode"->#&,
      "ProcessNode"->#&
      |>,
    "BreadthFirst"-><|
      "EnterNode"->#&,
      "ExitNode"->(Sow[#, "WalkTree"]&),
      "ProcessNode"->#&
      |>
    |>;


(* ::Subsubsubsubsection::Closed:: *)
(*iTreeWalk*)



Options[iTreeWalk]=
  {
    "TraversalFunction"->"DepthFirst"
    };
iTreeWalk[node_, visitFunctions_,
  ops:OptionsPattern[]
  ]:=
  Module[
    {
      mode, enter, exit, body,
      funcs
      },
    mode=
      Replace[
        OptionValue[iTreeWalk, 
          FilterRules[{ops}, "TraversalFunction"], 
          "TraversalFunction"
          ],
        {
          "BreadthFirst"->walkTreeBF,
          "DepthFirst"->walkTreeDF
          }
        ];
    funcs = 
      Lookup[$TreeTraversalFunctions, mode, $TreeTraversalFunctions["DepthFirst"]];
    enter=Lookup[visitFunctions, "EnterNode",   funcs["EnterNode"]];
    exit =Lookup[visitFunctions, "ExitNode",    funcs["ExitNode"]];
    body =Lookup[visitFunctions, "ProcessNode", funcs["ProcessNode"]];
    mode[node, {body, enter, exit}]
    ];


(* ::Subsubsubsubsection::Closed:: *)
(*TreeWalk*)



Options[TreeWalk]=
  Options[iTreeWalk];
TreeWalk[Tree[t_], visitFunctions_, ops:OptionsPattern[]]:=
  iTreeWalk[t, visitFunctions, ops];
TreeWalk[TreeNode[d_, t_], visitFunctions_, ops:OptionsPattern[]]:=
  iTreeWalk[{d, t}, visitFunctions, ops];


(* ::Subsubsection::Closed:: *)
(*Formatting*)



(* ::Subsubsubsection::Closed:: *)
(*Tree*)



Format[q_Tree?TreeQ, StandardForm]:=
  RawBoxes@
    BoxForm`ArrangeSummaryBox[
      Tree,
      q,
      None,
      {
        BoxForm`MakeSummaryItem[
          {
            "Root:", 
              Quiet@Check[Replace[TreePopData[q], {a_, _}:>a], None, Tree::nodata]
            }, 
          StandardForm
          ],
        BoxForm`MakeSummaryItem[
          {
            "Children:", 
              Quiet@Check[TreeChildCount[q], 0, Tree::nochild]
            }, 
          StandardForm
          ]
        },
      {},
      StandardForm
      ];
Format[q_Tree?Tree, TextForm]:=
  "Tree[<>]"


(* ::Subsubsubsection::Closed:: *)
(*Node*)



Format[q_TreeNode?TreeNodeQ, StandardForm]:=
  RawBoxes@
    BoxForm`ArrangeSummaryBox[
      TreeNode,
      q,
      None,
      {
        BoxForm`MakeSummaryItem[
          {
            "Root:", 
              Quiet@Check[Replace[TreePopData[q], {a_, _}:>a], None, TreeNode::nodata]
            }, 
          StandardForm
          ],
        BoxForm`MakeSummaryItem[
          {
            "Children:", 
              Quiet@Check[TreeChildCount[q], 0, TreeNode::nochild]
            }, 
          StandardForm
          ]
        },
      {},
      StandardForm
      ];
Format[q_TreeNode?TreeNodeQ, TextForm]:=
  "TreeNode[<>]"


End[];



