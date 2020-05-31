Needs["ScrewCalculusPro`", "ScrewCalculusPro`ScrewCalculusPro`"]

BeginPackage["OdeSolve`", "ScrewCalculusPro`"]

RungeKutta::usage = "RungeKutta[{f1,f2,..}, {x1,x2,..},{x10,x20,..},{t1, dt}]
	numerically integrates the fi functions of the xi with initial values xi0.
	The integration proceeds in steps of dt from 0 to t1.
	RungeKutta[{f1,f2,..}, {x1,x2,..},{x10,x20,..},{t, t0, t1, dt}] integrates
	a time-dependent system from t0 to t1.";

ForwardEuler::usage = "ForwardEuler[{f1,f2,..}, {x1,x2,..},{x10,x20,..},{t1, dt}]
	numerically integrates the fi functions of the xi with initial values xi0.
	The integration proceeds in steps of dt from 0 to t1.
	ForwardEuler[{f1,f2,..}, {x1,x2,..},{x10,x20,..},{t, t0, t1, dt}] integrates
	a time-dependent system from t0 to t1.";

BackwardEuler::usage = "BackwardEuler[{f1,f2,..}, {x1,x2,..},{x10,x20,..},{t1, dt}]
	numerically integrates the fi functions of the xi with initial values xi0.
	The integration proceeds in steps of dt from 0 to t1.
	BackwardEuler[{f1,f2,..}, {x1,x2,..},{x10,x20,..},{t, t0, t1, dt}] integrates
	a time-dependent system from t0 to t1.";
	
CrankNicolson::usage = "CrankNicolson[{f1,f2,..}, {x1,x2,..},{x10,x20,..},{t1, dt}]
	numerically integrates the fi functions of the xi with initial values xi0.
	The integration proceeds in steps of dt from 0 to t1.
	CrankNicolson[{f1,f2,..}, {x1,x2,..},{x10,x20,..},{t, t0, t1, dt}] integrates
	a time-dependent system from t0 to t1.";

ToSO3::usage = "ToSO3[Q] returns the best approximation of Q in SO(3)."

PolarDecompositionRU::usage = "PolarDecompositionRU[Q] returns the decomposition of Q as a product of R in SO(3) and U symmetric and p.d."

PolarDecompositionVR::usage = "PolarDecompositionVR[Q] returns the decomposition of Q as a product of V symmetric and p.d. and R in SO(3)."

SpatialPrincipalDeformations::usage = "SpatialPrincipalDeformations[Q] returns the principal deformations (dilatation factors) and the principal directions in
                                       the spatial frame organized as the column of the output matrix."

LocalPrincipalDeformations::usage = "LocalPrincipalDeformations[Q] returns the principal deformations (dilatation factors) and the principal directions in
                                     the local frame organized as the column of the output matrix."

FrameAxes::usage = "FrameAxes[Q] returns the coordinates of the end points of the axes relative to the columns of Q."

RKStep::usage = " ";
FEStep::usage = " ";
BEStep::usage = " ";
CNstep::usage = " ";
	
Begin["`Private`"]

(* Runge-Kutta Method *)

RKStep[f_, y_, y0_, dt_] :=	
	Module[{k1, k2, k3, k4},
		k1 = dt N[ f/.Thread[y -> y0] ];
		k2 = dt N[ f/.Thread[y -> y0 + k1/2] ];
		k3 = dt N[ f/.Thread[y -> y0 + k2/2] ];
		k4 = dt N[ f/.Thread[y -> y0 + k3] ];
		y0 + (k1 + 2 k2 + 2 k3 + k4)/6
	];	
	
RungeKutta[f_List, y_List, y0_List, {t1_, dt_}] :=
	NestList[ RKStep[f, y, #, N[dt] ]&, N[y0], Round[N[t1/dt]] ]/; Length[f] == Length[y] == Length[y0]
		
RungeKutta[f_List, y_List, y0_List, {t_, t0_, t1_, dt_}] :=
	Module[{res},
		res = RungeKutta[ Append[f, 1], Append[y, t], Append[y0, t0], {t1 - t0, dt} ];
		Drop[#, -1]& /@ res
		  ]/; Length[f] == Length[y] == Length[y0]

(* Forward Euler Method *)

FEStep[f_, y_, y0_, dt_] :=
	Module[{k1},
		k1 = dt N[ f/.Thread[y -> y0] ];
		y0 + k1
	];

ForwardEuler[f_List, y_List, y0_List, {t1_, dt_}] :=
	NestList[ FEStep[f, y, #, N[dt] ]&, N[y0], Round[N[t1/dt]] ]/; Length[f] == Length[y] == Length[y0]
		
ForwardEuler[f_List, y_List, y0_List, {t_, t0_, t1_, dt_}] :=
	Module[{res},
		res = ForwardEuler[ Append[f, 1], Append[y, t], Append[y0, t0], {t1 - t0, dt} ];
		Drop[#, -1]& /@ res
		  ]/; Length[f] == Length[y] == Length[y0]

(* Backward Euler Method *)

BEStep[f_, y_, y0_, dt_] :=
	Module[{ysol, sys, sol},
		ysol = Table[ToExpression["ynext" <> ToString[i]], {i, 1, Length[y0]}];
		sys = ysol - y0 - dt N[ f/.Thread[y -> ysol]];
		sol = FindRoot[sys == 0, Thread[List[ysol, y0]] ];	
		ysol/.sol
	];

BackwardEuler[f_List, y_List, y0_List, {t1_, dt_}] :=
	NestList[ BEStep[f, y, #, N[dt] ]&, N[y0], Round[N[t1/dt]] ]/; Length[f] == Length[y] == Length[y0]
		
BackwardEuler[f_List, y_List, y0_List, {t_, t0_, t1_, dt_}] :=
	Module[{res},
		res = BackwardEuler[ Append[f, 1], Append[y, t], Append[y0, t0], {t1 - t0, dt} ];
		Drop[#, -1]& /@ res
		  ]/; Length[f] == Length[y] == Length[y0]

(* Crank Nicolson Method *)

CNStep[f_, y_, y0_, dt_] :=
	Module[{ysol, sys, sol},
		ysol = Table[ToExpression["ynext" <> ToString[i]], {i, 1, Length[y0]}];
		sys = ysol - y0 - (dt/2) ( N[f/.Thread[y -> y0]] + f/.Thread[y -> ysol] );
		sol = FindRoot[sys == 0, Thread[List[ysol, y0]] ];	
		ysol/.sol
	];

CrankNicolson[f_List, y_List, y0_List, {t1_, dt_}] :=
    NestList[ CNStep[f, y, #, N[dt] ]&, N[y0], Round[N[t1/dt]] ]/; Length[f] == Length[y] == Length[y0]

CrankNicolson[f_List, y_List, y0_List, {t_, t0_, t1_, dt_}] :=
	Module[{res},
		res = CrankNicolson[ Append[f, 1], Append[y, t], Append[y0, t0], {t1 - t0, dt} ];
		Drop[#, -1]& /@ res
		  ]/; Length[f] == Length[y] == Length[y0]


(* Best SO(3) approximation of a given matrix Q *)

ToSO3[Q_] :=
	Module[{U, S, V},
		{U, Sigma, V} = SingularValueDecomposition[Q];
		S = {{1, 0, 0},
			 {0, 1, 0},
			 {0, 0, Det[U.Transpose[V]]}
		    };
		    U.S.Transpose[V]
	];
	
(* Polar decomposition RU (right: is where the deformation matrix U is placed) of a given square matrix Q *)	
	
PolarDecompositionRU[Q_] :=
	Module[{R, U, Utilde, Sigma, Vtilde},
		{Utilde, Sigma, Vtilde} = SingularValueDecomposition[Q];
		 R = Chop[ Utilde.Transpose[Vtilde], 10^(-12) ];
		 U = Chop[ Vtilde.Sigma.Transpose[Vtilde], 10^(-12) ];
		 {R, U} 	
	];

(* Polar decomposition VR (left: is where the deformation matrix V is placed) of a given square matrix Q *)	
	
PolarDecompositionVR[Q_] :=
	Module[{V, R, Utilde, Sigma, Vtilde},
		{Utilde, Sigma, Vtilde} = SingularValueDecomposition[Q];
		 R = Chop[ Utilde.Transpose[Vtilde], 10^(-12) ];
		 V = Chop[ Utilde.Sigma.Transpose[Utilde], 10^(-12) ];
		 {V, R} 	
	];

(* Calculations of the principal deformations and directions in spatial coordinates of a given square matrix Q *)

SpatialPrincipalDeformations[Q_] :=
	Module[{n, i, ulist, Utilde, Sigma, Vtilde, prindefs, prindirs},
	    {Utilde, Sigma, Vtilde} = SingularValueDecomposition[Q];
	    prindefs = Diagonal[Sigma];
	    n = Length[Q];
	    ulist = Transpose[Table[Transpose[Utilde][[i]]/Norm[ Transpose[Utilde][[i]] ], {i,1,n}]];
	    prindirs = ulist;
	    {prindefs, prindirs}		
	];	

(* Calculations of the principal deformations and directions in local coordinates of a given square matrix Q *)

LocalPrincipalDeformations[Q_] :=
	Module[{n, i, vlist, Utilde, Sigma, Vtilde, prindefs, prindirs},
	    {Utilde, Sigma, Vtilde} = SingularValueDecomposition[Q];
	    prindefs = Diagonal[Sigma];
	    n = Length[Q];
	    vlist = Transpose[Table[Transpose[Vtilde][[i]]/Norm[ Transpose[Vtilde][[i]] ], {i,1,n}]];
	    prindirs = vlist;
	    {prindefs, prindirs}		
	];	

FrameAxes[Q_] :=
	Module[{n, orig, axes},
		n = Length[Q];
		orig = Table[0, {n}];
		axes = Table[{orig, Flatten[Take[Q, All, {i}]]}, {i, 1, n}]
	];
	
End[];

(* Protect[RungeKutta] *)

EndPackage[];			