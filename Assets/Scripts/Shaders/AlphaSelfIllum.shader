Shader "AlphaSelfIllum" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Trans (A))", 2D) = "white" { }
	_SrcRect ("Source Rect", Vector) = (0,0,1,1)
}
SubShader {
	Tags { "Queue" = "Transparent" }
    Pass {
		
		
		Cull Off
		ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha 
        
		
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		
		#include "UnityCG.cginc"
		
		float4 _Color;
		sampler2D _MainTex;
		
			
		struct v2f {
		    float4  pos : SV_POSITION;
		    float2  uv : TEXCOORD0;
		};
		
		float4 _MainTex_ST;
		
		v2f vert (appdata_base v)
		{
		    v2f o;
		    o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
		    o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
		    return o;
		}

		float4 _SrcRect;
		
		half4 frag (v2f i) : COLOR
		{
			float2 sPos = i.uv*_SrcRect.zw+_SrcRect.xy;
		    half4 texcol = tex2D (_MainTex, sPos);
		    return texcol * _Color;
		}
		ENDCG
    }
}
Fallback off
} 