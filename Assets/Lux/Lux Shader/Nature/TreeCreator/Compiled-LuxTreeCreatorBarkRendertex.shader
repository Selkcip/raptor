Shader "Hidden/Lux/Nature/Tree Creator Bark Rendertex" {
Properties {
	_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
	_BumpSpecMap ("Normalmap (GA) Spec (R)", 2D) = "bump" {}
	_TranslucencyMap ("Trans (RGB) Gloss(A)", 2D) = "white" {}
	
	// These are here only to provide default values
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Scale ("Scale", Vector) = (1,1,1,1)
	_SquashAmount ("Squash", Float) = 1
}

SubShader {  
	Fog { Mode Off }	
	Pass {
Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 39 to 39
//   d3d9 - ALU: 39 to 39
//   d3d11 - ALU: 35 to 35, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_TerrainTreeLightDirections0]
Vector 12 [_TerrainTreeLightDirections1]
Vector 13 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, c[9];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R0.xyz, R0, c[10].w, -vertex.position;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[11];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, vertex.normal, R1;
MAX result.texcoord[2].y, R1.x, c[0];
MAD R1.xyz, R0.w, R0, c[12];
MAD R0.xyz, R0.w, R0, c[13];
DP3 R1.w, R1, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, vertex.normal, R0;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R0.w, vertex.normal, R1;
MAX result.texcoord[4].y, R0.x, c[0];
DP3 R0.x, vertex.normal, c[11];
MAX result.texcoord[2].x, R0, c[0].y;
DP3 R0.x, vertex.normal, c[12];
DP3 R0.y, vertex.normal, c[13];
MAX result.texcoord[3].y, R0.w, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[5].xyz, vertex.normal;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
MAX result.texcoord[3].x, R0, c[0].y;
MAX result.texcoord[4].x, R0.y, c[0].y;
END
# 39 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_TerrainTreeLightDirections0]
Vector 11 [_TerrainTreeLightDirections1]
Vector 12 [_TerrainTreeLightDirections2]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c13, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mov r1.w, c13.x
mov r1.xyz, c8
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r0.xyz, r0, c9.w, -v0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c10
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r1.x, v1, r1
max o3.y, r1.x, c13
mad r1.xyz, r0.w, r0, c11
mad r0.xyz, r0.w, r0, c12
dp3 r1.w, r1, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.x, v1, r0
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r0.w, v1, r1
max o5.y, r0.x, c13
dp3 r0.x, v1, c10
max o3.x, r0, c13.y
dp3 r0.x, v1, c11
dp3 r0.y, v1, c12
max o4.y, r0.w, c13
mov o2.xyz, v3.w
mov o6.xyz, v1
mov o1.xy, v2
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
max o4.x, r0, c13.y
max o5.x, r0.y, c13.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
BindCB "UnityTerrainImposter" 2
// 39 instructions, 2 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedneadceckelkhgdibckfdaabmbopgflbnabaaaaaabmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfaafaaaaeaaaabaafeabaaaafjaaaaaeegiocaaaaaaaaaaa
afaaaaaafjaaaaaeegiocaaaabaaaaaabfaaaaaafjaaaaaeegiocaaaacaaaaaa
adaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaa
dgaaaaafhccabaaaacaaaaaapgbpbaaaafaaaaaabaaaaaaibcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbccabaaaadaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
aaaaaaaaaeaaaaaaegiccaaaabaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaabaaaaaabaaaaaaaagiacaaaaaaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaabaaaaaabcaaaaaakgikcaaaaaaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaabaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaabaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaa
adaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaaaeaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaabaaaaaadeaaaaahbccabaaaaeaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadeaaaaahcccabaaaafaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaacaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadgaaaaafhccabaaaagaaaaaaegbcbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  highp float specular_6;
  mediump float gloss_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_9;
  tmpvar_9 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_7 = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_6 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_11;
  diff_ibl_4.w = (diff_ibl_4.w * ((diff_ibl_4.w * ((diff_ibl_4.w * 0.305306) + 0.682171)) + 0.0125229));
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1);
  ambient_5 = tmpvar_12;
  mediump float nl_13;
  mediump vec3 lightColor_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = _TerrainTreeLightColors[0].xyz;
  lightColor_14 = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = pow (lightColor_14, vec3(0.454545, 0.454545, 0.454545));
  lightColor_14 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = xlv_TEXCOORD2.x;
  nl_13 = tmpvar_17;
  light_3 = (tmpvar_16 * nl_13);
  spec_2 = ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2.y, specular_6)) * gloss_7) * tmpvar_16);
  mediump float nl_18;
  mediump vec3 lightColor_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = _TerrainTreeLightColors[1].xyz;
  lightColor_19 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = pow (lightColor_19, vec3(0.454545, 0.454545, 0.454545));
  lightColor_19 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = xlv_TEXCOORD2_1.x;
  nl_18 = tmpvar_22;
  light_3 = (light_3 + (tmpvar_21 * nl_18));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_6)) * gloss_7) * tmpvar_21));
  mediump float nl_23;
  mediump vec3 lightColor_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = _TerrainTreeLightColors[2].xyz;
  lightColor_24 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = pow (lightColor_24, vec3(0.454545, 0.454545, 0.454545));
  lightColor_24 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = xlv_TEXCOORD2_2.x;
  nl_23 = tmpvar_27;
  light_3 = (light_3 + (tmpvar_26 * nl_23));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_6)) * gloss_7) * tmpvar_26));
  highp vec3 tmpvar_28;
  tmpvar_28 = ((((tmpvar_8.xyz * light_3) + spec_2) * 2.0) + (ambient_5 * tmpvar_8.xyz));
  c_1.xyz = tmpvar_28;
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
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  highp float specular_6;
  mediump float gloss_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_9;
  tmpvar_9 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_7 = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_6 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_11;
  diff_ibl_4.w = (diff_ibl_4.w * ((diff_ibl_4.w * ((diff_ibl_4.w * 0.305306) + 0.682171)) + 0.0125229));
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1);
  ambient_5 = tmpvar_12;
  mediump float nl_13;
  mediump vec3 lightColor_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = _TerrainTreeLightColors[0].xyz;
  lightColor_14 = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = pow (lightColor_14, vec3(0.454545, 0.454545, 0.454545));
  lightColor_14 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = xlv_TEXCOORD2.x;
  nl_13 = tmpvar_17;
  light_3 = (tmpvar_16 * nl_13);
  spec_2 = ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2.y, specular_6)) * gloss_7) * tmpvar_16);
  mediump float nl_18;
  mediump vec3 lightColor_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = _TerrainTreeLightColors[1].xyz;
  lightColor_19 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = pow (lightColor_19, vec3(0.454545, 0.454545, 0.454545));
  lightColor_19 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = xlv_TEXCOORD2_1.x;
  nl_18 = tmpvar_22;
  light_3 = (light_3 + (tmpvar_21 * nl_18));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_6)) * gloss_7) * tmpvar_21));
  mediump float nl_23;
  mediump vec3 lightColor_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = _TerrainTreeLightColors[2].xyz;
  lightColor_24 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = pow (lightColor_24, vec3(0.454545, 0.454545, 0.454545));
  lightColor_24 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = xlv_TEXCOORD2_2.x;
  nl_23 = tmpvar_27;
  light_3 = (light_3 + (tmpvar_26 * nl_23));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_6)) * gloss_7) * tmpvar_26));
  highp vec3 tmpvar_28;
  tmpvar_28 = ((((tmpvar_8.xyz * light_3) + spec_2) * 2.0) + (ambient_5 * tmpvar_8.xyz));
  c_1.xyz = tmpvar_28;
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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform samplerCube _DiffCubeIBL;
#line 352
uniform highp vec4 ExposureIBL;
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 326
v2f vert( in appdata_full v ) {
    #line 328
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    #line 332
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 336
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        o.params[j].x = max( 0.0, nl);
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 340
        highp float nh = max( 0.0, dot( v.normal, h));
        o.params[j].y = nh;
    }
    o.color = vec3( v.color.w);
    #line 344
    o.normal = v.normal;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD2_1;
out highp vec2 xlv_TEXCOORD2_2;
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
    xlv_TEXCOORD2 = vec2(xl_retval.params[0]);
    xlv_TEXCOORD2_1 = vec2(xl_retval.params[1]);
    xlv_TEXCOORD2_2 = vec2(xl_retval.params[2]);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform samplerCube _DiffCubeIBL;
#line 352
uniform highp vec4 ExposureIBL;
#line 353
lowp vec4 frag( in v2f i ) {
    lowp vec3 albedo = texture( _MainTex, i.uv).xyz;
    #line 356
    mediump float gloss = texture( _TranslucencyMap, i.uv).w;
    highp float specular = (exp2(((10.0 * texture( _BumpSpecMap, i.uv).x) + 1.0)) - 1.75);
    mediump vec3 ambient;
    mediump vec4 diff_ibl = texture( _DiffCubeIBL, i.normal);
    #line 360
    diff_ibl.w *= ((diff_ibl.w * ((diff_ibl.w * 0.305306) + 0.682171)) + 0.0125229);
    diff_ibl.xyz = (diff_ibl.xyz * diff_ibl.w);
    ambient = ((diff_ibl.xyz * ExposureIBL.x) * i.color);
    mediump vec3 light = vec3( 0.0);
    #line 364
    highp vec3 spec = vec3( 0.0);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 369
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        lightColor = pow( lightColor, vec3( 0.454545));
        mediump float nl = i.params[j].x;
        light += (lightColor * nl);
        #line 373
        highp float nh = i.params[j].y;
        spec += ((((specular * 0.125) * pow( nh, specular)) * gloss) * lightColor);
    }
    lowp vec4 c;
    #line 377
    c.xyz = ((((albedo * light) + spec) * 2.0) + (ambient * albedo));
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD2_1;
in highp vec2 xlv_TEXCOORD2_2;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.params[0] = vec2(xlv_TEXCOORD2);
    xlt_i.params[1] = vec2(xlv_TEXCOORD2_1);
    xlt_i.params[2] = vec2(xlv_TEXCOORD2_2);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_TerrainTreeLightDirections0]
Vector 12 [_TerrainTreeLightDirections1]
Vector 13 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, c[9];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R0.xyz, R0, c[10].w, -vertex.position;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[11];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, vertex.normal, R1;
MAX result.texcoord[2].y, R1.x, c[0];
MAD R1.xyz, R0.w, R0, c[12];
MAD R0.xyz, R0.w, R0, c[13];
DP3 R1.w, R1, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, vertex.normal, R0;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R0.w, vertex.normal, R1;
MAX result.texcoord[4].y, R0.x, c[0];
DP3 R0.x, vertex.normal, c[11];
MAX result.texcoord[2].x, R0, c[0].y;
DP3 R0.x, vertex.normal, c[12];
DP3 R0.y, vertex.normal, c[13];
MAX result.texcoord[3].y, R0.w, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[5].xyz, vertex.normal;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
MAX result.texcoord[3].x, R0, c[0].y;
MAX result.texcoord[4].x, R0.y, c[0].y;
END
# 39 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_TerrainTreeLightDirections0]
Vector 11 [_TerrainTreeLightDirections1]
Vector 12 [_TerrainTreeLightDirections2]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c13, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mov r1.w, c13.x
mov r1.xyz, c8
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r0.xyz, r0, c9.w, -v0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c10
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r1.x, v1, r1
max o3.y, r1.x, c13
mad r1.xyz, r0.w, r0, c11
mad r0.xyz, r0.w, r0, c12
dp3 r1.w, r1, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.x, v1, r0
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r0.w, v1, r1
max o5.y, r0.x, c13
dp3 r0.x, v1, c10
max o3.x, r0, c13.y
dp3 r0.x, v1, c11
dp3 r0.y, v1, c12
max o4.y, r0.w, c13
mov o2.xyz, v3.w
mov o6.xyz, v1
mov o1.xy, v2
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
max o4.x, r0, c13.y
max o5.x, r0.y, c13.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
BindCB "UnityTerrainImposter" 2
// 39 instructions, 2 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedneadceckelkhgdibckfdaabmbopgflbnabaaaaaabmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfaafaaaaeaaaabaafeabaaaafjaaaaaeegiocaaaaaaaaaaa
afaaaaaafjaaaaaeegiocaaaabaaaaaabfaaaaaafjaaaaaeegiocaaaacaaaaaa
adaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaa
dgaaaaafhccabaaaacaaaaaapgbpbaaaafaaaaaabaaaaaaibcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbccabaaaadaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
aaaaaaaaaeaaaaaaegiccaaaabaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaabaaaaaabaaaaaaaagiacaaaaaaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaabaaaaaabcaaaaaakgikcaaaaaaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaabaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaabaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaa
adaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaaaeaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaabaaaaaadeaaaaahbccabaaaaeaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadeaaaaahcccabaaaafaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaacaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadgaaaaafhccabaaaagaaaaaaegbcbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec3 ambient_4;
  highp float specular_5;
  mediump float gloss_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_8;
  tmpvar_8 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_6 = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_5 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1) * 2.0);
  ambient_4 = tmpvar_10;
  mediump float nl_11;
  mediump vec3 lightColor_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = _TerrainTreeLightColors[0].xyz;
  lightColor_12 = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = pow (lightColor_12, vec3(0.454545, 0.454545, 0.454545));
  lightColor_12 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = xlv_TEXCOORD2.x;
  nl_11 = tmpvar_15;
  light_3 = (tmpvar_14 * nl_11);
  spec_2 = ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2.y, specular_5)) * gloss_6) * tmpvar_14);
  mediump float nl_16;
  mediump vec3 lightColor_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = _TerrainTreeLightColors[1].xyz;
  lightColor_17 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = pow (lightColor_17, vec3(0.454545, 0.454545, 0.454545));
  lightColor_17 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD2_1.x;
  nl_16 = tmpvar_20;
  light_3 = (light_3 + (tmpvar_19 * nl_16));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_5)) * gloss_6) * tmpvar_19));
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[2].xyz;
  lightColor_22 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = pow (lightColor_22, vec3(0.454545, 0.454545, 0.454545));
  lightColor_22 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = xlv_TEXCOORD2_2.x;
  nl_21 = tmpvar_25;
  light_3 = (light_3 + (tmpvar_24 * nl_21));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_5)) * gloss_6) * tmpvar_24));
  highp vec3 tmpvar_26;
  tmpvar_26 = ((((tmpvar_7.xyz * light_3) + spec_2) * 2.0) + (ambient_4 * tmpvar_7.xyz));
  c_1.xyz = tmpvar_26;
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
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec3 ambient_4;
  highp float specular_5;
  mediump float gloss_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_8;
  tmpvar_8 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_6 = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_5 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1) * 2.0);
  ambient_4 = tmpvar_10;
  mediump float nl_11;
  mediump vec3 lightColor_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = _TerrainTreeLightColors[0].xyz;
  lightColor_12 = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = pow (lightColor_12, vec3(0.454545, 0.454545, 0.454545));
  lightColor_12 = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = xlv_TEXCOORD2.x;
  nl_11 = tmpvar_15;
  light_3 = (tmpvar_14 * nl_11);
  spec_2 = ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2.y, specular_5)) * gloss_6) * tmpvar_14);
  mediump float nl_16;
  mediump vec3 lightColor_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = _TerrainTreeLightColors[1].xyz;
  lightColor_17 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = pow (lightColor_17, vec3(0.454545, 0.454545, 0.454545));
  lightColor_17 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD2_1.x;
  nl_16 = tmpvar_20;
  light_3 = (light_3 + (tmpvar_19 * nl_16));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_5)) * gloss_6) * tmpvar_19));
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[2].xyz;
  lightColor_22 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = pow (lightColor_22, vec3(0.454545, 0.454545, 0.454545));
  lightColor_22 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = xlv_TEXCOORD2_2.x;
  nl_21 = tmpvar_25;
  light_3 = (light_3 + (tmpvar_24 * nl_21));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_5)) * gloss_6) * tmpvar_24));
  highp vec3 tmpvar_26;
  tmpvar_26 = ((((tmpvar_7.xyz * light_3) + spec_2) * 2.0) + (ambient_4 * tmpvar_7.xyz));
  c_1.xyz = tmpvar_26;
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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform highp vec4 ExposureIBL;
#line 352
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 326
v2f vert( in appdata_full v ) {
    #line 328
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    #line 332
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 336
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        o.params[j].x = max( 0.0, nl);
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 340
        highp float nh = max( 0.0, dot( v.normal, h));
        o.params[j].y = nh;
    }
    o.color = vec3( v.color.w);
    #line 344
    o.normal = v.normal;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD2_1;
out highp vec2 xlv_TEXCOORD2_2;
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
    xlv_TEXCOORD2 = vec2(xl_retval.params[0]);
    xlv_TEXCOORD2_1 = vec2(xl_retval.params[1]);
    xlv_TEXCOORD2_2 = vec2(xl_retval.params[2]);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform highp vec4 ExposureIBL;
#line 352
#line 352
lowp vec4 frag( in v2f i ) {
    lowp vec3 albedo = texture( _MainTex, i.uv).xyz;
    mediump float gloss = texture( _TranslucencyMap, i.uv).w;
    #line 356
    highp float specular = (exp2(((10.0 * texture( _BumpSpecMap, i.uv).x) + 1.0)) - 1.75);
    mediump vec3 ambient;
    ambient = ((vec3( glstate_lightmodel_ambient) * i.color) * 2.0);
    mediump vec3 light = vec3( 0.0);
    #line 360
    highp vec3 spec = vec3( 0.0);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 365
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        lightColor = pow( lightColor, vec3( 0.454545));
        mediump float nl = i.params[j].x;
        light += (lightColor * nl);
        #line 369
        highp float nh = i.params[j].y;
        spec += ((((specular * 0.125) * pow( nh, specular)) * gloss) * lightColor);
    }
    lowp vec4 c;
    #line 373
    c.xyz = ((((albedo * light) + spec) * 2.0) + (ambient * albedo));
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD2_1;
in highp vec2 xlv_TEXCOORD2_2;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.params[0] = vec2(xlv_TEXCOORD2);
    xlt_i.params[1] = vec2(xlv_TEXCOORD2_1);
    xlt_i.params[2] = vec2(xlv_TEXCOORD2_2);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_TerrainTreeLightDirections0]
Vector 12 [_TerrainTreeLightDirections1]
Vector 13 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, c[9];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R0.xyz, R0, c[10].w, -vertex.position;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[11];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, vertex.normal, R1;
MAX result.texcoord[2].y, R1.x, c[0];
MAD R1.xyz, R0.w, R0, c[12];
MAD R0.xyz, R0.w, R0, c[13];
DP3 R1.w, R1, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, vertex.normal, R0;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R0.w, vertex.normal, R1;
MAX result.texcoord[4].y, R0.x, c[0];
DP3 R0.x, vertex.normal, c[11];
MAX result.texcoord[2].x, R0, c[0].y;
DP3 R0.x, vertex.normal, c[12];
DP3 R0.y, vertex.normal, c[13];
MAX result.texcoord[3].y, R0.w, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[5].xyz, vertex.normal;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
MAX result.texcoord[3].x, R0, c[0].y;
MAX result.texcoord[4].x, R0.y, c[0].y;
END
# 39 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_TerrainTreeLightDirections0]
Vector 11 [_TerrainTreeLightDirections1]
Vector 12 [_TerrainTreeLightDirections2]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c13, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mov r1.w, c13.x
mov r1.xyz, c8
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r0.xyz, r0, c9.w, -v0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c10
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r1.x, v1, r1
max o3.y, r1.x, c13
mad r1.xyz, r0.w, r0, c11
mad r0.xyz, r0.w, r0, c12
dp3 r1.w, r1, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.x, v1, r0
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r0.w, v1, r1
max o5.y, r0.x, c13
dp3 r0.x, v1, c10
max o3.x, r0, c13.y
dp3 r0.x, v1, c11
dp3 r0.y, v1, c12
max o4.y, r0.w, c13
mov o2.xyz, v3.w
mov o6.xyz, v1
mov o1.xy, v2
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
max o4.x, r0, c13.y
max o5.x, r0.y, c13.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
BindCB "UnityTerrainImposter" 2
// 39 instructions, 2 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedneadceckelkhgdibckfdaabmbopgflbnabaaaaaabmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfaafaaaaeaaaabaafeabaaaafjaaaaaeegiocaaaaaaaaaaa
afaaaaaafjaaaaaeegiocaaaabaaaaaabfaaaaaafjaaaaaeegiocaaaacaaaaaa
adaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaa
dgaaaaafhccabaaaacaaaaaapgbpbaaaafaaaaaabaaaaaaibcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbccabaaaadaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
aaaaaaaaaeaaaaaaegiccaaaabaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaabaaaaaabaaaaaaaagiacaaaaaaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaabaaaaaabcaaaaaakgikcaaaaaaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaabaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaabaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaa
adaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaaaeaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaabaaaaaadeaaaaahbccabaaaaeaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadeaaaaahcccabaaaafaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaacaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadgaaaaafhccabaaaagaaaaaaegbcbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  highp float specular_6;
  mediump float gloss_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_9;
  tmpvar_9 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_7 = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_6 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_11;
  diff_ibl_4.w = (diff_ibl_4.w * ((diff_ibl_4.w * ((diff_ibl_4.w * 0.305306) + 0.682171)) + 0.0125229));
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1);
  ambient_5 = tmpvar_12;
  mediump float nl_13;
  mediump vec3 lightColor_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = _TerrainTreeLightColors[0].xyz;
  lightColor_14 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = xlv_TEXCOORD2.x;
  nl_13 = tmpvar_16;
  light_3 = (lightColor_14 * nl_13);
  spec_2 = ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2.y, specular_6)) * gloss_7) * lightColor_14);
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[1].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD2_1.x;
  nl_17 = tmpvar_20;
  light_3 = (light_3 + (lightColor_18 * nl_17));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_6)) * gloss_7) * lightColor_18));
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[2].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD2_2.x;
  nl_21 = tmpvar_24;
  light_3 = (light_3 + (lightColor_22 * nl_21));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_6)) * gloss_7) * lightColor_22));
  highp vec3 tmpvar_25;
  tmpvar_25 = ((((tmpvar_8.xyz * light_3) + spec_2) * 2.0) + (ambient_5 * tmpvar_8.xyz));
  c_1.xyz = tmpvar_25;
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
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  highp float specular_6;
  mediump float gloss_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_9;
  tmpvar_9 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_7 = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_6 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_11;
  diff_ibl_4.w = (diff_ibl_4.w * ((diff_ibl_4.w * ((diff_ibl_4.w * 0.305306) + 0.682171)) + 0.0125229));
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1);
  ambient_5 = tmpvar_12;
  mediump float nl_13;
  mediump vec3 lightColor_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = _TerrainTreeLightColors[0].xyz;
  lightColor_14 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = xlv_TEXCOORD2.x;
  nl_13 = tmpvar_16;
  light_3 = (lightColor_14 * nl_13);
  spec_2 = ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2.y, specular_6)) * gloss_7) * lightColor_14);
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[1].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD2_1.x;
  nl_17 = tmpvar_20;
  light_3 = (light_3 + (lightColor_18 * nl_17));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_6)) * gloss_7) * lightColor_18));
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[2].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD2_2.x;
  nl_21 = tmpvar_24;
  light_3 = (light_3 + (lightColor_22 * nl_21));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_6)) * gloss_7) * lightColor_22));
  highp vec3 tmpvar_25;
  tmpvar_25 = ((((tmpvar_8.xyz * light_3) + spec_2) * 2.0) + (ambient_5 * tmpvar_8.xyz));
  c_1.xyz = tmpvar_25;
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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform samplerCube _DiffCubeIBL;
#line 352
uniform highp vec4 ExposureIBL;
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 326
v2f vert( in appdata_full v ) {
    #line 328
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    #line 332
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 336
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        o.params[j].x = max( 0.0, nl);
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 340
        highp float nh = max( 0.0, dot( v.normal, h));
        o.params[j].y = nh;
    }
    o.color = vec3( v.color.w);
    #line 344
    o.normal = v.normal;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD2_1;
out highp vec2 xlv_TEXCOORD2_2;
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
    xlv_TEXCOORD2 = vec2(xl_retval.params[0]);
    xlv_TEXCOORD2_1 = vec2(xl_retval.params[1]);
    xlv_TEXCOORD2_2 = vec2(xl_retval.params[2]);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform samplerCube _DiffCubeIBL;
#line 352
uniform highp vec4 ExposureIBL;
#line 353
lowp vec4 frag( in v2f i ) {
    lowp vec3 albedo = texture( _MainTex, i.uv).xyz;
    #line 356
    mediump float gloss = texture( _TranslucencyMap, i.uv).w;
    highp float specular = (exp2(((10.0 * texture( _BumpSpecMap, i.uv).x) + 1.0)) - 1.75);
    mediump vec3 ambient;
    mediump vec4 diff_ibl = texture( _DiffCubeIBL, i.normal);
    #line 360
    diff_ibl.w *= ((diff_ibl.w * ((diff_ibl.w * 0.305306) + 0.682171)) + 0.0125229);
    diff_ibl.xyz = (diff_ibl.xyz * diff_ibl.w);
    ambient = ((diff_ibl.xyz * ExposureIBL.x) * i.color);
    mediump vec3 light = vec3( 0.0);
    #line 364
    highp vec3 spec = vec3( 0.0);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 369
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump float nl = i.params[j].x;
        light += (lightColor * nl);
        highp float nh = i.params[j].y;
        #line 373
        spec += ((((specular * 0.125) * pow( nh, specular)) * gloss) * lightColor);
    }
    lowp vec4 c;
    c.xyz = ((((albedo * light) + spec) * 2.0) + (ambient * albedo));
    #line 377
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD2_1;
in highp vec2 xlv_TEXCOORD2_2;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.params[0] = vec2(xlv_TEXCOORD2);
    xlt_i.params[1] = vec2(xlv_TEXCOORD2_1);
    xlt_i.params[2] = vec2(xlv_TEXCOORD2_2);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_TerrainTreeLightDirections0]
Vector 12 [_TerrainTreeLightDirections1]
Vector 13 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, c[9];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R0.xyz, R0, c[10].w, -vertex.position;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[11];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, vertex.normal, R1;
MAX result.texcoord[2].y, R1.x, c[0];
MAD R1.xyz, R0.w, R0, c[12];
MAD R0.xyz, R0.w, R0, c[13];
DP3 R1.w, R1, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, vertex.normal, R0;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R0.w, vertex.normal, R1;
MAX result.texcoord[4].y, R0.x, c[0];
DP3 R0.x, vertex.normal, c[11];
MAX result.texcoord[2].x, R0, c[0].y;
DP3 R0.x, vertex.normal, c[12];
DP3 R0.y, vertex.normal, c[13];
MAX result.texcoord[3].y, R0.w, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[5].xyz, vertex.normal;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
MAX result.texcoord[3].x, R0, c[0].y;
MAX result.texcoord[4].x, R0.y, c[0].y;
END
# 39 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_TerrainTreeLightDirections0]
Vector 11 [_TerrainTreeLightDirections1]
Vector 12 [_TerrainTreeLightDirections2]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c13, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mov r1.w, c13.x
mov r1.xyz, c8
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r0.xyz, r0, c9.w, -v0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c10
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r1.x, v1, r1
max o3.y, r1.x, c13
mad r1.xyz, r0.w, r0, c11
mad r0.xyz, r0.w, r0, c12
dp3 r1.w, r1, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.x, v1, r0
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r0.w, v1, r1
max o5.y, r0.x, c13
dp3 r0.x, v1, c10
max o3.x, r0, c13.y
dp3 r0.x, v1, c11
dp3 r0.y, v1, c12
max o4.y, r0.w, c13
mov o2.xyz, v3.w
mov o6.xyz, v1
mov o1.xy, v2
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
max o4.x, r0, c13.y
max o5.x, r0.y, c13.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
BindCB "UnityTerrainImposter" 2
// 39 instructions, 2 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedneadceckelkhgdibckfdaabmbopgflbnabaaaaaabmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfaafaaaaeaaaabaafeabaaaafjaaaaaeegiocaaaaaaaaaaa
afaaaaaafjaaaaaeegiocaaaabaaaaaabfaaaaaafjaaaaaeegiocaaaacaaaaaa
adaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaa
dgaaaaafhccabaaaacaaaaaapgbpbaaaafaaaaaabaaaaaaibcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbccabaaaadaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
aaaaaaaaaeaaaaaaegiccaaaabaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaabaaaaaabaaaaaaaagiacaaaaaaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaabaaaaaabcaaaaaakgikcaaaaaaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaabaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaabaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaa
adaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaaaeaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaabaaaaaadeaaaaahbccabaaaaeaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadeaaaaahcccabaaaafaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaacaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadgaaaaafhccabaaaagaaaaaaegbcbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec3 ambient_4;
  highp float specular_5;
  mediump float gloss_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_8;
  tmpvar_8 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_6 = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_5 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1) * 2.0);
  ambient_4 = tmpvar_10;
  mediump float nl_11;
  mediump vec3 lightColor_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = _TerrainTreeLightColors[0].xyz;
  lightColor_12 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = xlv_TEXCOORD2.x;
  nl_11 = tmpvar_14;
  light_3 = (lightColor_12 * nl_11);
  spec_2 = ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2.y, specular_5)) * gloss_6) * lightColor_12);
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[1].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD2_1.x;
  nl_15 = tmpvar_18;
  light_3 = (light_3 + (lightColor_16 * nl_15));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_5)) * gloss_6) * lightColor_16));
  mediump float nl_19;
  mediump vec3 lightColor_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = _TerrainTreeLightColors[2].xyz;
  lightColor_20 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = xlv_TEXCOORD2_2.x;
  nl_19 = tmpvar_22;
  light_3 = (light_3 + (lightColor_20 * nl_19));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_5)) * gloss_6) * lightColor_20));
  highp vec3 tmpvar_23;
  tmpvar_23 = ((((tmpvar_7.xyz * light_3) + spec_2) * 2.0) + (ambient_4 * tmpvar_7.xyz));
  c_1.xyz = tmpvar_23;
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
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec3 ambient_4;
  highp float specular_5;
  mediump float gloss_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_8;
  tmpvar_8 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_6 = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_5 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1) * 2.0);
  ambient_4 = tmpvar_10;
  mediump float nl_11;
  mediump vec3 lightColor_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = _TerrainTreeLightColors[0].xyz;
  lightColor_12 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = xlv_TEXCOORD2.x;
  nl_11 = tmpvar_14;
  light_3 = (lightColor_12 * nl_11);
  spec_2 = ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2.y, specular_5)) * gloss_6) * lightColor_12);
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[1].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD2_1.x;
  nl_15 = tmpvar_18;
  light_3 = (light_3 + (lightColor_16 * nl_15));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_5)) * gloss_6) * lightColor_16));
  mediump float nl_19;
  mediump vec3 lightColor_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = _TerrainTreeLightColors[2].xyz;
  lightColor_20 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = xlv_TEXCOORD2_2.x;
  nl_19 = tmpvar_22;
  light_3 = (light_3 + (lightColor_20 * nl_19));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_5)) * gloss_6) * lightColor_20));
  highp vec3 tmpvar_23;
  tmpvar_23 = ((((tmpvar_7.xyz * light_3) + spec_2) * 2.0) + (ambient_4 * tmpvar_7.xyz));
  c_1.xyz = tmpvar_23;
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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform highp vec4 ExposureIBL;
#line 352
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 326
v2f vert( in appdata_full v ) {
    #line 328
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    #line 332
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 336
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        o.params[j].x = max( 0.0, nl);
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 340
        highp float nh = max( 0.0, dot( v.normal, h));
        o.params[j].y = nh;
    }
    o.color = vec3( v.color.w);
    #line 344
    o.normal = v.normal;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD2_1;
out highp vec2 xlv_TEXCOORD2_2;
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
    xlv_TEXCOORD2 = vec2(xl_retval.params[0]);
    xlv_TEXCOORD2_1 = vec2(xl_retval.params[1]);
    xlv_TEXCOORD2_2 = vec2(xl_retval.params[2]);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform highp vec4 ExposureIBL;
#line 352
#line 352
lowp vec4 frag( in v2f i ) {
    lowp vec3 albedo = texture( _MainTex, i.uv).xyz;
    mediump float gloss = texture( _TranslucencyMap, i.uv).w;
    #line 356
    highp float specular = (exp2(((10.0 * texture( _BumpSpecMap, i.uv).x) + 1.0)) - 1.75);
    mediump vec3 ambient;
    ambient = ((vec3( glstate_lightmodel_ambient) * i.color) * 2.0);
    mediump vec3 light = vec3( 0.0);
    #line 360
    highp vec3 spec = vec3( 0.0);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 365
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump float nl = i.params[j].x;
        light += (lightColor * nl);
        highp float nh = i.params[j].y;
        #line 369
        spec += ((((specular * 0.125) * pow( nh, specular)) * gloss) * lightColor);
    }
    lowp vec4 c;
    c.xyz = ((((albedo * light) + spec) * 2.0) + (ambient * albedo));
    #line 373
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD2_1;
in highp vec2 xlv_TEXCOORD2_2;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.params[0] = vec2(xlv_TEXCOORD2);
    xlt_i.params[1] = vec2(xlv_TEXCOORD2_1);
    xlt_i.params[2] = vec2(xlv_TEXCOORD2_2);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_TerrainTreeLightDirections0]
Vector 12 [_TerrainTreeLightDirections1]
Vector 13 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, c[9];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R0.xyz, R0, c[10].w, -vertex.position;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[11];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, vertex.normal, R1;
MAX result.texcoord[2].y, R1.x, c[0];
MAD R1.xyz, R0.w, R0, c[12];
MAD R0.xyz, R0.w, R0, c[13];
DP3 R1.w, R1, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, vertex.normal, R0;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R0.w, vertex.normal, R1;
MAX result.texcoord[4].y, R0.x, c[0];
DP3 R0.x, vertex.normal, c[11];
MAX result.texcoord[2].x, R0, c[0].y;
DP3 R0.x, vertex.normal, c[12];
DP3 R0.y, vertex.normal, c[13];
MAX result.texcoord[3].y, R0.w, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[5].xyz, vertex.normal;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
MAX result.texcoord[3].x, R0, c[0].y;
MAX result.texcoord[4].x, R0.y, c[0].y;
END
# 39 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_TerrainTreeLightDirections0]
Vector 11 [_TerrainTreeLightDirections1]
Vector 12 [_TerrainTreeLightDirections2]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c13, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mov r1.w, c13.x
mov r1.xyz, c8
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r0.xyz, r0, c9.w, -v0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c10
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r1.x, v1, r1
max o3.y, r1.x, c13
mad r1.xyz, r0.w, r0, c11
mad r0.xyz, r0.w, r0, c12
dp3 r1.w, r1, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.x, v1, r0
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r0.w, v1, r1
max o5.y, r0.x, c13
dp3 r0.x, v1, c10
max o3.x, r0, c13.y
dp3 r0.x, v1, c11
dp3 r0.y, v1, c12
max o4.y, r0.w, c13
mov o2.xyz, v3.w
mov o6.xyz, v1
mov o1.xy, v2
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
max o4.x, r0, c13.y
max o5.x, r0.y, c13.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
BindCB "UnityTerrainImposter" 2
// 39 instructions, 2 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedneadceckelkhgdibckfdaabmbopgflbnabaaaaaabmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfaafaaaaeaaaabaafeabaaaafjaaaaaeegiocaaaaaaaaaaa
afaaaaaafjaaaaaeegiocaaaabaaaaaabfaaaaaafjaaaaaeegiocaaaacaaaaaa
adaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaa
dgaaaaafhccabaaaacaaaaaapgbpbaaaafaaaaaabaaaaaaibcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbccabaaaadaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
aaaaaaaaaeaaaaaaegiccaaaabaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaabaaaaaabaaaaaaaagiacaaaaaaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaabaaaaaabcaaaaaakgikcaaaaaaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaabaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaabaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaa
adaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaaaeaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaabaaaaaadeaaaaahbccabaaaaeaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadeaaaaahcccabaaaafaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaacaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadgaaaaafhccabaaaagaaaaaaegbcbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  highp float specular_6;
  mediump float gloss_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_9;
  tmpvar_9 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_7 = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_6 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_11;
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1);
  ambient_5 = tmpvar_12;
  mediump float nl_13;
  mediump vec3 lightColor_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = _TerrainTreeLightColors[0].xyz;
  lightColor_14 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = xlv_TEXCOORD2.x;
  nl_13 = tmpvar_16;
  light_3 = (lightColor_14 * nl_13);
  spec_2 = ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2.y, specular_6)) * gloss_7) * lightColor_14);
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[1].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD2_1.x;
  nl_17 = tmpvar_20;
  light_3 = (light_3 + (lightColor_18 * nl_17));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_6)) * gloss_7) * lightColor_18));
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[2].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD2_2.x;
  nl_21 = tmpvar_24;
  light_3 = (light_3 + (lightColor_22 * nl_21));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_6)) * gloss_7) * lightColor_22));
  highp vec3 tmpvar_25;
  tmpvar_25 = ((((tmpvar_8.xyz * light_3) + spec_2) * 2.0) + (ambient_5 * tmpvar_8.xyz));
  c_1.xyz = tmpvar_25;
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
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  highp float specular_6;
  mediump float gloss_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_9;
  tmpvar_9 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_7 = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_6 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_11;
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1);
  ambient_5 = tmpvar_12;
  mediump float nl_13;
  mediump vec3 lightColor_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = _TerrainTreeLightColors[0].xyz;
  lightColor_14 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = xlv_TEXCOORD2.x;
  nl_13 = tmpvar_16;
  light_3 = (lightColor_14 * nl_13);
  spec_2 = ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2.y, specular_6)) * gloss_7) * lightColor_14);
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[1].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD2_1.x;
  nl_17 = tmpvar_20;
  light_3 = (light_3 + (lightColor_18 * nl_17));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_6)) * gloss_7) * lightColor_18));
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[2].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD2_2.x;
  nl_21 = tmpvar_24;
  light_3 = (light_3 + (lightColor_22 * nl_21));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_6)) * gloss_7) * lightColor_22));
  highp vec3 tmpvar_25;
  tmpvar_25 = ((((tmpvar_8.xyz * light_3) + spec_2) * 2.0) + (ambient_5 * tmpvar_8.xyz));
  c_1.xyz = tmpvar_25;
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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform samplerCube _DiffCubeIBL;
#line 352
uniform highp vec4 ExposureIBL;
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 326
v2f vert( in appdata_full v ) {
    #line 328
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    #line 332
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 336
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        o.params[j].x = max( 0.0, nl);
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 340
        highp float nh = max( 0.0, dot( v.normal, h));
        o.params[j].y = nh;
    }
    o.color = vec3( v.color.w);
    #line 344
    o.normal = v.normal;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD2_1;
out highp vec2 xlv_TEXCOORD2_2;
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
    xlv_TEXCOORD2 = vec2(xl_retval.params[0]);
    xlv_TEXCOORD2_1 = vec2(xl_retval.params[1]);
    xlv_TEXCOORD2_2 = vec2(xl_retval.params[2]);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform samplerCube _DiffCubeIBL;
#line 352
uniform highp vec4 ExposureIBL;
#line 353
lowp vec4 frag( in v2f i ) {
    lowp vec3 albedo = texture( _MainTex, i.uv).xyz;
    #line 356
    mediump float gloss = texture( _TranslucencyMap, i.uv).w;
    highp float specular = (exp2(((10.0 * texture( _BumpSpecMap, i.uv).x) + 1.0)) - 1.75);
    mediump vec3 ambient;
    mediump vec4 diff_ibl = texture( _DiffCubeIBL, i.normal);
    #line 360
    diff_ibl.xyz = (diff_ibl.xyz * diff_ibl.w);
    ambient = ((diff_ibl.xyz * ExposureIBL.x) * i.color);
    mediump vec3 light = vec3( 0.0);
    highp vec3 spec = vec3( 0.0);
    #line 364
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 368
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump float nl = i.params[j].x;
        light += (lightColor * nl);
        highp float nh = i.params[j].y;
        #line 372
        spec += ((((specular * 0.125) * pow( nh, specular)) * gloss) * lightColor);
    }
    lowp vec4 c;
    c.xyz = ((((albedo * light) + spec) * 2.0) + (ambient * albedo));
    #line 376
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD2_1;
in highp vec2 xlv_TEXCOORD2_2;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.params[0] = vec2(xlv_TEXCOORD2);
    xlt_i.params[1] = vec2(xlv_TEXCOORD2_1);
    xlt_i.params[2] = vec2(xlv_TEXCOORD2_2);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_TerrainTreeLightDirections0]
Vector 12 [_TerrainTreeLightDirections1]
Vector 13 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, c[9];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R0.xyz, R0, c[10].w, -vertex.position;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[11];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, vertex.normal, R1;
MAX result.texcoord[2].y, R1.x, c[0];
MAD R1.xyz, R0.w, R0, c[12];
MAD R0.xyz, R0.w, R0, c[13];
DP3 R1.w, R1, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, vertex.normal, R0;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R0.w, vertex.normal, R1;
MAX result.texcoord[4].y, R0.x, c[0];
DP3 R0.x, vertex.normal, c[11];
MAX result.texcoord[2].x, R0, c[0].y;
DP3 R0.x, vertex.normal, c[12];
DP3 R0.y, vertex.normal, c[13];
MAX result.texcoord[3].y, R0.w, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[5].xyz, vertex.normal;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
MAX result.texcoord[3].x, R0, c[0].y;
MAX result.texcoord[4].x, R0.y, c[0].y;
END
# 39 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_TerrainTreeLightDirections0]
Vector 11 [_TerrainTreeLightDirections1]
Vector 12 [_TerrainTreeLightDirections2]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c13, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mov r1.w, c13.x
mov r1.xyz, c8
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r0.xyz, r0, c9.w, -v0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c10
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r1.x, v1, r1
max o3.y, r1.x, c13
mad r1.xyz, r0.w, r0, c11
mad r0.xyz, r0.w, r0, c12
dp3 r1.w, r1, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.x, v1, r0
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r0.w, v1, r1
max o5.y, r0.x, c13
dp3 r0.x, v1, c10
max o3.x, r0, c13.y
dp3 r0.x, v1, c11
dp3 r0.y, v1, c12
max o4.y, r0.w, c13
mov o2.xyz, v3.w
mov o6.xyz, v1
mov o1.xy, v2
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
max o4.x, r0, c13.y
max o5.x, r0.y, c13.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
BindCB "UnityTerrainImposter" 2
// 39 instructions, 2 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedneadceckelkhgdibckfdaabmbopgflbnabaaaaaabmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfaafaaaaeaaaabaafeabaaaafjaaaaaeegiocaaaaaaaaaaa
afaaaaaafjaaaaaeegiocaaaabaaaaaabfaaaaaafjaaaaaeegiocaaaacaaaaaa
adaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaa
dgaaaaafhccabaaaacaaaaaapgbpbaaaafaaaaaabaaaaaaibcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbccabaaaadaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
aaaaaaaaaeaaaaaaegiccaaaabaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaabaaaaaabaaaaaaaagiacaaaaaaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaabaaaaaabcaaaaaakgikcaaaaaaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaabaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaabaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaa
adaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaaaeaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaabaaaaaadeaaaaahbccabaaaaeaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadeaaaaahcccabaaaafaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaacaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadgaaaaafhccabaaaagaaaaaaegbcbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec3 ambient_4;
  highp float specular_5;
  mediump float gloss_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_8;
  tmpvar_8 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_6 = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_5 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1) * 2.0);
  ambient_4 = tmpvar_10;
  mediump float nl_11;
  mediump vec3 lightColor_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = _TerrainTreeLightColors[0].xyz;
  lightColor_12 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = xlv_TEXCOORD2.x;
  nl_11 = tmpvar_14;
  light_3 = (lightColor_12 * nl_11);
  spec_2 = ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2.y, specular_5)) * gloss_6) * lightColor_12);
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[1].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD2_1.x;
  nl_15 = tmpvar_18;
  light_3 = (light_3 + (lightColor_16 * nl_15));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_5)) * gloss_6) * lightColor_16));
  mediump float nl_19;
  mediump vec3 lightColor_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = _TerrainTreeLightColors[2].xyz;
  lightColor_20 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = xlv_TEXCOORD2_2.x;
  nl_19 = tmpvar_22;
  light_3 = (light_3 + (lightColor_20 * nl_19));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_5)) * gloss_6) * lightColor_20));
  highp vec3 tmpvar_23;
  tmpvar_23 = ((((tmpvar_7.xyz * light_3) + spec_2) * 2.0) + (ambient_4 * tmpvar_7.xyz));
  c_1.xyz = tmpvar_23;
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
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec3 ambient_4;
  highp float specular_5;
  mediump float gloss_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_8;
  tmpvar_8 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_6 = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_5 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1) * 2.0);
  ambient_4 = tmpvar_10;
  mediump float nl_11;
  mediump vec3 lightColor_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = _TerrainTreeLightColors[0].xyz;
  lightColor_12 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = xlv_TEXCOORD2.x;
  nl_11 = tmpvar_14;
  light_3 = (lightColor_12 * nl_11);
  spec_2 = ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2.y, specular_5)) * gloss_6) * lightColor_12);
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[1].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD2_1.x;
  nl_15 = tmpvar_18;
  light_3 = (light_3 + (lightColor_16 * nl_15));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_5)) * gloss_6) * lightColor_16));
  mediump float nl_19;
  mediump vec3 lightColor_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = _TerrainTreeLightColors[2].xyz;
  lightColor_20 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = xlv_TEXCOORD2_2.x;
  nl_19 = tmpvar_22;
  light_3 = (light_3 + (lightColor_20 * nl_19));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_5)) * gloss_6) * lightColor_20));
  highp vec3 tmpvar_23;
  tmpvar_23 = ((((tmpvar_7.xyz * light_3) + spec_2) * 2.0) + (ambient_4 * tmpvar_7.xyz));
  c_1.xyz = tmpvar_23;
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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform highp vec4 ExposureIBL;
#line 352
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 326
v2f vert( in appdata_full v ) {
    #line 328
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    #line 332
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 336
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        o.params[j].x = max( 0.0, nl);
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 340
        highp float nh = max( 0.0, dot( v.normal, h));
        o.params[j].y = nh;
    }
    o.color = vec3( v.color.w);
    #line 344
    o.normal = v.normal;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD2_1;
out highp vec2 xlv_TEXCOORD2_2;
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
    xlv_TEXCOORD2 = vec2(xl_retval.params[0]);
    xlv_TEXCOORD2_1 = vec2(xl_retval.params[1]);
    xlv_TEXCOORD2_2 = vec2(xl_retval.params[2]);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform highp vec4 ExposureIBL;
#line 352
#line 352
lowp vec4 frag( in v2f i ) {
    lowp vec3 albedo = texture( _MainTex, i.uv).xyz;
    mediump float gloss = texture( _TranslucencyMap, i.uv).w;
    #line 356
    highp float specular = (exp2(((10.0 * texture( _BumpSpecMap, i.uv).x) + 1.0)) - 1.75);
    mediump vec3 ambient;
    ambient = ((vec3( glstate_lightmodel_ambient) * i.color) * 2.0);
    mediump vec3 light = vec3( 0.0);
    #line 360
    highp vec3 spec = vec3( 0.0);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 365
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump float nl = i.params[j].x;
        light += (lightColor * nl);
        highp float nh = i.params[j].y;
        #line 369
        spec += ((((specular * 0.125) * pow( nh, specular)) * gloss) * lightColor);
    }
    lowp vec4 c;
    c.xyz = ((((albedo * light) + spec) * 2.0) + (ambient * albedo));
    #line 373
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD2_1;
in highp vec2 xlv_TEXCOORD2_2;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.params[0] = vec2(xlv_TEXCOORD2);
    xlt_i.params[1] = vec2(xlv_TEXCOORD2_1);
    xlt_i.params[2] = vec2(xlv_TEXCOORD2_2);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_TerrainTreeLightDirections0]
Vector 12 [_TerrainTreeLightDirections1]
Vector 13 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, c[9];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R0.xyz, R0, c[10].w, -vertex.position;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[11];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, vertex.normal, R1;
MAX result.texcoord[2].y, R1.x, c[0];
MAD R1.xyz, R0.w, R0, c[12];
MAD R0.xyz, R0.w, R0, c[13];
DP3 R1.w, R1, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, vertex.normal, R0;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R0.w, vertex.normal, R1;
MAX result.texcoord[4].y, R0.x, c[0];
DP3 R0.x, vertex.normal, c[11];
MAX result.texcoord[2].x, R0, c[0].y;
DP3 R0.x, vertex.normal, c[12];
DP3 R0.y, vertex.normal, c[13];
MAX result.texcoord[3].y, R0.w, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[5].xyz, vertex.normal;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
MAX result.texcoord[3].x, R0, c[0].y;
MAX result.texcoord[4].x, R0.y, c[0].y;
END
# 39 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_TerrainTreeLightDirections0]
Vector 11 [_TerrainTreeLightDirections1]
Vector 12 [_TerrainTreeLightDirections2]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c13, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mov r1.w, c13.x
mov r1.xyz, c8
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r0.xyz, r0, c9.w, -v0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c10
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r1.x, v1, r1
max o3.y, r1.x, c13
mad r1.xyz, r0.w, r0, c11
mad r0.xyz, r0.w, r0, c12
dp3 r1.w, r1, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.x, v1, r0
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r0.w, v1, r1
max o5.y, r0.x, c13
dp3 r0.x, v1, c10
max o3.x, r0, c13.y
dp3 r0.x, v1, c11
dp3 r0.y, v1, c12
max o4.y, r0.w, c13
mov o2.xyz, v3.w
mov o6.xyz, v1
mov o1.xy, v2
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
max o4.x, r0, c13.y
max o5.x, r0.y, c13.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
BindCB "UnityTerrainImposter" 2
// 39 instructions, 2 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedneadceckelkhgdibckfdaabmbopgflbnabaaaaaabmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfaafaaaaeaaaabaafeabaaaafjaaaaaeegiocaaaaaaaaaaa
afaaaaaafjaaaaaeegiocaaaabaaaaaabfaaaaaafjaaaaaeegiocaaaacaaaaaa
adaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaa
dgaaaaafhccabaaaacaaaaaapgbpbaaaafaaaaaabaaaaaaibcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbccabaaaadaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
aaaaaaaaaeaaaaaaegiccaaaabaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaabaaaaaabaaaaaaaagiacaaaaaaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaabaaaaaabcaaaaaakgikcaaaaaaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaabaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaabaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaa
adaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaaaeaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaabaaaaaadeaaaaahbccabaaaaeaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadeaaaaahcccabaaaafaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaacaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadgaaaaafhccabaaaagaaaaaaegbcbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  highp float specular_6;
  mediump float gloss_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_9;
  tmpvar_9 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_7 = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_6 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_11;
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1);
  ambient_5 = tmpvar_12;
  mediump float nl_13;
  mediump vec3 lightColor_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = _TerrainTreeLightColors[0].xyz;
  lightColor_14 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = xlv_TEXCOORD2.x;
  nl_13 = tmpvar_16;
  light_3 = (lightColor_14 * nl_13);
  spec_2 = ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2.y, specular_6)) * gloss_7) * lightColor_14);
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[1].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD2_1.x;
  nl_17 = tmpvar_20;
  light_3 = (light_3 + (lightColor_18 * nl_17));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_6)) * gloss_7) * lightColor_18));
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[2].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD2_2.x;
  nl_21 = tmpvar_24;
  light_3 = (light_3 + (lightColor_22 * nl_21));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_6)) * gloss_7) * lightColor_22));
  highp vec3 tmpvar_25;
  tmpvar_25 = ((((tmpvar_8.xyz * light_3) + spec_2) * 2.0) + (ambient_5 * tmpvar_8.xyz));
  c_1.xyz = tmpvar_25;
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
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 ExposureIBL;
uniform samplerCube _DiffCubeIBL;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec4 diff_ibl_4;
  mediump vec3 ambient_5;
  highp float specular_6;
  mediump float gloss_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_9;
  tmpvar_9 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_7 = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_6 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = textureCube (_DiffCubeIBL, xlv_TEXCOORD5);
  diff_ibl_4 = tmpvar_11;
  diff_ibl_4.xyz = (diff_ibl_4.xyz * diff_ibl_4.w);
  highp vec3 tmpvar_12;
  tmpvar_12 = ((diff_ibl_4.xyz * ExposureIBL.x) * xlv_TEXCOORD1);
  ambient_5 = tmpvar_12;
  mediump float nl_13;
  mediump vec3 lightColor_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = _TerrainTreeLightColors[0].xyz;
  lightColor_14 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = xlv_TEXCOORD2.x;
  nl_13 = tmpvar_16;
  light_3 = (lightColor_14 * nl_13);
  spec_2 = ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2.y, specular_6)) * gloss_7) * lightColor_14);
  mediump float nl_17;
  mediump vec3 lightColor_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = _TerrainTreeLightColors[1].xyz;
  lightColor_18 = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = xlv_TEXCOORD2_1.x;
  nl_17 = tmpvar_20;
  light_3 = (light_3 + (lightColor_18 * nl_17));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_6)) * gloss_7) * lightColor_18));
  mediump float nl_21;
  mediump vec3 lightColor_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = _TerrainTreeLightColors[2].xyz;
  lightColor_22 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = xlv_TEXCOORD2_2.x;
  nl_21 = tmpvar_24;
  light_3 = (light_3 + (lightColor_22 * nl_21));
  spec_2 = (spec_2 + ((((specular_6 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_6)) * gloss_7) * lightColor_22));
  highp vec3 tmpvar_25;
  tmpvar_25 = ((((tmpvar_8.xyz * light_3) + spec_2) * 2.0) + (ambient_5 * tmpvar_8.xyz));
  c_1.xyz = tmpvar_25;
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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform samplerCube _DiffCubeIBL;
#line 352
uniform highp vec4 ExposureIBL;
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 326
v2f vert( in appdata_full v ) {
    #line 328
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    #line 332
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 336
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        o.params[j].x = max( 0.0, nl);
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 340
        highp float nh = max( 0.0, dot( v.normal, h));
        o.params[j].y = nh;
    }
    o.color = vec3( v.color.w);
    #line 344
    o.normal = v.normal;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD2_1;
out highp vec2 xlv_TEXCOORD2_2;
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
    xlv_TEXCOORD2 = vec2(xl_retval.params[0]);
    xlv_TEXCOORD2_1 = vec2(xl_retval.params[1]);
    xlv_TEXCOORD2_2 = vec2(xl_retval.params[2]);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform samplerCube _DiffCubeIBL;
#line 352
uniform highp vec4 ExposureIBL;
#line 353
lowp vec4 frag( in v2f i ) {
    lowp vec3 albedo = texture( _MainTex, i.uv).xyz;
    #line 356
    mediump float gloss = texture( _TranslucencyMap, i.uv).w;
    highp float specular = (exp2(((10.0 * texture( _BumpSpecMap, i.uv).x) + 1.0)) - 1.75);
    mediump vec3 ambient;
    mediump vec4 diff_ibl = texture( _DiffCubeIBL, i.normal);
    #line 360
    diff_ibl.xyz = (diff_ibl.xyz * diff_ibl.w);
    ambient = ((diff_ibl.xyz * ExposureIBL.x) * i.color);
    mediump vec3 light = vec3( 0.0);
    highp vec3 spec = vec3( 0.0);
    #line 364
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 368
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump float nl = i.params[j].x;
        light += (lightColor * nl);
        highp float nh = i.params[j].y;
        #line 372
        spec += ((((specular * 0.125) * pow( nh, specular)) * gloss) * lightColor);
    }
    lowp vec4 c;
    c.xyz = ((((albedo * light) + spec) * 2.0) + (ambient * albedo));
    #line 376
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD2_1;
in highp vec2 xlv_TEXCOORD2_2;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.params[0] = vec2(xlv_TEXCOORD2);
    xlt_i.params[1] = vec2(xlv_TEXCOORD2_1);
    xlt_i.params[2] = vec2(xlv_TEXCOORD2_2);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

SubProgram "opengl " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_TerrainTreeLightDirections0]
Vector 12 [_TerrainTreeLightDirections1]
Vector 13 [_TerrainTreeLightDirections2]
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, c[9];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R0.xyz, R0, c[10].w, -vertex.position;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, R0, c[11];
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.x, vertex.normal, R1;
MAX result.texcoord[2].y, R1.x, c[0];
MAD R1.xyz, R0.w, R0, c[12];
MAD R0.xyz, R0.w, R0, c[13];
DP3 R1.w, R1, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, vertex.normal, R0;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP3 R0.w, vertex.normal, R1;
MAX result.texcoord[4].y, R0.x, c[0];
DP3 R0.x, vertex.normal, c[11];
MAX result.texcoord[2].x, R0, c[0].y;
DP3 R0.x, vertex.normal, c[12];
DP3 R0.y, vertex.normal, c[13];
MAX result.texcoord[3].y, R0.w, c[0];
MOV result.texcoord[1].xyz, vertex.color.w;
MOV result.texcoord[5].xyz, vertex.normal;
MOV result.texcoord[0].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
MAX result.texcoord[3].x, R0, c[0].y;
MAX result.texcoord[4].x, R0.y, c[0].y;
END
# 39 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_TerrainTreeLightDirections0]
Vector 11 [_TerrainTreeLightDirections1]
Vector 12 [_TerrainTreeLightDirections2]
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
def c13, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_color0 v3
mov r1.w, c13.x
mov r1.xyz, c8
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r0.xyz, r0, c9.w, -v0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad r1.xyz, r0.w, r0, c10
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r1.x, v1, r1
max o3.y, r1.x, c13
mad r1.xyz, r0.w, r0, c11
mad r0.xyz, r0.w, r0, c12
dp3 r1.w, r1, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.x, v1, r0
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r0.w, v1, r1
max o5.y, r0.x, c13
dp3 r0.x, v1, c10
max o3.x, r0, c13.y
dp3 r0.x, v1, c11
dp3 r0.y, v1, c12
max o4.y, r0.w, c13
mov o2.xyz, v3.w
mov o6.xyz, v1
mov o1.xy, v2
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
max o4.x, r0, c13.y
max o5.x, r0.y, c13.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "color" Color
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
ConstBuffer "UnityTerrainImposter" 128 // 60 used size, 2 vars
Vector 0 [_TerrainTreeLightDirections0] 3
Vector 16 [_TerrainTreeLightDirections1] 3
Vector 32 [_TerrainTreeLightDirections2] 3
Vector 48 [_TerrainTreeLightDirections3] 3
BindCB "UnityPerCamera" 0
BindCB "UnityPerDraw" 1
BindCB "UnityTerrainImposter" 2
// 39 instructions, 2 temp regs, 0 temp arrays:
// ALU 35 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedneadceckelkhgdibckfdaabmbopgflbnabaaaaaabmahaaaaadaaaaaa
cmaaaaaapeaaaaaameabaaaaejfdeheomaaaaaaaagaaaaaaaiaaaaaajiaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaakbaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaapaaaaaakjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaadaaaaaaapadaaaalaaaaaaa
abaaaaaaaaaaaaaaadaaaaaaaeaaaaaaapaaaaaaljaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaafaaaaaaapaiaaaafaepfdejfeejepeoaafeebeoehefeofeaaeoepfc
enebemaafeeffiedepepfceeaaedepemepfcaaklepfdeheomiaaaaaaahaaaaaa
aiaaaaaalaaaaaaaaaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaalmaaaaaaabaaaaaaaaaaaaaa
adaaaaaaacaaaaaaahaiaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaa
adamaaaalmaaaaaaadaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadamaaaalmaaaaaa
aeaaaaaaaaaaaaaaadaaaaaaafaaaaaaadamaaaalmaaaaaaafaaaaaaaaaaaaaa
adaaaaaaagaaaaaaahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfcee
aaklklklfdeieefcfaafaaaaeaaaabaafeabaaaafjaaaaaeegiocaaaaaaaaaaa
afaaaaaafjaaaaaeegiocaaaabaaaaaabfaaaaaafjaaaaaeegiocaaaacaaaaaa
adaaaaaafpaaaaadpcbabaaaaaaaaaaafpaaaaadhcbabaaaacaaaaaafpaaaaad
dcbabaaaadaaaaaafpaaaaadicbabaaaafaaaaaaghaaaaaepccabaaaaaaaaaaa
abaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaagfaaaaad
dccabaaaadaaaaaagfaaaaaddccabaaaaeaaaaaagfaaaaaddccabaaaafaaaaaa
gfaaaaadhccabaaaagaaaaaagiaaaaacacaaaaaadiaaaaaipcaabaaaaaaaaaaa
fgbfbaaaaaaaaaaaegiocaaaabaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaa
egiocaaaabaaaaaaaaaaaaaaagbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaak
pcaabaaaaaaaaaaaegiocaaaabaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaa
aaaaaaaadcaaaaakpccabaaaaaaaaaaaegiocaaaabaaaaaaadaaaaaapgbpbaaa
aaaaaaaaegaobaaaaaaaaaaadgaaaaafdccabaaaabaaaaaaegbabaaaadaaaaaa
dgaaaaafhccabaaaacaaaaaapgbpbaaaafaaaaaabaaaaaaibcaabaaaaaaaaaaa
egbcbaaaacaaaaaaegiccaaaacaaaaaaaaaaaaaadeaaaaahbccabaaaadaaaaaa
akaabaaaaaaaaaaaabeaaaaaaaaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaa
aaaaaaaaaeaaaaaaegiccaaaabaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaa
egiccaaaabaaaaaabaaaaaaaagiacaaaaaaaaaaaaeaaaaaaegacbaaaaaaaaaaa
dcaaaaalhcaabaaaaaaaaaaaegiccaaaabaaaaaabcaaaaaakgikcaaaaaaaaaaa
aeaaaaaaegacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaa
egiccaaaabaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaa
pgipcaaaabaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaa
aaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaa
dkaabaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaaegacbaaaaaaaaaaapgapbaaa
aaaaaaaaegiccaaaacaaaaaaaaaaaaaabaaaaaahicaabaaaabaaaaaaegacbaaa
abaaaaaaegacbaaaabaaaaaaeeaaaaaficaabaaaabaaaaaadkaabaaaabaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaabaaaaaaegacbaaaabaaaaaabaaaaaah
bcaabaaaabaaaaaaegbcbaaaacaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaa
adaaaaaaakaabaaaabaaaaaaabeaaaaaaaaaaaaadcaaaaakhcaabaaaabaaaaaa
egacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaaabaaaaaadcaaaaak
hcaabaaaaaaaaaaaegacbaaaaaaaaaaapgapbaaaaaaaaaaaegiccaaaacaaaaaa
acaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaabaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaabaaaaaa
pgapbaaaaaaaaaaaegacbaaaabaaaaaabaaaaaahicaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaabaaaaaadeaaaaahcccabaaaaeaaaaaadkaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaiicaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaabaaaaaadeaaaaahbccabaaaaeaaaaaadkaabaaaaaaaaaaaabeaaaaa
aaaaaaaabaaaaaahicaabaaaaaaaaaaaegacbaaaaaaaaaaaegacbaaaaaaaaaaa
eeaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaadiaaaaahhcaabaaaaaaaaaaa
pgapbaaaaaaaaaaaegacbaaaaaaaaaaabaaaaaahbcaabaaaaaaaaaaaegbcbaaa
acaaaaaaegacbaaaaaaaaaaadeaaaaahcccabaaaafaaaaaaakaabaaaaaaaaaaa
abeaaaaaaaaaaaaabaaaaaaibcaabaaaaaaaaaaaegbcbaaaacaaaaaaegiccaaa
acaaaaaaacaaaaaadeaaaaahbccabaaaafaaaaaaakaabaaaaaaaaaaaabeaaaaa
aaaaaaaadgaaaaafhccabaaaagaaaaaaegbcbaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
"!!GLES


#ifdef VERTEX

varying highp vec3 xlv_TEXCOORD5;
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec3 ambient_4;
  highp float specular_5;
  mediump float gloss_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_8;
  tmpvar_8 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_6 = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_5 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1) * 2.0);
  ambient_4 = tmpvar_10;
  mediump float nl_11;
  mediump vec3 lightColor_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = _TerrainTreeLightColors[0].xyz;
  lightColor_12 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = xlv_TEXCOORD2.x;
  nl_11 = tmpvar_14;
  light_3 = (lightColor_12 * nl_11);
  spec_2 = ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2.y, specular_5)) * gloss_6) * lightColor_12);
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[1].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD2_1.x;
  nl_15 = tmpvar_18;
  light_3 = (light_3 + (lightColor_16 * nl_15));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_5)) * gloss_6) * lightColor_16));
  mediump float nl_19;
  mediump vec3 lightColor_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = _TerrainTreeLightColors[2].xyz;
  lightColor_20 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = xlv_TEXCOORD2_2.x;
  nl_19 = tmpvar_22;
  light_3 = (light_3 + (lightColor_20 * nl_19));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_5)) * gloss_6) * lightColor_20));
  highp vec3 tmpvar_23;
  tmpvar_23 = ((((tmpvar_7.xyz * light_3) + spec_2) * 2.0) + (ambient_4 * tmpvar_7.xyz));
  c_1.xyz = tmpvar_23;
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
varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;
uniform highp mat4 glstate_matrix_mvp;
uniform highp vec3 _WorldSpaceCameraPos;
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
  highp vec2 tmpvar_4;
  highp vec2 tmpvar_5;
  highp vec2 tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  viewDir_2 = normalize((((_World2Object * tmpvar_7).xyz * unity_Scale.w) - _glesVertex.xyz));
  mediump vec3 h_8;
  mediump float nl_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = _TerrainTreeLightDirections[0];
  highp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, tmpvar_10);
  nl_9 = tmpvar_11;
  mediump float tmpvar_12;
  tmpvar_12 = max (0.0, nl_9);
  tmpvar_4.x = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_10 + viewDir_2));
  h_8 = tmpvar_13;
  tmpvar_4.y = max (0.0, dot (tmpvar_1, h_8));
  mediump vec3 h_14;
  mediump float nl_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = _TerrainTreeLightDirections[1];
  highp float tmpvar_17;
  tmpvar_17 = dot (tmpvar_1, tmpvar_16);
  nl_15 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = max (0.0, nl_15);
  tmpvar_5.x = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_16 + viewDir_2));
  h_14 = tmpvar_19;
  tmpvar_5.y = max (0.0, dot (tmpvar_1, h_14));
  mediump vec3 h_20;
  mediump float nl_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = _TerrainTreeLightDirections[2];
  highp float tmpvar_23;
  tmpvar_23 = dot (tmpvar_1, tmpvar_22);
  nl_21 = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = max (0.0, nl_21);
  tmpvar_6.x = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize((tmpvar_22 + viewDir_2));
  h_20 = tmpvar_25;
  tmpvar_6.y = max (0.0, dot (tmpvar_1, h_20));
  lowp vec3 tmpvar_26;
  tmpvar_26 = _glesColor.www;
  tmpvar_3 = tmpvar_26;
  gl_Position = (glstate_matrix_mvp * _glesVertex);
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD2_1 = tmpvar_5;
  xlv_TEXCOORD2_2 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD2_2;
varying highp vec2 xlv_TEXCOORD2_1;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D _TranslucencyMap;
uniform sampler2D _BumpSpecMap;
uniform sampler2D _MainTex;
uniform highp vec4 _TerrainTreeLightColors[4];
uniform highp vec4 glstate_lightmodel_ambient;
void main ()
{
  lowp vec4 c_1;
  highp vec3 spec_2;
  mediump vec3 light_3;
  mediump vec3 ambient_4;
  highp float specular_5;
  mediump float gloss_6;
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2D (_MainTex, xlv_TEXCOORD0);
  lowp float tmpvar_8;
  tmpvar_8 = texture2D (_TranslucencyMap, xlv_TEXCOORD0).w;
  gloss_6 = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = (exp2(((10.0 * texture2D (_BumpSpecMap, xlv_TEXCOORD0).x) + 1.0)) - 1.75);
  specular_5 = tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_10 = ((glstate_lightmodel_ambient.xyz * xlv_TEXCOORD1) * 2.0);
  ambient_4 = tmpvar_10;
  mediump float nl_11;
  mediump vec3 lightColor_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = _TerrainTreeLightColors[0].xyz;
  lightColor_12 = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = xlv_TEXCOORD2.x;
  nl_11 = tmpvar_14;
  light_3 = (lightColor_12 * nl_11);
  spec_2 = ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2.y, specular_5)) * gloss_6) * lightColor_12);
  mediump float nl_15;
  mediump vec3 lightColor_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = _TerrainTreeLightColors[1].xyz;
  lightColor_16 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = xlv_TEXCOORD2_1.x;
  nl_15 = tmpvar_18;
  light_3 = (light_3 + (lightColor_16 * nl_15));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_1.y, specular_5)) * gloss_6) * lightColor_16));
  mediump float nl_19;
  mediump vec3 lightColor_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = _TerrainTreeLightColors[2].xyz;
  lightColor_20 = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = xlv_TEXCOORD2_2.x;
  nl_19 = tmpvar_22;
  light_3 = (light_3 + (lightColor_20 * nl_19));
  spec_2 = (spec_2 + ((((specular_5 * 0.125) * pow (xlv_TEXCOORD2_2.y, specular_5)) * gloss_6) * lightColor_20));
  highp vec3 tmpvar_23;
  tmpvar_23 = ((((tmpvar_7.xyz * light_3) + spec_2) * 2.0) + (ambient_4 * tmpvar_7.xyz));
  c_1.xyz = tmpvar_23;
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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform highp vec4 ExposureIBL;
#line 352
#line 91
highp vec3 ObjSpaceViewDir( in highp vec4 v ) {
    highp vec3 objSpaceCameraPos = ((_World2Object * vec4( _WorldSpaceCameraPos.xyz, 1.0)).xyz * unity_Scale.w);
    return (objSpaceCameraPos - v.xyz);
}
#line 326
v2f vert( in appdata_full v ) {
    #line 328
    v2f o;
    o.pos = (glstate_matrix_mvp * v.vertex);
    o.uv = v.texcoord.xy;
    highp vec3 viewDir = normalize(ObjSpaceViewDir( v.vertex));
    #line 332
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 336
        highp vec3 lightDir = _TerrainTreeLightDirections[j];
        mediump float nl = dot( v.normal, lightDir);
        o.params[j].x = max( 0.0, nl);
        mediump vec3 h = normalize((lightDir + viewDir));
        #line 340
        highp float nh = max( 0.0, dot( v.normal, h));
        o.params[j].y = nh;
    }
    o.color = vec3( v.color.w);
    #line 344
    o.normal = v.normal;
    return o;
}

out highp vec2 xlv_TEXCOORD0;
out highp vec3 xlv_TEXCOORD1;
out highp vec2 xlv_TEXCOORD2;
out highp vec2 xlv_TEXCOORD2_1;
out highp vec2 xlv_TEXCOORD2_2;
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
    xlv_TEXCOORD2 = vec2(xl_retval.params[0]);
    xlv_TEXCOORD2_1 = vec2(xl_retval.params[1]);
    xlv_TEXCOORD2_2 = vec2(xl_retval.params[2]);
    xlv_TEXCOORD5 = vec3(xl_retval.normal);
}


#endif
#ifdef FRAGMENT

#define gl_FragData _glesFragData
layout(location = 0) out mediump vec4 _glesFragData[4];

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
struct v2f {
    highp vec4 pos;
    highp vec2 uv;
    highp vec3 color;
    highp vec2 params[3];
    highp vec3 normal;
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
#line 324
uniform highp vec3 _TerrainTreeLightDirections[4];
uniform highp vec4 _TerrainTreeLightColors[4];
uniform sampler2D _MainTex;
#line 348
uniform sampler2D _BumpSpecMap;
uniform sampler2D _TranslucencyMap;
uniform lowp vec4 _SpecColor;
uniform highp vec4 ExposureIBL;
#line 352
#line 352
lowp vec4 frag( in v2f i ) {
    lowp vec3 albedo = texture( _MainTex, i.uv).xyz;
    mediump float gloss = texture( _TranslucencyMap, i.uv).w;
    #line 356
    highp float specular = (exp2(((10.0 * texture( _BumpSpecMap, i.uv).x) + 1.0)) - 1.75);
    mediump vec3 ambient;
    ambient = ((vec3( glstate_lightmodel_ambient) * i.color) * 2.0);
    mediump vec3 light = vec3( 0.0);
    #line 360
    highp vec3 spec = vec3( 0.0);
    highp int j = 0;
    for ( ; (j < 3); (j++)) {
        #line 365
        mediump vec3 lightColor = _TerrainTreeLightColors[j].xyz;
        mediump float nl = i.params[j].x;
        light += (lightColor * nl);
        highp float nh = i.params[j].y;
        #line 369
        spec += ((((specular * 0.125) * pow( nh, specular)) * gloss) * lightColor);
    }
    lowp vec4 c;
    c.xyz = ((((albedo * light) + spec) * 2.0) + (ambient * albedo));
    #line 373
    c.w = 1.0;
    return c;
}
in highp vec2 xlv_TEXCOORD0;
in highp vec3 xlv_TEXCOORD1;
in highp vec2 xlv_TEXCOORD2;
in highp vec2 xlv_TEXCOORD2_1;
in highp vec2 xlv_TEXCOORD2_2;
in highp vec3 xlv_TEXCOORD5;
void main() {
    lowp vec4 xl_retval;
    v2f xlt_i;
    xlt_i.pos = vec4(0.0);
    xlt_i.uv = vec2(xlv_TEXCOORD0);
    xlt_i.color = vec3(xlv_TEXCOORD1);
    xlt_i.params[0] = vec2(xlv_TEXCOORD2);
    xlt_i.params[1] = vec2(xlv_TEXCOORD2_1);
    xlt_i.params[2] = vec2(xlv_TEXCOORD2_2);
    xlt_i.normal = vec3(xlv_TEXCOORD5);
    xl_retval = frag( xlt_i);
    gl_FragData[0] = vec4(xl_retval);
}


#endif"
}

}
Program "fp" {
// Fragment combos: 8
//   opengl - ALU: 28 to 43, TEX: 3 to 4
//   d3d9 - ALU: 33 to 82, TEX: 3 to 4
//   d3d11 - ALU: 18 to 25, TEX: 3 to 4, FLOW: 2 to 2
SubProgram "opengl " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Vector 0 [_TerrainTreeLightColors0]
Vector 1 [_TerrainTreeLightColors1]
Vector 2 [_TerrainTreeLightColors2]
Vector 3 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"3.0-!!ARBfp1.0
# 43 ALU, 4 TEX
PARAM c[7] = { program.local[0..3],
		{ 1, 0.45458984, 10, 1.75 },
		{ 0.125, 2, 0.30541992, 0.68212891 },
		{ 0.012519836 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R3.w, c[4].y;
TEX R0.x, fragment.texcoord[0], texture[2], 2D;
MAD R0.x, R0, c[4].z, c[4];
EX2 R0.x, R0.x;
ADD R2.w, R0.x, -c[4];
POW R0.x, fragment.texcoord[2].y, R2.w;
POW R4.x, fragment.texcoord[4].y, R2.w;
POW R0.y, fragment.texcoord[3].y, R2.w;
MUL R1.w, R2, R0.x;
MUL R0.x, R2.w, R0.y;
TEX R0.w, fragment.texcoord[0], texture[1], 2D;
MUL R1.x, R0.w, R0;
MUL R1.w, R0, R1;
MUL R4.x, R2.w, R4;
MUL R0.w, R4.x, R0;
POW R2.x, c[0].x, R3.w;
POW R2.y, c[0].y, R3.w;
POW R2.z, c[0].z, R3.w;
POW R0.x, c[1].x, R3.w;
POW R0.z, c[1].z, R3.w;
POW R0.y, c[1].y, R3.w;
MUL R1.xyz, R1.x, R0;
MAD R3.xyz, R1.w, R2, R1;
TEX R1, fragment.texcoord[5], texture[3], CUBE;
MAD R4.y, R1.w, c[5].z, c[5].w;
MAD R2.w, R1, R4.y, c[6].x;
MUL R0.xyz, fragment.texcoord[3].x, R0;
POW R4.x, c[2].x, R3.w;
POW R4.y, c[2].y, R3.w;
POW R4.z, c[2].z, R3.w;
MAD R3.xyz, R0.w, R4, R3;
MAD R0.xyz, fragment.texcoord[2].x, R2, R0;
MUL R0.w, R1, R2;
MUL R1.xyz, R1, R0.w;
MUL R1.xyz, R1, c[3].x;
MUL R2.xyz, R1, fragment.texcoord[1];
TEX R1.xyz, fragment.texcoord[0], texture[0], 2D;
MAD R0.xyz, fragment.texcoord[4].x, R4, R0;
MUL R0.xyz, R1, R0;
MUL R1.xyz, R1, R2;
MAD R0.xyz, R3, c[5].x, R0;
MAD result.color.xyz, R0, c[5].y, R1;
MOV result.color.w, c[4].x;
END
# 43 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Vector 0 [_TerrainTreeLightColors0]
Vector 1 [_TerrainTreeLightColors1]
Vector 2 [_TerrainTreeLightColors2]
Vector 3 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"ps_3_0
; 82 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c4, 10.00000000, 1.00000000, -1.75000000, 0.01251984
def c5, 0.30541992, 0.68212891, 0.45458984, 0.12500000
def c6, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xy
dcl_texcoord5 v5.xyz
texld r0.x, v0, s2
mad r0.x, r0, c4, c4.y
exp r0.x, r0.x
add r3.w, r0.x, c4.z
pow r1, v3.y, r3.w
mov_pp r1.y, c5.z
pow_pp r0, c1.x, r1.y
mov r0.y, r1.x
mov_pp r0.z, c5
pow_pp r2, c1.z, r0.z
mov_pp r0.z, r2
texld r2, v5, s3
mul r0.y, r3.w, r0
texld r0.w, v0, s1
mul r3.x, r0.w, r0.y
mov_pp r0.y, c5.z
pow_pp r1, c1.y, r0.y
mov_pp r0.y, r1
mul r4.xyz, r3.x, r0
pow r1, v2.y, r3.w
mov r3.y, r1.x
mov_pp r3.x, c5.z
pow_pp r1, c0.x, r3.x
mul r1.y, r3.w, r3
mov_pp r3.x, r1
mov_pp r1.x, c5.z
pow_pp r5, c0.y, r1.x
mul r4.w, r0, r1.y
mov_pp r3.y, c5.z
pow_pp r1, c0.z, r3.y
mov_pp r3.z, r1
mov_pp r3.y, r5
mad r4.xyz, r4.w, r3, r4
pow r1, v4.y, r3.w
mad_pp r4.w, r2, c5.x, c5.y
mul_pp r0.xyz, v3.x, r0
mov r5.y, r1.x
mov_pp r5.x, c5.z
pow_pp r1, c2.x, r5.x
mul r1.y, r3.w, r5
mov_pp r6.x, r1
mov_pp r1.x, c5.z
pow_pp r5, c2.y, r1.x
mul r0.w, r1.y, r0
mov_pp r3.w, c5.z
pow_pp r1, c2.z, r3.w
mov_pp r6.z, r1
mov_pp r6.y, r5
mad_pp r0.xyz, v2.x, r3, r0
mad r1.xyz, r0.w, r6, r4
mad_pp r4.w, r2, r4, c4
mul_pp r0.w, r2, r4
mul_pp r2.xyz, r2, r0.w
mul r2.xyz, r2, c3.x
mul r3.xyz, r2, v1
texld r2.xyz, v0, s0
mad_pp r0.xyz, v4.x, r6, r0
mul_pp r0.xyz, r2, r0
mul_pp r2.xyz, r2, r3
mad r0.xyz, r1, c5.w, r0
mad oC0.xyz, r0, c6.x, r2
mov_pp oC0.w, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
ConstBuffer "$Globals" 48 // 48 used size, 3 vars
Vector 32 [ExposureIBL] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_TranslucencyMap] 2D 2
SetTexture 2 [_BumpSpecMap] 2D 1
SetTexture 3 [_DiffCubeIBL] CUBE 3
// 36 instructions, 5 temp regs, 0 temp arrays:
// ALU 23 float, 2 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedfpgohmeiajgibmbfpejgkfmkamjkfbhgabaaaaaadaagaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcpiaeaaaaeaaaaaaadoabaaaa
fjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaiaaaeegiocaaaabaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fidaaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaa
gcbaaaaddcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacafaaaaaaflaaaaaedcbabaaaadaaaaaaadaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaabaaaaaadcaaaaajicaabaaaaaaaaaaaakaabaaaacaaaaaaabeaaaaa
aaaacaebabeaaaaaaaaaiadpbjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
aaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaoalpefaaaaaj
pcaabaaaacaaaaaaegbcbaaaagaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaa
dcaaaaajbcaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaabcfbjmdoabeaaaaa
mekccodpdcaaaaajbcaabaaaabaaaaaadkaabaaaacaaaaaaakaabaaaabaaaaaa
abeaaaaamccmendmdiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaadkaabaaa
acaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaagiacaaaaaaaaaaaacaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaacaaaaaadiaaaaah
bcaabaaaacaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaadodgaaaaaiocaabaaa
acaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaaipcaabaaa
adaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadaaaaaabcbaaaaah
bcaabaaaaeaaaaaadkaabaaaadaaaaaaabeaaaaaadaaaaaaadaaaeadakaabaaa
aeaaaaaacpaaaaaihcaabaaaaeaaaaaaegiccaagabaaaaaaaeaaaaaadkaabaaa
adaaaaaadiaaaaakhcaabaaaaeaaaaaaegacbaaaaeaaaaaaaceaaaaacplkoido
cplkoidocplkoidoaaaaaaaabjaaaaafhcaabaaaaeaaaaaaegacbaaaaeaaaaaa
dcaaaaalocaabaaaacaaaaaaagajbaaaaeaaaaaaagbanaaaadaaaaaadkaabaaa
adaaaaaafgaobaaaacaaaaaacpaaaaahicaabaaaaeaaaaaabkbanaaaadaaaaaa
dkaabaaaadaaaaaadiaaaaahicaabaaaaeaaaaaadkaabaaaaaaaaaaadkaabaaa
aeaaaaaabjaaaaaficaabaaaaeaaaaaadkaabaaaaeaaaaaadiaaaaahicaabaaa
aeaaaaaaakaabaaaacaaaaaadkaabaaaaeaaaaaadiaaaaahicaabaaaaeaaaaaa
dkaabaaaabaaaaaadkaabaaaaeaaaaaadcaaaaajhcaabaaaadaaaaaapgapbaaa
aeaaaaaaegacbaaaaeaaaaaaegacbaaaadaaaaaaboaaaaahicaabaaaadaaaaaa
dkaabaaaadaaaaaaabeaaaaaabaaaaaabgaaaaabdcaaaaajhcaabaaaacaaaaaa
egacbaaaaaaaaaaajgahbaaaacaaaaaaegacbaaaadaaaaaaaaaaaaahhcaabaaa
acaaaaaaegacbaaaacaaaaaaegacbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaa
egacbaaaabaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadgaaaaaficcabaaa
aaaaaaaaabeaaaaaaaaaiadpdoaaaaab"
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
Vector 1 [_TerrainTreeLightColors0]
Vector 2 [_TerrainTreeLightColors1]
Vector 3 [_TerrainTreeLightColors2]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
"3.0-!!ARBfp1.0
# 38 ALU, 3 TEX
PARAM c[6] = { state.lightmodel.ambient,
		program.local[1..3],
		{ 1, 0.45458984, 10, 1.75 },
		{ 0.125, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.w, c[4].y;
TEX R0.x, fragment.texcoord[0], texture[2], 2D;
MAD R0.x, R0, c[4].z, c[4];
EX2 R0.x, R0.x;
ADD R2.w, R0.x, -c[4];
POW R0.x, fragment.texcoord[2].y, R2.w;
MUL R1.x, R2.w, R0;
POW R0.y, fragment.texcoord[3].y, R2.w;
MUL R0.x, R2.w, R0.y;
TEX R0.w, fragment.texcoord[0], texture[1], 2D;
MUL R1.y, R0.w, R0.x;
MUL R3.y, R0.w, R1.x;
POW R3.x, fragment.texcoord[4].y, R2.w;
MUL R2.w, R2, R3.x;
POW R1.x, c[1].x, R1.w;
POW R1.z, c[1].z, R1.w;
POW R3.x, c[3].x, R1.w;
POW R3.z, c[3].z, R1.w;
POW R0.x, c[2].x, R1.w;
POW R0.z, c[2].z, R1.w;
POW R0.y, c[2].y, R1.w;
MUL R2.xyz, R1.y, R0;
POW R1.y, c[1].y, R1.w;
MAD R2.xyz, R3.y, R1, R2;
MUL R0.xyz, fragment.texcoord[3].x, R0;
MAD R0.xyz, fragment.texcoord[2].x, R1, R0;
POW R3.y, c[3].y, R1.w;
MUL R0.w, R2, R0;
MAD R2.xyz, R0.w, R3, R2;
MUL R1.xyz, fragment.texcoord[1], c[0];
MAD R0.xyz, fragment.texcoord[4].x, R3, R0;
MUL R3.xyz, R1, c[5].y;
TEX R1.xyz, fragment.texcoord[0], texture[0], 2D;
MUL R0.xyz, R1, R0;
MUL R1.xyz, R1, R3;
MAD R0.xyz, R2, c[5].x, R0;
MAD result.color.xyz, R0, c[5].y, R1;
MOV result.color.w, c[4].x;
END
# 38 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_TerrainTreeLightColors0]
Vector 2 [_TerrainTreeLightColors1]
Vector 3 [_TerrainTreeLightColors2]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
"ps_3_0
; 77 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c4, 10.00000000, 1.00000000, -1.75000000, 2.00000000
def c5, 0.45458984, 0.12500000, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xy
texld r0.x, v0, s2
mad r0.x, r0, c4, c4.y
exp r0.x, r0.x
add r3.w, r0.x, c4.z
pow r1, v3.y, r3.w
mov_pp r1.y, c5.x
pow r4, v2.y, r3.w
pow_pp r0, c2.x, r1.y
mov r0.y, r1.x
mov_pp r0.z, c5.x
pow_pp r2, c2.z, r0.z
texld r0.w, v0, s1
mul r0.y, r3.w, r0
mul r3.x, r0.w, r0.y
mov_pp r0.y, c5.x
pow_pp r1, c2.y, r0.y
mov_pp r0.z, r2
mov_pp r0.y, r1
mov_pp r2.x, c5
mul r3.xyz, r3.x, r0
pow_pp r1, c1.x, r2.x
mov r2.y, r4.x
mul r1.y, r3.w, r2
mul r1.w, r0, r1.y
mov_pp r1.y, c5.x
pow_pp r4, c1.y, r1.y
mov_pp r1.z, c5.x
pow_pp r2, c1.z, r1.z
mov_pp r1.z, r2
mul_pp r2.xyz, v3.x, r0
mov_pp r1.y, r4
pow r4, v4.y, r3.w
mad r3.xyz, r1.w, r1, r3
mad_pp r2.xyz, v2.x, r1, r2
mov r0.y, r4.x
mov_pp r0.x, c5
pow_pp r4, c3.x, r0.x
mul r0.x, r3.w, r0.y
mul r1.w, r0.x, r0
mov_pp r5.x, r4
mov_pp r0.x, c5
pow_pp r4, c3.y, r0.x
mov_pp r2.w, c5.x
pow_pp r0, c3.z, r2.w
mov_pp r5.z, r0
mov_pp r5.y, r4
mad r0.xyz, r1.w, r5, r3
mul r1.xyz, v1, c0
mul r3.xyz, r1, c4.w
texld r1.xyz, v0, s0
mad_pp r2.xyz, v4.x, r5, r2
mul_pp r2.xyz, r1, r2
mul_pp r1.xyz, r1, r3
mad r0.xyz, r0, c5.y, r2
mad oC0.xyz, r0, c4.w, r1
mov_pp oC0.w, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "UnityPerFrame" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_TranslucencyMap] 2D 2
SetTexture 2 [_BumpSpecMap] 2D 1
// 31 instructions, 5 temp regs, 0 temp arrays:
// ALU 19 float, 2 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedmpojddoefdjpacpikkbnnholjgdicgjlabaaaaaageafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefccmaeaaaaeaaaaaaaalabaaaa
fjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaiaaaeegiocaaaabaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaaddcbabaaa
aeaaaaaagcbaaaaddcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
afaaaaaaflaaaaaedcbabaaaadaaaaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaa
dcaaaaajicaabaaaaaaaaaaaakaabaaaacaaaaaaabeaaaaaaaaacaebabeaaaaa
aaaaiadpbjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaoalpdiaaaaaihcaabaaaabaaaaaa
egbcbaaaacaaaaaaegiccaaaaaaaaaaaaeaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaadodgaaaaaiocaabaaaacaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadgaaaaaipcaabaaaadaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadaaaaaabcbaaaaahbcaabaaaaeaaaaaadkaabaaa
adaaaaaaabeaaaaaadaaaaaaadaaaeadakaabaaaaeaaaaaacpaaaaaihcaabaaa
aeaaaaaaegiccaagabaaaaaaaeaaaaaadkaabaaaadaaaaaadiaaaaakhcaabaaa
aeaaaaaaegacbaaaaeaaaaaaaceaaaaacplkoidocplkoidocplkoidoaaaaaaaa
bjaaaaafhcaabaaaaeaaaaaaegacbaaaaeaaaaaadcaaaaalocaabaaaacaaaaaa
agajbaaaaeaaaaaaagbanaaaadaaaaaadkaabaaaadaaaaaafgaobaaaacaaaaaa
cpaaaaahicaabaaaaeaaaaaabkbanaaaadaaaaaadkaabaaaadaaaaaadiaaaaah
icaabaaaaeaaaaaadkaabaaaaaaaaaaadkaabaaaaeaaaaaabjaaaaaficaabaaa
aeaaaaaadkaabaaaaeaaaaaadiaaaaahicaabaaaaeaaaaaaakaabaaaacaaaaaa
dkaabaaaaeaaaaaadiaaaaahicaabaaaaeaaaaaadkaabaaaabaaaaaadkaabaaa
aeaaaaaadcaaaaajhcaabaaaadaaaaaapgapbaaaaeaaaaaaegacbaaaaeaaaaaa
egacbaaaadaaaaaaboaaaaahicaabaaaadaaaaaadkaabaaaadaaaaaaabeaaaaa
abaaaaaabgaaaaabdcaaaaajhcaabaaaacaaaaaaegacbaaaaaaaaaaajgahbaaa
acaaaaaaegacbaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaa
egacbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaa
aaaaaaaaegacbaaaacaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadp
doaaaaab"
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
Vector 0 [_TerrainTreeLightColors0]
Vector 1 [_TerrainTreeLightColors1]
Vector 2 [_TerrainTreeLightColors2]
Vector 3 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"3.0-!!ARBfp1.0
# 33 ALU, 4 TEX
PARAM c[6] = { program.local[0..3],
		{ 1, 10, 1.75, 0.125 },
		{ 2, 0.30541992, 0.68212891, 0.012519836 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[5], texture[3], CUBE;
MAD R1.x, R0.w, c[5].y, c[5].z;
MAD R1.x, R0.w, R1, c[5].w;
MUL R0.w, R0, R1.x;
MUL R0.xyz, R0, R0.w;
MUL R0.xyz, R0, c[3].x;
MUL R2.xyz, R0, fragment.texcoord[1];
TEX R1.x, fragment.texcoord[0], texture[2], 2D;
MAD R0.w, R1.x, c[4].y, c[4].x;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
EX2 R0.w, R0.w;
ADD R1.w, R0, -c[4].z;
POW R0.w, fragment.texcoord[3].y, R1.w;
MUL R2.w, R1, R0;
TEX R0.w, fragment.texcoord[0], texture[1], 2D;
POW R3.x, fragment.texcoord[4].y, R1.w;
MUL R1.xyz, fragment.texcoord[3].x, c[1];
MAD R1.xyz, fragment.texcoord[2].x, c[0], R1;
MUL R2.w, R0, R2;
MUL R2.xyz, R0, R2;
MAD R1.xyz, fragment.texcoord[4].x, c[2], R1;
MUL R0.xyz, R0, R1;
MUL R1.xyz, R2.w, c[1];
POW R2.w, fragment.texcoord[2].y, R1.w;
MUL R3.x, R1.w, R3;
MUL R2.w, R1, R2;
MUL R1.w, R0, R2;
MAD R1.xyz, R1.w, c[0], R1;
MUL R0.w, R3.x, R0;
MAD R1.xyz, R0.w, c[2], R1;
MAD R0.xyz, R1, c[4].w, R0;
MAD result.color.xyz, R0, c[5].x, R2;
MOV result.color.w, c[4].x;
END
# 33 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Vector 0 [_TerrainTreeLightColors0]
Vector 1 [_TerrainTreeLightColors1]
Vector 2 [_TerrainTreeLightColors2]
Vector 3 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"ps_3_0
; 37 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c4, 10.00000000, 1.00000000, -1.75000000, 0.01251984
def c5, 0.30541992, 0.68212891, 0.12500000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xy
dcl_texcoord5 v5.xyz
texld r0, v5, s3
mad_pp r1.x, r0.w, c5, c5.y
mad_pp r1.x, r0.w, r1, c4.w
mul_pp r0.w, r0, r1.x
mul_pp r0.xyz, r0, r0.w
mul r1.xyz, r0, c3.x
mul r2.xyz, r1, v1
texld r1.xyz, v0, s0
texld r0.x, v0, s2
mad r0.x, r0, c4, c4.y
exp r0.x, r0.x
add r1.w, r0.x, c4.z
pow r0, v4.y, r1.w
mul r2.w, r1, r0.x
pow r0, v3.y, r1.w
mov r0.y, r0.x
mul_pp r3.xyz, v3.x, c1
mad_pp r3.xyz, v2.x, c0, r3
texld r0.w, v0, s1
mul r0.y, r1.w, r0
mul_pp r2.xyz, r1, r2
mad_pp r3.xyz, v4.x, c2, r3
mul_pp r1.xyz, r1, r3
pow r3, v2.y, r1.w
mov r0.x, r3
mul r1.w, r1, r0.x
mul r0.y, r0.w, r0
mul r1.w, r0, r1
mul r0.xyz, r0.y, c1
mad r0.xyz, r1.w, c0, r0
mul r0.w, r2, r0
mad r0.xyz, r0.w, c2, r0
mad r0.xyz, r0, c5.z, r1
mad oC0.xyz, r0, c5.w, r2
mov_pp oC0.w, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
ConstBuffer "$Globals" 48 // 48 used size, 3 vars
Vector 32 [ExposureIBL] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_TranslucencyMap] 2D 2
SetTexture 2 [_BumpSpecMap] 2D 1
SetTexture 3 [_DiffCubeIBL] CUBE 3
// 33 instructions, 5 temp regs, 0 temp arrays:
// ALU 20 float, 2 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedaeclcdpiheomfoilnbmjmlgbpjnmodfdabaaaaaaomafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcleaeaaaaeaaaaaaacnabaaaa
fjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaiaaaeegiocaaaabaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fidaaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaa
gcbaaaaddcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacafaaaaaaflaaaaaedcbabaaaadaaaaaaadaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaabaaaaaadcaaaaajicaabaaaaaaaaaaaakaabaaaacaaaaaaabeaaaaa
aaaacaebabeaaaaaaaaaiadpbjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
aaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaoalpefaaaaaj
pcaabaaaacaaaaaaegbcbaaaagaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaa
dcaaaaajbcaabaaaabaaaaaadkaabaaaacaaaaaaabeaaaaabcfbjmdoabeaaaaa
mekccodpdcaaaaajbcaabaaaabaaaaaadkaabaaaacaaaaaaakaabaaaabaaaaaa
abeaaaaamccmendmdiaaaaahbcaabaaaabaaaaaaakaabaaaabaaaaaadkaabaaa
acaaaaaadiaaaaahhcaabaaaabaaaaaaagaabaaaabaaaaaaegacbaaaacaaaaaa
diaaaaaihcaabaaaabaaaaaaegacbaaaabaaaaaaagiacaaaaaaaaaaaacaaaaaa
diaaaaahhcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaacaaaaaadiaaaaah
bcaabaaaacaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaadodgaaaaaiocaabaaa
acaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaaipcaabaaa
adaaaaaaaceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadaaaaaabcbaaaaah
bcaabaaaaeaaaaaadkaabaaaadaaaaaaabeaaaaaadaaaaaaadaaaeadakaabaaa
aeaaaaaadcaaaaaoocaabaaaacaaaaaaagijcaagabaaaaaaaeaaaaaadkaabaaa
adaaaaaaagbanaaaadaaaaaadkaabaaaadaaaaaafgaobaaaacaaaaaacpaaaaah
bcaabaaaaeaaaaaabkbanaaaadaaaaaadkaabaaaadaaaaaadiaaaaahbcaabaaa
aeaaaaaadkaabaaaaaaaaaaaakaabaaaaeaaaaaabjaaaaafbcaabaaaaeaaaaaa
akaabaaaaeaaaaaadiaaaaahbcaabaaaaeaaaaaaakaabaaaacaaaaaaakaabaaa
aeaaaaaadiaaaaahbcaabaaaaeaaaaaadkaabaaaabaaaaaaakaabaaaaeaaaaaa
dcaaaaamhcaabaaaadaaaaaaagaabaaaaeaaaaaaegiccaagabaaaaaaaeaaaaaa
dkaabaaaadaaaaaaegacbaaaadaaaaaaboaaaaahicaabaaaadaaaaaadkaabaaa
adaaaaaaabeaaaaaabaaaaaabgaaaaabdcaaaaajhcaabaaaacaaaaaaegacbaaa
aaaaaaaajgahbaaaacaaaaaaegacbaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaa
egacbaaaacaaaaaaegacbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaa
abaaaaaaegacbaaaaaaaaaaaegacbaaaacaaaaaadgaaaaaficcabaaaaaaaaaaa
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
Vector 1 [_TerrainTreeLightColors0]
Vector 2 [_TerrainTreeLightColors1]
Vector 3 [_TerrainTreeLightColors2]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
"3.0-!!ARBfp1.0
# 28 ALU, 3 TEX
PARAM c[6] = { state.lightmodel.ambient,
		program.local[1..3],
		{ 1, 10, 1.75, 0.125 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R2.xyz, fragment.texcoord[1], c[0];
TEX R0.x, fragment.texcoord[0], texture[2], 2D;
MAD R0.x, R0, c[4].y, c[4];
EX2 R0.w, R0.x;
ADD R1.w, R0, -c[4].z;
POW R0.w, fragment.texcoord[3].y, R1.w;
MUL R2.w, R1, R0;
TEX R0.w, fragment.texcoord[0], texture[1], 2D;
POW R3.x, fragment.texcoord[4].y, R1.w;
MUL R0.xyz, fragment.texcoord[3].x, c[2];
MAD R0.xyz, fragment.texcoord[2].x, c[1], R0;
TEX R1.xyz, fragment.texcoord[0], texture[0], 2D;
MUL R2.xyz, R2, c[5].x;
MAD R0.xyz, fragment.texcoord[4].x, c[3], R0;
MUL R2.w, R0, R2;
MUL R2.xyz, R1, R2;
MUL R0.xyz, R1, R0;
MUL R1.xyz, R2.w, c[2];
POW R2.w, fragment.texcoord[2].y, R1.w;
MUL R3.x, R1.w, R3;
MUL R2.w, R1, R2;
MUL R1.w, R0, R2;
MAD R1.xyz, R1.w, c[1], R1;
MUL R0.w, R3.x, R0;
MAD R1.xyz, R0.w, c[3], R1;
MAD R0.xyz, R1, c[4].w, R0;
MAD result.color.xyz, R0, c[5].x, R2;
MOV result.color.w, c[4].x;
END
# 28 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_TerrainTreeLightColors0]
Vector 2 [_TerrainTreeLightColors1]
Vector 3 [_TerrainTreeLightColors2]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
"ps_3_0
; 33 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c4, 10.00000000, 1.00000000, -1.75000000, 2.00000000
def c5, 0.12500000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xy
texld r0.x, v0, s2
mul r2.xyz, v1, c0
mad r0.x, r0, c4, c4.y
exp r0.x, r0.x
add r1.w, r0.x, c4.z
pow r0, v4.y, r1.w
mul r2.w, r1, r0.x
pow r0, v3.y, r1.w
mov r0.y, r0.x
mul_pp r3.xyz, v3.x, c2
mad_pp r3.xyz, v2.x, c1, r3
texld r0.w, v0, s1
mul r0.y, r1.w, r0
texld r1.xyz, v0, s0
mul r2.xyz, r2, c4.w
mul_pp r2.xyz, r1, r2
mad_pp r3.xyz, v4.x, c3, r3
mul_pp r1.xyz, r1, r3
pow r3, v2.y, r1.w
mov r0.x, r3
mul r1.w, r1, r0.x
mul r0.y, r0.w, r0
mul r1.w, r0, r1
mul r0.xyz, r0.y, c2
mad r0.xyz, r1.w, c1, r0
mul r0.w, r2, r0
mad r0.xyz, r0.w, c3, r0
mad r0.xyz, r0, c5.x, r1
mad oC0.xyz, r0, c4.w, r2
mov_pp oC0.w, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_LINEAR" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "UnityPerFrame" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_TranslucencyMap] 2D 2
SetTexture 2 [_BumpSpecMap] 2D 1
// 28 instructions, 5 temp regs, 0 temp arrays:
// ALU 16 float, 2 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedpjfleicpgmaloeojkjhakoopbaaempclabaaaaaacaafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoiadaaaaeaaaaaaapkaaaaaa
fjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaiaaaeegiocaaaabaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaaddcbabaaa
aeaaaaaagcbaaaaddcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
afaaaaaaflaaaaaedcbabaaaadaaaaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaa
dcaaaaajicaabaaaaaaaaaaaakaabaaaacaaaaaaabeaaaaaaaaacaebabeaaaaa
aaaaiadpbjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaoalpdiaaaaaihcaabaaaabaaaaaa
egbcbaaaacaaaaaaegiccaaaaaaaaaaaaeaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaadodgaaaaaiocaabaaaacaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadgaaaaaipcaabaaaadaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadaaaaaabcbaaaaahbcaabaaaaeaaaaaadkaabaaa
adaaaaaaabeaaaaaadaaaaaaadaaaeadakaabaaaaeaaaaaadcaaaaaoocaabaaa
acaaaaaaagijcaagabaaaaaaaeaaaaaadkaabaaaadaaaaaaagbanaaaadaaaaaa
dkaabaaaadaaaaaafgaobaaaacaaaaaacpaaaaahbcaabaaaaeaaaaaabkbanaaa
adaaaaaadkaabaaaadaaaaaadiaaaaahbcaabaaaaeaaaaaadkaabaaaaaaaaaaa
akaabaaaaeaaaaaabjaaaaafbcaabaaaaeaaaaaaakaabaaaaeaaaaaadiaaaaah
bcaabaaaaeaaaaaaakaabaaaacaaaaaaakaabaaaaeaaaaaadiaaaaahbcaabaaa
aeaaaaaadkaabaaaabaaaaaaakaabaaaaeaaaaaadcaaaaamhcaabaaaadaaaaaa
agaabaaaaeaaaaaaegiccaagabaaaaaaaeaaaaaadkaabaaaadaaaaaaegacbaaa
adaaaaaaboaaaaahicaabaaaadaaaaaadkaabaaaadaaaaaaabeaaaaaabaaaaaa
bgaaaaabdcaaaaajhcaabaaaacaaaaaaegacbaaaaaaaaaaajgahbaaaacaaaaaa
egacbaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaa
acaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab
"
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
Vector 0 [_TerrainTreeLightColors0]
Vector 1 [_TerrainTreeLightColors1]
Vector 2 [_TerrainTreeLightColors2]
Vector 3 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"3.0-!!ARBfp1.0
# 30 ALU, 4 TEX
PARAM c[6] = { program.local[0..3],
		{ 1, 10, 1.75, 0.125 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[5], texture[3], CUBE;
MUL R0.xyz, R0, R0.w;
MUL R0.xyz, R0, c[3].x;
MUL R2.xyz, R0, fragment.texcoord[1];
TEX R1.x, fragment.texcoord[0], texture[2], 2D;
MAD R0.w, R1.x, c[4].y, c[4].x;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
EX2 R0.w, R0.w;
ADD R1.w, R0, -c[4].z;
POW R0.w, fragment.texcoord[3].y, R1.w;
MUL R2.w, R1, R0;
TEX R0.w, fragment.texcoord[0], texture[1], 2D;
POW R3.x, fragment.texcoord[4].y, R1.w;
MUL R1.xyz, fragment.texcoord[3].x, c[1];
MAD R1.xyz, fragment.texcoord[2].x, c[0], R1;
MUL R2.w, R0, R2;
MUL R2.xyz, R0, R2;
MAD R1.xyz, fragment.texcoord[4].x, c[2], R1;
MUL R0.xyz, R0, R1;
MUL R1.xyz, R2.w, c[1];
POW R2.w, fragment.texcoord[2].y, R1.w;
MUL R3.x, R1.w, R3;
MUL R2.w, R1, R2;
MUL R1.w, R0, R2;
MAD R1.xyz, R1.w, c[0], R1;
MUL R0.w, R3.x, R0;
MAD R1.xyz, R0.w, c[2], R1;
MAD R0.xyz, R1, c[4].w, R0;
MAD result.color.xyz, R0, c[5].x, R2;
MOV result.color.w, c[4].x;
END
# 30 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
Vector 0 [_TerrainTreeLightColors0]
Vector 1 [_TerrainTreeLightColors1]
Vector 2 [_TerrainTreeLightColors2]
Vector 3 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"ps_3_0
; 34 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c4, 10.00000000, 1.00000000, -1.75000000, 0.12500000
def c5, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xy
dcl_texcoord5 v5.xyz
texld r0, v5, s3
mul_pp r0.xyz, r0, r0.w
mul r1.xyz, r0, c3.x
mul r2.xyz, r1, v1
texld r1.xyz, v0, s0
texld r0.x, v0, s2
mad r0.x, r0, c4, c4.y
exp r0.x, r0.x
add r1.w, r0.x, c4.z
pow r0, v4.y, r1.w
mul r2.w, r1, r0.x
pow r0, v3.y, r1.w
mov r0.y, r0.x
mul_pp r3.xyz, v3.x, c1
mad_pp r3.xyz, v2.x, c0, r3
texld r0.w, v0, s1
mul r0.y, r1.w, r0
mul_pp r2.xyz, r1, r2
mad_pp r3.xyz, v4.x, c2, r3
mul_pp r1.xyz, r1, r3
pow r3, v2.y, r1.w
mov r0.x, r3
mul r1.w, r1, r0.x
mul r0.y, r0.w, r0
mul r1.w, r0, r1
mul r0.xyz, r0.y, c1
mad r0.xyz, r1.w, c0, r0
mul r0.w, r2, r0
mad r0.xyz, r0.w, c2, r0
mad r0.xyz, r0, c4.w, r1
mad oC0.xyz, r0, c5.x, r2
mov_pp oC0.w, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_ON" }
ConstBuffer "$Globals" 48 // 48 used size, 3 vars
Vector 32 [ExposureIBL] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_TranslucencyMap] 2D 2
SetTexture 2 [_BumpSpecMap] 2D 1
SetTexture 3 [_DiffCubeIBL] CUBE 3
// 30 instructions, 5 temp regs, 0 temp arrays:
// ALU 17 float, 2 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedpmaedjmgebobnfgfajfkppokdpfkfjahabaaaaaaiiafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfaaeaaaaeaaaaaaabeabaaaa
fjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaiaaaeegiocaaaabaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fidaaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaa
gcbaaaaddcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacafaaaaaaflaaaaaedcbabaaaadaaaaaaadaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaabaaaaaadcaaaaajicaabaaaaaaaaaaaakaabaaaacaaaaaaabeaaaaa
aaaacaebabeaaaaaaaaaiadpbjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
aaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaoalpefaaaaaj
pcaabaaaacaaaaaaegbcbaaaagaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaagiacaaaaaaaaaaaacaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaacaaaaaadiaaaaahbcaabaaa
acaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaadodgaaaaaiocaabaaaacaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaaipcaabaaaadaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadaaaaaabcbaaaaahbcaabaaa
aeaaaaaadkaabaaaadaaaaaaabeaaaaaadaaaaaaadaaaeadakaabaaaaeaaaaaa
dcaaaaaoocaabaaaacaaaaaaagijcaagabaaaaaaaeaaaaaadkaabaaaadaaaaaa
agbanaaaadaaaaaadkaabaaaadaaaaaafgaobaaaacaaaaaacpaaaaahbcaabaaa
aeaaaaaabkbanaaaadaaaaaadkaabaaaadaaaaaadiaaaaahbcaabaaaaeaaaaaa
dkaabaaaaaaaaaaaakaabaaaaeaaaaaabjaaaaafbcaabaaaaeaaaaaaakaabaaa
aeaaaaaadiaaaaahbcaabaaaaeaaaaaaakaabaaaacaaaaaaakaabaaaaeaaaaaa
diaaaaahbcaabaaaaeaaaaaadkaabaaaabaaaaaaakaabaaaaeaaaaaadcaaaaam
hcaabaaaadaaaaaaagaabaaaaeaaaaaaegiccaagabaaaaaaaeaaaaaadkaabaaa
adaaaaaaegacbaaaadaaaaaaboaaaaahicaabaaaadaaaaaadkaabaaaadaaaaaa
abeaaaaaabaaaaaabgaaaaabdcaaaaajhcaabaaaacaaaaaaegacbaaaaaaaaaaa
jgahbaaaacaaaaaaegacbaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaegacbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaaegacbaaaacaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
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
Vector 1 [_TerrainTreeLightColors0]
Vector 2 [_TerrainTreeLightColors1]
Vector 3 [_TerrainTreeLightColors2]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
"3.0-!!ARBfp1.0
# 28 ALU, 3 TEX
PARAM c[6] = { state.lightmodel.ambient,
		program.local[1..3],
		{ 1, 10, 1.75, 0.125 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R2.xyz, fragment.texcoord[1], c[0];
TEX R0.x, fragment.texcoord[0], texture[2], 2D;
MAD R0.x, R0, c[4].y, c[4];
EX2 R0.w, R0.x;
ADD R1.w, R0, -c[4].z;
POW R0.w, fragment.texcoord[3].y, R1.w;
MUL R2.w, R1, R0;
TEX R0.w, fragment.texcoord[0], texture[1], 2D;
POW R3.x, fragment.texcoord[4].y, R1.w;
MUL R0.xyz, fragment.texcoord[3].x, c[2];
MAD R0.xyz, fragment.texcoord[2].x, c[1], R0;
TEX R1.xyz, fragment.texcoord[0], texture[0], 2D;
MUL R2.xyz, R2, c[5].x;
MAD R0.xyz, fragment.texcoord[4].x, c[3], R0;
MUL R2.w, R0, R2;
MUL R2.xyz, R1, R2;
MUL R0.xyz, R1, R0;
MUL R1.xyz, R2.w, c[2];
POW R2.w, fragment.texcoord[2].y, R1.w;
MUL R3.x, R1.w, R3;
MUL R2.w, R1, R2;
MUL R1.w, R0, R2;
MAD R1.xyz, R1.w, c[1], R1;
MUL R0.w, R3.x, R0;
MAD R1.xyz, R0.w, c[3], R1;
MAD R0.xyz, R1, c[4].w, R0;
MAD result.color.xyz, R0, c[5].x, R2;
MOV result.color.w, c[4].x;
END
# 28 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_TerrainTreeLightColors0]
Vector 2 [_TerrainTreeLightColors1]
Vector 3 [_TerrainTreeLightColors2]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
"ps_3_0
; 33 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c4, 10.00000000, 1.00000000, -1.75000000, 2.00000000
def c5, 0.12500000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xy
texld r0.x, v0, s2
mul r2.xyz, v1, c0
mad r0.x, r0, c4, c4.y
exp r0.x, r0.x
add r1.w, r0.x, c4.z
pow r0, v4.y, r1.w
mul r2.w, r1, r0.x
pow r0, v3.y, r1.w
mov r0.y, r0.x
mul_pp r3.xyz, v3.x, c2
mad_pp r3.xyz, v2.x, c1, r3
texld r0.w, v0, s1
mul r0.y, r1.w, r0
texld r1.xyz, v0, s0
mul r2.xyz, r2, c4.w
mul_pp r2.xyz, r1, r2
mad_pp r3.xyz, v4.x, c3, r3
mul_pp r1.xyz, r1, r3
pow r3, v2.y, r1.w
mov r0.x, r3
mul r1.w, r1, r0.x
mul r0.y, r0.w, r0
mul r1.w, r0, r1
mul r0.xyz, r0.y, c2
mad r0.xyz, r1.w, c1, r0
mul r0.w, r2, r0
mad r0.xyz, r0.w, c3, r0
mad r0.xyz, r0, c5.x, r1
mad oC0.xyz, r0, c4.w, r2
mov_pp oC0.w, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_ON" "GLDIFFCUBE_OFF" }
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "UnityPerFrame" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_TranslucencyMap] 2D 2
SetTexture 2 [_BumpSpecMap] 2D 1
// 28 instructions, 5 temp regs, 0 temp arrays:
// ALU 16 float, 2 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedpjfleicpgmaloeojkjhakoopbaaempclabaaaaaacaafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoiadaaaaeaaaaaaapkaaaaaa
fjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaiaaaeegiocaaaabaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaaddcbabaaa
aeaaaaaagcbaaaaddcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
afaaaaaaflaaaaaedcbabaaaadaaaaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaa
dcaaaaajicaabaaaaaaaaaaaakaabaaaacaaaaaaabeaaaaaaaaacaebabeaaaaa
aaaaiadpbjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaoalpdiaaaaaihcaabaaaabaaaaaa
egbcbaaaacaaaaaaegiccaaaaaaaaaaaaeaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaadodgaaaaaiocaabaaaacaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadgaaaaaipcaabaaaadaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadaaaaaabcbaaaaahbcaabaaaaeaaaaaadkaabaaa
adaaaaaaabeaaaaaadaaaaaaadaaaeadakaabaaaaeaaaaaadcaaaaaoocaabaaa
acaaaaaaagijcaagabaaaaaaaeaaaaaadkaabaaaadaaaaaaagbanaaaadaaaaaa
dkaabaaaadaaaaaafgaobaaaacaaaaaacpaaaaahbcaabaaaaeaaaaaabkbanaaa
adaaaaaadkaabaaaadaaaaaadiaaaaahbcaabaaaaeaaaaaadkaabaaaaaaaaaaa
akaabaaaaeaaaaaabjaaaaafbcaabaaaaeaaaaaaakaabaaaaeaaaaaadiaaaaah
bcaabaaaaeaaaaaaakaabaaaacaaaaaaakaabaaaaeaaaaaadiaaaaahbcaabaaa
aeaaaaaadkaabaaaabaaaaaaakaabaaaaeaaaaaadcaaaaamhcaabaaaadaaaaaa
agaabaaaaeaaaaaaegiccaagabaaaaaaaeaaaaaadkaabaaaadaaaaaaegacbaaa
adaaaaaaboaaaaahicaabaaaadaaaaaadkaabaaaadaaaaaaabeaaaaaabaaaaaa
bgaaaaabdcaaaaajhcaabaaaacaaaaaaegacbaaaaaaaaaaajgahbaaaacaaaaaa
egacbaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaa
acaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab
"
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
Vector 0 [_TerrainTreeLightColors0]
Vector 1 [_TerrainTreeLightColors1]
Vector 2 [_TerrainTreeLightColors2]
Vector 3 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"3.0-!!ARBfp1.0
# 30 ALU, 4 TEX
PARAM c[6] = { program.local[0..3],
		{ 1, 10, 1.75, 0.125 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[5], texture[3], CUBE;
MUL R0.xyz, R0, R0.w;
MUL R0.xyz, R0, c[3].x;
MUL R2.xyz, R0, fragment.texcoord[1];
TEX R1.x, fragment.texcoord[0], texture[2], 2D;
MAD R0.w, R1.x, c[4].y, c[4].x;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
EX2 R0.w, R0.w;
ADD R1.w, R0, -c[4].z;
POW R0.w, fragment.texcoord[3].y, R1.w;
MUL R2.w, R1, R0;
TEX R0.w, fragment.texcoord[0], texture[1], 2D;
POW R3.x, fragment.texcoord[4].y, R1.w;
MUL R1.xyz, fragment.texcoord[3].x, c[1];
MAD R1.xyz, fragment.texcoord[2].x, c[0], R1;
MUL R2.w, R0, R2;
MUL R2.xyz, R0, R2;
MAD R1.xyz, fragment.texcoord[4].x, c[2], R1;
MUL R0.xyz, R0, R1;
MUL R1.xyz, R2.w, c[1];
POW R2.w, fragment.texcoord[2].y, R1.w;
MUL R3.x, R1.w, R3;
MUL R2.w, R1, R2;
MUL R1.w, R0, R2;
MAD R1.xyz, R1.w, c[0], R1;
MUL R0.w, R3.x, R0;
MAD R1.xyz, R0.w, c[2], R1;
MAD R0.xyz, R1, c[4].w, R0;
MAD result.color.xyz, R0, c[5].x, R2;
MOV result.color.w, c[4].x;
END
# 30 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
Vector 0 [_TerrainTreeLightColors0]
Vector 1 [_TerrainTreeLightColors1]
Vector 2 [_TerrainTreeLightColors2]
Vector 3 [ExposureIBL]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
SetTexture 3 [_DiffCubeIBL] CUBE
"ps_3_0
; 34 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c4, 10.00000000, 1.00000000, -1.75000000, 0.12500000
def c5, 2.00000000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xy
dcl_texcoord5 v5.xyz
texld r0, v5, s3
mul_pp r0.xyz, r0, r0.w
mul r1.xyz, r0, c3.x
mul r2.xyz, r1, v1
texld r1.xyz, v0, s0
texld r0.x, v0, s2
mad r0.x, r0, c4, c4.y
exp r0.x, r0.x
add r1.w, r0.x, c4.z
pow r0, v4.y, r1.w
mul r2.w, r1, r0.x
pow r0, v3.y, r1.w
mov r0.y, r0.x
mul_pp r3.xyz, v3.x, c1
mad_pp r3.xyz, v2.x, c0, r3
texld r0.w, v0, s1
mul r0.y, r1.w, r0
mul_pp r2.xyz, r1, r2
mad_pp r3.xyz, v4.x, c2, r3
mul_pp r1.xyz, r1, r3
pow r3, v2.y, r1.w
mov r0.x, r3
mul r1.w, r1, r0.x
mul r0.y, r0.w, r0
mul r1.w, r0, r1
mul r0.xyz, r0.y, c1
mad r0.xyz, r1.w, c0, r0
mul r0.w, r2, r0
mad r0.xyz, r0.w, c2, r0
mad r0.xyz, r0, c4.w, r1
mad oC0.xyz, r0, c5.x, r2
mov_pp oC0.w, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_ON" }
ConstBuffer "$Globals" 48 // 48 used size, 3 vars
Vector 32 [ExposureIBL] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "$Globals" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_TranslucencyMap] 2D 2
SetTexture 2 [_BumpSpecMap] 2D 1
SetTexture 3 [_DiffCubeIBL] CUBE 3
// 30 instructions, 5 temp regs, 0 temp arrays:
// ALU 17 float, 2 int, 0 uint
// TEX 4 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedpmaedjmgebobnfgfajfkppokdpfkfjahabaaaaaaiiafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcfaaeaaaaeaaaaaaabeabaaaa
fjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaiaaaeegiocaaaabaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafkaaaaadaagabaaaadaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaa
fibiaaaeaahabaaaabaaaaaaffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaa
fidaaaaeaahabaaaadaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaaddcbabaaaaeaaaaaa
gcbaaaaddcbabaaaafaaaaaagcbaaaadhcbabaaaagaaaaaagfaaaaadpccabaaa
aaaaaaaagiaaaaacafaaaaaaflaaaaaedcbabaaaadaaaaaaadaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
efaaaaajpcaabaaaabaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaa
acaaaaaaefaaaaajpcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaa
aagabaaaabaaaaaadcaaaaajicaabaaaaaaaaaaaakaabaaaacaaaaaaabeaaaaa
aaaacaebabeaaaaaaaaaiadpbjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaa
aaaaaaahicaabaaaaaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaoalpefaaaaaj
pcaabaaaacaaaaaaegbcbaaaagaaaaaaeghobaaaadaaaaaaaagabaaaadaaaaaa
diaaaaahhcaabaaaabaaaaaapgapbaaaacaaaaaaegacbaaaacaaaaaadiaaaaai
hcaabaaaabaaaaaaegacbaaaabaaaaaaagiacaaaaaaaaaaaacaaaaaadiaaaaah
hcaabaaaabaaaaaaegacbaaaabaaaaaaegbcbaaaacaaaaaadiaaaaahbcaabaaa
acaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaaadodgaaaaaiocaabaaaacaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadgaaaaaipcaabaaaadaaaaaa
aceaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadaaaaaabcbaaaaahbcaabaaa
aeaaaaaadkaabaaaadaaaaaaabeaaaaaadaaaaaaadaaaeadakaabaaaaeaaaaaa
dcaaaaaoocaabaaaacaaaaaaagijcaagabaaaaaaaeaaaaaadkaabaaaadaaaaaa
agbanaaaadaaaaaadkaabaaaadaaaaaafgaobaaaacaaaaaacpaaaaahbcaabaaa
aeaaaaaabkbanaaaadaaaaaadkaabaaaadaaaaaadiaaaaahbcaabaaaaeaaaaaa
dkaabaaaaaaaaaaaakaabaaaaeaaaaaabjaaaaafbcaabaaaaeaaaaaaakaabaaa
aeaaaaaadiaaaaahbcaabaaaaeaaaaaaakaabaaaacaaaaaaakaabaaaaeaaaaaa
diaaaaahbcaabaaaaeaaaaaadkaabaaaabaaaaaaakaabaaaaeaaaaaadcaaaaam
hcaabaaaadaaaaaaagaabaaaaeaaaaaaegiccaagabaaaaaaaeaaaaaadkaabaaa
adaaaaaaegacbaaaadaaaaaaboaaaaahicaabaaaadaaaaaadkaabaaaadaaaaaa
abeaaaaaabaaaaaabgaaaaabdcaaaaajhcaabaaaacaaaaaaegacbaaaaaaaaaaa
jgahbaaaacaaaaaaegacbaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaa
acaaaaaaegacbaaaacaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaa
egacbaaaaaaaaaaaegacbaaaacaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaa
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
Vector 1 [_TerrainTreeLightColors0]
Vector 2 [_TerrainTreeLightColors1]
Vector 3 [_TerrainTreeLightColors2]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
"3.0-!!ARBfp1.0
# 28 ALU, 3 TEX
PARAM c[6] = { state.lightmodel.ambient,
		program.local[1..3],
		{ 1, 10, 1.75, 0.125 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R2.xyz, fragment.texcoord[1], c[0];
TEX R0.x, fragment.texcoord[0], texture[2], 2D;
MAD R0.x, R0, c[4].y, c[4];
EX2 R0.w, R0.x;
ADD R1.w, R0, -c[4].z;
POW R0.w, fragment.texcoord[3].y, R1.w;
MUL R2.w, R1, R0;
TEX R0.w, fragment.texcoord[0], texture[1], 2D;
POW R3.x, fragment.texcoord[4].y, R1.w;
MUL R0.xyz, fragment.texcoord[3].x, c[2];
MAD R0.xyz, fragment.texcoord[2].x, c[1], R0;
TEX R1.xyz, fragment.texcoord[0], texture[0], 2D;
MUL R2.xyz, R2, c[5].x;
MAD R0.xyz, fragment.texcoord[4].x, c[3], R0;
MUL R2.w, R0, R2;
MUL R2.xyz, R1, R2;
MUL R0.xyz, R1, R0;
MUL R1.xyz, R2.w, c[2];
POW R2.w, fragment.texcoord[2].y, R1.w;
MUL R3.x, R1.w, R3;
MUL R2.w, R1, R2;
MUL R1.w, R0, R2;
MAD R1.xyz, R1.w, c[1], R1;
MUL R0.w, R3.x, R0;
MAD R1.xyz, R0.w, c[3], R1;
MAD R0.xyz, R1, c[4].w, R0;
MAD result.color.xyz, R0, c[5].x, R2;
MOV result.color.w, c[4].x;
END
# 28 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_TerrainTreeLightColors0]
Vector 2 [_TerrainTreeLightColors1]
Vector 3 [_TerrainTreeLightColors2]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_TranslucencyMap] 2D
SetTexture 2 [_BumpSpecMap] 2D
"ps_3_0
; 33 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c4, 10.00000000, 1.00000000, -1.75000000, 2.00000000
def c5, 0.12500000, 0, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xy
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xy
texld r0.x, v0, s2
mul r2.xyz, v1, c0
mad r0.x, r0, c4, c4.y
exp r0.x, r0.x
add r1.w, r0.x, c4.z
pow r0, v4.y, r1.w
mul r2.w, r1, r0.x
pow r0, v3.y, r1.w
mov r0.y, r0.x
mul_pp r3.xyz, v3.x, c2
mad_pp r3.xyz, v2.x, c1, r3
texld r0.w, v0, s1
mul r0.y, r1.w, r0
texld r1.xyz, v0, s0
mul r2.xyz, r2, c4.w
mul_pp r2.xyz, r1, r2
mad_pp r3.xyz, v4.x, c3, r3
mul_pp r1.xyz, r1, r3
pow r3, v2.y, r1.w
mov r0.x, r3
mul r1.w, r1, r0.x
mul r0.y, r0.w, r0
mul r1.w, r0, r1
mul r0.xyz, r0.y, c2
mad r0.xyz, r1.w, c1, r0
mul r0.w, r2, r0
mad r0.xyz, r0.w, c3, r0
mad r0.xyz, r0, c5.x, r1
mad oC0.xyz, r0, c4.w, r2
mov_pp oC0.w, c4.y
"
}

SubProgram "d3d11 " {
Keywords { "LUX_GAMMA" "LUX_LLFIX_BILLBOARDS_OFF" "GLDIFFCUBE_OFF" }
ConstBuffer "UnityPerFrame" 208 // 80 used size, 4 vars
Vector 64 [glstate_lightmodel_ambient] 4
ConstBuffer "UnityTerrainImposter" 128 // 128 used size, 2 vars
Vector 64 [_TerrainTreeLightColors0] 4
Vector 80 [_TerrainTreeLightColors1] 4
Vector 96 [_TerrainTreeLightColors2] 4
Vector 112 [_TerrainTreeLightColors3] 4
BindCB "UnityPerFrame" 0
BindCB "UnityTerrainImposter" 1
SetTexture 0 [_MainTex] 2D 0
SetTexture 1 [_TranslucencyMap] 2D 2
SetTexture 2 [_BumpSpecMap] 2D 1
// 28 instructions, 5 temp regs, 0 temp arrays:
// ALU 16 float, 2 int, 0 uint
// TEX 3 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 1 dynamic
"ps_4_0
eefiecedpjfleicpgmaloeojkjhakoopbaaempclabaaaaaacaafaaaaadaaaaaa
cmaaaaaapmaaaaaadaabaaaaejfdeheomiaaaaaaahaaaaaaaiaaaaaalaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaalmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaalmaaaaaaabaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaalmaaaaaaacaaaaaaaaaaaaaaadaaaaaaadaaaaaaadadaaaalmaaaaaa
adaaaaaaaaaaaaaaadaaaaaaaeaaaaaaadadaaaalmaaaaaaaeaaaaaaaaaaaaaa
adaaaaaaafaaaaaaadadaaaalmaaaaaaafaaaaaaaaaaaaaaadaaaaaaagaaaaaa
ahaaaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaklklklepfdeheo
cmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaa
apaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoiadaaaaeaaaaaaapkaaaaaa
fjaaaaaeegiocaaaaaaaaaaaafaaaaaafjaiaaaeegiocaaaabaaaaaaaiaaaaaa
fkaaaaadaagabaaaaaaaaaaafkaaaaadaagabaaaabaaaaaafkaaaaadaagabaaa
acaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaafibiaaaeaahabaaaabaaaaaa
ffffaaaafibiaaaeaahabaaaacaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagcbaaaaddcbabaaaadaaaaaagcbaaaaddcbabaaa
aeaaaaaagcbaaaaddcbabaaaafaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaac
afaaaaaaflaaaaaedcbabaaaadaaaaaaadaaaaaaefaaaaajpcaabaaaaaaaaaaa
egbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaaefaaaaajpcaabaaa
abaaaaaaegbabaaaabaaaaaaeghobaaaabaaaaaaaagabaaaacaaaaaaefaaaaaj
pcaabaaaacaaaaaaegbabaaaabaaaaaaeghobaaaacaaaaaaaagabaaaabaaaaaa
dcaaaaajicaabaaaaaaaaaaaakaabaaaacaaaaaaabeaaaaaaaaacaebabeaaaaa
aaaaiadpbjaaaaaficaabaaaaaaaaaaadkaabaaaaaaaaaaaaaaaaaahicaabaaa
aaaaaaaadkaabaaaaaaaaaaaabeaaaaaaaaaoalpdiaaaaaihcaabaaaabaaaaaa
egbcbaaaacaaaaaaegiccaaaaaaaaaaaaeaaaaaaaaaaaaahhcaabaaaabaaaaaa
egacbaaaabaaaaaaegacbaaaabaaaaaadiaaaaahbcaabaaaacaaaaaadkaabaaa
aaaaaaaaabeaaaaaaaaaaadodgaaaaaiocaabaaaacaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadgaaaaaipcaabaaaadaaaaaaaceaaaaaaaaaaaaa
aaaaaaaaaaaaaaaaaaaaaaaadaaaaaabcbaaaaahbcaabaaaaeaaaaaadkaabaaa
adaaaaaaabeaaaaaadaaaaaaadaaaeadakaabaaaaeaaaaaadcaaaaaoocaabaaa
acaaaaaaagijcaagabaaaaaaaeaaaaaadkaabaaaadaaaaaaagbanaaaadaaaaaa
dkaabaaaadaaaaaafgaobaaaacaaaaaacpaaaaahbcaabaaaaeaaaaaabkbanaaa
adaaaaaadkaabaaaadaaaaaadiaaaaahbcaabaaaaeaaaaaadkaabaaaaaaaaaaa
akaabaaaaeaaaaaabjaaaaafbcaabaaaaeaaaaaaakaabaaaaeaaaaaadiaaaaah
bcaabaaaaeaaaaaaakaabaaaacaaaaaaakaabaaaaeaaaaaadiaaaaahbcaabaaa
aeaaaaaadkaabaaaabaaaaaaakaabaaaaeaaaaaadcaaaaamhcaabaaaadaaaaaa
agaabaaaaeaaaaaaegiccaagabaaaaaaaeaaaaaadkaabaaaadaaaaaaegacbaaa
adaaaaaaboaaaaahicaabaaaadaaaaaadkaabaaaadaaaaaaabeaaaaaabaaaaaa
bgaaaaabdcaaaaajhcaabaaaacaaaaaaegacbaaaaaaaaaaajgahbaaaacaaaaaa
egacbaaaadaaaaaaaaaaaaahhcaabaaaacaaaaaaegacbaaaacaaaaaaegacbaaa
acaaaaaadcaaaaajhccabaaaaaaaaaaaegacbaaaabaaaaaaegacbaaaaaaaaaaa
egacbaaaacaaaaaadgaaaaaficcabaaaaaaaaaaaabeaaaaaaaaaiadpdoaaaaab
"
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

#LINE 118

	}
}

FallBack Off
}
