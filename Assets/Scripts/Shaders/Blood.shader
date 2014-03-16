// Per pixel bumped refraction.
// Uses a normal map to distort the image behind, and
// an additional texture to tint the color.

Shader "FX/Blood" {
Properties {
	_BumpAmt  ("Distortion", range (0,128)) = 10
	_ColorTint ("Tint", Color) = (1,1,1,1)
	_MainTex ("Tint Color (RGB)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}
	 _GlowTex ("Glow", 2D) = "" {}
    _GlowColor ("Glow Color", Color)  = (1,1,1,1)
    _GlowStrength ("Glow Strength", Float) = 1.0
}

Category {

	// We must be transparent, so other objects are drawn before this one.
	//Tags { "Queue"="Transparent" }
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderEffect"="Glow11Transparent" "RenderType"="Glow11Transparent" }
	Blend SrcAlpha OneMinusSrcAlpha
	AlphaTest Greater .01


	SubShader {

		// This pass grabs the screen behind the object into a texture.
		// We can access the result in the next pass as _GrabTexture
		GrabPass {							
			Name "BASE"
			Tags { "LightMode" = "Always" }
 		}
 		
 		// Main pass: Take the texture grabbed above and use the bumpmap to perturb it
 		// on to the screen
		Pass {
			Name "BASE"
			Tags { "LightMode" = "Always" }
			
CGPROGRAM
#pragma profiles arbfp1
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#include "UnityCG.cginc"

struct appdata_t {
	float4 vertex : POSITION;
	float2 texcoord: TEXCOORD0;
};

struct v2f {
	float4 vertex : POSITION;
	float4 uvgrab : TEXCOORD0;
	float2 uvbump : TEXCOORD1;
	float2 uvmain : TEXCOORD2;
	float3 normal : TEXCOORD3;
};

float _BumpAmt;
float4 _ColorTint;
float4 _BumpMap_ST;
float4 _MainTex_ST;

v2f vert (appdata_base v)
{
	v2f o;
	o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
	#if UNITY_UV_STARTS_AT_TOP
	float scale = -1.0;
	#else
	float scale = 1.0;
	#endif
	o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
	o.uvgrab.zw = o.vertex.zw;
	o.uvbump = TRANSFORM_TEX( v.texcoord, _BumpMap );
	o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
	o.normal = mul( (float3x3)UNITY_MATRIX_MVP, v.normal );
	return o;
}

sampler2D _GrabTexture;
float4 _GrabTexture_TexelSize;
sampler2D _BumpMap;
sampler2D _MainTex;

half4 frag( v2f i ) : COLOR
{
	// calculate perturbed coordinates
	//i.normal = (i.normal+1.0)*0.5;
	half2 bump = i.normal.xy+UnpackNormal(tex2D( _BumpMap, i.uvbump )).rg; // we could optimize this by just reading the x & y without reconstructing the Z
	float2 offset = bump * _BumpAmt * _GrabTexture_TexelSize.xy;
	i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;
	
	half4 col = tex2Dproj( _GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
	half4 tint = tex2D( _MainTex, i.uvmain );
	return col * tint * _ColorTint;
}
ENDCG
		}
	}

	// ------------------------------------------------------------------
	// Fallback for older cards and Unity non-Pro
	
	SubShader {
		Blend DstColor Zero
		Pass {
			Name "BASE"
			SetTexture [_MainTex] {	combine texture }
		}
	}
}

CustomEditor "GlowMatInspector"

}
