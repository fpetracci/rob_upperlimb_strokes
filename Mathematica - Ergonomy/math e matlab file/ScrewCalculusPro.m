(* ::Package:: *)

(* 
*             ScrewCalculusPro.m - a Mathematica Package for Geometric and Kinematic
*                               Analysis of Robotic Systems
*
*                                       Marco Gabiccini
*
*             Dipartimento di Ingegneria Meccanica, Nucleare e della Produzione
*             Facolt\[AGrave] di Ingegneria - Universit\[AGrave] di Pisa
*             56122 Pisa (PI) - Italy
*
*  Copyright (c) 2007-2008, Marco Gabiccini
*  Permission is granted to copy, modify and redistribute this file,
*  provided that this header message is retained. 
*
* Version 0.01
*
*)

Needs["NumericalCalculus`"];
(* BeginPackage["ScrewCalculusPro`", "Global`", "NumericalCalculus`"] *)
BeginPackage["ScrewCalculusPro`", "NumericalCalculus`"]

(*
*  Preamble for Function Usage
*
*  Document all of the functions which are defined in this file.
*  Example: obtain documentation for function RotationQ just typing
*           ?RotationQ
*  
*)

(*
*  Beginning of private section of the package
*)

(* Utility functions for manipulating matrices *)

AppendColumns::usage=
"AppendColumns[mat1, mat2, ...] gives a new matrix composed of the
submatrices mat1, mat2, ... , by joining their columns. The submatrices must
all have the same number of columns."

AppendRows::usage=
"AppendRows[mat1, mat2, ...] gives a new matrix composed of the submatrices
mat1, mat2, ..., by joining their rows. The submatrices must all have the same
number of rows."

StackCols::usage=
"StakCols[mat1, mat2, ...] gives a new matrix obtained by stacking the columns 
of the submatrices mat1, mat2, ... . The submatrices must all have the same number
of rows."

StackRows::usage=
"StackRows[mat1, mat2, ...] gives a new matrix obtained by stacking the rows
of the submatrices mat1, mat2, ... . The submatrices must all have the same number 
of columns."

BlockMatrix::usage=
"BlockMatrix[block] gives a matrix composed of a matrix of matrices."

BlockDiag::usage=
"BlockDiag[list] gives a block-diagonal matrix composed of the matrices listed in list."

TakeRows::usage=
"TakeRows[mat, part] takes the rows of matrix mat given by the partspec,
part. This uses the same notation as Take."

TakeColumns::usage=
"TakeColumns[mat, part] takes the columns of matrix mat given by the
partspec, part. This uses the same notation as Take."

TakeMatrix::usage=
"TakeMatrix[mat, start, end] gives the submatrix starting at position start
and ending at position end, where each position is expressed as a 
{row, column} pair, e.g., {1, 2}."

SubMatrix::usage=
"SubMatrix[mat, start, dim] gives the submatrix of dimension dim = {m, n} starting
at position start = {i, j} in mat."

ZeroMatrix::usage=
"ZeroMatrix[n] gives the nxn zero matrix."

SelectionMatrix::usage=
"SelectionMatrix[q_List, indexlist_List] or SelectionMatrix[n_Integer, indexlist_List] returns the selection matrix with n=Length[q] columns that returns the
indexlist components of q."

SelectionMatrixColumns::usage=
"SelectionMatrixColumns[n, indexlist] returns the matrix that selects the indexlist columns from a matrix with n columns."

Magnitude::usage=
 "Magnitude[v] gives length of v."

(* Utilities *)

RotX::usage=
"RotX[alpha] gives the rotation matrix about the X axis.";

RotY::usage=
"RotY[alpha] gives the rotation matrix about the Y axis.";

RotZ::usage=
"RotZ[alpha] gives the rotation matrix about the Z axis.";

ATan2::usage =
"ATan2[y, x] gives the angle with tangent given by y/x in the right quadrant."

EulZXZToMat::usage=
"EulZXZToMat[alpha, beta, gamma] returns the rotation matrix corresponding to the ZXZ Euler angles.
This is the one of the standard parametrizations employed in Multibody Dynamics."

EulZYZToMat::usage=
"EulZYZToMat[alpha, beta, gamma] returns the rotation matrix corresponding to the ZYZ Euler angles.
This is the one of the standard parametrizations employed in Robotics."

EulZYXToMat::usage = RPYToMat::usage=
"EulZYXToMat[alpha, beta, gamma] returns the rotation matrix corresponding to the ZYX Euler angles,
also known as Roll, Pitch and Yaw.
This is one of the standard parametrizations employed in Robotics."

RodriguezToMat::usage=
"RodriguezToMat[g1, g2, g3] returns the rotation matrix corresponding to the Rodriguez parameters g1, g2, g3.\
Recall that {g1, g2, g3} = r tan(theta/2)."

RodriguezToSpatialJac::usage=
"RodriguezToSpatialJac[g1, g2, g3] returns the Spatial Jacobian Js corresponding to Rodriguez parameters.\
This is such that w_s = Js dot{g1, g2, g3}, with w_s spatial components."

RodriguezToBodyJac::usage=
"RodriguezToBodyJac[g1, g2, g3] returns the Body Jacobian Jb corresponding to Rodriguez parameters.\
This is such that w_b = Jb dot{g1, g2, g3}, with w_b body fixed components."

EulZXZToSpatialJac::usage=
"EulZXZToSpatialJac[alpha, beta, gamma] returns the Spatial Jacobian Js corresponding to the ZXZ Euler angles.
This is such that w_s = Js dot{alpha, beta, gamma}, with w_s spatial components."

EulZXZToBodyJac::usage=
"EulZXZToBodyJac[alpha, beta, gamma] returns the Body Jacobian Jb corresponding to the ZXZ Euler angles.
This is such that w_b = Jb dot{alpha, beta, gamma}, with w_b body fixed components."

EulZYZToSpatialJac::usage=
"EulZYZToSpatialJac[alpha, beta, gamma] returns the Spatial Jacobian Js corresponding to the ZYZ Euler angles.
This is such that w_s = Js dot{alpha, beta, gamma}, with w_s spatial components."

EulZYZToBodyJac::usage=
"EulZYZToBodyJac[alpha, beta, gamma] returns the Body Jacobian Jb corresponding to the ZYZ Euler angles.
This is such that w_b = Jb dot{alpha, beta, gamma}, with w_b body fixed components."

EulZYXToSpatialJac::usage=
"EulZYXToSpatialJac[alpha, beta, gamma] returns the Spatial Jacobian Js corresponding to the ZYX Euler angles.
This is such that w_s = Js dot{alpha, beta, gamma}, with w_s spatial components."

EulZYXToBodyJac::usage=
"EulZYXToBodyJac[alpha, beta, gamma] returns the Body Jacobian Jb corresponding to the ZYX Euler angles.
This is such that w_b = Jb dot{alpha, beta, gamma}, with w_b body fixed components."

QuatToSpatialJac::usage=
"QuatToSpatialJac[q] returns the Spatial Jacobian Js corresponding to the unit quaternion q (1-vector).
If q = (q0, q1, q2, q3), w_s = Js dot{q}."

QuatToBodyJac::usage=
"QuatToBodyJac[q] returns the Body Jacobian Jb corresponding to the unit quaternion q (1-vector).
If q = (q0, q1, q2, q3), w_b = Jb dot{q}."

(* Inverse functions given only for ZYZ and RPY - both non singular and singular cases can be handled *)

MatToEulZYZ::usage=
"MatToEulZYZ[R] returns the Euler angles for the parametrization ZYZ corresponding to the rotation matrix R."

MatToEulZYX::usage=MatToRPY::usage=
"MatToEulZYX[R] returns the Euler angles for the parametrization ZYX (also called RPY) corresponding to the rotation matrix R."

MatToVect::usage=
"MatToVect[R] returns the orientation error e_O = r sin(theta), where r and theta are the components of the axis angle parametrization.
e_O represents also the axis form of the skew-symm matrix R_SS = (1/2) (R - R^T)."

FramesToVect::usage=
"FramesTovect[{ R, Rd }] returns the orientation error e_O = r sin(theta) of frame Rd (desired) w.r.t. R (actual) in the spatial frame\
where both R and Rd are expressed."

(* Utilities for testing matrix properties *)

RotationQ::usage=
  "RotationQ[m] tests whether matrix m is a rotation matrix.";

skewQ::usage=
  "skewQ[m] tests whether matrix m is a skew-symmetrix matrix.";

(* Homogeneous representation *)
HomogeneousToVector::usage=
  "HomogeneousToVector[q] extracts the cartesian coordinates from homogeneous components q.";

PointToHomogeneous::usage=
  "PointToHomogeneous[q] gives the homogeneous representation of a point.";

VectorToHomogeneous::usage=
  "VectorToHomogeneous[q] gives the homogeneous representation of a vector.";

RPToHomogeneous::usage=
  "RPToHomogeneous[R,p] forms homogeneous matrix from rotation matrix R \
  and position vector p.";
  
RigidOrientation::usage=
  "RigidOrientation[g] extracts rotation matrix R from g.";

RigidPosition::usage=
  "RigidPosition[g] extracts position vector p from g.";
  
RigidInverse::usage=
  "RigidInverse[g] gives the inverse transformation of g";  

RotationAxis::usage=
"RotationAxis[R] returns the rotation axis of R in SO(3)."  
  
RotationParam::usage=
 "RotationParam[R] returns the rotation axis the and amount of rotation of R in SO(3)."  
  
(* Operations on so(3), the Lie algebra of SO(3) *)

AxisToSkew::usage=Skew::usage=Hat::usage=
  "AxisToSkew[w] generates skew-symmetric matrix given 3 vector w";

SkewToAxis::usage=UnSkew::usage=HatInv::usage=
  "SkewToAxis[S] extracts vector w from skew-symmetric matrix S";

SkewExp::usage=
 "SkewExp[w,(theta)] gives the matrix exponential of an axis w.
  Default value of Theta is 1.";

xitow::usage=
"xitow[xi] gives the angular part of twist xi."

xitov::usage=
"xitov[xi] gives the translational part of twist xi."


(* Operations on se(e), the Lie algebra of SE(3) *)

TwistExp::usage=
 "TwistExp[xi,(Theta)] gives the matrix exponential of a twist xi.
  Default value of Theta is 1.";

TwistToHomogeneous::usage=
  "TwistToHomogeneous[xi] converts xi from a 6 vector to a 4x4 matrix.";

HomogeneousToTwist::usage=
  "HomogeneousToTwist[xi] converts xi from a 4x4 matrix to a 6 vector.";

RigidTwist::usage=
  "RigidTwist[g] extracts 6 vector xi from g and the angle theta that generates g.";

TwistPitch::usage=
  "TwistPitch[xi] gives pitch of screw corresponding to a twist.";

TwistAxis::usage=
  "TwistAxis[xi] gives axis of screw corresponding to a twist as q (point on axis), w (axis)";

TwistMagnitude::usage=
  "TwistMagnitude[xi] gives magnitude of screw corresponding to a twist.";
  
ScrewToTwist::usage=
  "ScrewToTwist[h, q, w] builds a twist from its screw coordinates h (pitch), q (point on axis), w (axis).";  

(* Adjoint matrix calculations *)

RigidAdjoint::usage=
  "RigidAdjoint[g] gives the adjoint matrix corresponding to g";
  
InverseRigidAdjoint::usage=
  "InverseRigidAdjoint[g] gives the inverse adjoint matrix corresponding to g";  

(* Operations on SO(n), the Lie group of rotation matrices *)

LocalTranTwist::usage =
"LocalTranTwist[gStart, gEnd] returns the twist and theta such that: gStart.TwistExp[xi,theta] = gEnd.
 The xi coordinate are expressed in the local (gStart) reference frame."

GlobalTranTwist::usage =
"GlobalTranTwist[gStart, gEnd] returns the twist and theta such that: TwistExp[xi,theta].gStart = gEnd.
The xi coordinate are expressed in the global (identity) reference frame."

(* Unit quaternion < - > SO(3) matrices conversion utilities *)

QuatProd::usage=
"QuatProd[q1, q2] returns the composition product between two quaternions."

QuatInv::usage=
"QuatInv[q] returns the conjugate (also the inverse) of a unit quaternion."

QuatToMat::usage=
"QuatToMat[q] returns the rotation matrix associates with the unit quaternion q."

MatToQuat::usage=
"MatToQuat[R] returns the unit quaternion associated with the rotation matrix R."

QuatVectPart::usage=
"QuatVectorPart[R] returns the 3-vector part q of quaternion (q0, q) associated with the rotation matrix R."

MakeQuat::usage=
"MakeQuat[axis, angle] creates the unit quaternion given the unit vector of the axis and the angle."

MakeRot::usage=
"MakeRot[axis, angle] creates the rotation matrix given the unit vector of the axis and the angle."

QQTo4DRot::usage=
"QQTo4DRot[q1, q2] returns the 4D rotation matrix from two unit quaternions."

Lerp::usage=
"Lerp[qStart, qEnd, t] returns the Linear intERPolation function bewteen the unit quaternions qStart and qEnd.
Lerp[qStart, qEnd, t=0] = qStart and Lerp[qStart, qEnd, t=1] = qEnd."

Slerp::usage=
"Slerp[qStart, qEnd, t] returns the Spherical Linear intERPolation function bewteen the unit quaternions qStart and qEnd.
Slerp[qStart, qEnd, t=0] = qStart and Slerp[qStart, qEnd, t=1] = qEnd."

CRspline::usage=
"CRspline[q1, q2, q3, q4, t] returns the spline functions given the 4 unit quaternions q1, ..., q4. "

BZspline::usage=
"BZspline[q1, q2, q3, q4, t] returns the Bezier spline functions given the 4 unit quaternions q1, ..., q4. "

UBspline::usage=
"UBspline[q1, q2, q3, q4, t] returns the UB spline functions given the 4 unit quaternions q1, ..., q4. "

SCRspline::usage=
"SCRspline[q1, q2, q3, q4, t] returns the SCR spline functions given the 4 unit quaternions q1, ..., q4. "

SBZspline::usage=
"SBZspline[q1, q2, q3, q4, t] returns the SBZ spline functions given the 4 unit quaternions q1, ..., q4. "

SUBspline::usage=
"SUBspline[q1, q2, q3, q4, t] returns the SUB spline functions given the 4 unit quaternions q1, ..., q4. "

(*
 *  Systematic method to build forward kinematics and Spatial/Body Jacobians
 *)

RevoluteTwist::usage=
 "RevoluteTwist[q,w] builds the 6-vector corresponding to point q on the axis with unit vector w for a revolute joint.";

PrismaticTwist::usage=
 "RevoluteTwist[q,w] builds the 6-vector corresponding to point q on the axis with unit vector w for a prismatic joint.";

ForwardKinematics::usage=
 "ForwardKinematics[{xi1,th1}, ... ,{xiN,thN}, g0] computes the forward kinematics via the product of exponentials formula.
 g0 is the initial affine tranformation if any.";

SpatialJacobian::usage=
 "SpatialJacobian[{xi1,th1}, ... ,{xiN, thN} ,g0] computes the Spatial manipulator Jacobian of a robot defined by the given twists.";

BodyJacobian::usage=
 "BodyJacobian[{xi1,th1}, ..., {xiN, thN}, g0] computes the Body manipulator Jacobian of a robot defined by the given twists.";

InertiaToCoriolis::usage=
 "InertiaToCoriolis[B(q), q, q_dot] computes the Coriolis matrix given the inertia matrix, B, and a list of the joint variables, q,
 and the list of joint variable derivatives, q_dot."

InertiaToCoriolisNotChristoffel::usage=
 "InertiaToCoriolis[B(q), q, q_dot] computes the Coriolis matrix given the inertia matrix, B, and a list of the joint variables, q,
 and the list of joint variable derivatives, q_dot."

(* Definitions for Denavit-Hartenberg convention *)

HomogeneousRotX::usage=
"HomogeneousRotX[alpha] computes the homogeneous version of a rotation of alpha about the X-axis."

HomogeneousRotY::usage=
"HomogeneousRotY[alpha] computes the homogeneous version of a rotation of alpha about the Y-axis."

HomogeneousRotZ::usage=
"HomogeneousRotZ[alpha] computes the homogeneous version of a rotation of alpha about the Z-axis."

HomogeneousTranslX::usage=
"HomogeneousTranslX[d] computes the homogeneous version of a translation of d along the X-axis."

HomogeneousTranslY::usage=
"HomogeneousTranslY[d] computes the homogeneous version of a translation of d along the Y-axis."

HomogeneousTranslZ::usage=
"HomogeneousTranslZ[d] computes the homogeneous version of a translation of d along the Z-axis."

DH::usage= 
"DH[pars] computes the DH homogeneous matrix relative to the parameter list pars (row of DH table)."

DHFKine::usage=
"DHFKine[DHtable, j] computes the forward kinematics homogeneous matrix for the supplied DH table DHtable till j-th joint.\n
 If j is omitted the complete forward kinematics (till the end effector) is returned.\n
 Each DHtable row must have a string R or P in the last component to indicate the joint type.\n
 DHFKine[DHtable, {Tb0, Tne}] computes the forward kinematics considering also the Tb0 (base-to-zero) and the
 Tne (n-to-e.e.) homogeneous transformations."

DHJacob0::usage=
"DHJAcob0[DHtable] computes the DH spatial Jacobian for the supplied DH table DHtable."

DHJacobBase::usage=
"DHJacobBase[DHtable, Tb0] computes the DH spatial Jacobian for the supplied DH table DHtable, w.r.t. a base frame Sb (both origin and orientation are considered) \n\
where the displacement from Sb to S0 is expressed by the homogeneous matrix Tb0."

DHJacob0Dyn::usage=
"DHJacob0Dyn[DHtable, j] computes the DH spatial Jacobian till j-th joint with the needed empty columns stacked on the right."

DHJacobBaseDyn::usage=
"DHJacobBaseDyn[DHtable, {Tb0, Tne}, j] computes the DH spatial Jacobian till j-th joint with the needed empty columns stacked on the right\n\ 
considering also the initial offset 'Tb0' and final offset 'Tne'."

CGJacob0Dyn::usage=
"CGJacob0Dyn[DHtable, CGtable, j] computes the CG (linear velocity of the CG) spatial Jacobian till j-th joint with the needed empty columns stacked on the right.\n
 Besides the DH table DHtable, a table with the pici (CGtable) must be supplied."

CGJacobBaseDyn::usage=
"CGJacobBaseDyn[DHtable, CGtable, {Tb0, Tne} j] computes the CG (linear velocity of the CG) spatial Jacobian till j-th joint with the needed empty columns stacked on the right.\n
 Besides the DH table DHtable, a table with the pici (CGtable) and the homogeneous matrices {Tb0, Tne} initial [B to S0] and final [Sn to E] offset transformations  must be supplied."

TensorDerivative::usage=
"TensorDerivative[J, q] computes the derivative of (nxn) matrix J w.r.t. vector q."

Regressor::usage=
"Regressor[DHtable, q, qp, v, vp, t, g0, k] directly computes the regressor for the supplied: DHtable, q (config.), qp (velocity), v (reference velocity), vp (reference acceleration),  t (independent var),
g0 (components of gravity in {0}), k (contribute for the k-th link). If k is omitted the complete regressor is returned."

Inertia::usage=
"Inertia[DHtable, CGtable_, Masslist, Tensortable] returns matrix B(q) for the supplied: DHtable (DH table), GCtable (pici table), Masslist (list of link masses),
Tensortable (table with link inertia tensors)."

InertiaBase::usage=
"InertiaBase[DHtable, CGtable, Masslist, Tensortable, {Tb0, Tne}] returns matrix B(q) for the supplied: DHtable (DH table), GCtable (pici table), Masslist (list of link masses),
Tensortable (table with link inertia tensors), {Tb0, Tne} (initial [B to S0] and final [Sn to E] offset transformations)."

InertiaToCoriolis::usage=
"InertiaToCoriolis[B(q), q, qp] computes the Coriolis matrix given: the inertia matrix B, the joint variables q,
joint variable derivatives qp."

InertiaToCoriolisSlotineLi::usage=
"InertiaToCoriolisSlotineLi[B(q), q, qp] computes the Coriolis matrix given: the inertia matrix B, the joint variables q,
joint variable derivatives qp."
 
Gravitational::usage=
"Gravitational[DHtable, CGtable, Masslist, g0] computes the gravitational vector for the supplied: DHtable (DH table), GCtable (pici table), Masslist (list of link masses),
g0 (componenents of gravity in {0})."

GravitationalBase::usage=
"GravitationalBase[DHtable, CGtable, Masslist, gb, {Tb0, Tne}] computes the gravitational vector for the supplied: DHtable (DH table), GCtable (pici table), Masslist (list of link masses),
gb (componenents of gravity in {B}), {Tb0, Tne} (initial [B to S0] and final [Sn to E] offset transformations)."

DynamicEquations::usage=
"DynamicEquations[DHtable, CGtable, Masslist, Tensortable, g0, q, qp, v, vp] computes the LHS B(q)vp + C(q,qp)v + G(q) for the supplied:
DHtable (DH table), GCtable (pici table), Masslist (list of link masses), Tensortable (table with link inertia tensors), g0 (componenents of gravity in {0}),
q (config.), qp (velocity), v (Slotine-Li velocity), vp (Slotine-Li acceleration).\n
For the classical version simply set: v ->qp , vp -> qpp."

DynamicEquationsBase::usage=
"DynamicEquations[DHtable, CGtable, Masslist, Tensortable, gb, q, qp, v, vp, {Tb0, Tne}] computes the LHS B(q)vp + C(q,qp)v + G(q) for the supplied:
DHtable (DH table), GCtable (pici table), Masslist (list of link masses), Tensortable (table with link inertia tensors), gb (componenents of gravity in {B}),
q (config.), qp (velocity), v (Slotine-Li velocity), vp (Slotine-Li acceleration), {Tb0, Tne} (initial [B to S0] and final [Sn to E] offset transformations). \n
For the classical version simply set: v ->qp , vp -> qpp."

 
ExtractParameters::usage=
"ExtractParameters[CGtable, Masslist, Tensortable] returns a list with the inertia parameters reshaped according to the regressor formulation for the supplied:
GCtable (pici table), Masslist (list of link masses), Tensortable (table with link inertia tensors)."

SwitchAt::usage=
"Internal utility function."

NDMatrix::usage=
"NDMatrix[] returns the numerical derivative of the given matrix."

NullBasis::usage=
"NullBasis[A, indexlist] returns a matrix whose columns span the NullSpace of the input matrix A. The controls are the indexlist components of q_dot."

NullBasisNumerical::usage=
"NullBasisNumerical[A, q0, indexlist] returns a matrix whose columns span the NullSpace of the input matrix A. The controls are the indexlist components of q_dot."

Eye::usage=
"Eye[n] is equivalent to IdentityMatrix[n]."

(* constraint definitions *)
 
GraspMatrix::usage=
"GraspMatrix[EP] returns the grasp matrix G for a change of reference point expressed by vector EP.\nBeware that EP are the components of the vector EP in a fixed reference frame, not in the local E.E. frame." 

GlobalGraspMatrix::usage=
"GlobalGraspMatrix[EPlist] returns the global grasp matrix G for the changes of reference point expressed by the vector list EPlist.\n\
Beware that the EPi's are the components of the vector EP in a fixed reference frame."

ConstraintMatrix::usage=
"ConstraintMatrix[type, axis, Rbe] returns the contraint matrix associated with the constraint type, its axis (if applicable) and Sb to Se transformation Rbe. Allowed contraint types are:\n\
'S' for Spherical joint, 'R' for Revolute joint, 'P' for prismatic joint, 'C' for clamped, 'PC' for Point Contact, 'PCWF' for Point Contact With Friction,'SF' for Soft Finger. \n\
Axis is taken into account only in 'R' and 'P' joint types. \n\
Rbe is always taken into account."

GlobalConstraintMatrix::usage=
"GlobalConstraintMatrix[{ {type1, axis1, Rbe1}, {type2, axis2, Rbe2}, ... }] returns the global constraint matrix for the supplied list.
The structure of each element must follow the structure of ConstraintMatrix."

FreeHandJacobian::usage=
"FreeHandJacobian[{ {DHtable1, var1, gb01}, {DHtable2, var2, gb02}, ... }] returns the global free hand Jacobian. This is the block-diag Jacobians for all the
fingers, where each one is described through its DH table, its joint variables and its initial pose w.r.t. to the base frame."

HandJacobian::usage=
"HandJacobian[fingerlist, constraintlist] returns the H.J matrix given 'fingerlist' as in FreeHandJacobian and 'constraintlist' as in GlobalConstraintMatrix. "

ObjectJac::usage=
"ObjectJac[function, pars] return the 6x6 object jacobian corresponding to the parametrization 'function' applied to parameters 'pars'."

CouplerJacobian::usage=
"CouplerJacobian[function, pars, constraintlist, pointlist] returns..."

PfaffianMatrix::usage=
"PfaffianMatrix[fingerlist, fstring, pars, constraintlist, pointlist] returns..."
 
(* graphical primitives *) 

CreateGround::usage=
"CreateGround[{xmin, xmax, dx}, {ymin, ymax, dy}, colorplane, colorframe] creates the ground plane and the ground frame."

CreateFrame::usage=
"CreateFrame[g, color] returns a frame primitive associated with homogeneous transformation g."

CreateJoint::usage=
"CreateJoint[g, {height, radius}] creates a joint primitive."

CreateLink::usage=
"CreateLink[g, {length, radius}] creates a link primitive."

CreateRobot::usage=
"CreateRobot[]..."

BBox::usage=
"BBox[a, b, c]..."

EEllipsoid::usage=
"EEllipsoid[a, b, c]..."

CreateObject::usage=
"CreateObject[]..."

FindRedundantAnglesFromOrigin::usage=
"FindRedundantAnglesFromOrigin[]..."
 
(*
 * Error messages
 *
 * Use the Mma error message facility so that we can turn off error
 * messages that we don't want to hear about
 *
 *)

AxisToSkew::wrongD = "`1 argument` is not a 3 vector.";
SkewToAxis::notskewsymmetric = "`1 argument` is not a skew symmetric matrix";
Screws::wrongDimensions = "`1 argument`: Dimensions of input matrices incorrect.";
Screws::notSquare = "`1 argument`: Input matrix is not square.";
Screws::notVector = "`1 argument`: Input is not a vector.";



Begin["`Private`"]

(* PRECISION = Infinity; *) 

(* PRECISION = 16;       *)

(*
*  Utility functions for stacking rows, columns, plus other matrix operations
*)

(* test for dimensions and matrix properties *)

SameColumnSize[l_List] := (SameQ @@ (Dimensions[#][[2]]& /@ l) )

SameRowSize[l_List] := (SameQ @@ (Dimensions[#][[1]]& /@ l) )

RotationQ[mat_] :=
  Module[
    {nr, nc, zmat},

    (* First check to make sure that this is square matrix *)
    If[Not[MatrixQ[mat]] || ({nr, nc} = Dimensions[mat]; nr != nc),
	Message[Screws::notSquare];    
        Return[False]];

    (* Check to see if R^T R = Identity *)
    zmat = Simplify[mat . Transpose[mat]] - IdentityMatrix[nr];
    Return[ And @@ Map[TrueQ[Simplify[#] == 0]&, Flatten[zmat]]]
  ];

skewQ[mat_] :=
  Module[
    {nr, nc, zmat},

    (* First check to make sure that this is square matrix *)
    If[Not[MatrixQ[mat]] || ({nr, nc} = Dimensions[mat]; nr != nc),
	Message[Screws::notSquare];    
        Return[False]];

    (* Check to see if A = -A^T *)
    zmat = mat + Transpose[mat];
    Return[ And @@ Map[TrueQ[Simplify[#] == 0]&, Flatten[zmat]]]
];

(* creation by appending, joining, blocking *)

AppendColumns[l__?MatrixQ] := Join[l] /; SameColumnSize[{l}]

AppendRows[l__?MatrixQ] := MapThread[Join, {l}] /; 
   SameRowSize[{l}]
   
StackCols[l__?MatrixQ] := AppendRows[l];   

StackRows[l__?MatrixQ] := AppendColumns[l];

BlockMatrix[block_] :=
	AppendColumns @@ Apply[AppendRows, block, {1}]; 

BlockDiag[list_] :=
	Module[{r, mlist, nlist, m, n, i},
		r = Length[list];
		mlist = Dimensions[#][[1]]& /@ list;
		nlist = Dimensions[#][[2]]& /@ list;
		m = Plus @@ mlist;
		n = Plus @@ nlist;
		res = ZeroMatrix[m, n];
		
		res[[ 1;;mlist[[1]], 1;;nlist[[1]] ]]= list[[1]];
		
		
		For[ i=2, i <= r, ++i,
			res[[ Plus@@Take[mlist, i-1]+1 ;; Plus@@Take[mlist, i], Plus@@Take[nlist, i-1]+1 ;; Plus@@Take[nlist, i] ]] = list[[i]]
		];
		
		Return[res];
	];

(* extraction *)

TakeRows[mat_?MatrixQ, part_] := Take[mat, part]

TakeColumns[mat_?MatrixQ, part_] := Take[mat, All, part]

TakeMatrix[mat_?MatrixQ, start:{startR_Integer, startC_Integer},
end:{endR_Integer, endC_Integer}] :=
	Take[mat, {startR, endR}, {startC, endC}] /;
	And @@ Thread[Dimensions[mat] >= start] && 
	And @@ Thread[Dimensions[mat] >= end]

SubMatrix[mat_List, start:{_Integer, _Integer}, dim:{_Integer,_Integer}] :=
	TakeMatrix[mat, start, start+dim-1]; 

(* basic matrices *)

ZeroMatrix[0, ___] := {};
ZeroMatrix[m_Integer, 0] := Table[{}, {m}];

ZeroMatrix[m_Integer,n_Integer] := 
	Normal[SparseArray[{},{m, n}]] /; m >= 0 && n>=0

ZeroMatrix[m_Integer] := ZeroMatrix[m, m] /; m >= 0 

SelectionMatrix[q_List, indexlist_List] :=
	Module[{m, eye},
		m = Length[q];
		eye = IdentityMatrix[m];
		res = eye[[indexlist]];
		Return[res];
	];

SelectionMatrix[m_Integer, indexlist_List] :=
	Module[{eye},
		eye = IdentityMatrix[m];
		res = eye[[indexlist]];
		Return[res];
	];

SelectionMatrixColumns[n_Integer, indexlist_List] :=	
	Module[{eye},
		eye = IdentityMatrix[n];
		res = Transpose[ eye[[indexlist]] ];
		Return[res];
	];

Magnitude[v_] :=
 Module[
  {},
  
  If[Not[VectorQ[v]],
    Message[Screws::wrongDimensions, "Vector"];
    Return[Null];
  ];

  Sqrt[v.v]
];

(* Utilities *)

(* Rotations about a single axis*)
RotX[alpha_] :=
  Module[ {ca = Cos[alpha], sa = Sin[alpha]},
         {{1,  0, 0},
          {0, ca, -sa}, 
          {0, sa,  ca}
          }
  ];

RotY[alpha_] :=
  Module[ {ca = Cos[alpha], sa = Sin[alpha]},
         {{ca,  0, sa},
          {0,   1,  0}, 
          {-sa, 0,  ca}
          }
  ];

RotZ[alpha_] :=
  Module[ {ca = Cos[alpha], sa = Sin[alpha]},
         {{ca, -sa, 0},
          {sa,  ca, 0}, 
          {0,    0, 1}
          }
  ];

      
ATan2[y_, x_] := ArcTan[x,y];

(* Parametrizations of SO(3) - Forward Map *)

EulZXZToMat[alpha_, beta_, gamma_]:=
	Module[ {},
	RotZ[alpha].RotX[beta].RotZ[gamma]
	
	];

EulZYZToMat[alpha_, beta_, gamma_]:=
	Module[ {},
	RotZ[alpha].RotY[beta].RotZ[gamma]
	
	];

EulZYXToMat[alpha_, beta_, gamma_]:=
	Module[ {},
	RotZ[alpha].RotY[beta].RotX[gamma]
	
	];
	
RPYToMat[alpha_, beta_, gamma_]:= EulZYXToMat[alpha, beta, gamma];

(* Rodriguez parameters gamma = r tan(theta/2) *)
RodriguezToMat[gamma1_, gamma2_, gamma3_] :=
	Module[ {gamma, hatgamma, modulusgammasquared},
	
			gamma = {gamma1, gamma2, gamma3};
			hatgamma = Hat[gamma];
			modulusgammasquared = gamma.gamma;
			
			IdentityMatrix[3] + 2/(1 + modulusgammasquared) (hatgamma + hatgamma.hatgamma)
	      ];
	      
RodriguezToSpatialJac[gamma1_, gamma2_, gamma3_] :=
	Module[ {gamma, modulusgammasquared},
		gamma = {gamma1, gamma2, gamma3};
		modulusgammasquared = gamma.gamma;
		2/(1 + modulusgammasquared) { {      1,   -gamma3,    gamma2},
									  { gamma3,         1,   -gamma1},
									  {-gamma2,    gamma1,         1}
									}  	
	
	];
	
RodriguezToBodyJac[gamma1_, gamma2_, gamma3_] :=
	Module[ {gamma, modulusgammasquared},
		gamma = {gamma1, gamma2, gamma3};
		modulusgammasquared = gamma.gamma;
		2/(1 + modulusgammasquared) { {      1,   gamma3,    -gamma2},
									  { -gamma3,         1,   gamma1},
									  {  gamma2,    -gamma1,         1}
									}  	
	
	];	

(*
 *  Spatial and Body Jacobians relating Spatial or Body fixed angular velocity components to
 *  angle derivatives in various parametrizations
 *)

EulZXZToSpatialJac[phi_, theta_, psi_]:=
	Module[{},
		{{ 0, Cos[phi],  Sin[phi] Sin[theta] },
		 { 0, Sin[phi], -Cos[phi] Sin[theta] },
		 { 1,        0,           Cos[theta] }
		}
		
	];
	
EulZXZToBodyJac[phi_, theta_, psi_]:=
	Module[{},
		{{ Sin[theta] Sin[psi],  Cos[psi], 0 },
		 { Sin[theta] Cos[psi], -Sin[psi], 0 },
		 {          Cos[theta],         0, 1 }
		}
		
	];	
	
EulZYZToSpatialJac[phi_, theta_, psi_]:=
	Module[{},
		{{ 0, -Sin[phi], Cos[phi] Sin[theta]  },
		 { 0,  Cos[phi], Sin[phi] Sin[theta]  },
		 { 1,        0,           Cos[theta]  }
		}
		
	];	

EulZYZToBodyJac[phi_, theta_, psi_]:=
	Module[{},
		{{ -Cos[psi] Sin[theta], Sin[psi], 0 },
		 {  Sin[psi] Sin[theta], Cos[psi], 0 }
		 {           Cos[theta],        0, 1 }
		}
		
	];	
	
EulZYXToSpatialJac[phi_, theta_, psi_]:=
	Module[{},
		{{ 0, -Sin[phi], Cos[theta] Cos[phi]  },
		 { 0,  Cos[phi], Cos[theta] Sin[phi]  },
		 { 1,        0,          -Sin[theta]  }
		}
		
	];		
	
EulZYXToBodyJac[phi_, theta_, psi_]:=
	Module[{},
		{{          -Sin[theta],         0,  1 }         
		 {  Cos[theta] Sin[psi],  Cos[psi],  0 }
		 {  Cos[theta] Cos[psi], -Sin[psi],  0 }
		}
		
	];		
	
(* QuatToSpatialJac[ { b0_, b1_, b2_, b3_} ] :=
	Module[{},
	
	2 * { { -b1,  b0, -b3,  b2  },
		  { -b2,  b3,  b0, -b1 },
		  { -b3, -b2,  b1,  b0 }
	    }
	
	];	*)

QuatToSpatialJac[ b0_, b1_, b2_, b3_ ] :=
	Module[{},
	
	2 * { { -b1,  b0, -b3,  b2  },
		  { -b2,  b3,  b0, -b1 },
		  { -b3, -b2,  b1,  b0 }
	    }
	
	];
	
(* QuatToBodyJac[ { b0_, b1_, b2_, b3_} ] :=
	Module[{},
	
	2 * { { -b1,  b0,  b3, -b2  },
		  { -b2, -b3,  b0,  b1 },
		  { -b3,  b2, -b1,  b0 }
	    }
	
	];		*)

QuatToBodyJac[ b0_, b1_, b2_, b3_ ] :=
	Module[{},
	
	2 * { { -b1,  b0,  b3, -b2  },
		  { -b2, -b3,  b0,  b1 },
		  { -b3,  b2, -b1,  b0 }
	    }
	
	];		

(* Parametrizations of SO(3) - Inverse Map *)

(* with theta \in (0, Pi) *)
MatToEulZYZ[R_] :=
	Module[{phi, theta, psi, thetaiszero, thetaisPi},
	        
	(* Check the singularity of representation ZYZ *)        
	thetaiszero = Abs[ R[[3,3]] - 1] < 10^(-10);
	thetaisPi = Abs[R[[3,3]] + 1] < 10^(-10);     
	        
	(* In cases of singularity we set arbitrarily psi = 0 *)        
	        
	If[ thetaiszero,  
	     phi = ATan2[ R[[2,1]] , R[[1,1]] ];
	     theta = 0;
	     psi = 0;
	     ];
	  
	If[ thetaisPi,
	     phi = ATan2[ R[[2,1]], R[[1,1]] ];
	     theta = Pi;
	     psi = 0;
	     ];  
	   
	If[ !(thetaiszero || thetaisPi),
	     phi = ATan2[R[[2,3]], R[[1,3]]];
	     theta = ATan2[Sqrt[ R[[1,3]]^2 + R[[2,3]]^2 ], R[[3,3]] ];
	     psi = ATan2[R[[3,2]], -R[[3,1]]];
	     ];
	     
	     Return[{phi, theta, psi}];
	     
	];

(* with theta \in (-Pi/2, Pi/2) *)
MatToEulZYX[R_] :=
	Module[{phi, theta, psi, thetaisplushalfPi, thetaisminushalfPi},
	        
	(* Check the singularity of representation ZYX *)        
	thetaisplushalfPi = Abs[ R[[3,1]] + 1] < 10^(-10);
	thetaisminushalfPi = Abs[R[[3,1]] - 1] < 10^(-10);     
	        
	(* In cases of singularity we set arbitrarily psi = 0 *)        
	        
	If[ thetaisplushalfPi,  
	     phi = ATan2[ R[[2,3]] , R[[1,3]] ];
	     theta = Pi/2;
	     psi = 0;
	     ];
	  
	If[ thetaisminushalfPi,
	     phi = ATan2[ -R[[2,3]], -R[[1,3]] ];
	     theta = -Pi/2;
	     psi = 0;
	     ];  
	   
	If[ !(thetaisplushalfPi || thetaisminushalfPi),
	     phi = ATan2[R[[2,1]], R[[1,1]]];
	     theta = ATan2[ -R[[3,1]], Sqrt[ R[[3,2]]^2 + R[[3,3]]^2 ] ];
	     psi = ATan2[ R[[3,2]], R[[3,3]] ];
	     ];
	     
	     Return[{phi, theta, psi}];
	     
	];
	
MatToRPY[R_] := MatToEulZYX[R];	

FramesToVect[list_] :=
	Module[{ R  = list[[1]],
			 Rd = list[[2]],
			 hn,  hs,    ha,
			  nd,  sd,    ad,
			 eO },
			
			 hn = Hat[R[[All, 1]]];    
			 hs = Hat[R[[All, 2]]];   
			 ha = Hat[R[[All, 3]]];
			
		   	 nd = Rd[[All, 1]]; 
		   	 sd = Rd[[All, 2]]; 
		   	 ad = Rd[[All, 3]];
			
			 eO = (1/2) (hn.nd + hs.sd + ha.ad)
	];


MatToVect[R_] := 
	Module[{axis, theta},
	{axis, theta} = RotationParam[R];
	axis*Sin[theta]
	]/; Length[R]==3  
	
MatToVect[list_]	:=
	Module[{ R  = list[[1]],
			 Rd = list[[2]],
			 hn,  hs,    ha,
			  nd,  sd,    ad,
			 eO },
			
			 hn = Hat[R[[All, 1]]];    
			 hs = Hat[R[[All, 2]]];   
			 ha = Hat[R[[All, 3]]];
			
		   	 nd = Rd[[All, 1]]; 
		   	 sd = Rd[[All, 2]]; 
		   	 ad = Rd[[All, 3]];
			
			 eO = (1/2) (hn.nd + hs.sd + ha.ad)
	]/; Length[list]==2
	
(*
 * Homogeneous representation
 *
 * These functions convert back and forth from elements of SE(3)
 * and their homogeneous representations.
 *
 *)

(* Extracts cartesian components from homogeneous coordinates *)

HomogeneousToVector[p_] :=
	Block[{},
		Take[p, 3]
	];

(* Convert a point into homogeneous coordinates *)
PointToHomogeneous[p_] :=
  Block[{},
    (* Check to make sure the dimensions of the args make sense *)
    (* If[Not[VectorQ[p]], Message[Screws::notVector, "PointToHomogeneous"]]; *)

    (* Now put everything together into a homogeneous vector *)
    Append[p, 1]
  ];  

(* Convert a vector into homogeneous coordinates *)
VectorToHomogeneous[p_] :=
  Block[{},
    (* Check to make sure the dimensions of the args make sense *)
    (* If[Not[VectorQ[p]], Message[Screws::notVector, "VectorToHomogeneous"]]; *)

    (* Now put everything together into a homogeneous vector *)
    Append[p, 0]
  ];

(* Convert a rotation + a translation to a homogeneous matrix *)
RPToHomogeneous[R_, p_] :=
  Module[
    {n},

    (* Check to make sure the dimensions of the args make sense *)
    If[Not[VectorQ[p]] || Not[MatrixQ[R]] ||
       (n = Length[p]; Dimensions[R] != {n, n}),
	Message[Screws::wrongDimensions, "RPToHomogeneous:"];
    ];

    (* Now put everything together into a homogeneous transformation *)
    
    BlockMatrix[{{R,       Transpose[{p}]},
                 {ZeroMatrix[1,3],  {{1}}}
                 }
    ]
    
  ];  
  
(* Calculate the inverse rigid transformation *)

RigidInverse[g_?MatrixQ] := 
  Module[
    {R = RigidOrientation[g], p = RigidPosition[g]},
    RPToHomogeneous[Transpose[R], -Transpose[R].p]
  ];  

(* Extract the orientation portion from a homogeneous transformation *)
RigidOrientation[g_?MatrixQ]:=
  Module[
    {nr, nc},

    (* Check to make sure that we were passed a square matrix *)
    If[Not[MatrixQ[g]] || ({nr, nc} = Dimensions[g]; nr != nc) || nr < 3,
        Message[Screws::wrongDimensions, "RigidOrientation"];
	Return Null;
    ];

    (* Extract the 3x3 upper left corner *)
    SubMatrix[g, {1,1}, {nc-1,nc-1}]
  ];

(* Extract the orientation portion from a homogeneous transformation *)
RigidPosition[g_?MatrixQ]:=
  Module[
    {nr, nc},

    (* Check to make sure that we were passed a square matrix *)
    If[Not[MatrixQ[g]] || ({nr, nc} = Dimensions[g]; nr != nc) || nr < 3,
        Message[Screws::wrongDimensions, "RigidPosition"];
	Return Null;
    ];

    (* Extract the upper left column *)
    Flatten[SubMatrix[g, {1, nc}, {nc - 1 ,1}]]
  ];

(* Find the axis of a rotation matrix *)
RotationAxis[R_, theta_] :=
  Module[
    {nr, nc},

    (* Check to make sure that our input makes sense *)
    If[Not[MatrixQ[R]] || ({nr, nc} = Dimensions[R]; nr != nc),
        Message[Screws::wrongDimensions, "RotationAxis"];
	Return[Null];
    ];

    If[theta<0 || theta>Pi,
        Message[Screws::wrongTheta, "RotationAxis"];
	Return[Null];
    ];
 
    If[theta==Pi,
      axis=NullSpace[R-IdentityMatrix[3]][[1]];
      axis=axis/Magnitude[axis];
    ,
      axis={R[[3,2]]-R[[2,3]],R[[1,3]]-R[[3,1]],R[[2,1]]-R[[1,2]]}/(2*Sin[theta]);
    ];
    Return[axis];
];


RotationParam[R_] :=
  Module[
    {nr, nc},

    (* Check to make sure that our input makes sense *)
    If[Not[MatrixQ[R]] || ({nr, nc} = Dimensions[R]; nr != nc) || nr != 3,
        Message[Screws::wrongDimensions, "RotationAxis"];
	Return[Null];
    ];
     
     
    t = (Sum[R[[i,i]],{i, nr}]-1)/2;
    If[t<-1, t=-1;];
    If[t>1,t=1;];

    theta = ArcCos[t];

    If[theta != 0,
       axis=RotationAxis[R, theta];,
       axis = Table[0, {nc}];
       theta=0;
    ];

    Return[{axis, theta}]; 
 ];
 
(*
*  Rotation matrices
*  Operations on so(3), the Lie algebra of rotation matrices SO(3)
 *)  

(* Generate a skew symmetric matrix from an axis*)
Hat[w_] := AxisToSkew[w];  (* synonym *) 

Skew[w_] := AxisToSkew[w]; (* synonym *)

AxisToSkew[omega_?VectorQ]:=
  Module[
    {},
    (* Check to make sure the dimensions are okay *)
    If[Not[VectorQ[omega]] || Length[omega] != 3,
      Message[Screws::wrongDimension];
      Return Null;
    ];

    (* Return the appropriate matrix *)
    {{ 0,          -omega[[3]],  omega[[2]]},
     { omega[[3]], 0,           -omega[[1]]},
     {-omega[[2]], omega[[1]],  0          }}
  ];

(* Generate an axis from a skew symmetric matrix *)
HatInv[S_] := SkewToAxis[S]; (* synonyms *)

UnSkew[S_] := SkewToAxis[S];  (* synonym *) 

SkewToAxis[S_]:=
  Module[
    {},
    (* First check to make sure we have a skew symmetric matrix *)
    If[Not[skewQ[S]] || Dimensions[S] != {3,3},
      Message[Screws::wrongDimension];
      Return Null
    ];

    (* Now extract the appropriate component *)
    {S[[3,2]], S[[1,3]], S[[2,1]]}
  ];

(* Matrix exponential for a skew symmetric matrix or a vector *)

SkewExp[v_?VectorQ,theta_:1] := SkewExp[AxisToSkew[v],theta];

SkewExp[S_?skewQ,theta_:1]:=
  Module[
    {n = Dimensions[S][[1]]},

    (* Use Rodrigues's formula *)
    IdentityMatrix[3] + Sin[theta] S + (1 - Cos[theta]) S.S
  ];
  
(*
*  Rigid transformation matrices
*  Operations on se(3), the Lie algebra of rigid motions SE(3)
 *)    
 
 (* Figure out the dimension of a twist [private] *)
xidim[xi_?VectorQ] :=
  Module[
    {l = Length[xi], n},

    (* Check the dimensions of the vector to make sure everything is okay *)
    n = (Sqrt[1 + 8l] - 1)/2;
    If[Not[IntegerQ[n]],
      Message[Screws::wrongDimensions, "xidim"];
      Return 0;
    ];
    n
];

(* Extract the angular portion of a twist [private] *)
xitow[xi_?VectorQ] :=
  Module[
    {n = xidim[xi]},

    (* Make sure that the vector had a reasonable length *)   
    If[n == 0, Return Null];

    (* Extract the angular portion of the twist *)
    (* SetPrecision[Take[xi, -(n (n-1) / 2)],PRECISION] *)
    Take[xi, -(n (n-1) / 2)]
  ];

(* Extract the linear portion of a twist [private] *)
xitov[xi_?VectorQ] :=
  Module[
    {n = xidim[xi]},

    (* Make sure that the vector had a reasonable length *)   
    If[n == 0, Return Null];

    (* Extract the linear portion of the twist *)
    (* SetPrecision[Take[xi, n],PRECISION] *)
    Take[xi, n]
  ];

(* Check to see if a matrix is a twist matrix *)
(*! Not implemented !*)
TwistMatrixQ[A_] := MatrixQ[A];

(* Convert a homogeneous matrix to a twist *)
(*! This only works in dimensions 2 and 3 for now !*)
HomogeneousToTwist[A_] :=
  Module[
    {nr, nc},

    (* Check to make sure that our input makes sense *)
    If[Not[MatrixQ[A]] || ({nr, nc} = Dimensions[A]; nr != nc),
        Message[Screws::wrongDimensions, "HomogeneousToTwist"];
	Return Null;
    ];

    (* Make sure that we have a twist and not a rigid motion *)
    If[A[[nr,nc]] != 0,
        Message[Screws::notTwistMatrix, "HomogeneousToTwist"];
	Return Null;
    ];

    (* Extract the skew part and the vector part and make a vector *)
    Join[
      Flatten[SubMatrix[A, {1, nr}, {nr - 1, 1}]],
      SkewToAxis[ SubMatrix[A, {1, 1}, {nr - 1 ,nr - 1}] ]
    ]
  ];

(* Convert a twist to homogeneous coordinates *)
TwistToHomogeneous[xi_?VectorQ] :=
  Module[
    {w = xitow[xi], v = xitov[xi], R, p},
    
    (* Make sure that we got a real twist *)
    If[w == Null || v == NULL, Return Null];

    (* Now put everything together into a homogeneous transformation *)
    BlockMatrix[{{AxisToSkew[w],   Transpose[{v}]},
                 {ZeroMatrix[1,3], {{0}} }
                 }
    ]
  ];  

(* Take the exponential of a twist *)
(*! This only works in dimension 3 for now !*)
TwistExp[xi_?MatrixQ, theta_:1]:=TwistExp[HomogeneousToTwist[xi], theta]; 

TwistExp[xi_?VectorQ, theta_:1] :=
  Module[
    {w = xitow[xi], v = xitov[xi], R, p},
      
    (* Make sure that we got a real twist *)
    If[w == Null || v == NULL, Return Null];

    (* Use the exponential formula from MLS *)
    If [(MatchQ[w,{0,0,0}] || MatchQ[w, {{0},{0},{0}}]),
      R = IdentityMatrix[3];
      p = v * theta;,
     (* else *)
      ws=Skew[w];
      R = SkewExp[ws, theta];
      p = (IdentityMatrix[3] - R) . (ws . v) + w (w.v) theta;
    ];
    RPToHomogeneous[R, p]
  ];

(* Find the twist which generates a rigid motion - OLD VERSION *)
(* RigidTwist[g_?MatrixQ] :=
   Module[
    {R, p, axis, v, theta, w},

    (* Make sure the dimensions are okay *)
    (*! Missing !*)

    (* Extract the appropriate pieces of the homogeneous transformation *)
    R = RigidOrientation[g];
    p = RigidPosition[g];

    (* Now find the axis from the rotation *)    
    (*w = RotationAxis[R];
    *theta = RotationAngle[R];*)

    (*Lagt till ist\[ADoubleDot]llet f\[ODoubleDot]r ovan*)
    {w,theta}=RotationParam[R];

    (* Split into cases depending on whether theta is zero *)
    If[theta == 0,
      theta = Magnitude[p];
      If[theta == 0,  
        Return[{{0,0,0,0,0,0},0}];
        ];
      v = p/theta;,
    (* else *)
      (* Solve a linear equation to figure out what v is *)   
      v = LinearSolve[
        (IdentityMatrix[3]-Outer[Times,w,w]) Sin[theta] +
        Skew[w] (1 - Cos[theta]) + Outer[Times,w,w] theta,
      p];
    ];
	Return[{Flatten[{v, w}],theta}];
 
  ];
*)

(* Find the twist which generates a rigid motion - NEW VERSION *)
RigidTwist[g_?MatrixQ] :=
  Module[
    {R, p, axis, v, theta, w, Ainv},

    (* Make sure the dimensions are okay *)
    (*! Missing !*)

    (* Extract the appropriate pieces of the homogeneous transformation *)
    R = RigidOrientation[g];
    p = RigidPosition[g];

    (* Now find the axis from the rotation *)    
    (*w = RotationAxis[R];
    *theta = RotationAngle[R];*)

    {w,theta}=RotationParam[R];
    hatw = Hat[w];
     
    (* Split into cases depending on whether theta is zero *)
    If[theta == 0,
      theta = Magnitude[p];
      If[theta == 0,  
        Return[{{0,0,0,0,0,0},0}];
        ];
      v = p/theta;,
    (* else *)
      (* Solve a linear equation to figure out what v is *)   
      Ainv = IdentityMatrix[3]/theta - (1/2) hatw + (1/theta - (1/2) Cot[theta/2]) MatrixPower[hatw, 2];
      
      v = Ainv.p;
    ];
	Return[{Flatten[{v, w}],theta}];
 
  ];

(*
 * Geometric attributes of twists and wrenches.
 *
 * For twists in R^3, find the attributes of that twist.
 *
 * Wrench attributes are defined by switching the role of linear
 * and angular portions
 *)

(* Build a twist from a screw *)
ScrewToTwist[Infinity, q_, w_] := Join[w, {0,0,0}];

ScrewToTwist[h_, q_, w_] := Join[-AxisToSkew[w] . q + h w, w]

(* Find the pitch associated with a twist in R^3 *)
TwistPitch[xi_?VectorQ] := 
  Module[
    {v, w},
    {v, w} = Partition[xi, 3];
    v . w / w.w
  ];
  
WrenchPitch[xi_?VectorQ] := Null;

(* Find the axis of a twist *)
TwistAxis[xi_?VectorQ] := 
  Module[
    {v, w},
    {v, w} = Partition[xi, 3];
    If[(MatchQ[w,{0,0,0}] || MatchQ[w, {{0},{0},{0}}]), 
     {0, v / Sqrt[v.v]}, {AxisToSkew[w] . v / w.w, (w / w.w)}]
  ];

WrenchAxis[xi_?VectorQ] := Null;

(* Find the magnitude of a twist *)
TwistMagnitude[xi_?VectorQ] := 
  Module[
    {v, w},
    {v, w} = Partition[xi, 3];
    If[(MatchQ[w,{0,0,0}] || MatchQ[w, {{0},{0},{0}}]), 
      Sqrt[v.v], Sqrt[w.w]]
  ];
WrenchMagnitude[xi_?VectorQ] := Null;
 

(*
 * Adjoint calculation
 *
 * The adjoint matrix maps twist vectors to twist vectors.
 *
 *)

(* Adjoint matrix calculation *)
RigidAdjoint[g_?MatrixQ] := 
  Module[
    {R = RigidOrientation[g], p = RigidPosition[g]},
    
    BlockMatrix[{{R,       AxisToSkew[p] . R},
                 {ZeroMatrix[3,3],  R}
                 }
    ]
    
  ];
  
(* Inverse adjoint matrix calculation *)
InverseRigidAdjoint[g_?MatrixQ] := 
  Module[
    {RT = Transpose[RigidOrientation[g]], p = RigidPosition[g]},
    
    BlockMatrix[{{RT,       -RT.AxisToSkew[p]},
                 {ZeroMatrix[3,3],  RT}
                 }
    ]
    
  ];  
  
 (* Calculation of the error twist xi_err and error angle theta_err such that:
    gStart.TwistExp[xi_err, theta_err] = gEnd *)
    
 LocalTranTwist[gStart_?MatrixQ, gEnd_?MatrixQ]:=
 Module[
     {gError, xi, theta, i},
     
     gError = Inverse[gStart].gEnd;
     
     If[gError == IdentityMatrix[4],
       Return[{Table[0,{i,6}],0}];
     ];
     
     {xi,theta} = RigidTwist[gError];
     
     Return[{xi,theta}];
];

(* Calculation of the error twist xi_err and error angle theta_err such that:
    TwistExp[xi_err, theta_err].gStart = gEnd *)
  
 GlobalTranTwist[gStart_?MatrixQ, gEnd_?MatrixQ]:=
 Module[
     {gError, xi, theta, Adg, i},
     
     gError = Inverse[gStart].gEnd;
     
     If[gError == IdentityMatrix[4],
       Return[{Table[0,{i,6}],0}];
     ];
     
     {xi,theta} = RigidTwist[gError];
     
     Adg = RigidAdjoint[gStart];
      xi = Adg.xi;
       
     Return[{xi,theta}];
];
  
(*
 *  Quaternions to matrix and matrix to quaternions conversion utilities
 *
 *
 *)



(* ::Section:: *)
(*Quaternion Library:*)
(*   q[[1]]        -->      q0 = Cos[th/2]*)
(*   q[[2,3,4]]] -->  qvec = Sin[th/2] nhat*)


QuatProd[q_List,p_List] :=
{q[[1]]*p[[1]] - q[[2]]*p[[2]] - q[[3]]*p[[3]] - q[[4]]*p[[4]],
 q[[1]]*p[[2]] + q[[2]]*p[[1]] + q[[3]]*p[[4]] - q[[4]]*p[[3]],
 q[[1]]*p[[3]] + q[[3]]*p[[1]] + q[[4]]*p[[2]] - q[[2]]*p[[4]],
 q[[1]]*p[[4]] + q[[4]]*p[[1]] + q[[2]]*p[[3]] - q[[3]]*p[[2]]} /;
   Length[q] == Length[p] == 4


QuatInv[q_List] := {q[[1]], - q[[2]], -q[[3]], - q[[4]]}


normalize[lst_List] := Module[{norm = lst . lst,eps=10^(-14)},
If[NumberQ[norm],
If[norm<eps, lst, N[lst/Sqrt[norm]] ],
lst/Sqrt[norm]]]  


proj4 [pt4D_,angle_:0] := Chop[{pt4D[[1]],pt4D[[2]], 
                   Cos[angle]*pt4D[[3]] + Sin[angle]*pt4D[[4]]}]//N


(* ::Subsection:: *)
(*ROTATIONS and quaternions:*)
(*q*v*qbar  with v= (0,vec) a "pure" quaternion*)
(*gives EACH COLUMN of a rotation matrix:*)


 (* QuatToMat[q_List] :=
Module[{q0= q[[1]], q1=q[[2]], q2 = q[[3]], q3 = q[[4]]},
   Module[{d23 = 2 q2 q3, d1 = 2 q0 q1,
          d31 = 2 q3 q1, d2 = 2 q0 q2,
          d12 = 2 q1 q2, d3 = 2 q0 q3,
          q0sq = q0^2, q1sq = q1^2, q2sq = q2^2, q3sq = q3^2},
          {{q0sq + q1sq - q2sq - q3sq, d12 - d3, d31 + d2},
           {d12 + d3, q0sq - q1sq + q2sq - q3sq, d23 - d1},
           {d31 - d2, d23 + d1, q0sq - q1sq - q2sq + q3sq}} ]]; *)
          
QuatToMat[q_List] :=
Module[ {beta0 = q[[1]], betas = q[[{2,3,4}]],
         Im, 
         hatbetas,
         mat},
		 Im = IdentityMatrix[3];
		 hatbetas = Skew[betas];
         mat = Im + 2  hatbetas . ( beta0 Im + hatbetas);
         Return[mat];
];



(* ::Subsection:: *)
(*Warning: these are the reverse of conventional argument order:*)
(*change order once all is consistent to (angle, nhat).*)


MakeQuat[n_List:{0,0,1},angle_:0] :=
     Module[{c = Cos[angle/2], s = Sin[angle/2]},
     {c, n[[1]]*s, n[[2]]*s, n[[3]]*s}//N]


MakeRot[n_List:{0,0,1},angle_:0] :=
Module[{c = Cos[angle]//N, s = Sin[angle]//N, cm},
cm = 1 - c;
{{c + cm*n[[1]]^2, cm*n[[2]]*n[[1]] - s*n[[3]], cm*n[[3]]*n[[1]] + s*n[[2]]},
{cm*n[[1]]*n[[2]] + s*n[[3]], c + cm*n[[2]]^2,  cm*n[[3]]*n[[2]] - s*n[[1]]},
{ cm*n[[1]]*n[[3]] - s*n[[2]], 
              cm*n[[2]]*n[[3]] + s*n[[1]], c + cm*n[[3]]^2}}//N]



MatToQuat[mat_List] :=
   Module[{q0,q1,q2,q3,trace,s,t1,t2,t3},
         trace = Sum[mat[[i,i]],{i,1,3}];
         If[trace > 0,
             s = Sqrt[trace + 1.0];
               q0 = s/2;
               s = 1/(2 s);
               q1 = (mat[[3,2]] - mat[[2,3]])*s;
               q2 = (mat[[1,3]] - mat[[3,1]])*s;
               q3 = (mat[[2,1]] - mat[[1,2]])*s,
            If[(mat[[1,1]] >= mat[[2,2]]) &&
                (mat[[1,1]] >= mat[[3,3]]), (* i=0,  j = 1, k = 2 *)
                  s = Sqrt[mat[[1,1]] - mat[[2,2]] - mat[[3,3]] + 1.0];
                  q1 = s/2; s = 1/(2 s);
                  q0 = (mat[[3,2]] - mat[[2,3]])*s;
                  q2= (mat[[2,1]] + mat[[1,2]])*s;
                  q3 = (mat[[1,3]] + mat[[3,1]])*s,
               If[(mat[[1,1]] < mat[[2,2]]) &&
                (mat[[1,1]] >= mat[[3,3]]), (* i=1,  j = 2, k = 0 *)
                  s = Sqrt[mat[[2,2]] - mat[[3,3]] - mat[[1,1]] + 1.0];
                  q2 = s/2; s = 1/(2 s);
                  q0 = (mat[[1,3]] - mat[[3,1]])*s;
                  q3= (mat[[3,2]] + mat[[2,3]])*s;
                  q1 = (mat[[2,1]] + mat[[1,2]])*s,
             (* Else: (mat[[1,1]] < mat[[2,2]]) && (mat[[1,1]] < mat[[3,3]])  *)
             (* i=2,  j = 0, k = 1 *)
            s = Sqrt[mat[[3,3]] - mat[[1,1]] - mat[[2,2]] + 1.0];
                  q3 = s/2; s = 1/(2 s);
                  q0 = (mat[[2,1]] - mat[[1,2]])*s;
                  q1= (mat[[1,3]] + mat[[3,1]])*s;
                  q2 = (mat[[3,2]] + mat[[2,3]])*s]]];
                  normalize[N[{q0,q1,q2,q3}]]]
             
QuatVectPart[mat_List] := Take[ MatToQuat[mat], -3];

              


RotToQuatSym[mat_List] :=
   Module[{q0,q1,q2,q3,trace,s,t1,t2,t3},
         trace = Sum[mat[[i,i]],{i,1,3}];
             s = Sqrt[trace + 1.0];
               q0 = s/2;
               s = 1/(2 s);
               q1 = (mat[[3,2]] - mat[[2,3]])*s;
               q2 = (mat[[1,3]] - mat[[3,1]])*s;
               q3 = (mat[[2,1]] - mat[[1,2]])*s;
                {q0,q1,q2,q3}]

(*






(* ::Subsection:: *)
(*Distances in quaternion arcs:*)


QLength[curveOnSphere_List] :=
  Sum[ArcCos[curveOnSphere[[i]] . curveOnSphere[[i+1]]],
        {i,1,Length[curveOnSphere]-1}]


(* ::Subsection:: *)
(*Arrays of Quaternion frames need these:  *)


ForceCloseQFrames[qfrms_List] :=
  Module[{lastfrm = qfrms[[1]], thisfrm},
    Table[thisfrm = qfrms[[i]];
          lastfrm =
             If[thisfrm . lastfrm >= 0, thisfrm, - thisfrm],
             {i,1,Length[qfrms]}]]


 ForceClose2DQFrames[qrows_List] :=
  Module[{lastrow = qrows[[1]], thisrow},
    Table[thisrow = ForceCloseQFrames[qrows[[i]]];
          lastrow = 
             If[thisrow[[1]] . lastrow[[1]] >= 0, thisrow, - thisrow],
              {i,1,Length[qrows]}]]
              


ForceClose3DQFrames[qplanes_List]:=Module[{lastplane=qplanes[[1]],thisplane},Table[thisplane=ForceClose2DQFrames[qplanes[[i]]];
lastplane=If[thisplane[[1]].lastplane[[1]]>=0,thisplane,-thisplane],{i,1,Length[qplanes]}]]

*)



(* ::Subsection:: *)
(*4D rotation double quaternions*)


QQTo4DRot[p_List,q_List] :=
  Module[{q0= q[[1]], q1=q[[2]], q2 = q[[3]], q3 = q[[4]],
         p0= p[[1]], p1=p[[2]], p2 = p[[3]], p3 = p[[4]]},
{{p0*q0 + p1*q1 + p2*q2 + p3*q3, p1*q0 - p0*q1 - p3*q2 + p2*q3, 
            p2*q0 + p3*q1 - p0*q2 - p1*q3, p3*q0 - p2*q1 + p1*q2 - p0*q3}, 
 {(-(p1*q0) + p0*q1 - p3*q2 + p2*q3), (p0*q0 + p1*q1 - p2*q2 - p3*q3), 
     (-(p3*q0) + p2*q1 + p1*q2 - p0*q3), (p2*q0 + p3*q1 + p0*q2 + p1*q3)}, 
 {(-(p2*q0) + p3*q1 + p0*q2 - p1*q3), (p3*q0 + p2*q1 + p1*q2 + p0*q3),
     (p0*q0 - p1*q1 + p2*q2 - p3*q3), (-(p1*q0) - p0*q1 + p3*q2 + p2*q3)}, 
 {(-(p3*q0) - p2*q1 + p1*q2 + p0*q3), (-(p2*q0) + p3*q1 - p0*q2 + p1*q3), 
     (p1*q0 + p0*q1 + p3*q2 + p2*q3), (p0*q0 - p1*q1 - p2*q2 + p3*q3)}}]
 


(* ::Section:: *)
(*Spline Library is here*)


Lerp[p0_List,p1_List,t_] := (1-t)*p0 + t*p1


Slerp[p0_List,p1_List,t_] := Module[{costh = p0 . p1//Chop, th, sinth},
  If[costh > 0.0,costh = Chop[costh -1.] +1.];
  If[costh < 0.0,costh = Chop[costh +1.] -1.];
 th = N[ArcCos[costh]];
 sinth = N[Sin[th]];
If[sinth == 0, 
 (1-t)*p0 + t*p1,
 (Sin[th*(1-t)]/sinth)*p0 +(Sin[th*t]/sinth)*p1 ]]


(* ::Section:: *)
(*Spline and Spherical Splines*)


CRspline[p0_,p1_,p2_,p3_,t_] :=
	Lerp[Lerp[Lerp[p0,p1,t+1],Lerp[p1,p2,t],(t+1)/2.],
              Lerp[Lerp[p1,p2,t],Lerp[p2,p3,t-1],           t/2.],         t]


BZspline[p0_,p1_,p2_,p3_,t_] :=
	Lerp[Lerp[Lerp[p0,p1,t],Lerp[p1,p2,t],t],
              Lerp[Lerp[p1,p2,t],Lerp[p2,p3,t],t],t]


UBspline[p0_,p1_,p2_,p3_,t_] :=
	Lerp[Lerp[Lerp[p0,p1,(t+2)/3.],Lerp[p1,p2,(t+1)/3.],(t+1)/2.],
              Lerp[Lerp[p1,p2,(t+1)/3.],Lerp[p2,p3,t/3.],                       t/2.],t]


SCRspline[p0_,p1_,p2_,p3_,t_] :=
	Slerp[Slerp[Slerp[p0,p1,t+1],Slerp[p1,p2,t],(t+1)/2.],
              Slerp[Slerp[p1,p2,t],Slerp[p2,p3,t-1],           t/2.],         t]


SBZspline[p0_,p1_,p2_,p3_,t_] :=
	Slerp[Slerp[Slerp[p0,p1,t],Slerp[p1,p2,t],t],
              Slerp[Slerp[p1,p2,t],Slerp[p2,p3,t],t],t]


SUBspline[p0_,p1_,p2_,p3_,t_] :=
	Slerp[Slerp[Slerp[p0,p1,(t+2)/3.],Slerp[p1,p2,(t+1)/3.],(t+1)/2.],
              Slerp[Slerp[p1,p2,(t+1)/3.],Slerp[p2,p3,t/3.],                       t/2.],t]


squad[x0_,x1_,x2_,x3_,t_] :=(1-2t (1 - t))*((1-t) x0 + t x3) + 2t*(1-t)((1-t)x1 + t x2)

(*
 *  Calculations of the forward kinematic map and
 *  the Spatial and Body Jacobians
 *
 *)
 
 (* Gives Xi 6 vector given a point on axis and axis unit vector for a Revolute Joint *)
RevoluteTwist[q_,w_]:= Flatten[{Cross[q,w],w}];

(* Gives Xi 6 vector given a point on axis and axis unit vector for a Prismatic Joint *)
PrismaticTwist[q_,w_]:= Flatten[{w, {0,0,0}}];

(* Gives the homogeneous matrix *)
ForwardKinematics[args__, gst0_]:= 
  Module[
    { g, i,
      argList = {args},		(* turn arguments into a real list *)
      n = Length[{args}]	(* decide on the number of joints *)
    },

    (* Initialize the transformation matrix *)
    g = TwistExp[argList[[1,1]], argList[[1,2]]];   

    (* Build up the Jacobian joint by joint *)
    For[i = 2, i <= n, i++,
      (* Update the transformation matrix *)
      g = g . TwistExp[argList[[i,1]], argList[[i,2]]];
    ];      

    (* Finish by multiplying by the initial tool configuration *)
    g . gst0
  ];
			

(* Construct the Spatial Jacobian for a robot with any no. of links *)
SpatialJacobian[args__, gst0_] := 
  Module[
    { i, xi, Js, g,
      argList = {args},		(* turn arguments into a real list *)
      n = Length[{args}]	(* decide on the number of joints *)
    },

    (* First initialize the Jacobian and compute the first column *)
    Js = {argList[[1,1]]};
    g = TwistExp[argList[[1,1]], argList[[1,2]]];   

    (* Build up the Jacobian joint by joint *)
    For[i = 2, i <= n, i++,
      (* Compute this column of the Jacobian and append it to Js *)
      xi = RigidAdjoint[g] . argList[[i,1]];
      Js = Join[Js, {xi}];      

      (* Update the transformation matrix *)
      g = g . TwistExp[argList[[i,1]], argList[[i,2]]];
    ];      

    (* Return the Jacobian *)
    Transpose[Js]
  ];
			
(* Construct the Body Jacobian for a robot with any no. of links *)			
BodyJacobian[args__, gst0_] := 
  Module[
    { i, xi, Jb, g,
      argList = {args},		(* turn arguments into a real list *)
      n = Length[{args}]	(* decide on the number of joints *)
    },

    (* Initialize the Jacobian and the transformation matrix *)
    Jb = {};
    g = gst0;

    (* Build up the Jacobian joint by joint *)
    For[i = n, i >= 1, i--,
      (* Compute this column of the Jacobian and prepend it to Jb *)
      xi = RigidAdjoint[RigidInverse[g]] . argList[[i,1]];
      Jb = Join[{xi}, Jb];      

      (* Update the transformation matrix *)
      g = TwistExp[argList[[i,1]], argList[[i,2]]] . g;
    ];      

    (* Return the Jacobian *)
    Transpose[Jb]
  ];
  
(* Definitions for Denavit-Hartenberg convention *)

HomogeneousRotX[alpha_] :=
	Module[{},
		R = RotX[alpha];
		d = {0,0,0};
		H = RPToHomogeneous[R, d];
		Return[H];  
	];
  
HomogeneousRotY[alpha_] :=
	Module[{},
		R = RotY[alpha];
		d = {0,0,0};
		H = RPToHomogeneous[R, d];
		Return[H];  
	];

HomogeneousRotZ[alpha_] :=
	Module[{},
		R = RotZ[alpha];
		d = {0,0,0};
		H = RPToHomogeneous[R, d];
		Return[H];  
	];
	
HomogeneousTranslX[alpha_] :=
	Module[{},
		R = IdentityMatrix[3];
		d = {alpha,0,0};
		H = RPToHomogeneous[R, d];
		Return[H];  
	];	
	
HomogeneousTranslY[alpha_] :=
	Module[{},
		R = IdentityMatrix[3];
		d = {0, alpha, 0};
		H = RPToHomogeneous[R, d];
		Return[H];  
	];	

HomogeneousTranslZ[alpha_] :=
	Module[{},
		R = IdentityMatrix[3];
		d = {0, 0, alpha};
		H = RPToHomogeneous[R, d];
		Return[H];  
	];
	
DH[pars_List] :=
	Module[{   a = pars[[1]], 
		   alpha = pars[[2]],
		       d = pars[[3]],
		   theta = pars[[4]],
	   jointtype = pars[[5]],
		   TZ, RZ, TX, RX},
		       TZ = HomogeneousTranslZ[d]; 
		       RZ = HomogeneousRotZ[theta];
		       TX = HomogeneousTranslX[a];
		       RX = HomogeneousRotX[alpha];
		        H = TZ.RZ.TX.RX;
		        Return[H];
	];

DHFKine[DHtable_]:= 
  Module[
    { H, i, n = Length[DHtable]	(* decide on the number of joints *)
    },

    (* Initialize homogeneous matrix *)
    H = IdentityMatrix[4];

    (* Build up the Jacobian joint by joint *)
    For[i = 1, i <= n, i++,
      (* Update the transformation matrix *)
      H = H . DH[ DHtable[[i]] ];
    ];      

    (* Once finished... *)
    Return[H];
  ];
  
DHFKine[DHtable_, j_]:= 
  Module[
    { H, i, n = Length[DHtable]	(* decide on the number of joints *)
    },

    (* Initialize homogeneous matrix *)
    H = IdentityMatrix[4];

    (* Build up the Jacobian joint by joint *)
    For[i = 1, i <= j, i++,
      (* Update the transformation matrix *)
      H = H . DH[ DHtable[[i]] ];
    ];      

    (* Once finished... *)
    Return[H];
  ];  
  
DHFKine[DHtable_, {Tb0_, Tne_}]:=
	Module[
		{H0n, H},
        H0n = DHFKine[DHtable];
        H   = Tb0.H0n.Tne;
        
        Return[H];		
	];
  
DHFKine[DHtable_, {Tb0_, Tne_}, j_]:=
	Module[
    { H, i, n = Length[DHtable]	(* decide on the number of joints *)
    },

    (* Initialize homogeneous matrix *)
    H = Tb0;

    (* Build up the Jacobian joint by joint *)
    For[i = 1, i <= j, i++,
      (* Update the transformation matrix *)
      H = H . DH[ DHtable[[i]] ];
    ];      

    (* Once finished... *)
    Return[H];
  ];  

DHJacob0[DHtable_]:=
	Module[{ i, n = Length[DHtable], He,
		     type, z, r,
		     jv, jo, j, J },
		     
		J  = {};     
		He = DHFKine[DHtable];
		For[i = 1, i <= n, i++,
			
			type = DHtable[[i, 5]];
			   z = (RigidOrientation[DHFKine[DHtable, i-1]])[[All, 3]];
			   r = RigidPosition[He] - (RigidPosition[DHFKine[DHtable, i-1]]);
			
			If[ type == "P",
				
				(* Prismatic Joint *)
				jv = z;
				jo = {0, 0, 0};
				j  = Join[jv, jo] ; ,
			
			    (* Revolute Joint *)
			    jv = Hat[z].r;
			    jo = z;
			    j  = Join[jv, jo]; 
		      ];
		J = Append[J, j];
		
	];
	Return[Transpose[J]];
	];

DHJacobBase[DHtable_, Tb0_]:=	
	Module[{g, R, zero, Adg, J, Jb},
		R    = RigidOrientation[Tb0];
		zero = {0, 0, 0};
		g    = RPToHomogeneous[R, zero];
		Adg  = RigidAdjoint[g];
		J    = DHJacob0[DHtable];
		Jb   = Adg.J;
		
		Return[Jb];
	];
	
DHJacob0Dyn[DHtable_, k_]:=	
	Module[{ i, n = Length[DHtable], Hk,
		     type, z, r, 
             jv, jo, j, Jk, J },
		     
		Jk  = {};     
		Hk = DHFKine[DHtable, k];
		For[i = 1, i <= k, i++,
			
			type = DHtable[[i, 5]];
			   z = (RigidOrientation[DHFKine[DHtable, i-1]])[[All, 3]];
			   r = RigidPosition[Hk] - (RigidPosition[DHFKine[DHtable, i-1]]);
			
			If[ type == "P",
				
				(* Prismatic Joint *)
				jv = z;
				jo = {0, 0, 0};
				j  = Join[jv, jo] ; ,
			
			    (* Revolute Joint *)
			    jv = Hat[z].r;
			    jo = z;
			    j  = Join[jv, jo]; 
		      ];
		Jk = Append[Jk, j];
		
		];
		
	    J = StackCols[ Transpose[Jk], ZeroMatrix[6, n-k] ];
	    Return[J];
	];
	
DHJacobBaseDyn[DHtable_, {Tb0_, Tne_}, k_]:=	
	Module[{ i, n = Length[DHtable], Hk,
		     type, z, r, 
             jv, jo, j, Jk, J },
		     
		Jk  = {};    
		Hk  = DHFKine[DHtable, {Tb0, Tne}, k];
	
		For[i = 1, i <= k, i++,
			
			type = DHtable[[i, 5]];
			   z = (RigidOrientation[DHFKine[DHtable, {Tb0, Tne}, i-1]])[[All, 3]];
			   r = RigidPosition[Hk] - (RigidPosition[DHFKine[DHtable, {Tb0, Tne}, i-1]]);
			
			If[ type == "P",
				
				(* Prismatic Joint *)
				jv = z;
				jo = {0, 0, 0};
				j  = Join[jv, jo] ; ,
			
			    (* Revolute Joint *)
			    jv = Hat[z].r;
			    jo = z;
			    j  = Join[jv, jo]; 
		      ];
		Jk = Append[Jk, j];
		
		];
		
	    J = StackCols[ Transpose[Jk], ZeroMatrix[6, n-k] ];
	    Return[J];
	];	

CGJacob0Dyn[DHtable_, CGtable_, k_]:=
	Module[{R0k, pkck, M, DHJacob, CGJacob},
		R0k  = RigidOrientation[ DHFKine[DHtable, k] ];
		pkck = CGtable[[k]];
		M = BlockMatrix[ {
			               {   IdentityMatrix[3],     -Hat[R0k.pkck] },
						   {     ZeroMatrix[3,3],  IdentityMatrix[3] }
						  }
			           ];
		DHJacob = DHJacob0Dyn[DHtable, k];
		CGJacob = M.DHJacob;
		Return[CGJacob];	           
	];

CGJacobBaseDyn[DHtable_, CGtable_, {Tb0_, Tne_}, k_]:=
	Module[{R0k, pkck, M, DHJacob, CGJacob},
		R0k  = RigidOrientation[ DHFKine[DHtable, {Tb0, Tne}, k] ];
		pkck = CGtable[[k]];
		M = BlockMatrix[ {
			               {   IdentityMatrix[3],     -Hat[R0k.pkck] },
						   {     ZeroMatrix[3,3],  IdentityMatrix[3] }
						  }
			           ];
		DHJacob = DHJacobBaseDyn[DHtable, {Tb0, Tne}, k];
		CGJacob = M.DHJacob;
		Return[CGJacob];	           
	];

(* Calcolo dei termini che formano il regressore *)
TensorDerivative[J_, q_]:=	
	Module[{DJ, res },
		DJ  = D[J, {q}];
		res =(1/2) (DJ + Transpose[DJ, {1, 3, 2}]);
		Return[res];
	];
 
Regressor[DHtable_, q_, qp_, v_, vp_, t_, g0_, k_]:=
	Module[{X0p, X1a, X1b, X1ap, X1bp, X1p, X2p, par,
		    W0, W1, W2,
		    Z0, Z1,
		    R0k, R0kT,
		    Jk, Jvk, Jok, JvkT, JokT,
		    Jvkp, JvkpT, Jokp, JokpT,
		    JvTJv,
		    T1, T2, T3, TT, 
		    E1, E2, E3, E4, E5, E6, EE,
		    Y0, Y1, Y2, Y},
		    
		    R0k  = RigidOrientation[ DHFKine[DHtable, k] ];
		    R0kT = Transpose[R0k];
		    Jk   =  DHJacob0Dyn[DHtable, k];
		    Jvk  =  Jk[[1;;3, All]];
		    Jok  =  Jk[[4;;6, All]];
		    
		    JvkT = Transpose[Jvk];
		    JokT = Transpose[Jok];
		    JvTJv = JvkT.Jvk;
		    
		    Jvkp  = TensorDerivative[Jvk, q].qp;
		    JvkpT = Transpose[Jvkp];
		    
		    Jokp  = TensorDerivative[Jok, q].qp;
		    JokpT = Transpose[Jokp]; 
		    
		    (* termini da d   dT1                                        *)
		    (*            -   -                                          *)
		    (*            dt  dqp         con T1 = v.B(q).qp             *)
		    
		    
 			X0p = Transpose[{(TensorDerivative[JvTJv, q].qp).v  + JvTJv.vp}];
 			
 			
 			(* X1p = (   JvkpT.Hat[Jok.v] + JvkT.(Hat[Jokp.v] + Hat[Jok.vp])
 				   - JokpT.Hat[Jvk.v]  - JokT.(Hat[Jvkp.v] + Hat[Jvk.vp]) ).R0k +
 				      (JvkT.Hat[Jok.v] - JokT.Hat[Jvk.v]).(D[R0k, t]); *)
 			
 			T1 = SparseArray[{{2, 3} -> -1,  {3, 2} ->  1, {3,3} -> 0}];
 			T2 = SparseArray[{{1, 3} ->  1,  {3, 1} -> -1, {3,3} -> 0}];
 			T3 = SparseArray[{{1, 2} -> -1,  {2, 1} ->  1, {3,3} -> 0}];
 			
 			TT = {T1, T2, T3};
 			TT = Transpose[TT, {2,1,3}];
 			
 			X1a  = JokT.R0k.TT.R0kT.Jvk;
 			
 			X1ap = Transpose[Table[(TensorDerivative[X1a[[All,i,All]], q].qp).v, {i,1,3}]];
 			
 			X1b  = -JvkT.R0k.TT.R0kT.Jok;  
 			
 			X1bp = Transpose[Table[(TensorDerivative[X1b[[All,i,All]], q].qp).v, {i,1,3}]];
 			
 			
 			X1p = (X1a + X1b).vp + X1ap + X1bp;
 			
 			E1 = SparseArray[{{1, 1} -> 1,  {3, 3} -> 0}];
 			E2 = SparseArray[{{1, 2} -> -1, {2, 1} -> -1 , {3, 3} -> 0}];
 			E3 = SparseArray[{{1, 3} -> -1, {3, 1} -> -1 , {3, 3} -> 0}];
 			E4 = SparseArray[{{2, 2} -> 1,  {3, 3} -> 0}];
 			E5 = SparseArray[{{2, 3} -> -1, {3, 2} -> -1 , {3, 3} -> 0}];
 			E6 = SparseArray[{{3, 3} -> 1}];
 			EE = {E1, E2, E3, E4, E5, E6};
 			EE = Transpose[EE, {2,1,3}];
 			
 			par = JokT.R0k.EE.R0kT.Jok;
 			
 			X2p = Transpose[Table[(TensorDerivative[par[[All,i,All]], q].qp).v, {i,1,6}]] + par.vp;
 		
 			
 			(* termini da dT2                                    *)
		    (*            -                                      *)
		    (*            dq           con T2 = (1/2)v.B(q).qp   *)
		    
		    W0 = (1/2) D[ v.JvkT.Jvk.qp ,{q}];
		    
		    W1 = (1/2) Transpose[ D[ (v.JvkT.Hat[Jok.qp] - v.JokT.Hat[Jvk.qp]).R0k  ,{q}] ];
 			
 			W2 = (1/2) Transpose[ D[ v.JokT.R0k.EE.Transpose[R0k].Jok.qp ,{q}] ];
 			
 			
 			(* termini da d U   *)
 			(*            -     *)
 			(*            d q   *)
 			
 			Z0 = -JvkT.g0;
 			
 			(*
 			If[ k == 1,
 			Z1 = -Transpose[ { D[ g0.R0k , {q}] } ],
 			Z1 = -Transpose[   D[ g0.R0k , {q}]   ]
 			 ];
 			 *)
 			 
 			Z1 = -Transpose[   D[ g0.R0k , {q}]   ]; 
 			
 			Y0 = X0p - W0  + Z0;
 			Y1 = X1p - W1  + Z1;
 			Y2 = X2p - W2;
 			
 			Y  = StackCols[Y0, Y1, Y2];
 			Return[Y]; 
 			 
 			 
 			 (* test:   Return[X2p]; *)	
	]; 

Regressor[DHtable_, q_, qp_, v_, vp_, t_, g0_]:=
	Module[{n, Yk, Y},
		
		n = Length[DHtable];
		Y = Regressor[DHtable, q, qp, v, vp, t, g0, 1];
		For[ k = 2, k <= n, k++,
			
			Yk = Regressor[DHtable, q, qp, v, vp, t, g0, k];
			Y  = StackCols[Y, Yk];
		];
		
		Return[Y];
	];

Inertia[DHtable_, CGtable_, Masslist_, Tensortable_]:=
	Module[
		{Bmat,
			k, n = Length[DHtable],
		 R0k, Jk, Jvk, Jok, JvkT, JokT},
		 
		 Bmat = ZeroMatrix[n];
		
		For[ k = 1, k <= n, k++,
			
			R0k  = RigidOrientation[ DHFKine[DHtable, k] ];
		    Jk  =  CGJacob0Dyn[DHtable, CGtable, k];
		    
		    (* attenzione: questo Jacobiano \[EGrave] relativo al baricentro *)
		    
		    Jvk =  Jk[[1;;3, All]];
		    Jok =  Jk[[4;;6, All]];
		    
		    JvkT = Transpose[Jvk];
		    JokT = Transpose[Jok];
		    
		    Bmat += Masslist[[k]] JvkT.Jvk + JokT.R0k.Tensortable[[k]].Transpose[R0k].Jok; 
		];
		Return[Bmat];
	];

InertiaBase[DHtable_, CGtable_, Masslist_, Tensortable_, {Tb0_, Tne_}]:=
	Module[
		{Bmat,
			k, n = Length[DHtable],
		 R0k, Jk, Jvk, Jok, JvkT, JokT},
		 
		 Bmat = ZeroMatrix[n];
		
		For[ k = 1, k <= n, k++,
			
			R0k  = RigidOrientation[ DHFKine[DHtable, {Tb0, Tne}, k] ];
		    Jk  =  CGJacobBaseDyn[DHtable, CGtable, {Tb0, Tne}, k];
		    
		    (* attenzione: questo Jacobiano \[EGrave] relativo al baricentro *)
		    
		    Jvk =  Jk[[1;;3, All]];
		    Jok =  Jk[[4;;6, All]];
		    
		    JvkT = Transpose[Jvk];
		    JokT = Transpose[Jok];
		    
		    Bmat += Masslist[[k]] JvkT.Jvk + JokT.R0k.Tensortable[[k]].Transpose[R0k].Jok; 
		];
		Return[Bmat];
	];

InertiaToCoriolis[M_, q_, qp_] :=
  Module[
    {Cmat, i, j, k, n = Length[M]},

    (* Brute force calculation *)
    Cmat = ZeroMatrix[n];

    For[i = 1, i <= n, ++i,
      For[j = 1, j <= n, ++j,
        For[k = 1, k <= n, ++k,
          Cmat[[i,j]] += (1/2) * qp[[k]] * (D[M[[i,j]], q[[k]]] + D[M[[i,k]], q[[j]]] - D[M[[j,k]], q[[i]]])
	       ]
         ]
       ];
   Cmat
  ];

InertiaToCoriolisNotChristoffel[M_, q_, qp_] :=
	Module[
		{n = Length[M], Cmat, i, j, k},
		Cmat = ZeroMatrix[n];
		
	   	   
	   	   For[i = 1, i <= n, ++i,
             For[j = 1, j <= n, ++j,
                Cmat[[i,j]] = Sum[
           	                  ( D[ M[[i, j]], q[[k]] ] - (1/2) D[ M[[j, k]], q[[i]] ] ) qp[[k]], {k, 1, n}
           	                     ]
             ]
	   	   ];
           Return[Cmat];	                  
	];
	
Gravitational[DHtable_, CGtable_, Masslist_, g0_]:=
	Module[{Gvec, k, n = Length[DHtable]},
		
		Gvec = (ZeroMatrix[1, n])[[1]];
		
		For[ k = 1, k <= n, k++,
			
			R0k  = RigidOrientation[ DHFKine[DHtable, k] ];
		    Jk  =  CGJacob0Dyn[DHtable, CGtable, k];
		    
		    (* attenzione: questo Jacobiano \[EGrave] relativo al baricentro *)
		    
		    Jvk =  Jk[[1;;3, All]];
		    (* Jok =  Jk[[4;;6, All]]; *)
		    
		    JvkT = Transpose[Jvk];
		    (* JokT = Transpose[Jok];  *)
		    
		    Gvec += -Masslist[[k]] JvkT.g0; 
		];
		Return[Gvec];
		
	];

GravitationalBase[DHtable_, CGtable_, Masslist_, g0_, {Tb0_, Tne_}]:=
	Module[{Gvec, k, n = Length[DHtable]},
		
		Gvec = (ZeroMatrix[1, n])[[1]];
		
		For[ k = 1, k <= n, k++,
			
			R0k  = RigidOrientation[ DHFKine[DHtable, {Tb0, Tne}, k] ];
		    Jk  =  CGJacobBaseDyn[DHtable, CGtable, {Tb0, Tne}, k];
		    
		    (* attenzione: questo Jacobiano \[EGrave] relativo al baricentro *)
		    
		    Jvk =  Jk[[1;;3, All]];
		    (* Jok =  Jk[[4;;6, All]]; *)
		    
		    JvkT = Transpose[Jvk];
		    (* JokT = Transpose[Jok];  *)
		    
		    Gvec += -Masslist[[k]] JvkT.g0; 
		];
		Return[Gvec];
		
	];
	
DynamicEquations[DHtable_, CGtable_, Masslist_, Tensortable_, g0_, q_, qp_, v_, vp_]:=
	Module[{B, C, G, eqs},
		
		B = Inertia[DHtable, CGtable, Masslist, Tensortable];
		C = InertiaToCoriolis[B, q, qp];
		G = Gravitational[DHtable, CGtable, Masslist, g0];
		
		eqs = B.vp + C.v + G;
		
		Return[eqs];	
	];
	
DynamicEquationsBase[DHtable_, CGtable_, Masslist_, Tensortable_, gb_, q_, qp_, v_, vp_, {Tb0_, Tne_}]:=
	Module[{B, C, G, eqs},
		
		B = InertiaBase[DHtable, CGtable, Masslist, Tensortable, {Tb0, Tne}];
		C = InertiaToCoriolis[B, q, qp];
		G = GravitationalBase[DHtable, CGtable, Masslist, gb, {Tb0, Tne}];
		
		eqs = B.vp + C.v + G;
		
		Return[eqs];	
	];
	
(* parameters reshaping *)
TakeMoments[A_List]:=
	Module[{v},
		v = {A[[1,1]], -A[[1,2]], -A[[1,3]], A[[2,2]], -A[[2,3]], A[[3,3]]};
		
		Return[v];
		
	];

ExtractParameters[CGtable_, Masslist_, Tensortable_]:=
	Module[{p, n, k},
		p = {};
		n = Length[CGtable];
		
		For[ k = 1, k <= n, k++,
			
             p0k = {Masslist[[k]]};
             
             p1k = Masslist[[k]] CGtable[[k]];
             
             p2k = TakeMoments[ Tensortable[[k]] - Masslist[[k]] Hat[CGtable[[k]]].Hat[CGtable[[k]]] ];
             				
			 pk = Join[ p0k, p1k, p2k ];
			 
			 p = Join[p, pk]; 
		]; 
		
		Return[p];
		
		
	];		  

SwitchAt[v1_List, v2_List, k_] :=
	Module[{res,index},
		res = v1;
		index = k;
		res[[index]] = v2[[index]];
		Return[res];
	];
	
(* numerical derivative of a matrix w.r.t. q at numerical value q0 *)	

NDMatrix[S_, q_, q0_] :=
	Module[{r, i, m, n},
		
		r = Length[q];
		{m, n} = Dimensions[ S[q0] ];
		dS = Table[ZeroMatrix[m,n],{r}];
		
		
		For[i=1, i<=r, i++,
			
			(* dS[[i]] = ND[ S /. Thread[Rule[q, SwitchAt[q0, q, i] ]], q[[i]], q0[[i]] ]; *)
			
			dS[[i]] = ND[ S[SwitchAt[q0, q, i]], q[[i]], q0[[i]] ];
			
		];
		
		Return[dS];
	];

(* the whole expression A[q1,q2,...] must be supplied *)
	
NullBasis[A_, independent_] :=
	Module[{m, n, eye, dependent, depsel, indepsel, LHSmat, RHSvec, i},
		  
		   {m, n} = Dimensions[A];
		      eye = IdentityMatrix[n - m];
		dependent = Complement[Range[n], independent];
		 depsel   = SelectionMatrixColumns[n, dependent];
		 indepsel = SelectionMatrixColumns[n, independent];
		   LHSmat =  A.depsel;
		   RHSvec = -A.indepsel;
		      res = Inverse[LHSmat].RHSvec;
		      
		 For[i=1, i<=Length[independent], i++,
		 	
		 	  res = Insert[res, eye[[ i ]], {independent[[i]]} ];
		 
		 ];
		 
		 Return[res];
		      
		 
	];

(* only the head of the matrix has to be supplied *)
	
NullBasisNumerical[A_, q0_, independent_] :=
	Module[{m, n, Aq0},
		
		If[ MatrixQ[A[q0]] , Aq0 = A[q0], Aq0 = A@@q0];
		
		{m, n} = Dimensions[ Aq0 ];
		   eye = IdentityMatrix[n - m];
		   
		dependent = Complement[Range[n], independent];
		 depsel   = SelectionMatrixColumns[n, dependent];
		 indepsel = SelectionMatrixColumns[n, independent];
		   LHSmat =  Aq0.depsel;
		   RHSvec = -Aq0.indepsel;
		      res = PseudoInverse[LHSmat].RHSvec;
		      
		 For[i=1, i<=Length[independent], i++,
		 	
		 	  res = Insert[res, eye[[ i ]], {independent[[i]]} ];
		 
		 ];
		 
		 Return[res];
	];

Eye[n_]:= IdentityMatrix[n];
	
(* Constraint definitions *)

GraspMatrix[EP_]:=
	Module[{G},
		G = BlockMatrix[
			{{ IdentityMatrix[3],     ZeroMatrix[3] },
            {           Hat[EP], IdentityMatrix[3] }}
		];
		
		Return[G];
	];

GlobalGraspMatrix[EPlist_]:=
	Module[{G},
		G = StackCols@@GraspMatrix/@EPlist;
		
		Return[G];
	];
			
(* RigidAdjoint[gab], where gab = RPToHomogeneous[Rab, pab], gives the desired twist trasformation for a change of pole given by pab and a change of orientation given by Rab*)
(* see the twist notation functions *)

ConstraintMatrix[constrainttype_, axis_, Rbe_]:=
	Module[{H, F, n,  p, RT, g, Adg},
		H = IdentityMatrix[6];
		
		p = {0, 0, 0};
		RT = Transpose[Rbe];
		
		g = RPToHomogeneous[RT, p];
		
		Adg = RigidAdjoint[g];
		
		If[constrainttype == "S", 
			H = Take[H, {1, 3}, {1, 6}]; 
		];
		
		If[constrainttype == "R",  
		    F = Join[ {0, 0, 0}, axis ];
		    H = NullSpace[{F}];
		];
		
		If[constrainttype == "P",  
		    F = Join[ axis, {0, 0, 0} ];
		    H = NullSpace[{F}];
		];
		
		If[constrainttype == "C",  
		     H = IdentityMatrix[6];
		];
		
		If[constrainttype == "PC",  
		    H = Take[H, {3}];
		];
		
		If[constrainttype == "PCWF",  
		    H = Take[H, {1, 3}, {1, 6}];
		];
		
		If[constrainttype == "SF",  
		    H = H[[{1, 2, 3, 6}, All]];
		];
		
		Return[H.Adg];
	];

GlobalConstraintMatrix[list_]:=
	Module[{consmats, H},
		
		consmats = (ConstraintMatrix @@ #)& /@ list;
		
		H        = BlockDiag[consmats];
		
		Return[H];
		
	];


FreeHandJacobian[list_]:=
	Module[{Jacmats, fhJac},
		
		(* each element of list must be {DHtable_i, vars_i, gp0i } *)
		
		Jacmats = DHJacobBase[#[[1]] @@ #[[2]], #[[3]]]& /@ list;
		fhJac   = BlockDiag[Jacmats];
		
		Return[fhJac];
		
	];
	
HandJacobian[fingerlist_, constraintlist_]:=
	Module[{fhJac, H, hJac},
		
		fhJac = FreeHandJacobian[fingerlist];
		H     = GlobalConstraintMatrix[constraintlist];
		
		hJac  = H.fhJac;
		
		Return[hJac]; 
	];	

ObjectJac[ function_, pars_ ]:=	
	Module[{res},
		
		res = BlockMatrix[
			{ 
			  { Eye[3]       , ZeroMatrix[3] },
			  { ZeroMatrix[3], function@@pars }
			}	
		];
		
		Return[res];
		
	];

CouplerJacobian[ fstring_, pars_, constraintlist_, pointlist_ ]:=
	Module[{H, G, GT, Jo,  fJac, fFKin, res },
		
		fFKin  = ToExpression[fstring <> "ToMat"];
		fJac   = ToExpression[fstring <> "ToSpatialJac"];
		
		H  = GlobalConstraintMatrix[constraintlist];
		
        G  = GlobalGraspMatrix[ fFKin@@pars.(#) & /@ pointlist];
        GT = Transpose[G];
        
		Jo = ObjectJac[fJac, pars]; 
 
	   res = H.GT.Jo;
	   
	   Return[res]; 
		
	];

PfaffianMatrix[fingerlist_, fstring_, pars_, constraintlist_, pointlist_]:=
	Module[{A11, A12, res},
		
		A11 =   HandJacobian[fingerlist, constraintlist];
		
		A12 = - CouplerJacobian[fstring, pars, constraintlist, pointlist];
		
		res = StackCols[A11, A12];
		
		Return[res];
	];

(* Graphical Primitives *)

CreateGround[{xmin_, xmax_, dx_}, {ymin_, ymax_, dy_}, colorplane_, colorframe_]:=
	Module[{x, y, planepts, plane, e1s, e2s, e3s, Orig, frameS, scene},
		
		planepts = Table[{x, y, 0}, {x, xmin, xmax, dx}, {y, ymin, ymax, dy}];

        plane = Map[ Graphics3D, {Map[{colorplane, Line[#]} &, planepts], Map[{colorplane, Line[#]} &, Transpose[planepts]]}];
        
        e1s = {5, 0, 0}; e2s = {0, 5, 0}; e3s = {0, 0, 5}; Orig = {0, 0, 0};
        
        frameS = Graphics3D[{Thick, colorframe, Line[{Orig, e1s}], Line[{Orig, e2s}], Line[{Orig, e3s}]}];

        scene = Append[plane, frameS];
        
        Return[scene];
		
	];

CreateFrame[g_, colorframe_]:=
	Module[{R, p, x, y, z, scale, frame},
		scale = 5.0;
		
		R = RigidOrientation[g];
		p = RigidPosition[g];
		
		px = p + scale Flatten[TakeColumns[R, {1}]];
		py = p + scale Flatten[TakeColumns[R, {2}]];
		pz = p + scale Flatten[TakeColumns[R, {3}]];
		
		frame = Graphics3D[{Thick, colorframe, Line[{p, px}], Line[{p, py}], Line[{p, pz}]}];
	
	    Return[frame];
	];
	
CreateJoint[g_, {height_, radius_}]:=
	Module[{R, p, z, bottom, top, cylinder},
		
		R = RigidOrientation[g];
		p = RigidPosition[g];
		z = Flatten[TakeColumns[R, {3}]];
		
		bottom = p - (height/2) z;
		top    = p + (height/2) z;
		
		cylinder = Graphics3D[{
			                   Green, Opacity[0.25], Specularity[White, 30],
		                       Cylinder[{bottom, top}, radius]
		                       }, Boxed -> False];
		
		Return[cylinder];	
	];
	
CreateLink[g_, {length_, radius_}]:=
	Module[{R, p, x, start, end, cylinder},
		
		R = RigidOrientation[g];
		p = RigidPosition[g];
		x = Flatten[TakeColumns[R, {1}]];
		
		start  = p - length x;
		end    = p;
		
		cylinder = Graphics3D[{
			                   Orange, Opacity[0.25], Specularity[White, 30],
		                       Cylinder[{start, end}, radius]
		                       }, Boxed -> False];
		
		Return[cylinder];	
	];
	
CreateRobot[DHtable_, {gpb_, gb0_}, q0_, a0_:20]:=
	Module[{Tpb, Tb0, i, n, rlink, rjoint, hjoint, robot, res},
		Tpb = gpb;
		Tb0 = gb0;
		n   = Length[DHtable@@q0];
		rlink  = 2.5;
		rjoint = 5.0; 
		hjoint = 10.0;
		     (* a0 = 20; *)
		
		(* ruleq = Thread[Rule[q, q0]]; *)
		
		link0  = {CreateLink[Tpb.Tb0.HomogeneousRotY[-Pi/2], {a0, rlink}]};
		joint1 = {CreateJoint[Tpb, {hjoint, rjoint}]};
		
		linklist = Table[ 
			             CreateLink[ 
			             	   DHFKine[ DHtable@@q0, {Tpb.Tb0, Eye[4]}, i 
			             	          ], 
			             		        { (DHtable@@q0)[[i, 1]], rlink } 
			                       ],
			             {i, 1, n}
			             ];
			             
		jointlist = Table[ 
			             CreateJoint[ 
			             	   DHFKine[ DHtable@@q0, {Tpb.Tb0, Eye[4]}, i-1 
			             	          ], 
			             		        { hjoint, rjoint } 
			                       ],
			             {i, 2, n}
			             ];	             
		frameEE = {CreateFrame[ DHFKine[ DHtable@@q0, {Tpb.Tb0, Eye[4]} ], Magenta ]};
			             
		res = Join[link0, joint1, linklist, jointlist, frameEE];	             
		
		Return[res];
	];

BBox[a_, b_, c_]:=
	Module[{list},
		p1 = {a, b, -c, 1}; p2 = {-a, b, -c, 1}; p3 = {-a, -b, -c, 1}; p4 = {a, -b, -c, 1};
		p5 = {a, b,  c, 1}; p6 = {-a, b,  c, 1}; p7 = {-a, -b,  c, 1}; p8 = {a, -b,  c, 1};
	    
	    list1 = {p1, p2, p3, p4, p1}//Transpose;
	    list2 = {p5, p6, p7, p8, p5}//Transpose;
	    list3 = {p1, p5}//Transpose;
	    list4 = {p2, p6}//Transpose;
	    list5 = {p3, p7}//Transpose;
	    list6 = {p4, p8}//Transpose;
	    
	    list = {list1, list2, list3, list4, list5, list6};
	    
	    Return[list];
	
	];

EEllipsoid[a_, b_, c_]:=
	Module[{nu, nv},
		
		nu = 20.; nv = 20.;
		
		x[u_, v_]:= a Cos[v] Cos[u];
		y[u_, v_]:= b Cos[v] Sin[u];
		z[u_, v_]:= c Sin[v];
		
		r[u_, v_]:= {x[u,v], y[u,v], z[u,v], 1};
		
		list1 = Table[r[u,v], {u, 0, 2. Pi, 2. Pi/nu}, {v, -Pi/2., Pi/2., Pi/nv}];
		list2 = Transpose[list1];
		list1 = Transpose /@ list1;
		list2 = Transpose /@ list2;
		Return[ Join[list1, list2] ];
		
	];
	
CreateObject[g_, objectlist_, color_]:=
	Module[{points, lines, res},
		
		points = Transpose[Drop[Dot[g,#],-1]] & /@ objectlist;
		
		lines = Line /@ points;
		
		res = Graphics3D[{Thin, color, lines}];
		
		Return[res];
		
	];
	
FindRedundantAnglesFromOrigin[origin_, DHtable_, {Tb0_, Tne_}, q_, qguess_]:=
	Module[{g, p, f, L, gcons1, gcons2, gcons, cons, initguess, res},
		
		g = DHFKine[DHtable, {Tb0, Tne}];
		p = RigidPosition[g];
		
		f      = {(1/2) q.q}; 
		(* f      = {Max[q]};    *)
		
		gcons1  = origin - p;
		gcons2  = {};
		gcons   = Join[gcons1, gcons2];
		cons     = Thread[Equal[gcons, 0]];
		
		L = Join[f, cons];
		
		initguess = Thread[List[q, qguess]];
		
		res = q /. FindMinimum[L, initguess ][[2]]; 
		(* res = q /. NMinimize[L, q ][[2]]; *)

        Return[res];		
	];	
				
	
End[];

EndPackage[];
