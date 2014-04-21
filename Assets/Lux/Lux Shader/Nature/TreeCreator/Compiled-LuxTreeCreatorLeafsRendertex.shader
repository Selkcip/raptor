Shader "Hidden/Lux/Nature/Tree Creator Leaves Rendertex" {
Properties {
	_TranslucencyColor ("Translucency Color", Color) = (0.73,0.85,0.41,1) // (187,219,106,255)
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	_HalfOverCutoff ("0.5 / alpha cutoff", Range(0,1)) = 1.0
	_TranslucencyViewDependency ("View dependency", Range(0,1)) = 0.7
	
	_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
	_BumpSpecMap ("Normalmap (GA) Spec (R) Shadow Offset (B)", 2D) = "bump" {}
	_TranslucencyMap ("Trans (B) Gloss(A)", 2D) = "white" {}
}

SubShader {  
	Fog { Mode Off }
	
	Pass {
Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 79 to 79
//   d3d9 - ALU: 72 to 72
//   d3d11 - ALU: 65 to 65, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 14 [unity_Scale]
Float 15 [_TranslucencyViewDependency]
Vector 16 [_TerrainTreeLightDirections0]
Vector 17 [_TerrainTreeLightDirections1]
Vector 18 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 79 ALU
PARAM c[20] = { { 0, 1, 2, 0.60009766 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..18],
		{ 0.39990234 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0, vertex.normal.y, c[6];
MAD R1, vertex.normal.x, c[5], R0;
ABS R2.x, vertex.attrib[14].w;
ADD R3.w, -R2.x, c[0].y;
ADD R0, R1, c[0].x;
MAD R0, R0, R3.w, vertex.position;
MAD R1, vertex.normal.z, c[7], R1;
ADD R1, R1, c[0].x;
DP4 R1.w, R1, R1;
RSQ R1.w, R1.w;
MAD R1.xyz, R1.w, R1, -vertex.normal;
MAD R1.xyz, R3.w, R1, vertex.normal;
MOV R2.w, c[0].y;
MOV R2.xyz, c[13];
DP4 R3.z, R2, c[11];
DP4 R3.y, R2, c[10];
DP4 R3.x, R2, c[9];
MAD R2.xyz, R3, c[14].w, -R0;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
ADD R3.xyz, R2, c[18];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R1.w, R1, R3;
ADD R4.xyz, R2, c[17];
DP3 R2.w, R4, R4;
MAX result.texcoord[4].z, R1.w, c[0].x;
RSQ R1.w, R2.w;
ADD R3.xyz, R2, c[16];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R3.x, R1, R3;
DP3 R2.w, R2, -c[18];
MUL R4.xyz, R1.w, R4;
DP3 R1.w, R1, R4;
MAX result.texcoord[4].y, R1.w, c[0].x;
DP3 R1.w, R1, c[18];
MIN R3.w, -R1, c[0].y;
MIN R2.w, R2, c[0].y;
MAX result.texcoord[4].x, R3, c[0];
DP3 R3.x, R2, -c[17];
MIN R3.y, R3.x, c[0];
MAX R3.w, R3, c[0].x;
MAX R2.w, R2, c[0].x;
ADD R2.w, R2, -R3;
MAD R2.w, R2, c[15].x, R3;
MUL result.texcoord[2].z, R2.w, c[0];
DP3 R2.w, R1, c[17];
DP3 R1.x, R1, c[16];
DP3 R1.y, R2, -c[16];
MIN R3.z, -R2.w, c[0].y;
MIN R1.z, -R1.x, c[0].y;
MIN R1.y, R1, c[0];
MAX R3.x, R3.z, c[0];
MAX R3.y, R3, c[0].x;
MAX R1.z, R1, c[0].x;
MAX R1.y, R1, c[0].x;
ADD R2.x, R1.y, -R1.z;
MAD R1.z, R2.x, c[15].x, R1;
ADD R3.y, R3, -R3.x;
MAD R1.y, R3, c[15].x, R3.x;
MUL result.texcoord[2].y, R1, c[0].z;
MOV R1.y, c[19].x;
MUL result.texcoord[2].x, R1.z, c[0].z;
MAD R1.z, R1.w, c[0].w, R1.y;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MAD R0.x, R2.w, c[0].w, R1.y;
MAD R0.y, R1.x, c[0].w, R1;
MAX result.texcoord[3].z, R1, c[0].x;
MAX result.texcoord[3].y, R0.x, c[0].x;
MAX result.texcoord[3].x, R0.y, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 79 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 13 [unity_Scale]
Float 14 [_TranslucencyViewDependency]
Vector 15 [_TerrainTreeLightDirections0]
Vector 16 [_TerrainTreeLightDirections1]
Vector 17 [_TerrainTreeLightDirections2]
"vs_3_0
; 72 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.00000000, 1.00000000, 2.00000000, 0
def c19, 0.60009766, 0.39990234, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_color0 v4
abs r1.x, v1.w
mul r0, v2.y, c5
add r3.w, -r1.x, c18.y
mad r0, v2.x, c4, r0
add r1, r0, c18.x
mad r1, r1, r3.w, v0
mad r0, v2.z, c6, r0
add r0, r0, c18.x
dp4 r0.w, r0, r0
mov r2.w, c18.y
mov r2.xyz, c12
dp4 r3.z, r2, c10
dp4 r3.y, r2, c9
dp4 r3.x, r2, c8
mad r2.xyz, r3, c13.w, -r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2.w, r2
add r3.xyz, r2, c17
dp3 r2.w, r3, r3
rsq r2.w, r2.w
mul r3.xyz, r2.w, r3
rsq r2.w, r0.w
add r4.xyz, r2, c16
mad r0.xyz, r2.w, r0, -v2
mad r0.xyz, r3.w, r0, v2
dp3 r2.w, r0, r3
dp3 r0.w, r4, r4
rsq r0.w, r0.w
mul r3.xyz, r0.w, r4
dp3 r0.w, r0, r3
max o5.y, r0.w, c18.x
dp3 r0.w, r0, c17
add r3.xyz, r2, c15
max o5.z, r2.w, c18.x
dp3 r2.w, r3, r3
rsq r3.w, r2.w
mul r3.xyz, r3.w, r3
dp3 r3.x, r0, r3
min r2.w, -r0, c18.y
max r3.w, r2, c18.x
dp3_sat r2.w, r2, -c17
add r2.w, r2, -r3
mad r2.w, r2, c14.x, r3
max o5.x, r3, c18
dp3_sat r3.x, r2, -c16
mul o3.z, r2.w, c18
dp3 r2.w, r0, c16
dp3 r0.x, r0, c15
min r3.y, -r2.w, c18
max r0.y, r3, c18.x
add r0.z, r3.x, -r0.y
min r3.y, -r0.x, c18
mad r0.y, r0.z, c14.x, r0
mul o3.y, r0, c18.z
mad r0.y, r0.w, c19.x, c19
max o4.z, r0.y, c18.x
mad r0.y, r2.w, c19.x, c19
mad r0.x, r0, c19, c19.y
max r3.x, r3.y, c18
dp3_sat r2.x, r2, -c15
add r2.x, r2, -r3
mad r0.z, r2.x, c14.x, r3.x
mul o3.x, r0.z, c18.z
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
max o4.y, r0, c18.x
max o4.x, r0, c18
mov o2.xyz, v4.w
mov o1.xy, v3
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 10 vars
Float 92 [_TranslucencyViewDependency]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
BindCB "UnityTerrainImposter" 3
// 71 instructions, 4 temp regs, 0 temp arrays:
// ALU 65 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedlkejbhhcjobgiedjfcbiphbaekenfgpdabaaaaaaeaalaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaiaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcheajaaaaeaaaabaafnacaaaafjaaaaaeegiocaaaaaaaaaaa
agaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafjaaaaaeegiocaaaadaaaaaaadaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadicbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
aeaaaaaaapaaaaaibcaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
aiaaaaaaapaaaaaiccaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
ajaaaaaaapaaaaaiecaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
akaaaaaaapaaaaaiicaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
alaaaaaaaaaaaaaibcaabaaaabaaaaaadkbabaiambaaaaaaabaaaaaaabeaaaaa
aaaaiadpdcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
egbobaaaaaaaaaaadiaaaaaipcaabaaaacaaaaaafgafbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaa
dgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaadgaaaaafhccabaaaacaaaaaa
pgbpbaaaafaaaaaadiaaaaajocaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
agijcaaaacaaaaaabbaaaaaadcaaaaalocaabaaaabaaaaaaagijcaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaafgaobaaaabaaaaaadcaaaaalocaabaaa
abaaaaaaagijcaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaafgaobaaa
abaaaaaaaaaaaaaiocaabaaaabaaaaaafgaobaaaabaaaaaaagijcaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaaaaaaaaajgahbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahocaabaaaabaaaaaapgapbaaaaaaaaaaaagajbaaaaaaaaaaabacaaaaj
bcaabaaaacaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaaaaaaaaa
baaaaaaiicaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaalaaaaaa
baaaaaaibcaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaa
baaaaaaiccaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaajaaaaaa
baaaaaaiecaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaakaaaaaa
bbaaaaahccaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaeeaaaaaf
ccaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakocaabaaaacaaaaaaagajbaaa
adaaaaaafgafbaaaacaaaaaaagbjbaiaebaaaaaaacaaaaaadcaaaaajocaabaaa
acaaaaaaagaabaaaabaaaaaafgaobaaaacaaaaaaagbjbaaaacaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaaaaaaaaadgcaaaag
bcaabaaaadaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaahbccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaaakaabaaaadaaaaaaaaaaaaah
bccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabacaaaajbcaabaaa
abaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaabaaaaaabacaaaaj
ccaabaaaabaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaacaaaaaa
baaaaaaiecaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaabaaaaaa
dgcaaaagicaabaaaabaaaaaackaabaiaebaaaaaaabaaaaaadcaaaaajecaabaaa
abaaaaaackaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaah
cccabaaaaeaaaaaackaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaadcaaaaakbcaabaaa
abaaaaaadkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaadkaabaaaabaaaaaa
aaaaaaahcccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaacaaaaaadgcaaaag
ecaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaaheccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
ckaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaackaabaaaabaaaaaaaaaaaaah
eccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaadaaaaaaaaaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaajgahbaaaacaaaaaa
egacbaaaabaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egiccaaaadaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgapbaaaaaaaaaaaegiccaaaadaaaaaaacaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
cccabaaaafaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaaaaaaaaa
deaaaaaheccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  mediump float gloss_6;
  mediump float specular_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_9;
  x_9 = (tmpvar_8.w - _Cutoff);
  if ((x_9 < 0.0)) {
    discard;
  };
  lowp float tmpvar_10;
  tmpvar_10 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_7 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  gloss_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_13;
  diff_ibl_4.w = (diff_ibl_4.w * ((diff_ibl_4.w * ((diff_ibl_4.w * 0.305306) + 0.682171)) + 0.0125229));
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1) * 0.5);
  ambient_5 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (xlv_TEXCOORD2 * tmpvar_11.z);
  backContribs_3 = tmpvar_15;
  light_2 = (ambient_5 * tmpvar_8.xyz);
  mediump float nh_16;
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[0].xyz;
  lightColor_18 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = pow (lightColor_18, vec3(0.454545, 0.454545, 0.454545));
  lightColor_18 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = xlv_TEXCOORD3.x;
  nl_17 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = xlv_TEXCOORD4.x;
  nh_16 = tmpvar_22;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_17)) + (_SpecColor.xyz * (pow (nh_16, specular_7) * gloss_6))) * tmpvar_20));
  mediump float nh_23;
  mediump float nl_24;
  mediump vec3 lightColor_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = _TerrainTreeLightColors[1].xyz;
  lightColor_25 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = pow (lightColor_25, vec3(0.454545, 0.454545, 0.454545));
  lightColor_25 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = xlv_TEXCOORD3.y;
  nl_24 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = xlv_TEXCOORD4.y;
  nh_23 = tmpvar_29;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_24)) + (_SpecColor.xyz * (pow (nh_23, specular_7) * gloss_6))) * tmpvar_27));
  mediump float nh_30;
  mediump float nl_31;
  mediump vec3 lightColor_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = _TerrainTreeLightColors[2].xyz;
  lightColor_32 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = pow (lightColor_32, vec3(0.454545, 0.454545, 0.454545));
  lightColor_32 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = xlv_TEXCOORD3.z;
  nl_31 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = xlv_TEXCOORD4.z;
  nh_30 = tmpvar_36;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_31)) + (_SpecColor.xyz * (pow (nh_30, specular_7) * gloss_6))) * tmpvar_34));
  mediump vec3 tmpvar_37;
  tmpvar_37 = (light_2 * 2.0);
  c_1.xyz = tmpvar_37;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  mediump float gloss_6;
  mediump float specular_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_9;
  x_9 = (tmpvar_8.w - _Cutoff);
  if ((x_9 < 0.0)) {
    discard;
  };
  lowp float tmpvar_10;
  tmpvar_10 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_7 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  gloss_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_13;
  diff_ibl_4.w = (diff_ibl_4.w * ((diff_ibl_4.w * ((diff_ibl_4.w * 0.305306) + 0.682171)) + 0.0125229));
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1) * 0.5);
  ambient_5 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (xlv_TEXCOORD2 * tmpvar_11.z);
  backContribs_3 = tmpvar_15;
  light_2 = (ambient_5 * tmpvar_8.xyz);
  mediump float nh_16;
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[0].xyz;
  lightColor_18 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = pow (lightColor_18, vec3(0.454545, 0.454545, 0.454545));
  lightColor_18 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = xlv_TEXCOORD3.x;
  nl_17 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = xlv_TEXCOORD4.x;
  nh_16 = tmpvar_22;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_17)) + (_SpecColor.xyz * (pow (nh_16, specular_7) * gloss_6))) * tmpvar_20));
  mediump float nh_23;
  mediump float nl_24;
  mediump vec3 lightColor_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = _TerrainTreeLightColors[1].xyz;
  lightColor_25 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = pow (lightColor_25, vec3(0.454545, 0.454545, 0.454545));
  lightColor_25 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = xlv_TEXCOORD3.y;
  nl_24 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = xlv_TEXCOORD4.y;
  nh_23 = tmpvar_29;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_24)) + (_SpecColor.xyz * (pow (nh_23, specular_7) * gloss_6))) * tmpvar_27));
  mediump float nh_30;
  mediump float nl_31;
  mediump vec3 lightColor_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = _TerrainTreeLightColors[2].xyz;
  lightColor_32 = tmpvar_33;
  mediump vec3 tmpvar_34;
  tmpvar_34 = pow (lightColor_32, vec3(0.454545, 0.454545, 0.454545));
  lightColor_32 = tmpvar_34;
  highp float tmpvar_35;
  tmpvar_35 = xlv_TEXCOORD3.z;
  nl_31 = tmpvar_35;
  highp float tmpvar_36;
  tmpvar_36 = xlv_TEXCOORD4.z;
  nh_30 = tmpvar_36;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_31)) + (_SpecColor.xyz * (pow (nh_30, specular_7) * gloss_6))) * tmpvar_34));
  mediump vec3 tmpvar_37;
  tmpvar_37 = (light_2 * 2.0);
  c_1.xyz = tmpvar_37;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 ExposureIBL;
#line 656
#line 514
void ExpandBillboard( in highp mat4 mat, inout highp vec4 pos, inout highp vec3 normal, inout highp vec4 tangent ) {
    highp float isBillboard = (1.0 - abs(tangent.w));
    #line 517
    highp vec3 norb = vec3( normalize((vec4( normal, 0.0) * mat)));
    highp vec3 tanb = vec3( normalize((vec4( tangent.xyz, 0.0) * mat)));
    pos += ((vec4( normal.xy, 0.0, 0.0) * mat) * isBillboard);
    normal = mix( normal, norb, vec3( isBillboard));
    #line 521
    tangent = mix( tangent, vec4( tanb, -1.0), vec4( isBillboard));
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 625
v2f vert( in appdata_full v ) {
    #line 627
    v2f o;
    ExpandBillboard( glstate_matrix_invtrans_modelview0, v.vertex, v.normal, v.tangent);
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    #line 631
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 636
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        mediump float backContrib = xll_saturate_f(dot( viewDir, (-lightDir)));
        backContrib = mix( xll_saturate_f((-nl)), backContrib, _TranslucencyViewDependency);
        #line 640
        o.backContrib[j] = (backContrib * 2.0);
        nl = max( 0.0, ((nl * 0.6) + 0.4));
        o.nl[j] = nl;
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 644
        highp float nh = max( 0.0, dot( v.normal, h));
        o.nh[j] = nh;
    }
    o.color = vec3( v.color.w);
    #line 648
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec3 xlv_TEXCOORD5;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uv);
    xlv_TEXCOORD1 = vec3(xl_retval.color);
    xlv_TEXCOORD2 = vec3(xl_retval.backContrib);
    xlv_TEXCOORD3 = vec3(xl_retval.nl);
    xlv_TEXCOORD4 = vec3(xl_retval.nh);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
void xll_clip_f(float x) {
  if ( x<0.0 ) discard;
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 ExposureIBL;
#line 656
#line 656
lowp vec4 frag( in v2f i ) {
    lowp vec4 col = texture( _MainTex, i.uv);
    xll_clip_f((col.w - _Cutoff));
    #line 660
    lowp vec3 albedo = col.xyz;
    mediump float specular = (texture( _BumpSpecMap, i.uv).x * 128.0);
    lowp vec4 trngls = texture( _TranslucencyMap, i.uv);
    mediump float gloss = trngls.w;
    #line 664
    mediump vec3 ambient;
    mediump vec4 diff_ibl = texture( _DiffCubeIBL, i.normal);
    diff_ibl.w *= ((diff_ibl.w * ((diff_ibl.w * 0.305306) + 0.682171)) + 0.0125229);
    diff_ibl.xyz = (diff_ibl.xyz * diff_ibl.w);
    #line 668
    ambient = (((diff_ibl.xyz * ExposureIBL.x) * i.color) * 0.5);
    mediump vec3 backContribs = (i.backContrib * trngls.z);
    mediump vec3 light = (ambient * albedo);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 675
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        lightColor = pow( lightColor, vec3( 0.454545));
        mediump vec3 translucencyColor = (backContribs[j] * _TranslucencyColor);
        mediump float nl = i.nl[j];
        #line 679
        mediump float nh = i.nh[j];
        mediump float spec = (pow( nh, specular) * gloss);
        light += (((albedo * (translucencyColor + nl)) + (_SpecColor.xyz * spec)) * lightColor);
    }
    #line 683
    lowp vec4 c;
    c.xyz = (light * 2.0);
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.backContrib = vec3(xlv_TEXCOORD2);
    xlt_i.nl = vec3(xlv_TEXCOORD3);
    xlt_i.nh = vec3(xlv_TEXCOORD4);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 14 [unity_Scale]
Float 15 [_TranslucencyViewDependency]
Vector 16 [_TerrainTreeLightDirections0]
Vector 17 [_TerrainTreeLightDirections1]
Vector 18 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 79 ALU
PARAM c[20] = { { 0, 1, 2, 0.60009766 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..18],
		{ 0.39990234 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0, vertex.normal.y, c[6];
MAD R1, vertex.normal.x, c[5], R0;
ABS R2.x, vertex.attrib[14].w;
ADD R3.w, -R2.x, c[0].y;
ADD R0, R1, c[0].x;
MAD R0, R0, R3.w, vertex.position;
MAD R1, vertex.normal.z, c[7], R1;
ADD R1, R1, c[0].x;
DP4 R1.w, R1, R1;
RSQ R1.w, R1.w;
MAD R1.xyz, R1.w, R1, -vertex.normal;
MAD R1.xyz, R3.w, R1, vertex.normal;
MOV R2.w, c[0].y;
MOV R2.xyz, c[13];
DP4 R3.z, R2, c[11];
DP4 R3.y, R2, c[10];
DP4 R3.x, R2, c[9];
MAD R2.xyz, R3, c[14].w, -R0;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
ADD R3.xyz, R2, c[18];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R1.w, R1, R3;
ADD R4.xyz, R2, c[17];
DP3 R2.w, R4, R4;
MAX result.texcoord[4].z, R1.w, c[0].x;
RSQ R1.w, R2.w;
ADD R3.xyz, R2, c[16];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R3.x, R1, R3;
DP3 R2.w, R2, -c[18];
MUL R4.xyz, R1.w, R4;
DP3 R1.w, R1, R4;
MAX result.texcoord[4].y, R1.w, c[0].x;
DP3 R1.w, R1, c[18];
MIN R3.w, -R1, c[0].y;
MIN R2.w, R2, c[0].y;
MAX result.texcoord[4].x, R3, c[0];
DP3 R3.x, R2, -c[17];
MIN R3.y, R3.x, c[0];
MAX R3.w, R3, c[0].x;
MAX R2.w, R2, c[0].x;
ADD R2.w, R2, -R3;
MAD R2.w, R2, c[15].x, R3;
MUL result.texcoord[2].z, R2.w, c[0];
DP3 R2.w, R1, c[17];
DP3 R1.x, R1, c[16];
DP3 R1.y, R2, -c[16];
MIN R3.z, -R2.w, c[0].y;
MIN R1.z, -R1.x, c[0].y;
MIN R1.y, R1, c[0];
MAX R3.x, R3.z, c[0];
MAX R3.y, R3, c[0].x;
MAX R1.z, R1, c[0].x;
MAX R1.y, R1, c[0].x;
ADD R2.x, R1.y, -R1.z;
MAD R1.z, R2.x, c[15].x, R1;
ADD R3.y, R3, -R3.x;
MAD R1.y, R3, c[15].x, R3.x;
MUL result.texcoord[2].y, R1, c[0].z;
MOV R1.y, c[19].x;
MUL result.texcoord[2].x, R1.z, c[0].z;
MAD R1.z, R1.w, c[0].w, R1.y;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MAD R0.x, R2.w, c[0].w, R1.y;
MAD R0.y, R1.x, c[0].w, R1;
MAX result.texcoord[3].z, R1, c[0].x;
MAX result.texcoord[3].y, R0.x, c[0].x;
MAX result.texcoord[3].x, R0.y, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 79 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 13 [unity_Scale]
Float 14 [_TranslucencyViewDependency]
Vector 15 [_TerrainTreeLightDirections0]
Vector 16 [_TerrainTreeLightDirections1]
Vector 17 [_TerrainTreeLightDirections2]
"vs_3_0
; 72 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.00000000, 1.00000000, 2.00000000, 0
def c19, 0.60009766, 0.39990234, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_color0 v4
abs r1.x, v1.w
mul r0, v2.y, c5
add r3.w, -r1.x, c18.y
mad r0, v2.x, c4, r0
add r1, r0, c18.x
mad r1, r1, r3.w, v0
mad r0, v2.z, c6, r0
add r0, r0, c18.x
dp4 r0.w, r0, r0
mov r2.w, c18.y
mov r2.xyz, c12
dp4 r3.z, r2, c10
dp4 r3.y, r2, c9
dp4 r3.x, r2, c8
mad r2.xyz, r3, c13.w, -r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2.w, r2
add r3.xyz, r2, c17
dp3 r2.w, r3, r3
rsq r2.w, r2.w
mul r3.xyz, r2.w, r3
rsq r2.w, r0.w
add r4.xyz, r2, c16
mad r0.xyz, r2.w, r0, -v2
mad r0.xyz, r3.w, r0, v2
dp3 r2.w, r0, r3
dp3 r0.w, r4, r4
rsq r0.w, r0.w
mul r3.xyz, r0.w, r4
dp3 r0.w, r0, r3
max o5.y, r0.w, c18.x
dp3 r0.w, r0, c17
add r3.xyz, r2, c15
max o5.z, r2.w, c18.x
dp3 r2.w, r3, r3
rsq r3.w, r2.w
mul r3.xyz, r3.w, r3
dp3 r3.x, r0, r3
min r2.w, -r0, c18.y
max r3.w, r2, c18.x
dp3_sat r2.w, r2, -c17
add r2.w, r2, -r3
mad r2.w, r2, c14.x, r3
max o5.x, r3, c18
dp3_sat r3.x, r2, -c16
mul o3.z, r2.w, c18
dp3 r2.w, r0, c16
dp3 r0.x, r0, c15
min r3.y, -r2.w, c18
max r0.y, r3, c18.x
add r0.z, r3.x, -r0.y
min r3.y, -r0.x, c18
mad r0.y, r0.z, c14.x, r0
mul o3.y, r0, c18.z
mad r0.y, r0.w, c19.x, c19
max o4.z, r0.y, c18.x
mad r0.y, r2.w, c19.x, c19
mad r0.x, r0, c19, c19.y
max r3.x, r3.y, c18
dp3_sat r2.x, r2, -c15
add r2.x, r2, -r3
mad r0.z, r2.x, c14.x, r3.x
mul o3.x, r0.z, c18.z
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
max o4.y, r0, c18.x
max o4.x, r0, c18
mov o2.xyz, v4.w
mov o1.xy, v3
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 10 vars
Float 92 [_TranslucencyViewDependency]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
BindCB "UnityTerrainImposter" 3
// 71 instructions, 4 temp regs, 0 temp arrays:
// ALU 65 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedlkejbhhcjobgiedjfcbiphbaekenfgpdabaaaaaaeaalaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaiaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcheajaaaaeaaaabaafnacaaaafjaaaaaeegiocaaaaaaaaaaa
agaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafjaaaaaeegiocaaaadaaaaaaadaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadicbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
aeaaaaaaapaaaaaibcaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
aiaaaaaaapaaaaaiccaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
ajaaaaaaapaaaaaiecaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
akaaaaaaapaaaaaiicaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
alaaaaaaaaaaaaaibcaabaaaabaaaaaadkbabaiambaaaaaaabaaaaaaabeaaaaa
aaaaiadpdcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
egbobaaaaaaaaaaadiaaaaaipcaabaaaacaaaaaafgafbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaa
dgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaadgaaaaafhccabaaaacaaaaaa
pgbpbaaaafaaaaaadiaaaaajocaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
agijcaaaacaaaaaabbaaaaaadcaaaaalocaabaaaabaaaaaaagijcaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaafgaobaaaabaaaaaadcaaaaalocaabaaa
abaaaaaaagijcaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaafgaobaaa
abaaaaaaaaaaaaaiocaabaaaabaaaaaafgaobaaaabaaaaaaagijcaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaaaaaaaaajgahbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahocaabaaaabaaaaaapgapbaaaaaaaaaaaagajbaaaaaaaaaaabacaaaaj
bcaabaaaacaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaaaaaaaaa
baaaaaaiicaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaalaaaaaa
baaaaaaibcaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaa
baaaaaaiccaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaajaaaaaa
baaaaaaiecaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaakaaaaaa
bbaaaaahccaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaeeaaaaaf
ccaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakocaabaaaacaaaaaaagajbaaa
adaaaaaafgafbaaaacaaaaaaagbjbaiaebaaaaaaacaaaaaadcaaaaajocaabaaa
acaaaaaaagaabaaaabaaaaaafgaobaaaacaaaaaaagbjbaaaacaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaaaaaaaaadgcaaaag
bcaabaaaadaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaahbccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaaakaabaaaadaaaaaaaaaaaaah
bccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabacaaaajbcaabaaa
abaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaabaaaaaabacaaaaj
ccaabaaaabaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaacaaaaaa
baaaaaaiecaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaabaaaaaa
dgcaaaagicaabaaaabaaaaaackaabaiaebaaaaaaabaaaaaadcaaaaajecaabaaa
abaaaaaackaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaah
cccabaaaaeaaaaaackaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaadcaaaaakbcaabaaa
abaaaaaadkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaadkaabaaaabaaaaaa
aaaaaaahcccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaacaaaaaadgcaaaag
ecaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaaheccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
ckaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaackaabaaaabaaaaaaaaaaaaah
eccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaadaaaaaaaaaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaajgahbaaaacaaaaaa
egacbaaaabaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egiccaaaadaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgapbaaaaaaaaaaaegiccaaaadaaaaaaacaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
cccabaaaafaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaaaaaaaaa
deaaaaaheccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec3 ambient_4;
  mediump float gloss_5;
  mediump float specular_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_8;
  x_8 = (tmpvar_7.w - _Cutoff);
  if ((x_8 < 0.0)) {
    discard;
  };
  lowp float tmpvar_9;
  tmpvar_9 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_6 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  gloss_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1);
  ambient_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD2 * tmpvar_10.z);
  backContribs_3 = tmpvar_13;
  light_2 = (ambient_4 * tmpvar_7.xyz);
  mediump float nh_14;
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[0].xyz;
  lightColor_16 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = pow (lightColor_16, vec3(0.454545, 0.454545, 0.454545));
  lightColor_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = xlv_TEXCOORD3.x;
  nl_15 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD4.x;
  nh_14 = tmpvar_20;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_15)) + (_SpecColor.xyz * (pow (nh_14, specular_6) * gloss_5))) * tmpvar_18));
  mediump float nh_21;
  mediump float nl_22;
  mediump vec3 lightColor_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = _TerrainTreeLightColors[1].xyz;
  lightColor_23 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = pow (lightColor_23, vec3(0.454545, 0.454545, 0.454545));
  lightColor_23 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = xlv_TEXCOORD3.y;
  nl_22 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = xlv_TEXCOORD4.y;
  nh_21 = tmpvar_27;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_22)) + (_SpecColor.xyz * (pow (nh_21, specular_6) * gloss_5))) * tmpvar_25));
  mediump float nh_28;
  mediump float nl_29;
  mediump vec3 lightColor_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = _TerrainTreeLightColors[2].xyz;
  lightColor_30 = tmpvar_31;
  mediump vec3 tmpvar_32;
  tmpvar_32 = pow (lightColor_30, vec3(0.454545, 0.454545, 0.454545));
  lightColor_30 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = xlv_TEXCOORD3.z;
  nl_29 = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = xlv_TEXCOORD4.z;
  nh_28 = tmpvar_34;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_29)) + (_SpecColor.xyz * (pow (nh_28, specular_6) * gloss_5))) * tmpvar_32));
  mediump vec3 tmpvar_35;
  tmpvar_35 = (light_2 * 2.0);
  c_1.xyz = tmpvar_35;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec3 ambient_4;
  mediump float gloss_5;
  mediump float specular_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_8;
  x_8 = (tmpvar_7.w - _Cutoff);
  if ((x_8 < 0.0)) {
    discard;
  };
  lowp float tmpvar_9;
  tmpvar_9 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_6 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  gloss_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1);
  ambient_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD2 * tmpvar_10.z);
  backContribs_3 = tmpvar_13;
  light_2 = (ambient_4 * tmpvar_7.xyz);
  mediump float nh_14;
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[0].xyz;
  lightColor_16 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = pow (lightColor_16, vec3(0.454545, 0.454545, 0.454545));
  lightColor_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = xlv_TEXCOORD3.x;
  nl_15 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD4.x;
  nh_14 = tmpvar_20;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_15)) + (_SpecColor.xyz * (pow (nh_14, specular_6) * gloss_5))) * tmpvar_18));
  mediump float nh_21;
  mediump float nl_22;
  mediump vec3 lightColor_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = _TerrainTreeLightColors[1].xyz;
  lightColor_23 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = pow (lightColor_23, vec3(0.454545, 0.454545, 0.454545));
  lightColor_23 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = xlv_TEXCOORD3.y;
  nl_22 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = xlv_TEXCOORD4.y;
  nh_21 = tmpvar_27;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_22)) + (_SpecColor.xyz * (pow (nh_21, specular_6) * gloss_5))) * tmpvar_25));
  mediump float nh_28;
  mediump float nl_29;
  mediump vec3 lightColor_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = _TerrainTreeLightColors[2].xyz;
  lightColor_30 = tmpvar_31;
  mediump vec3 tmpvar_32;
  tmpvar_32 = pow (lightColor_30, vec3(0.454545, 0.454545, 0.454545));
  lightColor_30 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = xlv_TEXCOORD3.z;
  nl_29 = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = xlv_TEXCOORD4.z;
  nh_28 = tmpvar_34;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_29)) + (_SpecColor.xyz * (pow (nh_28, specular_6) * gloss_5))) * tmpvar_32));
  mediump vec3 tmpvar_35;
  tmpvar_35 = (light_2 * 2.0);
  c_1.xyz = tmpvar_35;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform highp vec4 ExposureIBL;
#line 514
void ExpandBillboard( in highp mat4 mat, inout highp vec4 pos, inout highp vec3 normal, inout highp vec4 tangent ) {
    highp float isBillboard = (1.0 - abs(tangent.w));
    #line 517
    highp vec3 norb = vec3( normalize((vec4( normal, 0.0) * mat)));
    highp vec3 tanb = vec3( normalize((vec4( tangent.xyz, 0.0) * mat)));
    pos += ((vec4( normal.xy, 0.0, 0.0) * mat) * isBillboard);
    normal = mix( normal, norb, vec3( isBillboard));
    #line 521
    tangent = mix( tangent, vec4( tanb, -1.0), vec4( isBillboard));
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 625
v2f vert( in appdata_full v ) {
    #line 627
    v2f o;
    ExpandBillboard( glstate_matrix_invtrans_modelview0, v.vertex, v.normal, v.tangent);
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    #line 631
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 636
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        mediump float backContrib = xll_saturate_f(dot( viewDir, (-lightDir)));
        backContrib = mix( xll_saturate_f((-nl)), backContrib, _TranslucencyViewDependency);
        #line 640
        o.backContrib[j] = (backContrib * 2.0);
        nl = max( 0.0, ((nl * 0.6) + 0.4));
        o.nl[j] = nl;
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 644
        highp float nh = max( 0.0, dot( v.normal, h));
        o.nh[j] = nh;
    }
    o.color = vec3( v.color.w);
    #line 648
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec3 xlv_TEXCOORD5;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uv);
    xlv_TEXCOORD1 = vec3(xl_retval.color);
    xlv_TEXCOORD2 = vec3(xl_retval.backContrib);
    xlv_TEXCOORD3 = vec3(xl_retval.nl);
    xlv_TEXCOORD4 = vec3(xl_retval.nh);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
void xll_clip_f(float x) {
  if ( x<0.0 ) discard;
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform highp vec4 ExposureIBL;
#line 655
lowp vec4 frag( in v2f i ) {
    #line 657
    lowp vec4 col = texture( _MainTex, i.uv);
    xll_clip_f((col.w - _Cutoff));
    lowp vec3 albedo = col.xyz;
    mediump float specular = (texture( _BumpSpecMap, i.uv).x * 128.0);
    #line 661
    lowp vec4 trngls = texture( _TranslucencyMap, i.uv);
    mediump float gloss = trngls.w;
    mediump vec3 ambient;
    ambient = (vec3( glstate_lightmodel_ambient) * i.color);
    #line 665
    mediump vec3 backContribs = (i.backContrib * trngls.z);
    mediump vec3 light = (ambient * albedo);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 671
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        lightColor = pow( lightColor, vec3( 0.454545));
        mediump vec3 translucencyColor = (backContribs[j] * _TranslucencyColor);
        mediump float nl = i.nl[j];
        #line 675
        mediump float nh = i.nh[j];
        mediump float spec = (pow( nh, specular) * gloss);
        light += (((albedo * (translucencyColor + nl)) + (_SpecColor.xyz * spec)) * lightColor);
    }
    #line 679
    lowp vec4 c;
    c.xyz = (light * 2.0);
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.backContrib = vec3(xlv_TEXCOORD2);
    xlt_i.nl = vec3(xlv_TEXCOORD3);
    xlt_i.nh = vec3(xlv_TEXCOORD4);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 14 [unity_Scale]
Float 15 [_TranslucencyViewDependency]
Vector 16 [_TerrainTreeLightDirections0]
Vector 17 [_TerrainTreeLightDirections1]
Vector 18 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 79 ALU
PARAM c[20] = { { 0, 1, 2, 0.60009766 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..18],
		{ 0.39990234 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0, vertex.normal.y, c[6];
MAD R1, vertex.normal.x, c[5], R0;
ABS R2.x, vertex.attrib[14].w;
ADD R3.w, -R2.x, c[0].y;
ADD R0, R1, c[0].x;
MAD R0, R0, R3.w, vertex.position;
MAD R1, vertex.normal.z, c[7], R1;
ADD R1, R1, c[0].x;
DP4 R1.w, R1, R1;
RSQ R1.w, R1.w;
MAD R1.xyz, R1.w, R1, -vertex.normal;
MAD R1.xyz, R3.w, R1, vertex.normal;
MOV R2.w, c[0].y;
MOV R2.xyz, c[13];
DP4 R3.z, R2, c[11];
DP4 R3.y, R2, c[10];
DP4 R3.x, R2, c[9];
MAD R2.xyz, R3, c[14].w, -R0;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
ADD R3.xyz, R2, c[18];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R1.w, R1, R3;
ADD R4.xyz, R2, c[17];
DP3 R2.w, R4, R4;
MAX result.texcoord[4].z, R1.w, c[0].x;
RSQ R1.w, R2.w;
ADD R3.xyz, R2, c[16];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R3.x, R1, R3;
DP3 R2.w, R2, -c[18];
MUL R4.xyz, R1.w, R4;
DP3 R1.w, R1, R4;
MAX result.texcoord[4].y, R1.w, c[0].x;
DP3 R1.w, R1, c[18];
MIN R3.w, -R1, c[0].y;
MIN R2.w, R2, c[0].y;
MAX result.texcoord[4].x, R3, c[0];
DP3 R3.x, R2, -c[17];
MIN R3.y, R3.x, c[0];
MAX R3.w, R3, c[0].x;
MAX R2.w, R2, c[0].x;
ADD R2.w, R2, -R3;
MAD R2.w, R2, c[15].x, R3;
MUL result.texcoord[2].z, R2.w, c[0];
DP3 R2.w, R1, c[17];
DP3 R1.x, R1, c[16];
DP3 R1.y, R2, -c[16];
MIN R3.z, -R2.w, c[0].y;
MIN R1.z, -R1.x, c[0].y;
MIN R1.y, R1, c[0];
MAX R3.x, R3.z, c[0];
MAX R3.y, R3, c[0].x;
MAX R1.z, R1, c[0].x;
MAX R1.y, R1, c[0].x;
ADD R2.x, R1.y, -R1.z;
MAD R1.z, R2.x, c[15].x, R1;
ADD R3.y, R3, -R3.x;
MAD R1.y, R3, c[15].x, R3.x;
MUL result.texcoord[2].y, R1, c[0].z;
MOV R1.y, c[19].x;
MUL result.texcoord[2].x, R1.z, c[0].z;
MAD R1.z, R1.w, c[0].w, R1.y;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MAD R0.x, R2.w, c[0].w, R1.y;
MAD R0.y, R1.x, c[0].w, R1;
MAX result.texcoord[3].z, R1, c[0].x;
MAX result.texcoord[3].y, R0.x, c[0].x;
MAX result.texcoord[3].x, R0.y, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 79 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 13 [unity_Scale]
Float 14 [_TranslucencyViewDependency]
Vector 15 [_TerrainTreeLightDirections0]
Vector 16 [_TerrainTreeLightDirections1]
Vector 17 [_TerrainTreeLightDirections2]
"vs_3_0
; 72 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.00000000, 1.00000000, 2.00000000, 0
def c19, 0.60009766, 0.39990234, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_color0 v4
abs r1.x, v1.w
mul r0, v2.y, c5
add r3.w, -r1.x, c18.y
mad r0, v2.x, c4, r0
add r1, r0, c18.x
mad r1, r1, r3.w, v0
mad r0, v2.z, c6, r0
add r0, r0, c18.x
dp4 r0.w, r0, r0
mov r2.w, c18.y
mov r2.xyz, c12
dp4 r3.z, r2, c10
dp4 r3.y, r2, c9
dp4 r3.x, r2, c8
mad r2.xyz, r3, c13.w, -r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2.w, r2
add r3.xyz, r2, c17
dp3 r2.w, r3, r3
rsq r2.w, r2.w
mul r3.xyz, r2.w, r3
rsq r2.w, r0.w
add r4.xyz, r2, c16
mad r0.xyz, r2.w, r0, -v2
mad r0.xyz, r3.w, r0, v2
dp3 r2.w, r0, r3
dp3 r0.w, r4, r4
rsq r0.w, r0.w
mul r3.xyz, r0.w, r4
dp3 r0.w, r0, r3
max o5.y, r0.w, c18.x
dp3 r0.w, r0, c17
add r3.xyz, r2, c15
max o5.z, r2.w, c18.x
dp3 r2.w, r3, r3
rsq r3.w, r2.w
mul r3.xyz, r3.w, r3
dp3 r3.x, r0, r3
min r2.w, -r0, c18.y
max r3.w, r2, c18.x
dp3_sat r2.w, r2, -c17
add r2.w, r2, -r3
mad r2.w, r2, c14.x, r3
max o5.x, r3, c18
dp3_sat r3.x, r2, -c16
mul o3.z, r2.w, c18
dp3 r2.w, r0, c16
dp3 r0.x, r0, c15
min r3.y, -r2.w, c18
max r0.y, r3, c18.x
add r0.z, r3.x, -r0.y
min r3.y, -r0.x, c18
mad r0.y, r0.z, c14.x, r0
mul o3.y, r0, c18.z
mad r0.y, r0.w, c19.x, c19
max o4.z, r0.y, c18.x
mad r0.y, r2.w, c19.x, c19
mad r0.x, r0, c19, c19.y
max r3.x, r3.y, c18
dp3_sat r2.x, r2, -c15
add r2.x, r2, -r3
mad r0.z, r2.x, c14.x, r3.x
mul o3.x, r0.z, c18.z
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
max o4.y, r0, c18.x
max o4.x, r0, c18
mov o2.xyz, v4.w
mov o1.xy, v3
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 10 vars
Float 92 [_TranslucencyViewDependency]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
BindCB "UnityTerrainImposter" 3
// 71 instructions, 4 temp regs, 0 temp arrays:
// ALU 65 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedlkejbhhcjobgiedjfcbiphbaekenfgpdabaaaaaaeaalaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaiaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcheajaaaaeaaaabaafnacaaaafjaaaaaeegiocaaaaaaaaaaa
agaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafjaaaaaeegiocaaaadaaaaaaadaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadicbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
aeaaaaaaapaaaaaibcaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
aiaaaaaaapaaaaaiccaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
ajaaaaaaapaaaaaiecaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
akaaaaaaapaaaaaiicaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
alaaaaaaaaaaaaaibcaabaaaabaaaaaadkbabaiambaaaaaaabaaaaaaabeaaaaa
aaaaiadpdcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
egbobaaaaaaaaaaadiaaaaaipcaabaaaacaaaaaafgafbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaa
dgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaadgaaaaafhccabaaaacaaaaaa
pgbpbaaaafaaaaaadiaaaaajocaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
agijcaaaacaaaaaabbaaaaaadcaaaaalocaabaaaabaaaaaaagijcaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaafgaobaaaabaaaaaadcaaaaalocaabaaa
abaaaaaaagijcaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaafgaobaaa
abaaaaaaaaaaaaaiocaabaaaabaaaaaafgaobaaaabaaaaaaagijcaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaaaaaaaaajgahbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahocaabaaaabaaaaaapgapbaaaaaaaaaaaagajbaaaaaaaaaaabacaaaaj
bcaabaaaacaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaaaaaaaaa
baaaaaaiicaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaalaaaaaa
baaaaaaibcaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaa
baaaaaaiccaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaajaaaaaa
baaaaaaiecaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaakaaaaaa
bbaaaaahccaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaeeaaaaaf
ccaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakocaabaaaacaaaaaaagajbaaa
adaaaaaafgafbaaaacaaaaaaagbjbaiaebaaaaaaacaaaaaadcaaaaajocaabaaa
acaaaaaaagaabaaaabaaaaaafgaobaaaacaaaaaaagbjbaaaacaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaaaaaaaaadgcaaaag
bcaabaaaadaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaahbccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaaakaabaaaadaaaaaaaaaaaaah
bccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabacaaaajbcaabaaa
abaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaabaaaaaabacaaaaj
ccaabaaaabaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaacaaaaaa
baaaaaaiecaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaabaaaaaa
dgcaaaagicaabaaaabaaaaaackaabaiaebaaaaaaabaaaaaadcaaaaajecaabaaa
abaaaaaackaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaah
cccabaaaaeaaaaaackaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaadcaaaaakbcaabaaa
abaaaaaadkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaadkaabaaaabaaaaaa
aaaaaaahcccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaacaaaaaadgcaaaag
ecaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaaheccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
ckaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaackaabaaaabaaaaaaaaaaaaah
eccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaadaaaaaaaaaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaajgahbaaaacaaaaaa
egacbaaaabaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egiccaaaadaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgapbaaaaaaaaaaaegiccaaaadaaaaaaacaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
cccabaaaafaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaaaaaaaaa
deaaaaaheccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  mediump float gloss_6;
  mediump float specular_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_9;
  x_9 = (tmpvar_8.w - _Cutoff);
  if ((x_9 < 0.0)) {
    discard;
  };
  lowp float tmpvar_10;
  tmpvar_10 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_7 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  gloss_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_13;
  diff_ibl_4.w = (diff_ibl_4.w * ((diff_ibl_4.w * ((diff_ibl_4.w * 0.305306) + 0.682171)) + 0.0125229));
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1) * 0.5);
  ambient_5 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (xlv_TEXCOORD2 * tmpvar_11.z);
  backContribs_3 = tmpvar_15;
  light_2 = (ambient_5 * tmpvar_8.xyz);
  mediump float nh_16;
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[0].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD3.x;
  nl_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = xlv_TEXCOORD4.x;
  nh_16 = tmpvar_21;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_17)) + (_SpecColor.xyz * (pow (nh_16, specular_7) * gloss_6))) * lightColor_18));
  mediump float nh_22;
  mediump float nl_23;
  mediump vec3 lightColor_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = _TerrainTreeLightColors[1].xyz;
  lightColor_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = xlv_TEXCOORD3.y;
  nl_23 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = xlv_TEXCOORD4.y;
  nh_22 = tmpvar_27;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_23)) + (_SpecColor.xyz * (pow (nh_22, specular_7) * gloss_6))) * lightColor_24));
  mediump float nh_28;
  mediump float nl_29;
  mediump vec3 lightColor_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = _TerrainTreeLightColors[2].xyz;
  lightColor_30 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = xlv_TEXCOORD3.z;
  nl_29 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = xlv_TEXCOORD4.z;
  nh_28 = tmpvar_33;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_29)) + (_SpecColor.xyz * (pow (nh_28, specular_7) * gloss_6))) * lightColor_30));
  mediump vec3 tmpvar_34;
  tmpvar_34 = (light_2 * 2.0);
  c_1.xyz = tmpvar_34;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  mediump float gloss_6;
  mediump float specular_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_9;
  x_9 = (tmpvar_8.w - _Cutoff);
  if ((x_9 < 0.0)) {
    discard;
  };
  lowp float tmpvar_10;
  tmpvar_10 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_7 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  gloss_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_13;
  diff_ibl_4.w = (diff_ibl_4.w * ((diff_ibl_4.w * ((diff_ibl_4.w * 0.305306) + 0.682171)) + 0.0125229));
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1) * 0.5);
  ambient_5 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (xlv_TEXCOORD2 * tmpvar_11.z);
  backContribs_3 = tmpvar_15;
  light_2 = (ambient_5 * tmpvar_8.xyz);
  mediump float nh_16;
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[0].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD3.x;
  nl_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = xlv_TEXCOORD4.x;
  nh_16 = tmpvar_21;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_17)) + (_SpecColor.xyz * (pow (nh_16, specular_7) * gloss_6))) * lightColor_18));
  mediump float nh_22;
  mediump float nl_23;
  mediump vec3 lightColor_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = _TerrainTreeLightColors[1].xyz;
  lightColor_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = xlv_TEXCOORD3.y;
  nl_23 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = xlv_TEXCOORD4.y;
  nh_22 = tmpvar_27;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_23)) + (_SpecColor.xyz * (pow (nh_22, specular_7) * gloss_6))) * lightColor_24));
  mediump float nh_28;
  mediump float nl_29;
  mediump vec3 lightColor_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = _TerrainTreeLightColors[2].xyz;
  lightColor_30 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = xlv_TEXCOORD3.z;
  nl_29 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = xlv_TEXCOORD4.z;
  nh_28 = tmpvar_33;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_29)) + (_SpecColor.xyz * (pow (nh_28, specular_7) * gloss_6))) * lightColor_30));
  mediump vec3 tmpvar_34;
  tmpvar_34 = (light_2 * 2.0);
  c_1.xyz = tmpvar_34;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 ExposureIBL;
#line 656
#line 514
void ExpandBillboard( in highp mat4 mat, inout highp vec4 pos, inout highp vec3 normal, inout highp vec4 tangent ) {
    highp float isBillboard = (1.0 - abs(tangent.w));
    #line 517
    highp vec3 norb = vec3( normalize((vec4( normal, 0.0) * mat)));
    highp vec3 tanb = vec3( normalize((vec4( tangent.xyz, 0.0) * mat)));
    pos += ((vec4( normal.xy, 0.0, 0.0) * mat) * isBillboard);
    normal = mix( normal, norb, vec3( isBillboard));
    #line 521
    tangent = mix( tangent, vec4( tanb, -1.0), vec4( isBillboard));
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 625
v2f vert( in appdata_full v ) {
    #line 627
    v2f o;
    ExpandBillboard( glstate_matrix_invtrans_modelview0, v.vertex, v.normal, v.tangent);
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    #line 631
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 636
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        mediump float backContrib = xll_saturate_f(dot( viewDir, (-lightDir)));
        backContrib = mix( xll_saturate_f((-nl)), backContrib, _TranslucencyViewDependency);
        #line 640
        o.backContrib[j] = (backContrib * 2.0);
        nl = max( 0.0, ((nl * 0.6) + 0.4));
        o.nl[j] = nl;
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 644
        highp float nh = max( 0.0, dot( v.normal, h));
        o.nh[j] = nh;
    }
    o.color = vec3( v.color.w);
    #line 648
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec3 xlv_TEXCOORD5;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uv);
    xlv_TEXCOORD1 = vec3(xl_retval.color);
    xlv_TEXCOORD2 = vec3(xl_retval.backContrib);
    xlv_TEXCOORD3 = vec3(xl_retval.nl);
    xlv_TEXCOORD4 = vec3(xl_retval.nh);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
void xll_clip_f(float x) {
  if ( x<0.0 ) discard;
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 ExposureIBL;
#line 656
#line 656
lowp vec4 frag( in v2f i ) {
    lowp vec4 col = texture( _MainTex, i.uv);
    xll_clip_f((col.w - _Cutoff));
    #line 660
    lowp vec3 albedo = col.xyz;
    mediump float specular = (texture( _BumpSpecMap, i.uv).x * 128.0);
    lowp vec4 trngls = texture( _TranslucencyMap, i.uv);
    mediump float gloss = trngls.w;
    #line 664
    mediump vec3 ambient;
    mediump vec4 diff_ibl = texture( _DiffCubeIBL, i.normal);
    diff_ibl.w *= ((diff_ibl.w * ((diff_ibl.w * 0.305306) + 0.682171)) + 0.0125229);
    diff_ibl.xyz = (diff_ibl.xyz * diff_ibl.w);
    #line 668
    ambient = (((diff_ibl.xyz * ExposureIBL.x) * i.color) * 0.5);
    mediump vec3 backContribs = (i.backContrib * trngls.z);
    mediump vec3 light = (ambient * albedo);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 675
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump vec3 translucencyColor = (backContribs[j] * _TranslucencyColor);
        mediump float nl = i.nl[j];
        mediump float nh = i.nh[j];
        #line 679
        mediump float spec = (pow( nh, specular) * gloss);
        light += (((albedo * (translucencyColor + nl)) + (_SpecColor.xyz * spec)) * lightColor);
    }
    lowp vec4 c;
    #line 683
    c.xyz = (light * 2.0);
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.backContrib = vec3(xlv_TEXCOORD2);
    xlt_i.nl = vec3(xlv_TEXCOORD3);
    xlt_i.nh = vec3(xlv_TEXCOORD4);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 14 [unity_Scale]
Float 15 [_TranslucencyViewDependency]
Vector 16 [_TerrainTreeLightDirections0]
Vector 17 [_TerrainTreeLightDirections1]
Vector 18 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 79 ALU
PARAM c[20] = { { 0, 1, 2, 0.60009766 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..18],
		{ 0.39990234 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0, vertex.normal.y, c[6];
MAD R1, vertex.normal.x, c[5], R0;
ABS R2.x, vertex.attrib[14].w;
ADD R3.w, -R2.x, c[0].y;
ADD R0, R1, c[0].x;
MAD R0, R0, R3.w, vertex.position;
MAD R1, vertex.normal.z, c[7], R1;
ADD R1, R1, c[0].x;
DP4 R1.w, R1, R1;
RSQ R1.w, R1.w;
MAD R1.xyz, R1.w, R1, -vertex.normal;
MAD R1.xyz, R3.w, R1, vertex.normal;
MOV R2.w, c[0].y;
MOV R2.xyz, c[13];
DP4 R3.z, R2, c[11];
DP4 R3.y, R2, c[10];
DP4 R3.x, R2, c[9];
MAD R2.xyz, R3, c[14].w, -R0;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
ADD R3.xyz, R2, c[18];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R1.w, R1, R3;
ADD R4.xyz, R2, c[17];
DP3 R2.w, R4, R4;
MAX result.texcoord[4].z, R1.w, c[0].x;
RSQ R1.w, R2.w;
ADD R3.xyz, R2, c[16];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R3.x, R1, R3;
DP3 R2.w, R2, -c[18];
MUL R4.xyz, R1.w, R4;
DP3 R1.w, R1, R4;
MAX result.texcoord[4].y, R1.w, c[0].x;
DP3 R1.w, R1, c[18];
MIN R3.w, -R1, c[0].y;
MIN R2.w, R2, c[0].y;
MAX result.texcoord[4].x, R3, c[0];
DP3 R3.x, R2, -c[17];
MIN R3.y, R3.x, c[0];
MAX R3.w, R3, c[0].x;
MAX R2.w, R2, c[0].x;
ADD R2.w, R2, -R3;
MAD R2.w, R2, c[15].x, R3;
MUL result.texcoord[2].z, R2.w, c[0];
DP3 R2.w, R1, c[17];
DP3 R1.x, R1, c[16];
DP3 R1.y, R2, -c[16];
MIN R3.z, -R2.w, c[0].y;
MIN R1.z, -R1.x, c[0].y;
MIN R1.y, R1, c[0];
MAX R3.x, R3.z, c[0];
MAX R3.y, R3, c[0].x;
MAX R1.z, R1, c[0].x;
MAX R1.y, R1, c[0].x;
ADD R2.x, R1.y, -R1.z;
MAD R1.z, R2.x, c[15].x, R1;
ADD R3.y, R3, -R3.x;
MAD R1.y, R3, c[15].x, R3.x;
MUL result.texcoord[2].y, R1, c[0].z;
MOV R1.y, c[19].x;
MUL result.texcoord[2].x, R1.z, c[0].z;
MAD R1.z, R1.w, c[0].w, R1.y;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MAD R0.x, R2.w, c[0].w, R1.y;
MAD R0.y, R1.x, c[0].w, R1;
MAX result.texcoord[3].z, R1, c[0].x;
MAX result.texcoord[3].y, R0.x, c[0].x;
MAX result.texcoord[3].x, R0.y, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 79 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 13 [unity_Scale]
Float 14 [_TranslucencyViewDependency]
Vector 15 [_TerrainTreeLightDirections0]
Vector 16 [_TerrainTreeLightDirections1]
Vector 17 [_TerrainTreeLightDirections2]
"vs_3_0
; 72 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.00000000, 1.00000000, 2.00000000, 0
def c19, 0.60009766, 0.39990234, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_color0 v4
abs r1.x, v1.w
mul r0, v2.y, c5
add r3.w, -r1.x, c18.y
mad r0, v2.x, c4, r0
add r1, r0, c18.x
mad r1, r1, r3.w, v0
mad r0, v2.z, c6, r0
add r0, r0, c18.x
dp4 r0.w, r0, r0
mov r2.w, c18.y
mov r2.xyz, c12
dp4 r3.z, r2, c10
dp4 r3.y, r2, c9
dp4 r3.x, r2, c8
mad r2.xyz, r3, c13.w, -r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2.w, r2
add r3.xyz, r2, c17
dp3 r2.w, r3, r3
rsq r2.w, r2.w
mul r3.xyz, r2.w, r3
rsq r2.w, r0.w
add r4.xyz, r2, c16
mad r0.xyz, r2.w, r0, -v2
mad r0.xyz, r3.w, r0, v2
dp3 r2.w, r0, r3
dp3 r0.w, r4, r4
rsq r0.w, r0.w
mul r3.xyz, r0.w, r4
dp3 r0.w, r0, r3
max o5.y, r0.w, c18.x
dp3 r0.w, r0, c17
add r3.xyz, r2, c15
max o5.z, r2.w, c18.x
dp3 r2.w, r3, r3
rsq r3.w, r2.w
mul r3.xyz, r3.w, r3
dp3 r3.x, r0, r3
min r2.w, -r0, c18.y
max r3.w, r2, c18.x
dp3_sat r2.w, r2, -c17
add r2.w, r2, -r3
mad r2.w, r2, c14.x, r3
max o5.x, r3, c18
dp3_sat r3.x, r2, -c16
mul o3.z, r2.w, c18
dp3 r2.w, r0, c16
dp3 r0.x, r0, c15
min r3.y, -r2.w, c18
max r0.y, r3, c18.x
add r0.z, r3.x, -r0.y
min r3.y, -r0.x, c18
mad r0.y, r0.z, c14.x, r0
mul o3.y, r0, c18.z
mad r0.y, r0.w, c19.x, c19
max o4.z, r0.y, c18.x
mad r0.y, r2.w, c19.x, c19
mad r0.x, r0, c19, c19.y
max r3.x, r3.y, c18
dp3_sat r2.x, r2, -c15
add r2.x, r2, -r3
mad r0.z, r2.x, c14.x, r3.x
mul o3.x, r0.z, c18.z
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
max o4.y, r0, c18.x
max o4.x, r0, c18
mov o2.xyz, v4.w
mov o1.xy, v3
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 10 vars
Float 92 [_TranslucencyViewDependency]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
BindCB "UnityTerrainImposter" 3
// 71 instructions, 4 temp regs, 0 temp arrays:
// ALU 65 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedlkejbhhcjobgiedjfcbiphbaekenfgpdabaaaaaaeaalaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaiaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcheajaaaaeaaaabaafnacaaaafjaaaaaeegiocaaaaaaaaaaa
agaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafjaaaaaeegiocaaaadaaaaaaadaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadicbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
aeaaaaaaapaaaaaibcaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
aiaaaaaaapaaaaaiccaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
ajaaaaaaapaaaaaiecaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
akaaaaaaapaaaaaiicaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
alaaaaaaaaaaaaaibcaabaaaabaaaaaadkbabaiambaaaaaaabaaaaaaabeaaaaa
aaaaiadpdcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
egbobaaaaaaaaaaadiaaaaaipcaabaaaacaaaaaafgafbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaa
dgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaadgaaaaafhccabaaaacaaaaaa
pgbpbaaaafaaaaaadiaaaaajocaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
agijcaaaacaaaaaabbaaaaaadcaaaaalocaabaaaabaaaaaaagijcaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaafgaobaaaabaaaaaadcaaaaalocaabaaa
abaaaaaaagijcaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaafgaobaaa
abaaaaaaaaaaaaaiocaabaaaabaaaaaafgaobaaaabaaaaaaagijcaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaaaaaaaaajgahbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahocaabaaaabaaaaaapgapbaaaaaaaaaaaagajbaaaaaaaaaaabacaaaaj
bcaabaaaacaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaaaaaaaaa
baaaaaaiicaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaalaaaaaa
baaaaaaibcaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaa
baaaaaaiccaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaajaaaaaa
baaaaaaiecaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaakaaaaaa
bbaaaaahccaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaeeaaaaaf
ccaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakocaabaaaacaaaaaaagajbaaa
adaaaaaafgafbaaaacaaaaaaagbjbaiaebaaaaaaacaaaaaadcaaaaajocaabaaa
acaaaaaaagaabaaaabaaaaaafgaobaaaacaaaaaaagbjbaaaacaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaaaaaaaaadgcaaaag
bcaabaaaadaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaahbccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaaakaabaaaadaaaaaaaaaaaaah
bccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabacaaaajbcaabaaa
abaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaabaaaaaabacaaaaj
ccaabaaaabaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaacaaaaaa
baaaaaaiecaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaabaaaaaa
dgcaaaagicaabaaaabaaaaaackaabaiaebaaaaaaabaaaaaadcaaaaajecaabaaa
abaaaaaackaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaah
cccabaaaaeaaaaaackaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaadcaaaaakbcaabaaa
abaaaaaadkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaadkaabaaaabaaaaaa
aaaaaaahcccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaacaaaaaadgcaaaag
ecaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaaheccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
ckaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaackaabaaaabaaaaaaaaaaaaah
eccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaadaaaaaaaaaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaajgahbaaaacaaaaaa
egacbaaaabaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egiccaaaadaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgapbaaaaaaaaaaaegiccaaaadaaaaaaacaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
cccabaaaafaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaaaaaaaaa
deaaaaaheccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec3 ambient_4;
  mediump float gloss_5;
  mediump float specular_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_8;
  x_8 = (tmpvar_7.w - _Cutoff);
  if ((x_8 < 0.0)) {
    discard;
  };
  lowp float tmpvar_9;
  tmpvar_9 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_6 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  gloss_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1);
  ambient_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD2 * tmpvar_10.z);
  backContribs_3 = tmpvar_13;
  light_2 = (ambient_4 * tmpvar_7.xyz);
  mediump float nh_14;
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[0].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD3.x;
  nl_15 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = xlv_TEXCOORD4.x;
  nh_14 = tmpvar_19;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_15)) + (_SpecColor.xyz * (pow (nh_14, specular_6) * gloss_5))) * lightColor_16));
  mediump float nh_20;
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[1].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD3.y;
  nl_21 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = xlv_TEXCOORD4.y;
  nh_20 = tmpvar_25;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_21)) + (_SpecColor.xyz * (pow (nh_20, specular_6) * gloss_5))) * lightColor_22));
  mediump float nh_26;
  mediump float nl_27;
  mediump vec3 lightColor_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = _TerrainTreeLightColors[2].xyz;
  lightColor_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = xlv_TEXCOORD3.z;
  nl_27 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = xlv_TEXCOORD4.z;
  nh_26 = tmpvar_31;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_27)) + (_SpecColor.xyz * (pow (nh_26, specular_6) * gloss_5))) * lightColor_28));
  mediump vec3 tmpvar_32;
  tmpvar_32 = (light_2 * 2.0);
  c_1.xyz = tmpvar_32;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec3 ambient_4;
  mediump float gloss_5;
  mediump float specular_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_8;
  x_8 = (tmpvar_7.w - _Cutoff);
  if ((x_8 < 0.0)) {
    discard;
  };
  lowp float tmpvar_9;
  tmpvar_9 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_6 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  gloss_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1);
  ambient_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD2 * tmpvar_10.z);
  backContribs_3 = tmpvar_13;
  light_2 = (ambient_4 * tmpvar_7.xyz);
  mediump float nh_14;
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[0].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD3.x;
  nl_15 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = xlv_TEXCOORD4.x;
  nh_14 = tmpvar_19;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_15)) + (_SpecColor.xyz * (pow (nh_14, specular_6) * gloss_5))) * lightColor_16));
  mediump float nh_20;
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[1].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD3.y;
  nl_21 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = xlv_TEXCOORD4.y;
  nh_20 = tmpvar_25;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_21)) + (_SpecColor.xyz * (pow (nh_20, specular_6) * gloss_5))) * lightColor_22));
  mediump float nh_26;
  mediump float nl_27;
  mediump vec3 lightColor_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = _TerrainTreeLightColors[2].xyz;
  lightColor_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = xlv_TEXCOORD3.z;
  nl_27 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = xlv_TEXCOORD4.z;
  nh_26 = tmpvar_31;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_27)) + (_SpecColor.xyz * (pow (nh_26, specular_6) * gloss_5))) * lightColor_28));
  mediump vec3 tmpvar_32;
  tmpvar_32 = (light_2 * 2.0);
  c_1.xyz = tmpvar_32;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform highp vec4 ExposureIBL;
#line 514
void ExpandBillboard( in highp mat4 mat, inout highp vec4 pos, inout highp vec3 normal, inout highp vec4 tangent ) {
    highp float isBillboard = (1.0 - abs(tangent.w));
    #line 517
    highp vec3 norb = vec3( normalize((vec4( normal, 0.0) * mat)));
    highp vec3 tanb = vec3( normalize((vec4( tangent.xyz, 0.0) * mat)));
    pos += ((vec4( normal.xy, 0.0, 0.0) * mat) * isBillboard);
    normal = mix( normal, norb, vec3( isBillboard));
    #line 521
    tangent = mix( tangent, vec4( tanb, -1.0), vec4( isBillboard));
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 625
v2f vert( in appdata_full v ) {
    #line 627
    v2f o;
    ExpandBillboard( glstate_matrix_invtrans_modelview0, v.vertex, v.normal, v.tangent);
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    #line 631
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 636
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        mediump float backContrib = xll_saturate_f(dot( viewDir, (-lightDir)));
        backContrib = mix( xll_saturate_f((-nl)), backContrib, _TranslucencyViewDependency);
        #line 640
        o.backContrib[j] = (backContrib * 2.0);
        nl = max( 0.0, ((nl * 0.6) + 0.4));
        o.nl[j] = nl;
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 644
        highp float nh = max( 0.0, dot( v.normal, h));
        o.nh[j] = nh;
    }
    o.color = vec3( v.color.w);
    #line 648
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec3 xlv_TEXCOORD5;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uv);
    xlv_TEXCOORD1 = vec3(xl_retval.color);
    xlv_TEXCOORD2 = vec3(xl_retval.backContrib);
    xlv_TEXCOORD3 = vec3(xl_retval.nl);
    xlv_TEXCOORD4 = vec3(xl_retval.nh);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
void xll_clip_f(float x) {
  if ( x<0.0 ) discard;
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform highp vec4 ExposureIBL;
#line 655
lowp vec4 frag( in v2f i ) {
    #line 657
    lowp vec4 col = texture( _MainTex, i.uv);
    xll_clip_f((col.w - _Cutoff));
    lowp vec3 albedo = col.xyz;
    mediump float specular = (texture( _BumpSpecMap, i.uv).x * 128.0);
    #line 661
    lowp vec4 trngls = texture( _TranslucencyMap, i.uv);
    mediump float gloss = trngls.w;
    mediump vec3 ambient;
    ambient = (vec3( glstate_lightmodel_ambient) * i.color);
    #line 665
    mediump vec3 backContribs = (i.backContrib * trngls.z);
    mediump vec3 light = (ambient * albedo);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 671
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump vec3 translucencyColor = (backContribs[j] * _TranslucencyColor);
        mediump float nl = i.nl[j];
        mediump float nh = i.nh[j];
        #line 675
        mediump float spec = (pow( nh, specular) * gloss);
        light += (((albedo * (translucencyColor + nl)) + (_SpecColor.xyz * spec)) * lightColor);
    }
    lowp vec4 c;
    #line 679
    c.xyz = (light * 2.0);
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.backContrib = vec3(xlv_TEXCOORD2);
    xlt_i.nl = vec3(xlv_TEXCOORD3);
    xlt_i.nh = vec3(xlv_TEXCOORD4);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 14 [unity_Scale]
Float 15 [_TranslucencyViewDependency]
Vector 16 [_TerrainTreeLightDirections0]
Vector 17 [_TerrainTreeLightDirections1]
Vector 18 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 79 ALU
PARAM c[20] = { { 0, 1, 2, 0.60009766 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..18],
		{ 0.39990234 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0, vertex.normal.y, c[6];
MAD R1, vertex.normal.x, c[5], R0;
ABS R2.x, vertex.attrib[14].w;
ADD R3.w, -R2.x, c[0].y;
ADD R0, R1, c[0].x;
MAD R0, R0, R3.w, vertex.position;
MAD R1, vertex.normal.z, c[7], R1;
ADD R1, R1, c[0].x;
DP4 R1.w, R1, R1;
RSQ R1.w, R1.w;
MAD R1.xyz, R1.w, R1, -vertex.normal;
MAD R1.xyz, R3.w, R1, vertex.normal;
MOV R2.w, c[0].y;
MOV R2.xyz, c[13];
DP4 R3.z, R2, c[11];
DP4 R3.y, R2, c[10];
DP4 R3.x, R2, c[9];
MAD R2.xyz, R3, c[14].w, -R0;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
ADD R3.xyz, R2, c[18];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R1.w, R1, R3;
ADD R4.xyz, R2, c[17];
DP3 R2.w, R4, R4;
MAX result.texcoord[4].z, R1.w, c[0].x;
RSQ R1.w, R2.w;
ADD R3.xyz, R2, c[16];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R3.x, R1, R3;
DP3 R2.w, R2, -c[18];
MUL R4.xyz, R1.w, R4;
DP3 R1.w, R1, R4;
MAX result.texcoord[4].y, R1.w, c[0].x;
DP3 R1.w, R1, c[18];
MIN R3.w, -R1, c[0].y;
MIN R2.w, R2, c[0].y;
MAX result.texcoord[4].x, R3, c[0];
DP3 R3.x, R2, -c[17];
MIN R3.y, R3.x, c[0];
MAX R3.w, R3, c[0].x;
MAX R2.w, R2, c[0].x;
ADD R2.w, R2, -R3;
MAD R2.w, R2, c[15].x, R3;
MUL result.texcoord[2].z, R2.w, c[0];
DP3 R2.w, R1, c[17];
DP3 R1.x, R1, c[16];
DP3 R1.y, R2, -c[16];
MIN R3.z, -R2.w, c[0].y;
MIN R1.z, -R1.x, c[0].y;
MIN R1.y, R1, c[0];
MAX R3.x, R3.z, c[0];
MAX R3.y, R3, c[0].x;
MAX R1.z, R1, c[0].x;
MAX R1.y, R1, c[0].x;
ADD R2.x, R1.y, -R1.z;
MAD R1.z, R2.x, c[15].x, R1;
ADD R3.y, R3, -R3.x;
MAD R1.y, R3, c[15].x, R3.x;
MUL result.texcoord[2].y, R1, c[0].z;
MOV R1.y, c[19].x;
MUL result.texcoord[2].x, R1.z, c[0].z;
MAD R1.z, R1.w, c[0].w, R1.y;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MAD R0.x, R2.w, c[0].w, R1.y;
MAD R0.y, R1.x, c[0].w, R1;
MAX result.texcoord[3].z, R1, c[0].x;
MAX result.texcoord[3].y, R0.x, c[0].x;
MAX result.texcoord[3].x, R0.y, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 79 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 13 [unity_Scale]
Float 14 [_TranslucencyViewDependency]
Vector 15 [_TerrainTreeLightDirections0]
Vector 16 [_TerrainTreeLightDirections1]
Vector 17 [_TerrainTreeLightDirections2]
"vs_3_0
; 72 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.00000000, 1.00000000, 2.00000000, 0
def c19, 0.60009766, 0.39990234, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_color0 v4
abs r1.x, v1.w
mul r0, v2.y, c5
add r3.w, -r1.x, c18.y
mad r0, v2.x, c4, r0
add r1, r0, c18.x
mad r1, r1, r3.w, v0
mad r0, v2.z, c6, r0
add r0, r0, c18.x
dp4 r0.w, r0, r0
mov r2.w, c18.y
mov r2.xyz, c12
dp4 r3.z, r2, c10
dp4 r3.y, r2, c9
dp4 r3.x, r2, c8
mad r2.xyz, r3, c13.w, -r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2.w, r2
add r3.xyz, r2, c17
dp3 r2.w, r3, r3
rsq r2.w, r2.w
mul r3.xyz, r2.w, r3
rsq r2.w, r0.w
add r4.xyz, r2, c16
mad r0.xyz, r2.w, r0, -v2
mad r0.xyz, r3.w, r0, v2
dp3 r2.w, r0, r3
dp3 r0.w, r4, r4
rsq r0.w, r0.w
mul r3.xyz, r0.w, r4
dp3 r0.w, r0, r3
max o5.y, r0.w, c18.x
dp3 r0.w, r0, c17
add r3.xyz, r2, c15
max o5.z, r2.w, c18.x
dp3 r2.w, r3, r3
rsq r3.w, r2.w
mul r3.xyz, r3.w, r3
dp3 r3.x, r0, r3
min r2.w, -r0, c18.y
max r3.w, r2, c18.x
dp3_sat r2.w, r2, -c17
add r2.w, r2, -r3
mad r2.w, r2, c14.x, r3
max o5.x, r3, c18
dp3_sat r3.x, r2, -c16
mul o3.z, r2.w, c18
dp3 r2.w, r0, c16
dp3 r0.x, r0, c15
min r3.y, -r2.w, c18
max r0.y, r3, c18.x
add r0.z, r3.x, -r0.y
min r3.y, -r0.x, c18
mad r0.y, r0.z, c14.x, r0
mul o3.y, r0, c18.z
mad r0.y, r0.w, c19.x, c19
max o4.z, r0.y, c18.x
mad r0.y, r2.w, c19.x, c19
mad r0.x, r0, c19, c19.y
max r3.x, r3.y, c18
dp3_sat r2.x, r2, -c15
add r2.x, r2, -r3
mad r0.z, r2.x, c14.x, r3.x
mul o3.x, r0.z, c18.z
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
max o4.y, r0, c18.x
max o4.x, r0, c18
mov o2.xyz, v4.w
mov o1.xy, v3
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 10 vars
Float 92 [_TranslucencyViewDependency]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
BindCB "UnityTerrainImposter" 3
// 71 instructions, 4 temp regs, 0 temp arrays:
// ALU 65 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedlkejbhhcjobgiedjfcbiphbaekenfgpdabaaaaaaeaalaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaiaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcheajaaaaeaaaabaafnacaaaafjaaaaaeegiocaaaaaaaaaaa
agaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafjaaaaaeegiocaaaadaaaaaaadaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadicbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
aeaaaaaaapaaaaaibcaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
aiaaaaaaapaaaaaiccaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
ajaaaaaaapaaaaaiecaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
akaaaaaaapaaaaaiicaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
alaaaaaaaaaaaaaibcaabaaaabaaaaaadkbabaiambaaaaaaabaaaaaaabeaaaaa
aaaaiadpdcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
egbobaaaaaaaaaaadiaaaaaipcaabaaaacaaaaaafgafbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaa
dgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaadgaaaaafhccabaaaacaaaaaa
pgbpbaaaafaaaaaadiaaaaajocaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
agijcaaaacaaaaaabbaaaaaadcaaaaalocaabaaaabaaaaaaagijcaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaafgaobaaaabaaaaaadcaaaaalocaabaaa
abaaaaaaagijcaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaafgaobaaa
abaaaaaaaaaaaaaiocaabaaaabaaaaaafgaobaaaabaaaaaaagijcaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaaaaaaaaajgahbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahocaabaaaabaaaaaapgapbaaaaaaaaaaaagajbaaaaaaaaaaabacaaaaj
bcaabaaaacaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaaaaaaaaa
baaaaaaiicaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaalaaaaaa
baaaaaaibcaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaa
baaaaaaiccaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaajaaaaaa
baaaaaaiecaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaakaaaaaa
bbaaaaahccaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaeeaaaaaf
ccaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakocaabaaaacaaaaaaagajbaaa
adaaaaaafgafbaaaacaaaaaaagbjbaiaebaaaaaaacaaaaaadcaaaaajocaabaaa
acaaaaaaagaabaaaabaaaaaafgaobaaaacaaaaaaagbjbaaaacaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaaaaaaaaadgcaaaag
bcaabaaaadaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaahbccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaaakaabaaaadaaaaaaaaaaaaah
bccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabacaaaajbcaabaaa
abaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaabaaaaaabacaaaaj
ccaabaaaabaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaacaaaaaa
baaaaaaiecaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaabaaaaaa
dgcaaaagicaabaaaabaaaaaackaabaiaebaaaaaaabaaaaaadcaaaaajecaabaaa
abaaaaaackaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaah
cccabaaaaeaaaaaackaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaadcaaaaakbcaabaaa
abaaaaaadkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaadkaabaaaabaaaaaa
aaaaaaahcccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaacaaaaaadgcaaaag
ecaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaaheccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
ckaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaackaabaaaabaaaaaaaaaaaaah
eccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaadaaaaaaaaaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaajgahbaaaacaaaaaa
egacbaaaabaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egiccaaaadaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgapbaaaaaaaaaaaegiccaaaadaaaaaaacaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
cccabaaaafaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaaaaaaaaa
deaaaaaheccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  mediump float gloss_6;
  mediump float specular_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_9;
  x_9 = (tmpvar_8.w - _Cutoff);
  if ((x_9 < 0.0)) {
    discard;
  };
  lowp float tmpvar_10;
  tmpvar_10 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_7 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  gloss_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_13;
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1) * 0.5);
  ambient_5 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (xlv_TEXCOORD2 * tmpvar_11.z);
  backContribs_3 = tmpvar_15;
  light_2 = (ambient_5 * tmpvar_8.xyz);
  mediump float nh_16;
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[0].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD3.x;
  nl_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = xlv_TEXCOORD4.x;
  nh_16 = tmpvar_21;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_17)) + (_SpecColor.xyz * (pow (nh_16, specular_7) * gloss_6))) * lightColor_18));
  mediump float nh_22;
  mediump float nl_23;
  mediump vec3 lightColor_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = _TerrainTreeLightColors[1].xyz;
  lightColor_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = xlv_TEXCOORD3.y;
  nl_23 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = xlv_TEXCOORD4.y;
  nh_22 = tmpvar_27;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_23)) + (_SpecColor.xyz * (pow (nh_22, specular_7) * gloss_6))) * lightColor_24));
  mediump float nh_28;
  mediump float nl_29;
  mediump vec3 lightColor_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = _TerrainTreeLightColors[2].xyz;
  lightColor_30 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = xlv_TEXCOORD3.z;
  nl_29 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = xlv_TEXCOORD4.z;
  nh_28 = tmpvar_33;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_29)) + (_SpecColor.xyz * (pow (nh_28, specular_7) * gloss_6))) * lightColor_30));
  mediump vec3 tmpvar_34;
  tmpvar_34 = (light_2 * 2.0);
  c_1.xyz = tmpvar_34;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  mediump float gloss_6;
  mediump float specular_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_9;
  x_9 = (tmpvar_8.w - _Cutoff);
  if ((x_9 < 0.0)) {
    discard;
  };
  lowp float tmpvar_10;
  tmpvar_10 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_7 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  gloss_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_13;
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1) * 0.5);
  ambient_5 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (xlv_TEXCOORD2 * tmpvar_11.z);
  backContribs_3 = tmpvar_15;
  light_2 = (ambient_5 * tmpvar_8.xyz);
  mediump float nh_16;
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[0].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD3.x;
  nl_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = xlv_TEXCOORD4.x;
  nh_16 = tmpvar_21;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_17)) + (_SpecColor.xyz * (pow (nh_16, specular_7) * gloss_6))) * lightColor_18));
  mediump float nh_22;
  mediump float nl_23;
  mediump vec3 lightColor_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = _TerrainTreeLightColors[1].xyz;
  lightColor_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = xlv_TEXCOORD3.y;
  nl_23 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = xlv_TEXCOORD4.y;
  nh_22 = tmpvar_27;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_23)) + (_SpecColor.xyz * (pow (nh_22, specular_7) * gloss_6))) * lightColor_24));
  mediump float nh_28;
  mediump float nl_29;
  mediump vec3 lightColor_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = _TerrainTreeLightColors[2].xyz;
  lightColor_30 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = xlv_TEXCOORD3.z;
  nl_29 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = xlv_TEXCOORD4.z;
  nh_28 = tmpvar_33;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_29)) + (_SpecColor.xyz * (pow (nh_28, specular_7) * gloss_6))) * lightColor_30));
  mediump vec3 tmpvar_34;
  tmpvar_34 = (light_2 * 2.0);
  c_1.xyz = tmpvar_34;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 ExposureIBL;
#line 656
#line 514
void ExpandBillboard( in highp mat4 mat, inout highp vec4 pos, inout highp vec3 normal, inout highp vec4 tangent ) {
    highp float isBillboard = (1.0 - abs(tangent.w));
    #line 517
    highp vec3 norb = vec3( normalize((vec4( normal, 0.0) * mat)));
    highp vec3 tanb = vec3( normalize((vec4( tangent.xyz, 0.0) * mat)));
    pos += ((vec4( normal.xy, 0.0, 0.0) * mat) * isBillboard);
    normal = mix( normal, norb, vec3( isBillboard));
    #line 521
    tangent = mix( tangent, vec4( tanb, -1.0), vec4( isBillboard));
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 625
v2f vert( in appdata_full v ) {
    #line 627
    v2f o;
    ExpandBillboard( glstate_matrix_invtrans_modelview0, v.vertex, v.normal, v.tangent);
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    #line 631
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 636
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        mediump float backContrib = xll_saturate_f(dot( viewDir, (-lightDir)));
        backContrib = mix( xll_saturate_f((-nl)), backContrib, _TranslucencyViewDependency);
        #line 640
        o.backContrib[j] = (backContrib * 2.0);
        nl = max( 0.0, ((nl * 0.6) + 0.4));
        o.nl[j] = nl;
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 644
        highp float nh = max( 0.0, dot( v.normal, h));
        o.nh[j] = nh;
    }
    o.color = vec3( v.color.w);
    #line 648
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec3 xlv_TEXCOORD5;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uv);
    xlv_TEXCOORD1 = vec3(xl_retval.color);
    xlv_TEXCOORD2 = vec3(xl_retval.backContrib);
    xlv_TEXCOORD3 = vec3(xl_retval.nl);
    xlv_TEXCOORD4 = vec3(xl_retval.nh);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
void xll_clip_f(float x) {
  if ( x<0.0 ) discard;
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 ExposureIBL;
#line 656
#line 656
lowp vec4 frag( in v2f i ) {
    lowp vec4 col = texture( _MainTex, i.uv);
    xll_clip_f((col.w - _Cutoff));
    #line 660
    lowp vec3 albedo = col.xyz;
    mediump float specular = (texture( _BumpSpecMap, i.uv).x * 128.0);
    lowp vec4 trngls = texture( _TranslucencyMap, i.uv);
    mediump float gloss = trngls.w;
    #line 664
    mediump vec3 ambient;
    mediump vec4 diff_ibl = texture( _DiffCubeIBL, i.normal);
    diff_ibl.xyz = (diff_ibl.xyz * diff_ibl.w);
    ambient = (((diff_ibl.xyz * ExposureIBL.x) * i.color) * 0.5);
    #line 668
    mediump vec3 backContribs = (i.backContrib * trngls.z);
    mediump vec3 light = (ambient * albedo);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 674
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump vec3 translucencyColor = (backContribs[j] * _TranslucencyColor);
        mediump float nl = i.nl[j];
        mediump float nh = i.nh[j];
        #line 678
        mediump float spec = (pow( nh, specular) * gloss);
        light += (((albedo * (translucencyColor + nl)) + (_SpecColor.xyz * spec)) * lightColor);
    }
    lowp vec4 c;
    #line 682
    c.xyz = (light * 2.0);
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.backContrib = vec3(xlv_TEXCOORD2);
    xlt_i.nl = vec3(xlv_TEXCOORD3);
    xlt_i.nh = vec3(xlv_TEXCOORD4);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 14 [unity_Scale]
Float 15 [_TranslucencyViewDependency]
Vector 16 [_TerrainTreeLightDirections0]
Vector 17 [_TerrainTreeLightDirections1]
Vector 18 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 79 ALU
PARAM c[20] = { { 0, 1, 2, 0.60009766 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..18],
		{ 0.39990234 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0, vertex.normal.y, c[6];
MAD R1, vertex.normal.x, c[5], R0;
ABS R2.x, vertex.attrib[14].w;
ADD R3.w, -R2.x, c[0].y;
ADD R0, R1, c[0].x;
MAD R0, R0, R3.w, vertex.position;
MAD R1, vertex.normal.z, c[7], R1;
ADD R1, R1, c[0].x;
DP4 R1.w, R1, R1;
RSQ R1.w, R1.w;
MAD R1.xyz, R1.w, R1, -vertex.normal;
MAD R1.xyz, R3.w, R1, vertex.normal;
MOV R2.w, c[0].y;
MOV R2.xyz, c[13];
DP4 R3.z, R2, c[11];
DP4 R3.y, R2, c[10];
DP4 R3.x, R2, c[9];
MAD R2.xyz, R3, c[14].w, -R0;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
ADD R3.xyz, R2, c[18];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R1.w, R1, R3;
ADD R4.xyz, R2, c[17];
DP3 R2.w, R4, R4;
MAX result.texcoord[4].z, R1.w, c[0].x;
RSQ R1.w, R2.w;
ADD R3.xyz, R2, c[16];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R3.x, R1, R3;
DP3 R2.w, R2, -c[18];
MUL R4.xyz, R1.w, R4;
DP3 R1.w, R1, R4;
MAX result.texcoord[4].y, R1.w, c[0].x;
DP3 R1.w, R1, c[18];
MIN R3.w, -R1, c[0].y;
MIN R2.w, R2, c[0].y;
MAX result.texcoord[4].x, R3, c[0];
DP3 R3.x, R2, -c[17];
MIN R3.y, R3.x, c[0];
MAX R3.w, R3, c[0].x;
MAX R2.w, R2, c[0].x;
ADD R2.w, R2, -R3;
MAD R2.w, R2, c[15].x, R3;
MUL result.texcoord[2].z, R2.w, c[0];
DP3 R2.w, R1, c[17];
DP3 R1.x, R1, c[16];
DP3 R1.y, R2, -c[16];
MIN R3.z, -R2.w, c[0].y;
MIN R1.z, -R1.x, c[0].y;
MIN R1.y, R1, c[0];
MAX R3.x, R3.z, c[0];
MAX R3.y, R3, c[0].x;
MAX R1.z, R1, c[0].x;
MAX R1.y, R1, c[0].x;
ADD R2.x, R1.y, -R1.z;
MAD R1.z, R2.x, c[15].x, R1;
ADD R3.y, R3, -R3.x;
MAD R1.y, R3, c[15].x, R3.x;
MUL result.texcoord[2].y, R1, c[0].z;
MOV R1.y, c[19].x;
MUL result.texcoord[2].x, R1.z, c[0].z;
MAD R1.z, R1.w, c[0].w, R1.y;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MAD R0.x, R2.w, c[0].w, R1.y;
MAD R0.y, R1.x, c[0].w, R1;
MAX result.texcoord[3].z, R1, c[0].x;
MAX result.texcoord[3].y, R0.x, c[0].x;
MAX result.texcoord[3].x, R0.y, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 79 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 13 [unity_Scale]
Float 14 [_TranslucencyViewDependency]
Vector 15 [_TerrainTreeLightDirections0]
Vector 16 [_TerrainTreeLightDirections1]
Vector 17 [_TerrainTreeLightDirections2]
"vs_3_0
; 72 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.00000000, 1.00000000, 2.00000000, 0
def c19, 0.60009766, 0.39990234, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_color0 v4
abs r1.x, v1.w
mul r0, v2.y, c5
add r3.w, -r1.x, c18.y
mad r0, v2.x, c4, r0
add r1, r0, c18.x
mad r1, r1, r3.w, v0
mad r0, v2.z, c6, r0
add r0, r0, c18.x
dp4 r0.w, r0, r0
mov r2.w, c18.y
mov r2.xyz, c12
dp4 r3.z, r2, c10
dp4 r3.y, r2, c9
dp4 r3.x, r2, c8
mad r2.xyz, r3, c13.w, -r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2.w, r2
add r3.xyz, r2, c17
dp3 r2.w, r3, r3
rsq r2.w, r2.w
mul r3.xyz, r2.w, r3
rsq r2.w, r0.w
add r4.xyz, r2, c16
mad r0.xyz, r2.w, r0, -v2
mad r0.xyz, r3.w, r0, v2
dp3 r2.w, r0, r3
dp3 r0.w, r4, r4
rsq r0.w, r0.w
mul r3.xyz, r0.w, r4
dp3 r0.w, r0, r3
max o5.y, r0.w, c18.x
dp3 r0.w, r0, c17
add r3.xyz, r2, c15
max o5.z, r2.w, c18.x
dp3 r2.w, r3, r3
rsq r3.w, r2.w
mul r3.xyz, r3.w, r3
dp3 r3.x, r0, r3
min r2.w, -r0, c18.y
max r3.w, r2, c18.x
dp3_sat r2.w, r2, -c17
add r2.w, r2, -r3
mad r2.w, r2, c14.x, r3
max o5.x, r3, c18
dp3_sat r3.x, r2, -c16
mul o3.z, r2.w, c18
dp3 r2.w, r0, c16
dp3 r0.x, r0, c15
min r3.y, -r2.w, c18
max r0.y, r3, c18.x
add r0.z, r3.x, -r0.y
min r3.y, -r0.x, c18
mad r0.y, r0.z, c14.x, r0
mul o3.y, r0, c18.z
mad r0.y, r0.w, c19.x, c19
max o4.z, r0.y, c18.x
mad r0.y, r2.w, c19.x, c19
mad r0.x, r0, c19, c19.y
max r3.x, r3.y, c18
dp3_sat r2.x, r2, -c15
add r2.x, r2, -r3
mad r0.z, r2.x, c14.x, r3.x
mul o3.x, r0.z, c18.z
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
max o4.y, r0, c18.x
max o4.x, r0, c18
mov o2.xyz, v4.w
mov o1.xy, v3
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 10 vars
Float 92 [_TranslucencyViewDependency]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
BindCB "UnityTerrainImposter" 3
// 71 instructions, 4 temp regs, 0 temp arrays:
// ALU 65 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedlkejbhhcjobgiedjfcbiphbaekenfgpdabaaaaaaeaalaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaiaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcheajaaaaeaaaabaafnacaaaafjaaaaaeegiocaaaaaaaaaaa
agaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafjaaaaaeegiocaaaadaaaaaaadaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadicbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
aeaaaaaaapaaaaaibcaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
aiaaaaaaapaaaaaiccaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
ajaaaaaaapaaaaaiecaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
akaaaaaaapaaaaaiicaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
alaaaaaaaaaaaaaibcaabaaaabaaaaaadkbabaiambaaaaaaabaaaaaaabeaaaaa
aaaaiadpdcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
egbobaaaaaaaaaaadiaaaaaipcaabaaaacaaaaaafgafbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaa
dgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaadgaaaaafhccabaaaacaaaaaa
pgbpbaaaafaaaaaadiaaaaajocaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
agijcaaaacaaaaaabbaaaaaadcaaaaalocaabaaaabaaaaaaagijcaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaafgaobaaaabaaaaaadcaaaaalocaabaaa
abaaaaaaagijcaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaafgaobaaa
abaaaaaaaaaaaaaiocaabaaaabaaaaaafgaobaaaabaaaaaaagijcaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaaaaaaaaajgahbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahocaabaaaabaaaaaapgapbaaaaaaaaaaaagajbaaaaaaaaaaabacaaaaj
bcaabaaaacaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaaaaaaaaa
baaaaaaiicaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaalaaaaaa
baaaaaaibcaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaa
baaaaaaiccaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaajaaaaaa
baaaaaaiecaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaakaaaaaa
bbaaaaahccaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaeeaaaaaf
ccaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakocaabaaaacaaaaaaagajbaaa
adaaaaaafgafbaaaacaaaaaaagbjbaiaebaaaaaaacaaaaaadcaaaaajocaabaaa
acaaaaaaagaabaaaabaaaaaafgaobaaaacaaaaaaagbjbaaaacaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaaaaaaaaadgcaaaag
bcaabaaaadaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaahbccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaaakaabaaaadaaaaaaaaaaaaah
bccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabacaaaajbcaabaaa
abaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaabaaaaaabacaaaaj
ccaabaaaabaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaacaaaaaa
baaaaaaiecaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaabaaaaaa
dgcaaaagicaabaaaabaaaaaackaabaiaebaaaaaaabaaaaaadcaaaaajecaabaaa
abaaaaaackaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaah
cccabaaaaeaaaaaackaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaadcaaaaakbcaabaaa
abaaaaaadkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaadkaabaaaabaaaaaa
aaaaaaahcccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaacaaaaaadgcaaaag
ecaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaaheccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
ckaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaackaabaaaabaaaaaaaaaaaaah
eccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaadaaaaaaaaaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaajgahbaaaacaaaaaa
egacbaaaabaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egiccaaaadaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgapbaaaaaaaaaaaegiccaaaadaaaaaaacaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
cccabaaaafaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaaaaaaaaa
deaaaaaheccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec3 ambient_4;
  mediump float gloss_5;
  mediump float specular_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_8;
  x_8 = (tmpvar_7.w - _Cutoff);
  if ((x_8 < 0.0)) {
    discard;
  };
  lowp float tmpvar_9;
  tmpvar_9 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_6 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  gloss_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1);
  ambient_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD2 * tmpvar_10.z);
  backContribs_3 = tmpvar_13;
  light_2 = (ambient_4 * tmpvar_7.xyz);
  mediump float nh_14;
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[0].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD3.x;
  nl_15 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = xlv_TEXCOORD4.x;
  nh_14 = tmpvar_19;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_15)) + (_SpecColor.xyz * (pow (nh_14, specular_6) * gloss_5))) * lightColor_16));
  mediump float nh_20;
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[1].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD3.y;
  nl_21 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = xlv_TEXCOORD4.y;
  nh_20 = tmpvar_25;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_21)) + (_SpecColor.xyz * (pow (nh_20, specular_6) * gloss_5))) * lightColor_22));
  mediump float nh_26;
  mediump float nl_27;
  mediump vec3 lightColor_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = _TerrainTreeLightColors[2].xyz;
  lightColor_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = xlv_TEXCOORD3.z;
  nl_27 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = xlv_TEXCOORD4.z;
  nh_26 = tmpvar_31;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_27)) + (_SpecColor.xyz * (pow (nh_26, specular_6) * gloss_5))) * lightColor_28));
  mediump vec3 tmpvar_32;
  tmpvar_32 = (light_2 * 2.0);
  c_1.xyz = tmpvar_32;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec3 ambient_4;
  mediump float gloss_5;
  mediump float specular_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_8;
  x_8 = (tmpvar_7.w - _Cutoff);
  if ((x_8 < 0.0)) {
    discard;
  };
  lowp float tmpvar_9;
  tmpvar_9 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_6 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  gloss_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1);
  ambient_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD2 * tmpvar_10.z);
  backContribs_3 = tmpvar_13;
  light_2 = (ambient_4 * tmpvar_7.xyz);
  mediump float nh_14;
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[0].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD3.x;
  nl_15 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = xlv_TEXCOORD4.x;
  nh_14 = tmpvar_19;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_15)) + (_SpecColor.xyz * (pow (nh_14, specular_6) * gloss_5))) * lightColor_16));
  mediump float nh_20;
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[1].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD3.y;
  nl_21 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = xlv_TEXCOORD4.y;
  nh_20 = tmpvar_25;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_21)) + (_SpecColor.xyz * (pow (nh_20, specular_6) * gloss_5))) * lightColor_22));
  mediump float nh_26;
  mediump float nl_27;
  mediump vec3 lightColor_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = _TerrainTreeLightColors[2].xyz;
  lightColor_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = xlv_TEXCOORD3.z;
  nl_27 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = xlv_TEXCOORD4.z;
  nh_26 = tmpvar_31;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_27)) + (_SpecColor.xyz * (pow (nh_26, specular_6) * gloss_5))) * lightColor_28));
  mediump vec3 tmpvar_32;
  tmpvar_32 = (light_2 * 2.0);
  c_1.xyz = tmpvar_32;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform highp vec4 ExposureIBL;
#line 514
void ExpandBillboard( in highp mat4 mat, inout highp vec4 pos, inout highp vec3 normal, inout highp vec4 tangent ) {
    highp float isBillboard = (1.0 - abs(tangent.w));
    #line 517
    highp vec3 norb = vec3( normalize((vec4( normal, 0.0) * mat)));
    highp vec3 tanb = vec3( normalize((vec4( tangent.xyz, 0.0) * mat)));
    pos += ((vec4( normal.xy, 0.0, 0.0) * mat) * isBillboard);
    normal = mix( normal, norb, vec3( isBillboard));
    #line 521
    tangent = mix( tangent, vec4( tanb, -1.0), vec4( isBillboard));
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 625
v2f vert( in appdata_full v ) {
    #line 627
    v2f o;
    ExpandBillboard( glstate_matrix_invtrans_modelview0, v.vertex, v.normal, v.tangent);
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    #line 631
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 636
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        mediump float backContrib = xll_saturate_f(dot( viewDir, (-lightDir)));
        backContrib = mix( xll_saturate_f((-nl)), backContrib, _TranslucencyViewDependency);
        #line 640
        o.backContrib[j] = (backContrib * 2.0);
        nl = max( 0.0, ((nl * 0.6) + 0.4));
        o.nl[j] = nl;
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 644
        highp float nh = max( 0.0, dot( v.normal, h));
        o.nh[j] = nh;
    }
    o.color = vec3( v.color.w);
    #line 648
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec3 xlv_TEXCOORD5;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uv);
    xlv_TEXCOORD1 = vec3(xl_retval.color);
    xlv_TEXCOORD2 = vec3(xl_retval.backContrib);
    xlv_TEXCOORD3 = vec3(xl_retval.nl);
    xlv_TEXCOORD4 = vec3(xl_retval.nh);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
void xll_clip_f(float x) {
  if ( x<0.0 ) discard;
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform highp vec4 ExposureIBL;
#line 655
lowp vec4 frag( in v2f i ) {
    #line 657
    lowp vec4 col = texture( _MainTex, i.uv);
    xll_clip_f((col.w - _Cutoff));
    lowp vec3 albedo = col.xyz;
    mediump float specular = (texture( _BumpSpecMap, i.uv).x * 128.0);
    #line 661
    lowp vec4 trngls = texture( _TranslucencyMap, i.uv);
    mediump float gloss = trngls.w;
    mediump vec3 ambient;
    ambient = (vec3( glstate_lightmodel_ambient) * i.color);
    #line 665
    mediump vec3 backContribs = (i.backContrib * trngls.z);
    mediump vec3 light = (ambient * albedo);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 671
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump vec3 translucencyColor = (backContribs[j] * _TranslucencyColor);
        mediump float nl = i.nl[j];
        mediump float nh = i.nh[j];
        #line 675
        mediump float spec = (pow( nh, specular) * gloss);
        light += (((albedo * (translucencyColor + nl)) + (_SpecColor.xyz * spec)) * lightColor);
    }
    lowp vec4 c;
    #line 679
    c.xyz = (light * 2.0);
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.backContrib = vec3(xlv_TEXCOORD2);
    xlt_i.nl = vec3(xlv_TEXCOORD3);
    xlt_i.nh = vec3(xlv_TEXCOORD4);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 14 [unity_Scale]
Float 15 [_TranslucencyViewDependency]
Vector 16 [_TerrainTreeLightDirections0]
Vector 17 [_TerrainTreeLightDirections1]
Vector 18 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 79 ALU
PARAM c[20] = { { 0, 1, 2, 0.60009766 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..18],
		{ 0.39990234 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0, vertex.normal.y, c[6];
MAD R1, vertex.normal.x, c[5], R0;
ABS R2.x, vertex.attrib[14].w;
ADD R3.w, -R2.x, c[0].y;
ADD R0, R1, c[0].x;
MAD R0, R0, R3.w, vertex.position;
MAD R1, vertex.normal.z, c[7], R1;
ADD R1, R1, c[0].x;
DP4 R1.w, R1, R1;
RSQ R1.w, R1.w;
MAD R1.xyz, R1.w, R1, -vertex.normal;
MAD R1.xyz, R3.w, R1, vertex.normal;
MOV R2.w, c[0].y;
MOV R2.xyz, c[13];
DP4 R3.z, R2, c[11];
DP4 R3.y, R2, c[10];
DP4 R3.x, R2, c[9];
MAD R2.xyz, R3, c[14].w, -R0;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
ADD R3.xyz, R2, c[18];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R1.w, R1, R3;
ADD R4.xyz, R2, c[17];
DP3 R2.w, R4, R4;
MAX result.texcoord[4].z, R1.w, c[0].x;
RSQ R1.w, R2.w;
ADD R3.xyz, R2, c[16];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R3.x, R1, R3;
DP3 R2.w, R2, -c[18];
MUL R4.xyz, R1.w, R4;
DP3 R1.w, R1, R4;
MAX result.texcoord[4].y, R1.w, c[0].x;
DP3 R1.w, R1, c[18];
MIN R3.w, -R1, c[0].y;
MIN R2.w, R2, c[0].y;
MAX result.texcoord[4].x, R3, c[0];
DP3 R3.x, R2, -c[17];
MIN R3.y, R3.x, c[0];
MAX R3.w, R3, c[0].x;
MAX R2.w, R2, c[0].x;
ADD R2.w, R2, -R3;
MAD R2.w, R2, c[15].x, R3;
MUL result.texcoord[2].z, R2.w, c[0];
DP3 R2.w, R1, c[17];
DP3 R1.x, R1, c[16];
DP3 R1.y, R2, -c[16];
MIN R3.z, -R2.w, c[0].y;
MIN R1.z, -R1.x, c[0].y;
MIN R1.y, R1, c[0];
MAX R3.x, R3.z, c[0];
MAX R3.y, R3, c[0].x;
MAX R1.z, R1, c[0].x;
MAX R1.y, R1, c[0].x;
ADD R2.x, R1.y, -R1.z;
MAD R1.z, R2.x, c[15].x, R1;
ADD R3.y, R3, -R3.x;
MAD R1.y, R3, c[15].x, R3.x;
MUL result.texcoord[2].y, R1, c[0].z;
MOV R1.y, c[19].x;
MUL result.texcoord[2].x, R1.z, c[0].z;
MAD R1.z, R1.w, c[0].w, R1.y;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MAD R0.x, R2.w, c[0].w, R1.y;
MAD R0.y, R1.x, c[0].w, R1;
MAX result.texcoord[3].z, R1, c[0].x;
MAX result.texcoord[3].y, R0.x, c[0].x;
MAX result.texcoord[3].x, R0.y, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 79 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 13 [unity_Scale]
Float 14 [_TranslucencyViewDependency]
Vector 15 [_TerrainTreeLightDirections0]
Vector 16 [_TerrainTreeLightDirections1]
Vector 17 [_TerrainTreeLightDirections2]
"vs_3_0
; 72 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.00000000, 1.00000000, 2.00000000, 0
def c19, 0.60009766, 0.39990234, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_color0 v4
abs r1.x, v1.w
mul r0, v2.y, c5
add r3.w, -r1.x, c18.y
mad r0, v2.x, c4, r0
add r1, r0, c18.x
mad r1, r1, r3.w, v0
mad r0, v2.z, c6, r0
add r0, r0, c18.x
dp4 r0.w, r0, r0
mov r2.w, c18.y
mov r2.xyz, c12
dp4 r3.z, r2, c10
dp4 r3.y, r2, c9
dp4 r3.x, r2, c8
mad r2.xyz, r3, c13.w, -r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2.w, r2
add r3.xyz, r2, c17
dp3 r2.w, r3, r3
rsq r2.w, r2.w
mul r3.xyz, r2.w, r3
rsq r2.w, r0.w
add r4.xyz, r2, c16
mad r0.xyz, r2.w, r0, -v2
mad r0.xyz, r3.w, r0, v2
dp3 r2.w, r0, r3
dp3 r0.w, r4, r4
rsq r0.w, r0.w
mul r3.xyz, r0.w, r4
dp3 r0.w, r0, r3
max o5.y, r0.w, c18.x
dp3 r0.w, r0, c17
add r3.xyz, r2, c15
max o5.z, r2.w, c18.x
dp3 r2.w, r3, r3
rsq r3.w, r2.w
mul r3.xyz, r3.w, r3
dp3 r3.x, r0, r3
min r2.w, -r0, c18.y
max r3.w, r2, c18.x
dp3_sat r2.w, r2, -c17
add r2.w, r2, -r3
mad r2.w, r2, c14.x, r3
max o5.x, r3, c18
dp3_sat r3.x, r2, -c16
mul o3.z, r2.w, c18
dp3 r2.w, r0, c16
dp3 r0.x, r0, c15
min r3.y, -r2.w, c18
max r0.y, r3, c18.x
add r0.z, r3.x, -r0.y
min r3.y, -r0.x, c18
mad r0.y, r0.z, c14.x, r0
mul o3.y, r0, c18.z
mad r0.y, r0.w, c19.x, c19
max o4.z, r0.y, c18.x
mad r0.y, r2.w, c19.x, c19
mad r0.x, r0, c19, c19.y
max r3.x, r3.y, c18
dp3_sat r2.x, r2, -c15
add r2.x, r2, -r3
mad r0.z, r2.x, c14.x, r3.x
mul o3.x, r0.z, c18.z
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
max o4.y, r0, c18.x
max o4.x, r0, c18
mov o2.xyz, v4.w
mov o1.xy, v3
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 10 vars
Float 92 [_TranslucencyViewDependency]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
BindCB "UnityTerrainImposter" 3
// 71 instructions, 4 temp regs, 0 temp arrays:
// ALU 65 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedlkejbhhcjobgiedjfcbiphbaekenfgpdabaaaaaaeaalaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaiaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcheajaaaaeaaaabaafnacaaaafjaaaaaeegiocaaaaaaaaaaa
agaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafjaaaaaeegiocaaaadaaaaaaadaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadicbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
aeaaaaaaapaaaaaibcaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
aiaaaaaaapaaaaaiccaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
ajaaaaaaapaaaaaiecaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
akaaaaaaapaaaaaiicaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
alaaaaaaaaaaaaaibcaabaaaabaaaaaadkbabaiambaaaaaaabaaaaaaabeaaaaa
aaaaiadpdcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
egbobaaaaaaaaaaadiaaaaaipcaabaaaacaaaaaafgafbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaa
dgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaadgaaaaafhccabaaaacaaaaaa
pgbpbaaaafaaaaaadiaaaaajocaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
agijcaaaacaaaaaabbaaaaaadcaaaaalocaabaaaabaaaaaaagijcaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaafgaobaaaabaaaaaadcaaaaalocaabaaa
abaaaaaaagijcaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaafgaobaaa
abaaaaaaaaaaaaaiocaabaaaabaaaaaafgaobaaaabaaaaaaagijcaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaaaaaaaaajgahbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahocaabaaaabaaaaaapgapbaaaaaaaaaaaagajbaaaaaaaaaaabacaaaaj
bcaabaaaacaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaaaaaaaaa
baaaaaaiicaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaalaaaaaa
baaaaaaibcaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaa
baaaaaaiccaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaajaaaaaa
baaaaaaiecaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaakaaaaaa
bbaaaaahccaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaeeaaaaaf
ccaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakocaabaaaacaaaaaaagajbaaa
adaaaaaafgafbaaaacaaaaaaagbjbaiaebaaaaaaacaaaaaadcaaaaajocaabaaa
acaaaaaaagaabaaaabaaaaaafgaobaaaacaaaaaaagbjbaaaacaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaaaaaaaaadgcaaaag
bcaabaaaadaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaahbccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaaakaabaaaadaaaaaaaaaaaaah
bccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabacaaaajbcaabaaa
abaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaabaaaaaabacaaaaj
ccaabaaaabaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaacaaaaaa
baaaaaaiecaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaabaaaaaa
dgcaaaagicaabaaaabaaaaaackaabaiaebaaaaaaabaaaaaadcaaaaajecaabaaa
abaaaaaackaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaah
cccabaaaaeaaaaaackaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaadcaaaaakbcaabaaa
abaaaaaadkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaadkaabaaaabaaaaaa
aaaaaaahcccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaacaaaaaadgcaaaag
ecaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaaheccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
ckaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaackaabaaaabaaaaaaaaaaaaah
eccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaadaaaaaaaaaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaajgahbaaaacaaaaaa
egacbaaaabaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egiccaaaadaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgapbaaaaaaaaaaaegiccaaaadaaaaaaacaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
cccabaaaafaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaaaaaaaaa
deaaaaaheccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  mediump float gloss_6;
  mediump float specular_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_9;
  x_9 = (tmpvar_8.w - _Cutoff);
  if ((x_9 < 0.0)) {
    discard;
  };
  lowp float tmpvar_10;
  tmpvar_10 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_7 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  gloss_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_13;
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1) * 0.5);
  ambient_5 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (xlv_TEXCOORD2 * tmpvar_11.z);
  backContribs_3 = tmpvar_15;
  light_2 = (ambient_5 * tmpvar_8.xyz);
  mediump float nh_16;
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[0].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD3.x;
  nl_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = xlv_TEXCOORD4.x;
  nh_16 = tmpvar_21;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_17)) + (_SpecColor.xyz * (pow (nh_16, specular_7) * gloss_6))) * lightColor_18));
  mediump float nh_22;
  mediump float nl_23;
  mediump vec3 lightColor_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = _TerrainTreeLightColors[1].xyz;
  lightColor_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = xlv_TEXCOORD3.y;
  nl_23 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = xlv_TEXCOORD4.y;
  nh_22 = tmpvar_27;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_23)) + (_SpecColor.xyz * (pow (nh_22, specular_7) * gloss_6))) * lightColor_24));
  mediump float nh_28;
  mediump float nl_29;
  mediump vec3 lightColor_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = _TerrainTreeLightColors[2].xyz;
  lightColor_30 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = xlv_TEXCOORD3.z;
  nl_29 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = xlv_TEXCOORD4.z;
  nh_28 = tmpvar_33;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_29)) + (_SpecColor.xyz * (pow (nh_28, specular_7) * gloss_6))) * lightColor_30));
  mediump vec3 tmpvar_34;
  tmpvar_34 = (light_2 * 2.0);
  c_1.xyz = tmpvar_34;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  mediump float gloss_6;
  mediump float specular_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_9;
  x_9 = (tmpvar_8.w - _Cutoff);
  if ((x_9 < 0.0)) {
    discard;
  };
  lowp float tmpvar_10;
  tmpvar_10 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_7 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_12;
  tmpvar_12 = tmpvar_11.w;
  gloss_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_13;
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_14;
  tmpvar_14 = (((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1) * 0.5);
  ambient_5 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = (xlv_TEXCOORD2 * tmpvar_11.z);
  backContribs_3 = tmpvar_15;
  light_2 = (ambient_5 * tmpvar_8.xyz);
  mediump float nh_16;
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[0].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD3.x;
  nl_17 = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = xlv_TEXCOORD4.x;
  nh_16 = tmpvar_21;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_17)) + (_SpecColor.xyz * (pow (nh_16, specular_7) * gloss_6))) * lightColor_18));
  mediump float nh_22;
  mediump float nl_23;
  mediump vec3 lightColor_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = _TerrainTreeLightColors[1].xyz;
  lightColor_24 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = xlv_TEXCOORD3.y;
  nl_23 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = xlv_TEXCOORD4.y;
  nh_22 = tmpvar_27;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_23)) + (_SpecColor.xyz * (pow (nh_22, specular_7) * gloss_6))) * lightColor_24));
  mediump float nh_28;
  mediump float nl_29;
  mediump vec3 lightColor_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = _TerrainTreeLightColors[2].xyz;
  lightColor_30 = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = xlv_TEXCOORD3.z;
  nl_29 = tmpvar_32;
  highp float tmpvar_33;
  tmpvar_33 = xlv_TEXCOORD4.z;
  nh_28 = tmpvar_33;
  light_2 = (light_2 + (((tmpvar_8.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_29)) + (_SpecColor.xyz * (pow (nh_28, specular_7) * gloss_6))) * lightColor_30));
  mediump vec3 tmpvar_34;
  tmpvar_34 = (light_2 * 2.0);
  c_1.xyz = tmpvar_34;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 ExposureIBL;
#line 656
#line 514
void ExpandBillboard( in highp mat4 mat, inout highp vec4 pos, inout highp vec3 normal, inout highp vec4 tangent ) {
    highp float isBillboard = (1.0 - abs(tangent.w));
    #line 517
    highp vec3 norb = vec3( normalize((vec4( normal, 0.0) * mat)));
    highp vec3 tanb = vec3( normalize((vec4( tangent.xyz, 0.0) * mat)));
    pos += ((vec4( normal.xy, 0.0, 0.0) * mat) * isBillboard);
    normal = mix( normal, norb, vec3( isBillboard));
    #line 521
    tangent = mix( tangent, vec4( tanb, -1.0), vec4( isBillboard));
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 625
v2f vert( in appdata_full v ) {
    #line 627
    v2f o;
    ExpandBillboard( glstate_matrix_invtrans_modelview0, v.vertex, v.normal, v.tangent);
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    #line 631
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 636
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        mediump float backContrib = xll_saturate_f(dot( viewDir, (-lightDir)));
        backContrib = mix( xll_saturate_f((-nl)), backContrib, _TranslucencyViewDependency);
        #line 640
        o.backContrib[j] = (backContrib * 2.0);
        nl = max( 0.0, ((nl * 0.6) + 0.4));
        o.nl[j] = nl;
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 644
        highp float nh = max( 0.0, dot( v.normal, h));
        o.nh[j] = nh;
    }
    o.color = vec3( v.color.w);
    #line 648
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec3 xlv_TEXCOORD5;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uv);
    xlv_TEXCOORD1 = vec3(xl_retval.color);
    xlv_TEXCOORD2 = vec3(xl_retval.backContrib);
    xlv_TEXCOORD3 = vec3(xl_retval.nl);
    xlv_TEXCOORD4 = vec3(xl_retval.nh);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
void xll_clip_f(float x) {
  if ( x<0.0 ) discard;
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform samplerCube _DiffCubeIBL;
uniform highp vec4 ExposureIBL;
#line 656
#line 656
lowp vec4 frag( in v2f i ) {
    lowp vec4 col = texture( _MainTex, i.uv);
    xll_clip_f((col.w - _Cutoff));
    #line 660
    lowp vec3 albedo = col.xyz;
    mediump float specular = (texture( _BumpSpecMap, i.uv).x * 128.0);
    lowp vec4 trngls = texture( _TranslucencyMap, i.uv);
    mediump float gloss = trngls.w;
    #line 664
    mediump vec3 ambient;
    mediump vec4 diff_ibl = texture( _DiffCubeIBL, i.normal);
    diff_ibl.xyz = (diff_ibl.xyz * diff_ibl.w);
    ambient = (((diff_ibl.xyz * ExposureIBL.x) * i.color) * 0.5);
    #line 668
    mediump vec3 backContribs = (i.backContrib * trngls.z);
    mediump vec3 light = (ambient * albedo);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 674
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump vec3 translucencyColor = (backContribs[j] * _TranslucencyColor);
        mediump float nl = i.nl[j];
        mediump float nh = i.nh[j];
        #line 678
        mediump float spec = (pow( nh, specular) * gloss);
        light += (((albedo * (translucencyColor + nl)) + (_SpecColor.xyz * spec)) * lightColor);
    }
    lowp vec4 c;
    #line 682
    c.xyz = (light * 2.0);
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.backContrib = vec3(xlv_TEXCOORD2);
    xlt_i.nl = vec3(xlv_TEXCOORD3);
    xlt_i.nh = vec3(xlv_TEXCOORD4);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 13 [_WorldSpaceCameraPos]
Matrix 9 [_World2Object]
Vector 14 [unity_Scale]
Float 15 [_TranslucencyViewDependency]
Vector 16 [_TerrainTreeLightDirections0]
Vector 17 [_TerrainTreeLightDirections1]
Vector 18 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 79 ALU
PARAM c[20] = { { 0, 1, 2, 0.60009766 },
		state.matrix.mvp,
		state.matrix.modelview[0].invtrans,
		program.local[9..18],
		{ 0.39990234 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0, vertex.normal.y, c[6];
MAD R1, vertex.normal.x, c[5], R0;
ABS R2.x, vertex.attrib[14].w;
ADD R3.w, -R2.x, c[0].y;
ADD R0, R1, c[0].x;
MAD R0, R0, R3.w, vertex.position;
MAD R1, vertex.normal.z, c[7], R1;
ADD R1, R1, c[0].x;
DP4 R1.w, R1, R1;
RSQ R1.w, R1.w;
MAD R1.xyz, R1.w, R1, -vertex.normal;
MAD R1.xyz, R3.w, R1, vertex.normal;
MOV R2.w, c[0].y;
MOV R2.xyz, c[13];
DP4 R3.z, R2, c[11];
DP4 R3.y, R2, c[10];
DP4 R3.x, R2, c[9];
MAD R2.xyz, R3, c[14].w, -R0;
DP3 R2.w, R2, R2;
RSQ R2.w, R2.w;
MUL R2.xyz, R2.w, R2;
ADD R3.xyz, R2, c[18];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R1.w, R1, R3;
ADD R4.xyz, R2, c[17];
DP3 R2.w, R4, R4;
MAX result.texcoord[4].z, R1.w, c[0].x;
RSQ R1.w, R2.w;
ADD R3.xyz, R2, c[16];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R3;
DP3 R3.x, R1, R3;
DP3 R2.w, R2, -c[18];
MUL R4.xyz, R1.w, R4;
DP3 R1.w, R1, R4;
MAX result.texcoord[4].y, R1.w, c[0].x;
DP3 R1.w, R1, c[18];
MIN R3.w, -R1, c[0].y;
MIN R2.w, R2, c[0].y;
MAX result.texcoord[4].x, R3, c[0];
DP3 R3.x, R2, -c[17];
MIN R3.y, R3.x, c[0];
MAX R3.w, R3, c[0].x;
MAX R2.w, R2, c[0].x;
ADD R2.w, R2, -R3;
MAD R2.w, R2, c[15].x, R3;
MUL result.texcoord[2].z, R2.w, c[0];
DP3 R2.w, R1, c[17];
DP3 R1.x, R1, c[16];
DP3 R1.y, R2, -c[16];
MIN R3.z, -R2.w, c[0].y;
MIN R1.z, -R1.x, c[0].y;
MIN R1.y, R1, c[0];
MAX R3.x, R3.z, c[0];
MAX R3.y, R3, c[0].x;
MAX R1.z, R1, c[0].x;
MAX R1.y, R1, c[0].x;
ADD R2.x, R1.y, -R1.z;
MAD R1.z, R2.x, c[15].x, R1;
ADD R3.y, R3, -R3.x;
MAD R1.y, R3, c[15].x, R3.x;
MUL result.texcoord[2].y, R1, c[0].z;
MOV R1.y, c[19].x;
MUL result.texcoord[2].x, R1.z, c[0].z;
MAD R1.z, R1.w, c[0].w, R1.y;
DP4 result.position.w, R0, c[4];
DP4 result.position.z, R0, c[3];
DP4 result.position.y, R0, c[2];
DP4 result.position.x, R0, c[1];
MAD R0.x, R2.w, c[0].w, R1.y;
MAD R0.y, R1.x, c[0].w, R1;
MAX result.texcoord[3].z, R1, c[0].x;
MAX result.texcoord[3].y, R0.x, c[0].x;
MAX result.texcoord[3].x, R0.y, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[0].xy, vertex.texcoord[0];
END
# 79 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [glstate_matrix_invtrans_modelview0]
Vector 12 [_WorldSpaceCameraPos]
Matrix 8 [_World2Object]
Vector 13 [unity_Scale]
Float 14 [_TranslucencyViewDependency]
Vector 15 [_TerrainTreeLightDirections0]
Vector 16 [_TerrainTreeLightDirections1]
Vector 17 [_TerrainTreeLightDirections2]
"vs_3_0
; 72 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c18, 0.00000000, 1.00000000, 2.00000000, 0
def c19, 0.60009766, 0.39990234, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
dcl_color0 v4
abs r1.x, v1.w
mul r0, v2.y, c5
add r3.w, -r1.x, c18.y
mad r0, v2.x, c4, r0
add r1, r0, c18.x
mad r1, r1, r3.w, v0
mad r0, v2.z, c6, r0
add r0, r0, c18.x
dp4 r0.w, r0, r0
mov r2.w, c18.y
mov r2.xyz, c12
dp4 r3.z, r2, c10
dp4 r3.y, r2, c9
dp4 r3.x, r2, c8
mad r2.xyz, r3, c13.w, -r1
dp3 r2.w, r2, r2
rsq r2.w, r2.w
mul r2.xyz, r2.w, r2
add r3.xyz, r2, c17
dp3 r2.w, r3, r3
rsq r2.w, r2.w
mul r3.xyz, r2.w, r3
rsq r2.w, r0.w
add r4.xyz, r2, c16
mad r0.xyz, r2.w, r0, -v2
mad r0.xyz, r3.w, r0, v2
dp3 r2.w, r0, r3
dp3 r0.w, r4, r4
rsq r0.w, r0.w
mul r3.xyz, r0.w, r4
dp3 r0.w, r0, r3
max o5.y, r0.w, c18.x
dp3 r0.w, r0, c17
add r3.xyz, r2, c15
max o5.z, r2.w, c18.x
dp3 r2.w, r3, r3
rsq r3.w, r2.w
mul r3.xyz, r3.w, r3
dp3 r3.x, r0, r3
min r2.w, -r0, c18.y
max r3.w, r2, c18.x
dp3_sat r2.w, r2, -c17
add r2.w, r2, -r3
mad r2.w, r2, c14.x, r3
max o5.x, r3, c18
dp3_sat r3.x, r2, -c16
mul o3.z, r2.w, c18
dp3 r2.w, r0, c16
dp3 r0.x, r0, c15
min r3.y, -r2.w, c18
max r0.y, r3, c18.x
add r0.z, r3.x, -r0.y
min r3.y, -r0.x, c18
mad r0.y, r0.z, c14.x, r0
mul o3.y, r0, c18.z
mad r0.y, r0.w, c19.x, c19
max o4.z, r0.y, c18.x
mad r0.y, r2.w, c19.x, c19
mad r0.x, r0, c19, c19.y
max r3.x, r3.y, c18
dp3_sat r2.x, r2, -c15
add r2.x, r2, -r3
mad r0.z, r2.x, c14.x, r3.x
mul o3.x, r0.z, c18.z
dp4 o0.w, r1, c3
dp4 o0.z, r1, c2
dp4 o0.y, r1, c1
dp4 o0.x, r1, c0
max o4.y, r0, c18.x
max o4.x, r0, c18
mov o2.xyz, v4.w
mov o1.xy, v3
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "$Globals" 128 // 96 used size, 10 vars
Float 92 [_TranslucencyViewDependency]
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 128 [glstate_matrix_invtrans_modelview0] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
BindCB "UnityTerrainImposter" 3
// 71 instructions, 4 temp regs, 0 temp arrays:
// ALU 65 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedlkejbhhcjobgiedjfcbiphbaekenfgpdabaaaaaaeaalaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaiaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
ahaiaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahaiaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaahaiaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahapaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcheajaaaaeaaaabaafnacaaaafjaaaaaeegiocaaaaaaaaaaa
agaaaaaafjaaaaaeegiocaaaabaaaaaaafaaaaaafjaaaaaeegiocaaaacaaaaaa
bfaaaaaafjaaaaaeegiocaaaadaaaaaaadaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadicbabaaaabaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaaddcbabaaa
adaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaaabaaaaaa
gfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaadhccabaaa
adaaaaaagfaaaaadhccabaaaaeaaaaaagfaaaaadhccabaaaafaaaaaagiaaaaac
aeaaaaaaapaaaaaibcaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
aiaaaaaaapaaaaaiccaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
ajaaaaaaapaaaaaiecaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
akaaaaaaapaaaaaiicaabaaaaaaaaaaaegbabaaaacaaaaaaegiacaaaacaaaaaa
alaaaaaaaaaaaaaibcaabaaaabaaaaaadkbabaiambaaaaaaabaaaaaaabeaaaaa
aaaaiadpdcaaaaajpcaabaaaaaaaaaaaegaobaaaaaaaaaaaagaabaaaabaaaaaa
egbobaaaaaaaaaaadiaaaaaipcaabaaaacaaaaaafgafbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaaacaaaaaaaaaaaaaa
agaabaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpcaabaaaacaaaaaaegiocaaa
acaaaaaaacaaaaaakgakbaaaaaaaaaaaegaobaaaacaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgapbaaaaaaaaaaaegaobaaaacaaaaaa
dgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaadgaaaaafhccabaaaacaaaaaa
pgbpbaaaafaaaaaadiaaaaajocaabaaaabaaaaaafgifcaaaabaaaaaaaeaaaaaa
agijcaaaacaaaaaabbaaaaaadcaaaaalocaabaaaabaaaaaaagijcaaaacaaaaaa
baaaaaaaagiacaaaabaaaaaaaeaaaaaafgaobaaaabaaaaaadcaaaaalocaabaaa
abaaaaaaagijcaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaafgaobaaa
abaaaaaaaaaaaaaiocaabaaaabaaaaaafgaobaaaabaaaaaaagijcaaaacaaaaaa
bdaaaaaadcaaaaalhcaabaaaaaaaaaaajgahbaaaabaaaaaapgipcaaaacaaaaaa
beaaaaaaegacbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaa
aaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
diaaaaahocaabaaaabaaaaaapgapbaaaaaaaaaaaagajbaaaaaaaaaaabacaaaaj
bcaabaaaacaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaaaaaaaaa
baaaaaaiicaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaalaaaaaa
baaaaaaibcaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaaiaaaaaa
baaaaaaiccaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaajaaaaaa
baaaaaaiecaabaaaadaaaaaaegbcbaaaacaaaaaaegiccaaaacaaaaaaakaaaaaa
bbaaaaahccaabaaaacaaaaaaegaobaaaadaaaaaaegaobaaaadaaaaaaeeaaaaaf
ccaabaaaacaaaaaabkaabaaaacaaaaaadcaaaaakocaabaaaacaaaaaaagajbaaa
adaaaaaafgafbaaaacaaaaaaagbjbaiaebaaaaaaacaaaaaadcaaaaajocaabaaa
acaaaaaaagaabaaaabaaaaaafgaobaaaacaaaaaaagbjbaaaacaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaaaaaaaaadgcaaaag
bcaabaaaadaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaahbccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
akaabaaaacaaaaaaakaabaiaebaaaaaaadaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaaakaabaaaadaaaaaaaaaaaaah
bccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabacaaaajbcaabaaa
abaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaabaaaaaabacaaaaj
ccaabaaaabaaaaaajgahbaaaabaaaaaaegiccaiaebaaaaaaadaaaaaaacaaaaaa
baaaaaaiecaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaabaaaaaa
dgcaaaagicaabaaaabaaaaaackaabaiaebaaaaaaabaaaaaadcaaaaajecaabaaa
abaaaaaackaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaah
cccabaaaaeaaaaaackaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaa
abaaaaaadkaabaiaebaaaaaaabaaaaaaakaabaaaabaaaaaadcaaaaakbcaabaaa
abaaaaaadkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaadkaabaaaabaaaaaa
aaaaaaahcccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaabaaaaaai
bcaabaaaabaaaaaajgahbaaaacaaaaaaegiccaaaadaaaaaaacaaaaaadgcaaaag
ecaabaaaabaaaaaaakaabaiaebaaaaaaabaaaaaadcaaaaajbcaabaaaabaaaaaa
akaabaaaabaaaaaaabeaaaaajkjjbjdpabeaaaaamnmmmmdodeaaaaaheccabaaa
aeaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaaaaaaaaaibcaabaaaabaaaaaa
ckaabaiaebaaaaaaabaaaaaabkaabaaaabaaaaaadcaaaaakbcaabaaaabaaaaaa
dkiacaaaaaaaaaaaafaaaaaaakaabaaaabaaaaaackaabaaaabaaaaaaaaaaaaah
eccabaaaadaaaaaaakaabaaaabaaaaaaakaabaaaabaaaaaadcaaaaakhcaabaaa
abaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaadaaaaaaaaaaaaaa
baaaaaahicaabaaaabaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaf
icaabaaaabaaaaaadkaabaaaabaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaa
abaaaaaaegacbaaaabaaaaaabaaaaaahbcaabaaaabaaaaaajgahbaaaacaaaaaa
egacbaaaabaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaa
egiccaaaadaaaaaaabaaaaaadcaaaaakhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgapbaaaaaaaaaaaegiccaaaadaaaaaaacaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaabaaaaaapgapbaaaaaaaaaaaegacbaaaabaaaaaa
baaaaaahicaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaabaaaaaadeaaaaah
cccabaaaafaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaa
aaaaaaaabaaaaaahbcaabaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaaaaaaaaa
deaaaaaheccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec3 ambient_4;
  mediump float gloss_5;
  mediump float specular_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_8;
  x_8 = (tmpvar_7.w - _Cutoff);
  if ((x_8 < 0.0)) {
    discard;
  };
  lowp float tmpvar_9;
  tmpvar_9 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_6 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  gloss_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1);
  ambient_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD2 * tmpvar_10.z);
  backContribs_3 = tmpvar_13;
  light_2 = (ambient_4 * tmpvar_7.xyz);
  mediump float nh_14;
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[0].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD3.x;
  nl_15 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = xlv_TEXCOORD4.x;
  nh_14 = tmpvar_19;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_15)) + (_SpecColor.xyz * (pow (nh_14, specular_6) * gloss_5))) * lightColor_16));
  mediump float nh_20;
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[1].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD3.y;
  nl_21 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = xlv_TEXCOORD4.y;
  nh_20 = tmpvar_25;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_21)) + (_SpecColor.xyz * (pow (nh_20, specular_6) * gloss_5))) * lightColor_22));
  mediump float nh_26;
  mediump float nl_27;
  mediump vec3 lightColor_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = _TerrainTreeLightColors[2].xyz;
  lightColor_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = xlv_TEXCOORD3.z;
  nl_27 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = xlv_TEXCOORD4.z;
  nh_26 = tmpvar_31;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_27)) + (_SpecColor.xyz * (pow (nh_26, specular_6) * gloss_5))) * lightColor_28));
  mediump vec3 tmpvar_32;
  tmpvar_32 = (light_2 * 2.0);
  c_1.xyz = tmpvar_32;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform lowp float _TranslucencyViewDependency;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesColor;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize(_glesNormal);
  highp vec3 viewDir_2;
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  highp vec3 tmpvar_7;
  highp float tmpvar_8;
  tmpvar_8 = (1.0 - abs(_glesTANGENT.w));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(0.0, 0.0);
  tmpvar_10.xy = tmpvar_1.xy;
  highp vec4 tmpvar_11;
  tmpvar_11 = (_glesVertex + ((tmpvar_10 * glstate_matrix_invtrans_modelview0) * tmpvar_8));
  highp vec3 tmpvar_12;
  tmpvar_12 = mix (tmpvar_1, normalize((tmpvar_9 * glstate_matrix_invtrans_modelview0)).xyz, vec3(tmpvar_8));
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_13).xyz * unity_Scale.w) - tmpvar_11.xyz));
  mediump vec3 h_14;
  mediump float backContrib_15;
  mediump float nl_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightDirections[0];
  highp float tmpvar_18;
  tmpvar_18 = dot (tmpvar_12, tmpvar_17);
  nl_16 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (dot (viewDir_2, -(tmpvar_17)), 0.0, 1.0);
  backContrib_15 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = mix (clamp (-(nl_16), 0.0, 1.0), backContrib_15, _TranslucencyViewDependency);
  backContrib_15 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * 2.0);
  tmpvar_4.x = tmpvar_21;
  mediump float tmpvar_22;
  tmpvar_22 = max (0.0, ((nl_16 * 0.6) + 0.4));
  nl_16 = tmpvar_22;
  tmpvar_5.x = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_17 + viewDir_2));
  h_14 = tmpvar_23;
  tmpvar_6.x = max (0.0, dot (tmpvar_12, h_14));
  mediump vec3 h_24;
  mediump float backContrib_25;
  mediump float nl_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = _TerrainTreeLightDirections[1];
  highp float tmpvar_28;
  tmpvar_28 = dot (tmpvar_12, tmpvar_27);
  nl_26 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp (dot (viewDir_2, -(tmpvar_27)), 0.0, 1.0);
  backContrib_25 = tmpvar_29;
  mediump float tmpvar_30;
  tmpvar_30 = mix (clamp (-(nl_26), 0.0, 1.0), backContrib_25, _TranslucencyViewDependency);
  backContrib_25 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * 2.0);
  tmpvar_4.y = tmpvar_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.0, ((nl_26 * 0.6) + 0.4));
  nl_26 = tmpvar_32;
  tmpvar_5.y = tmpvar_32;
  highp vec3 tmpvar_33;
  tmpvar_33 = normalize((tmpvar_27 + viewDir_2));
  h_24 = tmpvar_33;
  tmpvar_6.y = max (0.0, dot (tmpvar_12, h_24));
  mediump vec3 h_34;
  mediump float backContrib_35;
  mediump float nl_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = _TerrainTreeLightDirections[2];
  highp float tmpvar_38;
  tmpvar_38 = dot (tmpvar_12, tmpvar_37);
  nl_36 = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = clamp (dot (viewDir_2, -(tmpvar_37)), 0.0, 1.0);
  backContrib_35 = tmpvar_39;
  mediump float tmpvar_40;
  tmpvar_40 = mix (clamp (-(nl_36), 0.0, 1.0), backContrib_35, _TranslucencyViewDependency);
  backContrib_35 = tmpvar_40;
  mediump float tmpvar_41;
  tmpvar_41 = (tmpvar_40 * 2.0);
  tmpvar_4.z = tmpvar_41;
  mediump float tmpvar_42;
  tmpvar_42 = max (0.0, ((nl_36 * 0.6) + 0.4));
  nl_36 = tmpvar_42;
  tmpvar_5.z = tmpvar_42;
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_37 + viewDir_2));
  h_34 = tmpvar_43;
  tmpvar_6.z = max (0.0, dot (tmpvar_12, h_34));
  lowp vec3 tmpvar_44;
  tmpvar_44 = _glesColor.www;
  tmpvar_3 = tmpvar_44;
  gl_Position = (glstate_matrix_mvp * tmpvar_11);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform lowp float _Cutoff;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform lowp vec3 _TranslucencyColor;
uniform lowp vec4 _SpecColor;
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 light_2;
  mediump vec3 backContribs_3;
  mediump vec3 ambient_4;
  mediump float gloss_5;
  mediump float specular_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float x_8;
  x_8 = (tmpvar_7.w - _Cutoff);
  if ((x_8 < 0.0)) {
    discard;
  };
  lowp float tmpvar_9;
  tmpvar_9 = (texture2D (_BumpSpecMap, xlv_TEXCOORD0).x * 128.0);
  specular_6 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_TranslucencyMap, xlv_TEXCOORD0);
  lowp float tmpvar_11;
  tmpvar_11 = tmpvar_10.w;
  gloss_5 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1);
  ambient_4 = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD2 * tmpvar_10.z);
  backContribs_3 = tmpvar_13;
  light_2 = (ambient_4 * tmpvar_7.xyz);
  mediump float nh_14;
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[0].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD3.x;
  nl_15 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = xlv_TEXCOORD4.x;
  nh_14 = tmpvar_19;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.x * _TranslucencyColor) + nl_15)) + (_SpecColor.xyz * (pow (nh_14, specular_6) * gloss_5))) * lightColor_16));
  mediump float nh_20;
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[1].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD3.y;
  nl_21 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = xlv_TEXCOORD4.y;
  nh_20 = tmpvar_25;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.y * _TranslucencyColor) + nl_21)) + (_SpecColor.xyz * (pow (nh_20, specular_6) * gloss_5))) * lightColor_22));
  mediump float nh_26;
  mediump float nl_27;
  mediump vec3 lightColor_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = _TerrainTreeLightColors[2].xyz;
  lightColor_28 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = xlv_TEXCOORD3.z;
  nl_27 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = xlv_TEXCOORD4.z;
  nh_26 = tmpvar_31;
  light_2 = (light_2 + (((tmpvar_7.xyz * ((backContribs_3.z * _TranslucencyColor) + nl_27)) + (_SpecColor.xyz * (pow (nh_26, specular_6) * gloss_5))) * lightColor_28));
  mediump vec3 tmpvar_32;
  tmpvar_32 = (light_2 * 2.0);
  c_1.xyz = tmpvar_32;
  c_1.w = 1.0;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "gles3 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES3#version 300 es


#ifdef VERTEX

#define gl_Vertex _glesVertex
in vec4 _glesVertex;
#define gl_Color _glesColor
in vec4 _glesColor;
#define gl_Normal (normalize(_glesNormal))
in vec3 _glesNormal;
#define gl_MultiTexCoord0 _glesMultiTexCoord0
in vec4 _glesMultiTexCoord0;
#define gl_MultiTexCoord1 _glesMultiTexCoord1
in vec4 _glesMultiTexCoord1;
#define TANGENT vec4(normalize(_glesTANGENT.xyz), _glesTANGENT.w)
in vec4 _glesTANGENT;
float xll_saturate_f( float x) {
  return clamp( x, 0.0, 1.0);
}
vec2 xll_saturate_vf2( vec2 x) {
  return clamp( x, 0.0, 1.0);
}
vec3 xll_saturate_vf3( vec3 x) {
  return clamp( x, 0.0, 1.0);
}
vec4 xll_saturate_vf4( vec4 x) {
  return clamp( x, 0.0, 1.0);
}
mat2 xll_saturate_mf2x2(mat2 m) {
  return mat2( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0));
}
mat3 xll_saturate_mf3x3(mat3 m) {
  return mat3( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0));
}
mat4 xll_saturate_mf4x4(mat4 m) {
  return mat4( clamp(m[0], 0.0, 1.0), clamp(m[1], 0.0, 1.0), clamp(m[2], 0.0, 1.0), clamp(m[3], 0.0, 1.0));
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform highp vec4 ExposureIBL;
#line 514
void ExpandBillboard( in highp mat4 mat, inout highp vec4 pos, inout highp vec3 normal, inout highp vec4 tangent ) {
    highp float isBillboard = (1.0 - abs(tangent.w));
    #line 517
    highp vec3 norb = vec3( normalize((vec4( normal, 0.0) * mat)));
    highp vec3 tanb = vec3( normalize((vec4( tangent.xyz, 0.0) * mat)));
    pos += ((vec4( normal.xy, 0.0, 0.0) * mat) * isBillboard);
    normal = mix( normal, norb, vec3( isBillboard));
    #line 521
    tangent = mix( tangent, vec4( tanb, -1.0), vec4( isBillboard));
}
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 625
v2f vert( in appdata_full v ) {
    #line 627
    v2f o;
    ExpandBillboard( glstate_matrix_invtrans_modelview0, v.vertex, v.normal, v.tangent);
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    #line 631
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 636
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        mediump float backContrib = xll_saturate_f(dot( viewDir, (-lightDir)));
        backContrib = mix( xll_saturate_f((-nl)), backContrib, _TranslucencyViewDependency);
        #line 640
        o.backContrib[j] = (backContrib * 2.0);
        nl = max( 0.0, ((nl * 0.6) + 0.4));
        o.nl[j] = nl;
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 644
        highp float nh = max( 0.0, dot( v.normal, h));
        o.nh[j] = nh;
    }
    o.color = vec3( v.color.w);
    #line 648
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec3 xlv_TEXCOORD2;
out highp vec3 xlv_TEXCOORD3;
out highp vec3 xlv_TEXCOORD4;
out highp vec3 xlv_TEXCOORD5;
void main() {
    v2f xl_retval;
    appdata_full xlt_v;
    xlt_v.vertex = vec4(gl_Vertex);
    xlt_v.tangent = vec4(TANGENT);
    xlt_v.normal = vec3(gl_Normal);
    xlt_v.texcoord = vec4(gl_MultiTexCoord0);
    xlt_v.texcoord1 = vec4(gl_MultiTexCoord1);
    xlt_v.color = vec4(gl_Color);
    xl_retval = vert( xlt_v);
    gl_Position = vec4(xl_retval.pos);
    xlv_TEXCOORD0 = vec2(xl_retval.uv);
    xlv_TEXCOORD1 = vec3(xl_retval.color);
    xlv_TEXCOORD2 = vec3(xl_retval.backContrib);
    xlv_TEXCOORD3 = vec3(xl_retval.nl);
    xlv_TEXCOORD4 = vec3(xl_retval.nh);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];
void xll_clip_f(float x) {
  if ( x<0.0 ) discard;
}
#line 151
struct v2f_vertex_lit {
    highp vec2 uv;
    lowp vec4 diff;
    lowp vec4 spec;
};
#line 187
struct v2f_img {
    highp vec4 pos;
    mediump vec2 uv;
};
#line 181
struct appdata_img {
    highp vec4 vertex;
    mediump vec2 texcoord;
};
#line 315
struct SurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 67
struct appdata_full {
    highp vec4 vertex;
    highp vec4 tangent;
    highp vec3 normal;
    highp vec4 texcoord;
    highp vec4 texcoord1;
    lowp vec4 color;
};
#line 585
struct LeafSurfaceOutput {
    lowp vec3 Albedo;
    lowp vec3 Normal;
    lowp vec3 Emission;
    lowp float Translucency;
    mediump float Specular;
    lowp float Gloss;
    lowp float Alpha;
};
#line 612
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec3 backContrib;
    highp vec3 nl;
    highp vec3 nh;
    highp vec3 normal;
};
uniform highp vec4 _Time;
uniform highp vec4 _SinTime;
#line 3
uniform highp vec4 _CosTime;
uniform highp vec4 unity_DeltaTime;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
#line 7
uniform highp vec4 _ScreenParams;
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_CameraWorldClipPlanes[6];
uniform highp vec4 _WorldSpaceLightPos0;
#line 11
uniform highp vec4 _LightPositionRange;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosZ0;
#line 15
uniform highp vec4 unity_4LightAtten0;
uniform highp vec4 unity_LightColor[8];
uniform highp vec4 unity_LightPosition[8];
uniform highp vec4 unity_LightAtten[8];
#line 19
uniform highp vec4 unity_SpotDirection[8];
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
#line 23
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHC;
#line 27
uniform highp vec3 unity_LightColor0;
uniform highp vec3 unity_LightColor1;
uniform highp vec3 unity_LightColor2;
uniform highp vec3 unity_LightColor3;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp vec4 unity_LightShadowBias;
#line 31
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 _LightShadowData;
#line 35
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp mat4 glstate_matrix_mvp;
uniform highp mat4 glstate_matrix_modelview0;
uniform highp mat4 glstate_matrix_invtrans_modelview0;
#line 39
uniform highp mat4 _Object2World;
uniform highp mat4 _World2Object;
uniform highp vec4 unity_Scale;
uniform highp mat4 glstate_matrix_transpose_modelview0;
#line 43
uniform highp mat4 glstate_matrix_texture0;
uniform highp mat4 glstate_matrix_texture1;
uniform highp mat4 glstate_matrix_texture2;
uniform highp mat4 glstate_matrix_texture3;
#line 47
uniform highp mat4 glstate_matrix_projection;
uniform highp vec4 glstate_lightmodel_ambient;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
#line 51
uniform lowp vec4 unity_ColorSpaceGrey;
#line 77
#line 82
#line 87
#line 91
#line 96
#line 120
#line 137
#line 158
#line 166
#line 193
#line 206
#line 215
#line 220
#line 229
#line 234
#line 243
#line 260
#line 265
#line 291
#line 299
#line 307
#line 311
#line 325
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _SpecColor;
#line 338
#line 346
#line 360
uniform lowp vec4 _WavingTint;
uniform highp vec4 _WaveAndDistance;
#line 393
uniform highp vec4 _CameraPosition;
uniform highp vec3 _CameraRight;
uniform highp vec3 _CameraUp;
uniform highp vec4 _Scale;
uniform highp mat4 _TerrainEngineBendTree;
#line 397
uniform highp vec4 _SquashPlaneNormal;
uniform highp float _SquashAmount;
uniform highp vec3 _TreeBillboardCameraRight;
uniform highp vec4 _TreeBillboardCameraUp;
#line 401
uniform highp vec4 _TreeBillboardCameraFront;
uniform highp vec4 _TreeBillboardCameraPos;
uniform highp vec4 _TreeBillboardDistances;
#line 421
#line 469
#line 487
#line 501
#line 513
uniform highp vec4 _Wind;
#line 581
uniform lowp vec4 _Color;
uniform lowp vec3 _TranslucencyColor;
uniform lowp float _TranslucencyViewDependency;
uniform mediump float _ShadowStrength;
#line 596
#line 623
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
uniform sampler2D _BumpSpecMap;
#line 652
uniform sampler2D _TranslucencyMap;
uniform lowp float _Cutoff;
uniform highp vec4 ExposureIBL;
#line 655
lowp vec4 frag( in v2f i ) {
    #line 657
    lowp vec4 col = texture( _MainTex, i.uv);
    xll_clip_f((col.w - _Cutoff));
    lowp vec3 albedo = col.xyz;
    mediump float specular = (texture( _BumpSpecMap, i.uv).x * 128.0);
    #line 661
    lowp vec4 trngls = texture( _TranslucencyMap, i.uv);
    mediump float gloss = trngls.w;
    mediump vec3 ambient;
    ambient = (vec3( glstate_lightmodel_ambient) * i.color);
    #line 665
    mediump vec3 backContribs = (i.backContrib * trngls.z);
    mediump vec3 light = (ambient * albedo);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 671
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump vec3 translucencyColor = (backContribs[j] * _TranslucencyColor);
        mediump float nl = i.nl[j];
        mediump float nh = i.nh[j];
        #line 675
        mediump float spec = (pow( nh, specular) * gloss);
        light += (((albedo * (translucencyColor + nl)) + (_SpecColor.xyz * spec)) * lightColor);
    }
    lowp vec4 c;
    #line 679
    c.xyz = (light * 2.0);
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec3 xlv_TEXCOORD2;
in highp vec3 xlv_TEXCOORD3;
in highp vec3 xlv_TEXCOORD4;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.backContrib = vec3(xlv_TEXCOORD2);
    xlt_i.nl = vec3(xlv_TEXCOORD3);
    xlt_i.nh = vec3(xlv_TEXCOORD4);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 8
//   opengl - ALU: 29 to 46, TEX: 3 to 4
//   d3d9 - ALU: 35 to 85, TEX: 4 to 5
//   d3d11 - ALU: 20 to 29, TEX: 3 to 4, FLOW: 2 to 2
SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Vector 0 [_SpecColor]
Vector 1 [_TranslucencyColor]
Vector 2 [_TerrainTreeLightColors0]
Vector 3 [_TerrainTreeLightColors1]
Vector 4 [_TerrainTreeLightColors2]
Float 5 [_Cutoff]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"3.0-!!ARBfp1.0
# 46 ALU, 4 TEX
PARAM c[9] = { program.local[0..6],
		{ 1, 0.30541992, 0.68212891, 0.012519836 },
		{ 0.5, 128, 0.45458984, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[5], texture[3], CUBE;
TEX R2.zw, fragment.texcoord[0], texture[2], 2D;
MUL R4.xyz, fragment.texcoord[2], R2.z;
MAD R1.x, R0.w, c[7].y, c[7].z;
MAD R1.x, R0.w, R1, c[7].w;
MUL R0.w, R0, R1.x;
MUL R1.xyz, R0, R0.w;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R2.x, fragment.texcoord[0], texture[1], 2D;
MUL R1.w, R2.x, c[8].y;
POW R2.x, fragment.texcoord[4].x, R1.w;
MUL R2.x, R2.w, R2;
SLT R0.w, R0, c[5].x;
MOV R3.w, c[8].z;
MUL R1.xyz, R1, c[6].x;
MUL R2.xyz, R2.x, c[0];
MAD R3.xyz, R4.x, c[1], fragment.texcoord[3].x;
MAD R3.xyz, R0, R3, R2;
MUL R2.xyz, R1, fragment.texcoord[1];
MUL R2.xyz, R2, c[8].x;
POW R1.x, c[2].x, R3.w;
POW R1.z, c[2].z, R3.w;
POW R1.y, c[2].y, R3.w;
MUL R1.xyz, R3, R1;
POW R3.x, fragment.texcoord[4].y, R1.w;
MAD R1.xyz, R0, R2, R1;
MUL R2.x, R2.w, R3;
POW R1.w, fragment.texcoord[4].z, R1.w;
MAD R3.xyz, R4.y, c[1], fragment.texcoord[3].y;
MUL R2.xyz, R2.x, c[0];
MAD R2.xyz, R0, R3, R2;
POW R3.x, c[3].x, R3.w;
POW R3.y, c[3].y, R3.w;
POW R3.z, c[3].z, R3.w;
MAD R2.xyz, R2, R3, R1;
MUL R1.w, R2, R1;
MUL R1.xyz, R1.w, c[0];
MAD R3.xyz, R4.z, c[1], fragment.texcoord[3].z;
MAD R0.xyz, R0, R3, R1;
POW R1.x, c[4].x, R3.w;
POW R1.y, c[4].y, R3.w;
POW R1.z, c[4].z, R3.w;
MAD R0.xyz, R0, R1, R2;
MUL result.color.xyz, R0, c[8].w;
KIL -R0.w;
MOV result.color.w, c[7].x;
END
# 46 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Vector 0 [_SpecColor]
Vector 1 [_TranslucencyColor]
Vector 2 [_TerrainTreeLightColors0]
Vector 3 [_TerrainTreeLightColors1]
Vector 4 [_TerrainTreeLightColors2]
Float 5 [_Cutoff]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"ps_3_0
; 85 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c7, 0.00000000, 1.00000000, 128.00000000, 0.01251984
def c8, 0.30541992, 0.68212891, 0.50000000, 0.45458984
def c9, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r4.zw, v0, s2
mul r5.xyz, v2, r4.z
mad_pp r2.xyz, r5.x, c1, v3.x
texld r0.x, v0, s1
mul r5.w, r0.x, c7.z
pow_pp r0, v4.x, r5.w
mul_pp r0.x, r4.w, r0
texld r1, v0, s0
mul_pp r0.xyz, r0.x, c0
mad_pp r4.xyz, r1, r2, r0
texld r2, v5, s3
mov_pp r3.x, c8.w
pow_pp r0, c2.x, r3.x
mad_pp r3.y, r2.w, c8.x, c8
mad_pp r0.y, r2.w, r3, c7.w
mul_pp r2.w, r2, r0.y
mul_pp r2.xyz, r2, r2.w
mul r2.xyz, r2, c6.x
mov_pp r6.x, r0
mov_pp r3.x, c8.w
pow_pp r0, c2.z, r3.x
mov_pp r6.z, r0
pow_pp r0, v4.y, r5.w
mov_pp r0.w, r0.x
mul r2.xyz, r2, v1
mov_pp r5.x, c8.w
pow_pp r3, c2.y, r5.x
mov_pp r6.y, r3
mul_pp r3.xyz, r4, r6
mul r0.xyz, r2, c8.z
mad_pp r2.xyz, r1, r0, r3
mul_pp r0.w, r4, r0
mul_pp r0.xyz, r0.w, c0
mad_pp r3.xyz, r5.y, c1, v3.y
mad_pp r4.xyz, r1, r3, r0
pow_pp r0, v4.z, r5.w
mov_pp r0.y, c8.w
mul_pp r2.w, r4, r0.x
pow_pp r3, c3.x, r0.y
mov_pp r6.x, r3
mov_pp r0.x, c8.w
pow_pp r3, c3.y, r0.x
mov_pp r4.w, c8
pow_pp r0, c3.z, r4.w
mov_pp r6.y, r3
mov_pp r6.z, r0
mad_pp r0.xyz, r4, r6, r2
mul_pp r2.xyz, r2.w, c0
mad_pp r3.xyz, r5.z, c1, v3.z
mad_pp r2.xyz, r1, r3, r2
mov_pp r0.w, c8
pow_pp r3, c4.x, r0.w
add_pp r0.w, r1, -c5.x
cmp r4.w, r0, c7.x, c7.y
mov_pp r2.w, c8
pow_pp r1, c4.z, r2.w
mov_pp r4.x, r3
mov_pp r0.w, c8
pow_pp r3, c4.y, r0.w
mov_pp r4.y, r3
mov_pp r4.z, r1
mad_pp r1.xyz, r2, r4, r0
mov_pp r0, -r4.w
mul_pp oC0.xyz, r1, c9.x
texkill r0.xyzw
mov_pp oC0.w, c7.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
ConstBuffer "$Globals" 128 // 128 used size, 10 vars
Vector 32 [_SpecColor] 4
Vector 80 [_TranslucencyColor] 3
Float 100 [_Cutoff]
Vector 112 [ExposureIBL] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpSpecMap] 2D 1
SetTexture 2 [_TranslucencyMap] 2D 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
// 41 instructions, 7 temp regs, 0 temp arrays:
// ALU 27 float, 2 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedfgjainpfkcepjmcokfmpmpliimbnmhipabaaaaaanmagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckeafaaaaeaaaaaaagjabaaaa
dfbiaaaabcaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaiadpfjaaaaaeegiocaaaaaaaaaaaaiaaaaaafjaiaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
hcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacahaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaajicaabaaa
aaaaaaaadkaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaaagaaaaaadbaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaanaaaeaddkaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaedefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbcbaaaagaaaaaaeghobaaa
adaaaaaaaagabaaaadaaaaaadcaaaaajbcaabaaaabaaaaaadkaabaaaacaaaaaa
abeaaaaabcfbjmdoabeaaaaamekccodpdcaaaaajbcaabaaaabaaaaaadkaabaaa
acaaaaaaakaabaaaabaaaaaaabeaaaaamccmendmdiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaa
agiacaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaa
egbcbaaaacaaaaaadiaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaa
abaaaaaaegbcbaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadgaaaaafhcaabaaaadaaaaaaegacbaaaacaaaaaadgaaaaaf
icaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahicaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaaadaaaaaaadaaaeaddkaabaaaadaaaaaacpaaaaai
hcaabaaaaeaaaaaaegiccaagabaaaaaaaeaaaaaadkaabaaaacaaaaaadiaaaaak
hcaabaaaaeaaaaaaegacbaaaaeaaaaaaaceaaaaacplkoidocplkoidocplkoido
aaaaaaaabjaaaaafhcaabaaaaeaaaaaaegacbaaaaeaaaaaabaaaaaaiicaabaaa
adaaaaaaegacbaaaabaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaaiicaabaaa
aeaaaaaaegbcbaaaaeaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaaibcaabaaa
afaaaaaaegbcbaaaafaaaaaaegjcjaaadkaabaaaacaaaaaacpaaaaafbcaabaaa
afaaaaaaakaabaaaafaaaaaadiaaaaahbcaabaaaafaaaaaadkaabaaaaaaaaaaa
akaabaaaafaaaaaabjaaaaafbcaabaaaafaaaaaaakaabaaaafaaaaaadiaaaaah
bcaabaaaafaaaaaadkaabaaaabaaaaaaakaabaaaafaaaaaadcaaaaakocaabaaa
afaaaaaapgapbaaaadaaaaaaagijcaaaaaaaaaaaafaaaaaapgapbaaaaeaaaaaa
diaaaaaihcaabaaaagaaaaaaagaabaaaafaaaaaaegiccaaaaaaaaaaaacaaaaaa
dcaaaaajhcaabaaaafaaaaaaegacbaaaaaaaaaaajgahbaaaafaaaaaaegacbaaa
agaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaafaaaaaaegacbaaaaeaaaaaa
egacbaaaadaaaaaaboaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
abaaaaaabgaaaaabaaaaaaahhccabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Vector 1 [_SpecColor]
Vector 2 [_TranslucencyColor]
Vector 3 [_TerrainTreeLightColors0]
Vector 4 [_TerrainTreeLightColors1]
Vector 5 [_TerrainTreeLightColors2]
Float 6 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
"3.0-!!ARBfp1.0
# 39 ALU, 3 TEX
PARAM c[8] = { state.lightmodel.ambient,
		program.local[1..6],
		{ 1, 128, 0.45458984, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.zw, fragment.texcoord[0], texture[2], 2D;
MUL R4.xyz, fragment.texcoord[2], R1.z;
TEX R1.x, fragment.texcoord[0], texture[1], 2D;
MUL R3.w, R1.x, c[7].y;
POW R1.x, fragment.texcoord[4].y, R3.w;
POW R2.w, fragment.texcoord[4].x, R3.w;
MUL R1.x, R1.w, R1;
SLT R0.w, R0, c[6].x;
MUL R1.xyz, R1.x, c[1];
MAD R2.xyz, R4.y, c[2], fragment.texcoord[3].y;
MAD R3.xyz, R0, R2, R1;
MUL R1.x, R1.w, R2.w;
POW R3.w, fragment.texcoord[4].z, R3.w;
MOV R2.w, c[7].z;
MUL R1.xyz, R1.x, c[1];
MAD R2.xyz, R4.x, c[2], fragment.texcoord[3].x;
MAD R2.xyz, R0, R2, R1;
POW R1.x, c[3].x, R2.w;
POW R1.z, c[3].z, R2.w;
POW R1.y, c[3].y, R2.w;
MUL R2.xyz, R2, R1;
MUL R1.xyz, fragment.texcoord[1], c[0];
MAD R1.xyz, R0, R1, R2;
MUL R1.w, R1, R3;
POW R2.x, c[4].x, R2.w;
POW R2.y, c[4].y, R2.w;
POW R2.z, c[4].z, R2.w;
MAD R2.xyz, R3, R2, R1;
MUL R1.xyz, R1.w, c[1];
MAD R3.xyz, R4.z, c[2], fragment.texcoord[3].z;
MAD R0.xyz, R0, R3, R1;
POW R1.x, c[5].x, R2.w;
POW R1.y, c[5].y, R2.w;
POW R1.z, c[5].z, R2.w;
MAD R0.xyz, R0, R1, R2;
MUL result.color.xyz, R0, c[7].w;
KIL -R0.w;
MOV result.color.w, c[7].x;
END
# 39 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_SpecColor]
Vector 2 [_TranslucencyColor]
Vector 3 [_TerrainTreeLightColors0]
Vector 4 [_TerrainTreeLightColors1]
Vector 5 [_TerrainTreeLightColors2]
Float 6 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
"ps_3_0
; 80 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, 0.00000000, 1.00000000, 128.00000000, 0.45458984
def c8, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
texld r0.x, v0, s1
mul r2.w, r0.x, c7.z
texld r0, v0, s0
pow_pp r1, v4.y, r2.w
texld r1.zw, v0, s2
mul r3.xyz, v2, r1.z
mad_pp r2.xyz, r3.y, c2, v3.y
pow_pp r4, v4.x, r2.w
mul_pp r1.x, r1.w, r1
mul_pp r1.xyz, r1.x, c1
mad_pp r1.xyz, r0, r2, r1
mov_pp r2.x, r4
mov_pp r2.y, c7.w
pow_pp r4, c3.x, r2.y
mul_pp r2.x, r1.w, r2
add_pp r0.w, r0, -c6.x
mad_pp r5.xyz, r3.x, c2, v3.x
mul_pp r2.xyz, r2.x, c1
mad_pp r2.xyz, r0, r5, r2
mov_pp r3.w, c7
pow_pp r5, c3.y, r3.w
mov_pp r3.x, r4
mov_pp r3.y, c7.w
pow_pp r4, c3.z, r3.y
mov_pp r3.w, r4.z
mov_pp r3.y, r5
pow_pp r5, v4.z, r2.w
mul_pp r2.xyz, r2, r3.xyww
mul r4.xyz, v1, c0
mad_pp r2.xyz, r0, r4, r2
mov_pp r2.w, c7
pow_pp r4, c4.x, r2.w
mov_pp r2.w, r5.x
mul_pp r1.w, r1, r2
mov_pp r2.w, c7
pow_pp r5, c4.z, r2.w
mov_pp r3.x, r4
mov_pp r3.y, c7.w
pow_pp r4, c4.y, r3.y
mov_pp r3.y, r4
mov_pp r3.w, r5.z
mad_pp r1.xyz, r1, r3.xyww, r2
mul_pp r2.xyz, r1.w, c1
mad_pp r3.xyz, r3.z, c2, v3.z
mad_pp r0.xyz, r0, r3, r2
mov_pp r1.w, c7
pow_pp r2, c5.x, r1.w
mov_pp r4.x, r2
mov_pp r3.x, c7.w
pow_pp r2, c5.y, r3.x
mov_pp r1.w, c7
pow_pp r3, c5.z, r1.w
cmp r0.w, r0, c7.x, c7.y
mov_pp r4.y, r2
mov_pp r4.z, r3
mad_pp r0.xyz, r0, r4, r1
mov_pp r1, -r0.w
mul_pp oC0.xyz, r0, c8.x
texkill r1.xyzw
mov_pp oC0.w, c7.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
ConstBuffer "$Globals" 128 // 104 used size, 10 vars
Vector 32 [_SpecColor] 4
Vector 80 [_TranslucencyColor] 3
Float 100 [_Cutoff]
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityPerFrame" 1
BindCB "UnityTerrainImposter" 2
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpSpecMap] 2D 1
SetTexture 2 [_TranslucencyMap] 2D 2
// 34 instructions, 7 temp regs, 0 temp arrays:
// ALU 21 float, 2 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedppigchlbcdmjojaedlihkhefoildghobabaaaaaanmafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefckeaeaaaaeaaaaaaacjabaaaa
dfbiaaaabcaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaiadpfjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaiaaaeegiocaaaacaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaad
hcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacahaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaajicaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaa
agaaaaaadbaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
anaaaeaddkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaaedefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegbcbaaa
acaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaa
abaaaaaaegbcbaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadgaaaaafhcaabaaaadaaaaaaegacbaaaacaaaaaadgaaaaaf
icaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahicaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaaadaaaaaaadaaaeaddkaabaaaadaaaaaacpaaaaai
hcaabaaaaeaaaaaaegiccaagacaaaaaaaeaaaaaadkaabaaaacaaaaaadiaaaaak
hcaabaaaaeaaaaaaegacbaaaaeaaaaaaaceaaaaacplkoidocplkoidocplkoido
aaaaaaaabjaaaaafhcaabaaaaeaaaaaaegacbaaaaeaaaaaabaaaaaaiicaabaaa
adaaaaaaegacbaaaabaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaaiicaabaaa
aeaaaaaaegbcbaaaaeaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaaibcaabaaa
afaaaaaaegbcbaaaafaaaaaaegjcjaaadkaabaaaacaaaaaacpaaaaafbcaabaaa
afaaaaaaakaabaaaafaaaaaadiaaaaahbcaabaaaafaaaaaadkaabaaaaaaaaaaa
akaabaaaafaaaaaabjaaaaafbcaabaaaafaaaaaaakaabaaaafaaaaaadiaaaaah
bcaabaaaafaaaaaadkaabaaaabaaaaaaakaabaaaafaaaaaadcaaaaakocaabaaa
afaaaaaapgapbaaaadaaaaaaagijcaaaaaaaaaaaafaaaaaapgapbaaaaeaaaaaa
diaaaaaihcaabaaaagaaaaaaagaabaaaafaaaaaaegiccaaaaaaaaaaaacaaaaaa
dcaaaaajhcaabaaaafaaaaaaegacbaaaaaaaaaaajgahbaaaafaaaaaaegacbaaa
agaaaaaadcaaaaajhcaabaaaadaaaaaaegacbaaaafaaaaaaegacbaaaaeaaaaaa
egacbaaaadaaaaaaboaaaaahicaabaaaacaaaaaadkaabaaaacaaaaaaabeaaaaa
abaaaaaabgaaaaabaaaaaaahhccabaaaaaaaaaaaegacbaaaadaaaaaaegacbaaa
adaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Vector 0 [_SpecColor]
Vector 1 [_TranslucencyColor]
Vector 2 [_TerrainTreeLightColors0]
Vector 3 [_TerrainTreeLightColors1]
Vector 4 [_TerrainTreeLightColors2]
Float 5 [_Cutoff]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"3.0-!!ARBfp1.0
# 36 ALU, 4 TEX
PARAM c[9] = { program.local[0..6],
		{ 1, 0.30541992, 0.68212891, 0.012519836 },
		{ 0.5, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[5], texture[3], CUBE;
MAD R1.x, R0.w, c[7].y, c[7].z;
MAD R1.x, R0.w, R1, c[7].w;
MUL R0.w, R0, R1.x;
MUL R1.xyz, R0, R0.w;
TEX R0.x, fragment.texcoord[0], texture[1], 2D;
MUL R1.w, R0.x, c[8].y;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1.xyz, R1, c[6].x;
MUL R1.xyz, R1, fragment.texcoord[1];
SLT R0.w, R0, c[5].x;
TEX R2.zw, fragment.texcoord[0], texture[2], 2D;
POW R2.x, fragment.texcoord[4].x, R1.w;
MUL R3.x, R2.w, R2;
MUL R2.xyz, fragment.texcoord[2], R2.z;
MAD R4.xyz, R2.x, c[1], fragment.texcoord[3].x;
POW R2.x, fragment.texcoord[4].y, R1.w;
MUL R3.xyz, R3.x, c[0];
MAD R3.xyz, R0, R4, R3;
POW R1.w, fragment.texcoord[4].z, R1.w;
MUL R3.xyz, R3, c[2];
MUL R1.xyz, R1, c[8].x;
MAD R1.xyz, R0, R1, R3;
MUL R2.x, R2.w, R2;
MAD R4.xyz, R2.y, c[1], fragment.texcoord[3].y;
MUL R3.xyz, R2.x, c[0];
MAD R3.xyz, R0, R4, R3;
MAD R3.xyz, R3, c[3], R1;
MUL R1.w, R2, R1;
MUL R1.xyz, R1.w, c[0];
MAD R2.xyz, R2.z, c[1], fragment.texcoord[3].z;
MAD R0.xyz, R0, R2, R1;
MAD R0.xyz, R0, c[4], R3;
MUL result.color.xyz, R0, c[8].z;
KIL -R0.w;
MOV result.color.w, c[7].x;
END
# 36 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Vector 0 [_SpecColor]
Vector 1 [_TranslucencyColor]
Vector 2 [_TerrainTreeLightColors0]
Vector 3 [_TerrainTreeLightColors1]
Vector 4 [_TerrainTreeLightColors2]
Float 5 [_Cutoff]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"ps_3_0
; 42 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c7, 0.00000000, 1.00000000, 128.00000000, 0.01251984
def c8, 0.30541992, 0.68212891, 0.50000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r0, v5, s3
mad_pp r1.y, r0.w, c8.x, c8
mad_pp r1.y, r0.w, r1, c7.w
mul_pp r0.w, r0, r1.y
mul_pp r0.xyz, r0, r0.w
texld r1.x, v0, s1
mul r3.w, r1.x, c7.z
pow_pp r2, v4.x, r3.w
texld r2.zw, v0, s2
mul r4.xyz, v2, r2.z
mov_pp r0.w, r2.x
mul_pp r0.w, r2, r0
texld r1, v0, s0
mul_pp r2.xyz, r0.w, c0
mad_pp r3.xyz, r4.x, c1, v3.x
mad_pp r2.xyz, r1, r3, r2
mul_pp r3.xyz, r2, c2
mul r0.xyz, r0, c6.x
mul r2.xyz, r0, v1
pow_pp r0, v4.y, r3.w
mul r2.xyz, r2, c8.z
mad_pp r2.xyz, r1, r2, r3
mov_pp r3.x, r0
pow_pp r0, v4.z, r3.w
mul_pp r0.y, r2.w, r3.x
mul_pp r3.xyz, r0.y, c0
mad_pp r0.yzw, r4.y, c1.xxyz, v3.y
mad_pp r3.xyz, r1, r0.yzww, r3
mov_pp r0.w, r0.x
mad_pp r0.xyz, r3, c3, r2
mul_pp r2.x, r2.w, r0.w
add_pp r0.w, r1, -c5.x
mul_pp r2.xyz, r2.x, c0
mad_pp r3.xyz, r4.z, c1, v3.z
mad_pp r1.xyz, r1, r3, r2
mad_pp r1.xyz, r1, c4, r0
cmp r0.w, r0, c7.x, c7.y
mov_pp r0, -r0.w
mul_pp oC0.xyz, r1, c8.w
texkill r0.xyzw
mov_pp oC0.w, c7.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
ConstBuffer "$Globals" 128 // 128 used size, 10 vars
Vector 32 [_SpecColor] 4
Vector 80 [_TranslucencyColor] 3
Float 100 [_Cutoff]
Vector 112 [ExposureIBL] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpSpecMap] 2D 1
SetTexture 2 [_TranslucencyMap] 2D 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
// 38 instructions, 6 temp regs, 0 temp arrays:
// ALU 24 float, 2 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedabojecfkkbhclkcbnbdgejgejblmiilcabaaaaaaimagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfeafaaaaeaaaaaaaffabaaaa
dfbiaaaabcaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaiadpfjaaaaaeegiocaaaaaaaaaaaaiaaaaaafjaiaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
hcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaajicaabaaa
aaaaaaaadkaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaaagaaaaaadbaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaanaaaeaddkaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaedefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbcbaaaagaaaaaaeghobaaa
adaaaaaaaagabaaaadaaaaaadcaaaaajbcaabaaaabaaaaaadkaabaaaacaaaaaa
abeaaaaabcfbjmdoabeaaaaamekccodpdcaaaaajbcaabaaaabaaaaaadkaabaaa
acaaaaaaakaabaaaabaaaaaaabeaaaaamccmendmdiaaaaahbcaabaaaabaaaaaa
akaabaaaabaaaaaadkaabaaaacaaaaaadiaaaaahhcaabaaaacaaaaaaagaabaaa
abaaaaaaegacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaa
agiacaaaaaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaa
egbcbaaaacaaaaaadiaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaa
aaaaaadpaaaaaadpaaaaaadpaaaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaa
abaaaaaaegbcbaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadgaaaaafhcaabaaaadaaaaaaegacbaaaacaaaaaadgaaaaaf
icaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahicaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaaadaaaaaaadaaaeaddkaabaaaadaaaaaabaaaaaai
icaabaaaadaaaaaaegacbaaaabaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaai
bcaabaaaaeaaaaaaegbcbaaaaeaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaai
ccaabaaaaeaaaaaaegbcbaaaafaaaaaaegjcjaaadkaabaaaacaaaaaacpaaaaaf
ccaabaaaaeaaaaaabkaabaaaaeaaaaaadiaaaaahccaabaaaaeaaaaaadkaabaaa
aaaaaaaabkaabaaaaeaaaaaabjaaaaafccaabaaaaeaaaaaabkaabaaaaeaaaaaa
diaaaaahccaabaaaaeaaaaaadkaabaaaabaaaaaabkaabaaaaeaaaaaadcaaaaak
ncaabaaaaeaaaaaapgapbaaaadaaaaaaagijcaaaaaaaaaaaafaaaaaaagaabaaa
aeaaaaaadiaaaaaihcaabaaaafaaaaaafgafbaaaaeaaaaaaegiccaaaaaaaaaaa
acaaaaaadcaaaaajhcaabaaaaeaaaaaaegacbaaaaaaaaaaaigadbaaaaeaaaaaa
egacbaaaafaaaaaadcaaaaamhcaabaaaadaaaaaaegacbaaaaeaaaaaaegiccaag
abaaaaaaaeaaaaaadkaabaaaacaaaaaaegacbaaaadaaaaaaboaaaaahicaabaaa
acaaaaaadkaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaabaaaaaaahhccabaaa
aaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Vector 1 [_SpecColor]
Vector 2 [_TranslucencyColor]
Vector 3 [_TerrainTreeLightColors0]
Vector 4 [_TerrainTreeLightColors1]
Vector 5 [_TerrainTreeLightColors2]
Float 6 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
"3.0-!!ARBfp1.0
# 29 ALU, 3 TEX
PARAM c[8] = { state.lightmodel.ambient,
		program.local[1..6],
		{ 1, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.x, fragment.texcoord[0], texture[1], 2D;
MUL R3.w, R1.x, c[7].y;
TEX R2.zw, fragment.texcoord[0], texture[2], 2D;
MUL R1.xyw, fragment.texcoord[2].xyzz, R2.z;
SLT R0.w, R0, c[6].x;
POW R1.z, fragment.texcoord[4].x, R3.w;
MAD R3.xyz, R1.x, c[2], fragment.texcoord[3].x;
MUL R1.x, R2.w, R1.z;
POW R1.z, fragment.texcoord[4].y, R3.w;
MUL R2.xyz, R1.x, c[1];
MAD R2.xyz, R0, R3, R2;
MUL R1.x, R2.w, R1.z;
MUL R3.xyz, R1.x, c[1];
MAD R1.xyz, R1.y, c[2], fragment.texcoord[3].y;
MAD R3.xyz, R0, R1, R3;
POW R3.w, fragment.texcoord[4].z, R3.w;
MUL R2.xyz, R2, c[3];
MUL R1.xyz, fragment.texcoord[1], c[0];
MAD R1.xyz, R0, R1, R2;
MAD R2.xyz, R3, c[4], R1;
MUL R2.w, R2, R3;
MUL R1.xyz, R2.w, c[1];
MAD R3.xyz, R1.w, c[2], fragment.texcoord[3].z;
MAD R0.xyz, R0, R3, R1;
MAD R0.xyz, R0, c[5], R2;
MUL result.color.xyz, R0, c[7].z;
KIL -R0.w;
MOV result.color.w, c[7].x;
END
# 29 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_SpecColor]
Vector 2 [_TranslucencyColor]
Vector 3 [_TerrainTreeLightColors0]
Vector 4 [_TerrainTreeLightColors1]
Vector 5 [_TerrainTreeLightColors2]
Float 6 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
"ps_3_0
; 35 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, 0.00000000, 1.00000000, 128.00000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
texld r3.zw, v0, s2
mul r2.xyw, v2.xyzz, r3.z
texld r0.x, v0, s1
mul r4.x, r0, c7.z
pow_pp r0, v4.y, r4.x
pow_pp r1, v4.x, r4.x
mov_pp r0.y, r1.x
mad_pp r3.xyz, r2.y, c2, v3.y
texld r1, v0, s0
mul_pp r0.w, r3, r0.y
mul_pp r0.x, r3.w, r0
mul_pp r0.xyz, r0.x, c1
mad_pp r3.xyz, r1, r3, r0
mul_pp r0.xyz, r0.w, c1
mad_pp r2.xyz, r2.x, c2, v3.x
mad_pp r2.xyz, r1, r2, r0
pow_pp r0, v4.z, r4.x
mul_pp r0.yzw, r2.xxyz, c3.xxyz
mul r2.xyz, v1, c0
mad_pp r2.xyz, r1, r2, r0.yzww
mov_pp r0.w, r0.x
mad_pp r0.xyz, r3, c4, r2
mul_pp r2.x, r3.w, r0.w
add_pp r0.w, r1, -c6.x
mul_pp r2.xyz, r2.x, c1
mad_pp r3.xyz, r2.w, c2, v3.z
mad_pp r1.xyz, r1, r3, r2
mad_pp r1.xyz, r1, c5, r0
cmp r0.w, r0, c7.x, c7.y
mov_pp r0, -r0.w
mul_pp oC0.xyz, r1, c7.w
texkill r0.xyzw
mov_pp oC0.w, c7.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
ConstBuffer "$Globals" 128 // 104 used size, 10 vars
Vector 32 [_SpecColor] 4
Vector 80 [_TranslucencyColor] 3
Float 100 [_Cutoff]
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityPerFrame" 1
BindCB "UnityTerrainImposter" 2
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpSpecMap] 2D 1
SetTexture 2 [_TranslucencyMap] 2D 2
// 31 instructions, 6 temp regs, 0 temp arrays:
// ALU 18 float, 2 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedcljallcjikcondfokbfflomnnimojjlmabaaaaaaimafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfeaeaaaaeaaaaaaabfabaaaa
dfbiaaaabcaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaiadpfjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaiaaaeegiocaaaacaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaad
hcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaajicaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaa
agaaaaaadbaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
anaaaeaddkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaaedefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegbcbaaa
acaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaa
abaaaaaaegbcbaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadgaaaaafhcaabaaaadaaaaaaegacbaaaacaaaaaadgaaaaaf
icaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahicaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaaadaaaaaaadaaaeaddkaabaaaadaaaaaabaaaaaai
icaabaaaadaaaaaaegacbaaaabaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaai
bcaabaaaaeaaaaaaegbcbaaaaeaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaai
ccaabaaaaeaaaaaaegbcbaaaafaaaaaaegjcjaaadkaabaaaacaaaaaacpaaaaaf
ccaabaaaaeaaaaaabkaabaaaaeaaaaaadiaaaaahccaabaaaaeaaaaaadkaabaaa
aaaaaaaabkaabaaaaeaaaaaabjaaaaafccaabaaaaeaaaaaabkaabaaaaeaaaaaa
diaaaaahccaabaaaaeaaaaaadkaabaaaabaaaaaabkaabaaaaeaaaaaadcaaaaak
ncaabaaaaeaaaaaapgapbaaaadaaaaaaagijcaaaaaaaaaaaafaaaaaaagaabaaa
aeaaaaaadiaaaaaihcaabaaaafaaaaaafgafbaaaaeaaaaaaegiccaaaaaaaaaaa
acaaaaaadcaaaaajhcaabaaaaeaaaaaaegacbaaaaaaaaaaaigadbaaaaeaaaaaa
egacbaaaafaaaaaadcaaaaamhcaabaaaadaaaaaaegacbaaaaeaaaaaaegiccaag
acaaaaaaaeaaaaaadkaabaaaacaaaaaaegacbaaaadaaaaaaboaaaaahicaabaaa
acaaaaaadkaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaabaaaaaaahhccabaaa
aaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Vector 0 [_SpecColor]
Vector 1 [_TranslucencyColor]
Vector 2 [_TerrainTreeLightColors0]
Vector 3 [_TerrainTreeLightColors1]
Vector 4 [_TerrainTreeLightColors2]
Float 5 [_Cutoff]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"3.0-!!ARBfp1.0
# 33 ALU, 4 TEX
PARAM c[8] = { program.local[0..6],
		{ 1, 0.5, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[5], texture[3], CUBE;
MUL R1.xyz, R0, R0.w;
TEX R0.x, fragment.texcoord[0], texture[1], 2D;
MUL R1.w, R0.x, c[7].z;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1.xyz, R1, c[6].x;
MUL R1.xyz, R1, fragment.texcoord[1];
SLT R0.w, R0, c[5].x;
TEX R2.zw, fragment.texcoord[0], texture[2], 2D;
POW R2.x, fragment.texcoord[4].x, R1.w;
MUL R3.x, R2.w, R2;
MUL R2.xyz, fragment.texcoord[2], R2.z;
MAD R4.xyz, R2.x, c[1], fragment.texcoord[3].x;
POW R2.x, fragment.texcoord[4].y, R1.w;
MUL R3.xyz, R3.x, c[0];
MAD R3.xyz, R0, R4, R3;
POW R1.w, fragment.texcoord[4].z, R1.w;
MUL R3.xyz, R3, c[2];
MUL R1.xyz, R1, c[7].y;
MAD R1.xyz, R0, R1, R3;
MUL R2.x, R2.w, R2;
MAD R4.xyz, R2.y, c[1], fragment.texcoord[3].y;
MUL R3.xyz, R2.x, c[0];
MAD R3.xyz, R0, R4, R3;
MAD R3.xyz, R3, c[3], R1;
MUL R1.w, R2, R1;
MUL R1.xyz, R1.w, c[0];
MAD R2.xyz, R2.z, c[1], fragment.texcoord[3].z;
MAD R0.xyz, R0, R2, R1;
MAD R0.xyz, R0, c[4], R3;
MUL result.color.xyz, R0, c[7].w;
KIL -R0.w;
MOV result.color.w, c[7].x;
END
# 33 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Vector 0 [_SpecColor]
Vector 1 [_TranslucencyColor]
Vector 2 [_TerrainTreeLightColors0]
Vector 3 [_TerrainTreeLightColors1]
Vector 4 [_TerrainTreeLightColors2]
Float 5 [_Cutoff]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"ps_3_0
; 38 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c7, 0.00000000, 1.00000000, 128.00000000, 0.50000000
def c8, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r0.x, v0, s1
mul r3.w, r0.x, c7.z
texld r0, v0, s0
pow_pp r2, v4.x, r3.w
texld r2.zw, v0, s2
mul_pp r3.x, r2.w, r2
mul r2.xyz, v2, r2.z
texld r1, v5, s3
mad_pp r4.xyz, r2.x, c1, v3.x
mul_pp r3.xyz, r3.x, c0
mad_pp r3.xyz, r0, r4, r3
mul_pp r4.xyz, r3, c2
mul_pp r1.xyz, r1, r1.w
mul r3.xyz, r1, c6.x
pow_pp r1, v4.y, r3.w
mov_pp r2.x, r1
pow_pp r1, v4.z, r3.w
mul_pp r1.y, r2.w, r2.x
mul r3.xyz, r3, v1
mul r3.xyz, r3, c7.w
mad_pp r3.xyz, r0, r3, r4
mul_pp r4.xyz, r1.y, c0
mad_pp r1.yzw, r2.y, c1.xxyz, v3.y
mad_pp r4.xyz, r0, r1.yzww, r4
mov_pp r1.w, r1.x
mad_pp r1.xyz, r4, c3, r3
mul_pp r1.w, r2, r1
add_pp r0.w, r0, -c5.x
mul_pp r3.xyz, r1.w, c0
mad_pp r2.xyz, r2.z, c1, v3.z
mad_pp r2.xyz, r0, r2, r3
cmp r0.x, r0.w, c7, c7.y
mad_pp r1.xyz, r2, c4, r1
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c8.x
texkill r0.xyzw
mov_pp oC0.w, c7.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
ConstBuffer "$Globals" 128 // 128 used size, 10 vars
Vector 32 [_SpecColor] 4
Vector 80 [_TranslucencyColor] 3
Float 100 [_Cutoff]
Vector 112 [ExposureIBL] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpSpecMap] 2D 1
SetTexture 2 [_TranslucencyMap] 2D 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
// 35 instructions, 6 temp regs, 0 temp arrays:
// ALU 21 float, 2 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedilfipjfdcncohkdkgiaapohdojoklfhcabaaaaaaciagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcpaaeaaaaeaaaaaaadmabaaaa
dfbiaaaabcaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaiadpfjaaaaaeegiocaaaaaaaaaaaaiaaaaaafjaiaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
hcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaajicaabaaa
aaaaaaaadkaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaaagaaaaaadbaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaanaaaeaddkaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaedefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbcbaaaagaaaaaaeghobaaa
adaaaaaaaagabaaaadaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaacaaaaaa
egacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaagiacaaa
aaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbcbaaa
acaaaaaadiaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaabaaaaaa
egbcbaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaadgaaaaafhcaabaaaadaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaa
acaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahicaabaaaadaaaaaadkaabaaa
acaaaaaaabeaaaaaadaaaaaaadaaaeaddkaabaaaadaaaaaabaaaaaaiicaabaaa
adaaaaaaegacbaaaabaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaaibcaabaaa
aeaaaaaaegbcbaaaaeaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaaiccaabaaa
aeaaaaaaegbcbaaaafaaaaaaegjcjaaadkaabaaaacaaaaaacpaaaaafccaabaaa
aeaaaaaabkaabaaaaeaaaaaadiaaaaahccaabaaaaeaaaaaadkaabaaaaaaaaaaa
bkaabaaaaeaaaaaabjaaaaafccaabaaaaeaaaaaabkaabaaaaeaaaaaadiaaaaah
ccaabaaaaeaaaaaadkaabaaaabaaaaaabkaabaaaaeaaaaaadcaaaaakncaabaaa
aeaaaaaapgapbaaaadaaaaaaagijcaaaaaaaaaaaafaaaaaaagaabaaaaeaaaaaa
diaaaaaihcaabaaaafaaaaaafgafbaaaaeaaaaaaegiccaaaaaaaaaaaacaaaaaa
dcaaaaajhcaabaaaaeaaaaaaegacbaaaaaaaaaaaigadbaaaaeaaaaaaegacbaaa
afaaaaaadcaaaaamhcaabaaaadaaaaaaegacbaaaaeaaaaaaegiccaagabaaaaaa
aeaaaaaadkaabaaaacaaaaaaegacbaaaadaaaaaaboaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaabaaaaaaahhccabaaaaaaaaaaa
egacbaaaadaaaaaaegacbaaaadaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Vector 1 [_SpecColor]
Vector 2 [_TranslucencyColor]
Vector 3 [_TerrainTreeLightColors0]
Vector 4 [_TerrainTreeLightColors1]
Vector 5 [_TerrainTreeLightColors2]
Float 6 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
"3.0-!!ARBfp1.0
# 29 ALU, 3 TEX
PARAM c[8] = { state.lightmodel.ambient,
		program.local[1..6],
		{ 1, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.x, fragment.texcoord[0], texture[1], 2D;
MUL R3.w, R1.x, c[7].y;
TEX R2.zw, fragment.texcoord[0], texture[2], 2D;
MUL R1.xyw, fragment.texcoord[2].xyzz, R2.z;
SLT R0.w, R0, c[6].x;
POW R1.z, fragment.texcoord[4].x, R3.w;
MAD R3.xyz, R1.x, c[2], fragment.texcoord[3].x;
MUL R1.x, R2.w, R1.z;
POW R1.z, fragment.texcoord[4].y, R3.w;
MUL R2.xyz, R1.x, c[1];
MAD R2.xyz, R0, R3, R2;
MUL R1.x, R2.w, R1.z;
MUL R3.xyz, R1.x, c[1];
MAD R1.xyz, R1.y, c[2], fragment.texcoord[3].y;
MAD R3.xyz, R0, R1, R3;
POW R3.w, fragment.texcoord[4].z, R3.w;
MUL R2.xyz, R2, c[3];
MUL R1.xyz, fragment.texcoord[1], c[0];
MAD R1.xyz, R0, R1, R2;
MAD R2.xyz, R3, c[4], R1;
MUL R2.w, R2, R3;
MUL R1.xyz, R2.w, c[1];
MAD R3.xyz, R1.w, c[2], fragment.texcoord[3].z;
MAD R0.xyz, R0, R3, R1;
MAD R0.xyz, R0, c[5], R2;
MUL result.color.xyz, R0, c[7].z;
KIL -R0.w;
MOV result.color.w, c[7].x;
END
# 29 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_SpecColor]
Vector 2 [_TranslucencyColor]
Vector 3 [_TerrainTreeLightColors0]
Vector 4 [_TerrainTreeLightColors1]
Vector 5 [_TerrainTreeLightColors2]
Float 6 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
"ps_3_0
; 35 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, 0.00000000, 1.00000000, 128.00000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
texld r3.zw, v0, s2
mul r2.xyw, v2.xyzz, r3.z
texld r0.x, v0, s1
mul r4.x, r0, c7.z
pow_pp r0, v4.y, r4.x
pow_pp r1, v4.x, r4.x
mov_pp r0.y, r1.x
mad_pp r3.xyz, r2.y, c2, v3.y
texld r1, v0, s0
mul_pp r0.w, r3, r0.y
mul_pp r0.x, r3.w, r0
mul_pp r0.xyz, r0.x, c1
mad_pp r3.xyz, r1, r3, r0
mul_pp r0.xyz, r0.w, c1
mad_pp r2.xyz, r2.x, c2, v3.x
mad_pp r2.xyz, r1, r2, r0
pow_pp r0, v4.z, r4.x
mul_pp r0.yzw, r2.xxyz, c3.xxyz
mul r2.xyz, v1, c0
mad_pp r2.xyz, r1, r2, r0.yzww
mov_pp r0.w, r0.x
mad_pp r0.xyz, r3, c4, r2
mul_pp r2.x, r3.w, r0.w
add_pp r0.w, r1, -c6.x
mul_pp r2.xyz, r2.x, c1
mad_pp r3.xyz, r2.w, c2, v3.z
mad_pp r1.xyz, r1, r3, r2
mad_pp r1.xyz, r1, c5, r0
cmp r0.w, r0, c7.x, c7.y
mov_pp r0, -r0.w
mul_pp oC0.xyz, r1, c7.w
texkill r0.xyzw
mov_pp oC0.w, c7.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
ConstBuffer "$Globals" 128 // 104 used size, 10 vars
Vector 32 [_SpecColor] 4
Vector 80 [_TranslucencyColor] 3
Float 100 [_Cutoff]
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityPerFrame" 1
BindCB "UnityTerrainImposter" 2
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpSpecMap] 2D 1
SetTexture 2 [_TranslucencyMap] 2D 2
// 31 instructions, 6 temp regs, 0 temp arrays:
// ALU 18 float, 2 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedcljallcjikcondfokbfflomnnimojjlmabaaaaaaimafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfeaeaaaaeaaaaaaabfabaaaa
dfbiaaaabcaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaiadpfjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaiaaaeegiocaaaacaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaad
hcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaajicaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaa
agaaaaaadbaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
anaaaeaddkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaaedefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegbcbaaa
acaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaa
abaaaaaaegbcbaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadgaaaaafhcaabaaaadaaaaaaegacbaaaacaaaaaadgaaaaaf
icaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahicaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaaadaaaaaaadaaaeaddkaabaaaadaaaaaabaaaaaai
icaabaaaadaaaaaaegacbaaaabaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaai
bcaabaaaaeaaaaaaegbcbaaaaeaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaai
ccaabaaaaeaaaaaaegbcbaaaafaaaaaaegjcjaaadkaabaaaacaaaaaacpaaaaaf
ccaabaaaaeaaaaaabkaabaaaaeaaaaaadiaaaaahccaabaaaaeaaaaaadkaabaaa
aaaaaaaabkaabaaaaeaaaaaabjaaaaafccaabaaaaeaaaaaabkaabaaaaeaaaaaa
diaaaaahccaabaaaaeaaaaaadkaabaaaabaaaaaabkaabaaaaeaaaaaadcaaaaak
ncaabaaaaeaaaaaapgapbaaaadaaaaaaagijcaaaaaaaaaaaafaaaaaaagaabaaa
aeaaaaaadiaaaaaihcaabaaaafaaaaaafgafbaaaaeaaaaaaegiccaaaaaaaaaaa
acaaaaaadcaaaaajhcaabaaaaeaaaaaaegacbaaaaaaaaaaaigadbaaaaeaaaaaa
egacbaaaafaaaaaadcaaaaamhcaabaaaadaaaaaaegacbaaaaeaaaaaaegiccaag
acaaaaaaaeaaaaaadkaabaaaacaaaaaaegacbaaaadaaaaaaboaaaaahicaabaaa
acaaaaaadkaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaabaaaaaaahhccabaaa
aaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Vector 0 [_SpecColor]
Vector 1 [_TranslucencyColor]
Vector 2 [_TerrainTreeLightColors0]
Vector 3 [_TerrainTreeLightColors1]
Vector 4 [_TerrainTreeLightColors2]
Float 5 [_Cutoff]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"3.0-!!ARBfp1.0
# 33 ALU, 4 TEX
PARAM c[8] = { program.local[0..6],
		{ 1, 0.5, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[5], texture[3], CUBE;
MUL R1.xyz, R0, R0.w;
TEX R0.x, fragment.texcoord[0], texture[1], 2D;
MUL R1.w, R0.x, c[7].z;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R1.xyz, R1, c[6].x;
MUL R1.xyz, R1, fragment.texcoord[1];
SLT R0.w, R0, c[5].x;
TEX R2.zw, fragment.texcoord[0], texture[2], 2D;
POW R2.x, fragment.texcoord[4].x, R1.w;
MUL R3.x, R2.w, R2;
MUL R2.xyz, fragment.texcoord[2], R2.z;
MAD R4.xyz, R2.x, c[1], fragment.texcoord[3].x;
POW R2.x, fragment.texcoord[4].y, R1.w;
MUL R3.xyz, R3.x, c[0];
MAD R3.xyz, R0, R4, R3;
POW R1.w, fragment.texcoord[4].z, R1.w;
MUL R3.xyz, R3, c[2];
MUL R1.xyz, R1, c[7].y;
MAD R1.xyz, R0, R1, R3;
MUL R2.x, R2.w, R2;
MAD R4.xyz, R2.y, c[1], fragment.texcoord[3].y;
MUL R3.xyz, R2.x, c[0];
MAD R3.xyz, R0, R4, R3;
MAD R3.xyz, R3, c[3], R1;
MUL R1.w, R2, R1;
MUL R1.xyz, R1.w, c[0];
MAD R2.xyz, R2.z, c[1], fragment.texcoord[3].z;
MAD R0.xyz, R0, R2, R1;
MAD R0.xyz, R0, c[4], R3;
MUL result.color.xyz, R0, c[7].w;
KIL -R0.w;
MOV result.color.w, c[7].x;
END
# 33 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Vector 0 [_SpecColor]
Vector 1 [_TranslucencyColor]
Vector 2 [_TerrainTreeLightColors0]
Vector 3 [_TerrainTreeLightColors1]
Vector 4 [_TerrainTreeLightColors2]
Float 5 [_Cutoff]
Vector 6 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"ps_3_0
; 38 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c7, 0.00000000, 1.00000000, 128.00000000, 0.50000000
def c8, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
texld r0.x, v0, s1
mul r3.w, r0.x, c7.z
texld r0, v0, s0
pow_pp r2, v4.x, r3.w
texld r2.zw, v0, s2
mul_pp r3.x, r2.w, r2
mul r2.xyz, v2, r2.z
texld r1, v5, s3
mad_pp r4.xyz, r2.x, c1, v3.x
mul_pp r3.xyz, r3.x, c0
mad_pp r3.xyz, r0, r4, r3
mul_pp r4.xyz, r3, c2
mul_pp r1.xyz, r1, r1.w
mul r3.xyz, r1, c6.x
pow_pp r1, v4.y, r3.w
mov_pp r2.x, r1
pow_pp r1, v4.z, r3.w
mul_pp r1.y, r2.w, r2.x
mul r3.xyz, r3, v1
mul r3.xyz, r3, c7.w
mad_pp r3.xyz, r0, r3, r4
mul_pp r4.xyz, r1.y, c0
mad_pp r1.yzw, r2.y, c1.xxyz, v3.y
mad_pp r4.xyz, r0, r1.yzww, r4
mov_pp r1.w, r1.x
mad_pp r1.xyz, r4, c3, r3
mul_pp r1.w, r2, r1
add_pp r0.w, r0, -c5.x
mul_pp r3.xyz, r1.w, c0
mad_pp r2.xyz, r2.z, c1, v3.z
mad_pp r2.xyz, r0, r2, r3
cmp r0.x, r0.w, c7, c7.y
mad_pp r1.xyz, r2, c4, r1
mov_pp r0, -r0.x
mul_pp oC0.xyz, r1, c8.x
texkill r0.xyzw
mov_pp oC0.w, c7.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
ConstBuffer "$Globals" 128 // 128 used size, 10 vars
Vector 32 [_SpecColor] 4
Vector 80 [_TranslucencyColor] 3
Float 100 [_Cutoff]
Vector 112 [ExposureIBL] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpSpecMap] 2D 1
SetTexture 2 [_TranslucencyMap] 2D 2
SetTexture 3 [_DiffCubeIBL] CUBE 3
// 35 instructions, 6 temp regs, 0 temp arrays:
// ALU 21 float, 2 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedilfipjfdcncohkdkgiaapohdojoklfhcabaaaaaaciagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcpaaeaaaaeaaaaaaadmabaaaa
dfbiaaaabcaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaiadpfjaaaaaeegiocaaaaaaaaaaaaiaaaaaafjaiaaaeegiocaaa
abaaaaaaaiaaaaaafkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaa
fkaaaaadaagabaaaacaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaa
aaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaa
acaaaaaaffffaaaafidaaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaa
abaaaaaagcbaaaadhcbabaaaacaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaad
hcbabaaaaeaaaaaagcbaaaadhcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaa
gfaaaaadpccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaaaaaaaajicaabaaa
aaaaaaaadkaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaaagaaaaaadbaaaaah
icaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaaanaaaeaddkaabaaa
aaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaa
aagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaaabaaaaaaabeaaaaa
aaaaaaedefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaacaaaaaaefaaaaajpcaabaaaacaaaaaaegbcbaaaagaaaaaaeghobaaa
adaaaaaaaagabaaaadaaaaaadiaaaaahhcaabaaaacaaaaaapgapbaaaacaaaaaa
egacbaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegacbaaaacaaaaaaagiacaaa
aaaaaaaaahaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegbcbaaa
acaaaaaadiaaaaakhcaabaaaacaaaaaaegacbaaaacaaaaaaaceaaaaaaaaaaadp
aaaaaadpaaaaaadpaaaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaaabaaaaaa
egbcbaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaaegacbaaa
acaaaaaadgaaaaafhcaabaaaadaaaaaaegacbaaaacaaaaaadgaaaaaficaabaaa
acaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahicaabaaaadaaaaaadkaabaaa
acaaaaaaabeaaaaaadaaaaaaadaaaeaddkaabaaaadaaaaaabaaaaaaiicaabaaa
adaaaaaaegacbaaaabaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaaibcaabaaa
aeaaaaaaegbcbaaaaeaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaaiccaabaaa
aeaaaaaaegbcbaaaafaaaaaaegjcjaaadkaabaaaacaaaaaacpaaaaafccaabaaa
aeaaaaaabkaabaaaaeaaaaaadiaaaaahccaabaaaaeaaaaaadkaabaaaaaaaaaaa
bkaabaaaaeaaaaaabjaaaaafccaabaaaaeaaaaaabkaabaaaaeaaaaaadiaaaaah
ccaabaaaaeaaaaaadkaabaaaabaaaaaabkaabaaaaeaaaaaadcaaaaakncaabaaa
aeaaaaaapgapbaaaadaaaaaaagijcaaaaaaaaaaaafaaaaaaagaabaaaaeaaaaaa
diaaaaaihcaabaaaafaaaaaafgafbaaaaeaaaaaaegiccaaaaaaaaaaaacaaaaaa
dcaaaaajhcaabaaaaeaaaaaaegacbaaaaaaaaaaaigadbaaaaeaaaaaaegacbaaa
afaaaaaadcaaaaamhcaabaaaadaaaaaaegacbaaaaeaaaaaaegiccaagabaaaaaa
aeaaaaaadkaabaaaacaaaaaaegacbaaaadaaaaaaboaaaaahicaabaaaacaaaaaa
dkaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaabaaaaaaahhccabaaaaaaaaaaa
egacbaaaadaaaaaaegacbaaaadaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
aaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES3"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Vector 1 [_SpecColor]
Vector 2 [_TranslucencyColor]
Vector 3 [_TerrainTreeLightColors0]
Vector 4 [_TerrainTreeLightColors1]
Vector 5 [_TerrainTreeLightColors2]
Float 6 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
"3.0-!!ARBfp1.0
# 29 ALU, 3 TEX
PARAM c[8] = { state.lightmodel.ambient,
		program.local[1..6],
		{ 1, 128, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.x, fragment.texcoord[0], texture[1], 2D;
MUL R3.w, R1.x, c[7].y;
TEX R2.zw, fragment.texcoord[0], texture[2], 2D;
MUL R1.xyw, fragment.texcoord[2].xyzz, R2.z;
SLT R0.w, R0, c[6].x;
POW R1.z, fragment.texcoord[4].x, R3.w;
MAD R3.xyz, R1.x, c[2], fragment.texcoord[3].x;
MUL R1.x, R2.w, R1.z;
POW R1.z, fragment.texcoord[4].y, R3.w;
MUL R2.xyz, R1.x, c[1];
MAD R2.xyz, R0, R3, R2;
MUL R1.x, R2.w, R1.z;
MUL R3.xyz, R1.x, c[1];
MAD R1.xyz, R1.y, c[2], fragment.texcoord[3].y;
MAD R3.xyz, R0, R1, R3;
POW R3.w, fragment.texcoord[4].z, R3.w;
MUL R2.xyz, R2, c[3];
MUL R1.xyz, fragment.texcoord[1], c[0];
MAD R1.xyz, R0, R1, R2;
MAD R2.xyz, R3, c[4], R1;
MUL R2.w, R2, R3;
MUL R1.xyz, R2.w, c[1];
MAD R3.xyz, R1.w, c[2], fragment.texcoord[3].z;
MAD R0.xyz, R0, R3, R1;
MAD R0.xyz, R0, c[5], R2;
MUL result.color.xyz, R0, c[7].z;
KIL -R0.w;
MOV result.color.w, c[7].x;
END
# 29 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_SpecColor]
Vector 2 [_TranslucencyColor]
Vector 3 [_TerrainTreeLightColors0]
Vector 4 [_TerrainTreeLightColors1]
Vector 5 [_TerrainTreeLightColors2]
Float 6 [_Cutoff]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_BumpSpecMap] 2D
SetTexture 2 [_TranslucencyMap] 2D
"ps_3_0
; 35 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c7, 0.00000000, 1.00000000, 128.00000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4.xyz
texld r3.zw, v0, s2
mul r2.xyw, v2.xyzz, r3.z
texld r0.x, v0, s1
mul r4.x, r0, c7.z
pow_pp r0, v4.y, r4.x
pow_pp r1, v4.x, r4.x
mov_pp r0.y, r1.x
mad_pp r3.xyz, r2.y, c2, v3.y
texld r1, v0, s0
mul_pp r0.w, r3, r0.y
mul_pp r0.x, r3.w, r0
mul_pp r0.xyz, r0.x, c1
mad_pp r3.xyz, r1, r3, r0
mul_pp r0.xyz, r0.w, c1
mad_pp r2.xyz, r2.x, c2, v3.x
mad_pp r2.xyz, r1, r2, r0
pow_pp r0, v4.z, r4.x
mul_pp r0.yzw, r2.xxyz, c3.xxyz
mul r2.xyz, v1, c0
mad_pp r2.xyz, r1, r2, r0.yzww
mov_pp r0.w, r0.x
mad_pp r0.xyz, r3, c4, r2
mul_pp r2.x, r3.w, r0.w
add_pp r0.w, r1, -c6.x
mul_pp r2.xyz, r2.x, c1
mad_pp r3.xyz, r2.w, c2, v3.z
mad_pp r1.xyz, r1, r3, r2
mad_pp r1.xyz, r1, c5, r0
cmp r0.w, r0, c7.x, c7.y
mov_pp r0, -r0.w
mul_pp oC0.xyz, r1, c7.w
texkill r0.xyzw
mov_pp oC0.w, c7.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
ConstBuffer "$Globals" 128 // 104 used size, 10 vars
Vector 32 [_SpecColor] 4
Vector 80 [_TranslucencyColor] 3
Float 100 [_Cutoff]
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityPerFrame" 1
BindCB "UnityTerrainImposter" 2
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_BumpSpecMap] 2D 1
SetTexture 2 [_TranslucencyMap] 2D 2
// 31 instructions, 6 temp regs, 0 temp arrays:
// ALU 18 float, 2 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedcljallcjikcondfokbfflomnnimojjlmabaaaaaaimafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaahahaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaahahaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaahahaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfeaeaaaaeaaaaaaabfabaaaa
dfbiaaaabcaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadp
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaiadpaaaaaaaaaaaaaaaaaaaaaaaa
aaaaaaaaaaaaiadpfjaaaaaeegiocaaaaaaaaaaaahaaaaaafjaaaaaeegiocaaa
abaaaaaaafaaaaaafjaiaaaeegiocaaaacaaaaaaaiaaaaaafkaaaaadaagabaaa
aaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaaacaaaaaafibiaaae
aahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaaffffaaaafibiaaae
aahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaadhcbabaaa
acaaaaaagcbaaaadhcbabaaaadaaaaaagcbaaaadhcbabaaaaeaaaaaagcbaaaad
hcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacagaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
aaaaaaajicaabaaaaaaaaaaadkaabaaaaaaaaaaabkiacaiaebaaaaaaaaaaaaaa
agaaaaaadbaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaaaa
anaaaeaddkaabaaaaaaaaaaaefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaabaaaaaaaagabaaaabaaaaaadiaaaaahicaabaaaaaaaaaaaakaabaaa
abaaaaaaabeaaaaaaaaaaaedefaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaa
eghobaaaacaaaaaaaagabaaaacaaaaaadiaaaaaihcaabaaaacaaaaaaegbcbaaa
acaaaaaaegiccaaaabaaaaaaaeaaaaaadiaaaaahhcaabaaaabaaaaaakgakbaaa
abaaaaaaegbcbaaaadaaaaaadiaaaaahhcaabaaaacaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadgaaaaafhcaabaaaadaaaaaaegacbaaaacaaaaaadgaaaaaf
icaabaaaacaaaaaaabeaaaaaaaaaaaaadaaaaaabcbaaaaahicaabaaaadaaaaaa
dkaabaaaacaaaaaaabeaaaaaadaaaaaaadaaaeaddkaabaaaadaaaaaabaaaaaai
icaabaaaadaaaaaaegacbaaaabaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaai
bcaabaaaaeaaaaaaegbcbaaaaeaaaaaaegjcjaaadkaabaaaacaaaaaabaaaaaai
ccaabaaaaeaaaaaaegbcbaaaafaaaaaaegjcjaaadkaabaaaacaaaaaacpaaaaaf
ccaabaaaaeaaaaaabkaabaaaaeaaaaaadiaaaaahccaabaaaaeaaaaaadkaabaaa
aaaaaaaabkaabaaaaeaaaaaabjaaaaafccaabaaaaeaaaaaabkaabaaaaeaaaaaa
diaaaaahccaabaaaaeaaaaaadkaabaaaabaaaaaabkaabaaaaeaaaaaadcaaaaak
ncaabaaaaeaaaaaapgapbaaaadaaaaaaagijcaaaaaaaaaaaafaaaaaaagaabaaa
aeaaaaaadiaaaaaihcaabaaaafaaaaaafgafbaaaaeaaaaaaegiccaaaaaaaaaaa
acaaaaaadcaaaaajhcaabaaaaeaaaaaaegacbaaaaaaaaaaaigadbaaaaeaaaaaa
egacbaaaafaaaaaadcaaaaamhcaabaaaadaaaaaaegacbaaaaeaaaaaaegiccaag
acaaaaaaaeaaaaaadkaabaaaacaaaaaaegacbaaaadaaaaaaboaaaaahicaabaaa
acaaaaaadkaabaaaacaaaaaaabeaaaaaabaaaaaabgaaaaabaaaaaaahhccabaaa
aaaaaaaaegacbaaaadaaaaaaegacbaaaadaaaaaadgaaaaaficcabaaaaaaaaaaa
abeaaaaaaaaaiadpdoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES"
}

SubProgram "gles3 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES3"
}

}

#LINE 153

	}
}

SubShader {
	Pass {		
		Fog { Mode Off }
		
		Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 17 to 17
//   d3d9 - ALU: 17 to 17
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 6 [_TerrainTreeLightDirections0]
Vector 7 [_TerrainTreeLightDirections1]
Vector 8 [_TerrainTreeLightDirections2]
Vector 9 [_TerrainTreeLightColors0]
Vector 10 [_TerrainTreeLightColors1]
Vector 11 [_TerrainTreeLightColors2]
Float 12 [_HalfOverCutoff]
"!!ARBvp1.0
# 17 ALU
PARAM c[13] = { { 0.5 },
		state.lightmodel.ambient,
		state.matrix.mvp,
		program.local[6..12] };
TEMP R0;
TEMP R1;
TEMP R2;
DP3 R0.x, vertex.normal, c[8];
MUL R2.xyz, R0.x, c[11];
DP3 R0.x, vertex.normal, c[6];
MUL R1.xyz, R0.x, c[9];
DP3 R0.y, vertex.normal, c[7];
MUL R0.xyz, R0.y, c[10];
ADD R1.xyz, R1, c[1];
ADD R0.xyz, R1, R0;
ADD R0.xyz, R0, R2;
MUL result.color.xyz, R0, vertex.color.w;
MOV R0.x, c[0];
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[5];
DP4 result.position.z, vertex.position, c[4];
DP4 result.position.y, vertex.position, c[3];
DP4 result.position.x, vertex.position, c[2];
MUL result.color.w, R0.x, c[12].x;
END
# 17 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 4 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_mvp]
Vector 5 [_TerrainTreeLightDirections0]
Vector 6 [_TerrainTreeLightDirections1]
Vector 7 [_TerrainTreeLightDirections2]
Vector 8 [_TerrainTreeLightColors0]
Vector 9 [_TerrainTreeLightColors1]
Vector 10 [_TerrainTreeLightColors2]
Float 11 [_HalfOverCutoff]
"vs_2_0
; 17 ALU
def c12, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
dp3 r0.x, v1, c7
mul r2.xyz, r0.x, c10
dp3 r0.x, v1, c5
mul r1.xyz, r0.x, c8
dp3 r0.y, v1, c6
mul r0.xyz, r0.y, c9
add r1.xyz, r1, c4
add r0.xyz, r1, r0
add r0.xyz, r0, r2
mul oD0.xyz, r0, v3.w
mov r0.x, c11
mov oT0.xy, v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
mul oD0.w, c12.x, r0.x
"
}

}

#LINE 205

		
		AlphaTest GEqual 1
		SetTexture [_MainTex] {
			Combine texture * primary DOUBLE, texture * primary QUAD
		} 
	}
}

FallBack Off
}
