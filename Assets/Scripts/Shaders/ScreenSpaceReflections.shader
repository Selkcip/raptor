Shader "Image/ScreenSpaceReflections" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}

}

SubShader {
	Pass {
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }

		CGINCLUDE
		// Common code used by several SSAO passes below
		#include "UnityCG.cginc"
		#pragma exclude_renderers gles
		struct v2f_ssr {
			float4 pos : POSITION;
			float2 uv : TEXCOORD0;
			float2 uvr : TEXCOORD1;
		};

		float rand(float2 co){
			return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
		}

		uniform float2 _NoiseScale;
		float4 _CameraDepthNormalsTexture_ST;

		v2f_ssr vert_ssr (appdata_img v)
		{
			v2f_ssr o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv = v.texcoord;//TRANSFORM_TEX(v.texcoord, _CameraDepthNormalsTexture);
			o.uvr = v.texcoord.xy * _NoiseScale;
			return o;
		}

		sampler2D _CameraDepthNormalsTexture;
		sampler2D _CameraDepthTexture;
		sampler2D _RandomTexture;
		float4 _Params; // x=radius, y=minz, z=attenuation power, w=SSAO power
		ENDCG
				
		CGPROGRAM
		#pragma vertex vert_ssr
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma target 3.0
		#pragma glsl
		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		uniform float4x4 UnProj;
		uniform float4x4 Proj;
		uniform float4x4 WorldUnProj;
		uniform float4x4 CamToWorld;
		uniform float RefDis;

		fixed4 frag (v2f_ssr i) : COLOR
		{
			float4 main = tex2D(_MainTex, i.uv);

			fixed4 original = tex2D(_CameraDepthNormalsTexture, i.uv);
			float depth = 0.0;
			float3 normal = float3(0.0);
			DecodeDepthNormal(original, depth, normal);

			depth *= _ProjectionParams.z;

			//depth = UNITY_SAMPLE_DEPTH(tex2D (_CameraDepthTexture, i.uv));
			depth = UNITY_SAMPLE_DEPTH(tex2Dlod(_CameraDepthTexture, float4(i.uv, 0, 0)));

			float3 nNorm = normal;//mul( (float3x3)CamToWorld, normal );

			//sampleD *= _ProjectionParams.z;
			//float zd = saturate(sD-sampleD);

			float4 posMap = float4(i.uv, depth, 1.0);
			posMap.xyz = (posMap.xyz*2.0)-1.0;
			posMap = mul(UnProj, posMap);
			posMap.xyz /= posMap.w;

			//float4 cPos = mul( CamToWorld, float4(0,0,0,1) );
			float3 dir = normalize(-posMap.xyz);
			//dir = mul( (float3x3)Proj, dir );

			//posMap.xyz = cPos.xyz;

			float3 ref = normalize(reflect(-dir, nNorm))*1.0;
			float3 tanA = cross(nNorm, ref)*(-1+rand(i.uv)*2.0);
			float3 tanB = cross(nNorm, tanA)*(-1+rand(i.uv)*2.0);
			//ref = normalize(ref+float3(1.0)*(-0.5+rand(i.uv))*1.0);//(1.0-main.a));
			ref = normalize(ref+(tanA+tanB)*(1.0-main.a));

			float3 pos = posMap.xyz;
			float stepSize =  1.0;
			float4 newPos = float4(0.0);
			float scale = 0.0;
			float sign = 1.0;
			float4 color = float4(0.0);
			float range = 15.0;
			for(float i = 0.0; i < 15.0; ++i){
				pos += ref*stepSize;
				newPos = float4(pos, 1.0);
				newPos = mul(Proj, newPos);
				newPos.xyz /= newPos.w;
				newPos = (newPos+1.0)*0.5;

				original = tex2Dlod(_CameraDepthNormalsTexture, float4(newPos.xy, 0, 0));
				DecodeDepthNormal(original, depth, normal);
				//depth *= _ProjectionParams.z;
				//nNorm = mul( (float3x3)CamToWorld, normal );

				depth = UNITY_SAMPLE_DEPTH(tex2Dlod(_CameraDepthTexture, float4(newPos.xy, 0, 0)));

				posMap.xyz = float4(newPos.xy, depth, 1.0);
				posMap.xyz = (posMap.xyz*2.0)-1.0;
				posMap = mul(UnProj, posMap);
				posMap.xyz /= posMap.w;

				float depthDiff = newPos.z-depth;
				float diff = length(pos-posMap.xyz);
				if(depthDiff > 0.0){// && diff < RefDis){
					//sign *= -1.0;
					pos -= ref*stepSize;
					stepSize *= 0.25;
					//pos += ref*stepSize;
					scale = min(1.0, max(0.0, RefDis-diff));
					//color = tex2Dlod(_MainTex, float4((newPos.xy+1.0)*0.5, 0,0));
					//break;
				}
			}

			//normal = mul( (float3x3)CamToWorld, normal );
			color = tex2D(_MainTex, newPos.xy)*max(0.0, dot(-ref, normal))*scale*max(0.0, 1.0-pow(dot(ref, nNorm),1));
			color.a = 1.0;

			//return float4(depth);
			//return float4((ref.xyz+1.0)*0.5, 1.0);
			//return float4((nNorm.xyz+1.0)*0.5, 1.0);
			//return float4((posMap.xyz+1.0)*0.5, 1.0);
			//return float4(posMap.xyz, 1.0);
			return color*main.a;
			//return color;//*main.a;
			//return float4(tex2D(_MainTex, i.uv));
		}
		ENDCG

	}
	// ---- Blur pass
	Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 3.0
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"

		struct v2f {
			float4 pos : POSITION;
			float2 uv : TEXCOORD0;
		};

		float4 _MainTex_ST;

		v2f vert (appdata_img v)
		{
			v2f o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv = TRANSFORM_TEX (v.texcoord, _CameraDepthNormalsTexture);
			return o;
		}

		sampler2D _SSAO;
		float3 _TexelOffsetScale;

		inline half CheckSame (half4 n, half4 nn)
		{
			// difference in normals
			half2 diff = abs(n.xy - nn.xy);
			half sn = (diff.x + diff.y) < 0.1;
			// difference in depth
			float z = DecodeFloatRG (n.zw);
			float zz = DecodeFloatRG (nn.zw);
			float zdiff = abs(z-zz) * _ProjectionParams.z;
			half sz = zdiff < 0.2;
			return sn * sz;
		}


		float4 frag( v2f i ) : COLOR
		{
			#define NUM_BLUR_SAMPLES 4
	
			float2 o = _TexelOffsetScale.xy;
    
			float4 sum = tex2D(_SSAO, i.uv) * (NUM_BLUR_SAMPLES + 1);
			float denom = NUM_BLUR_SAMPLES + 1;
    
			half4 geom = tex2D (_CameraDepthNormalsTexture, i.uv);
    
			for (int s = 0; s < NUM_BLUR_SAMPLES; ++s)
			{
				float2 nuv = i.uv + o * (s+1);
				float4 ngeom = tex2D (_CameraDepthNormalsTexture, nuv.xy);
				float coef = (NUM_BLUR_SAMPLES - s) * CheckSame (geom, ngeom);
				sum += tex2D (_SSAO, nuv.xy) * coef;
				denom += coef;
			}
			for (int s = 0; s < NUM_BLUR_SAMPLES; ++s)
			{
				float2 nuv = i.uv - o * (s+1);
				float4 ngeom = tex2D (_CameraDepthNormalsTexture, nuv.xy);
				float coef = (NUM_BLUR_SAMPLES - s) * CheckSame (geom, ngeom);
				sum += tex2D (_SSAO, nuv.xy) * coef;
				denom += coef;
			}
			sum /= denom;
			sum.a = 1;
			return sum;
		}
		ENDCG
	}

	//Mix pass
	Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma target 3.0
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"

		struct v2f {
			float4 pos : POSITION;
			float2 uv : TEXCOORD0;
		};

		float4 _MainTex_ST;

		v2f vert (appdata_img v)
		{
			v2f o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv = TRANSFORM_TEX (v.texcoord, _CameraDepthNormalsTexture);
			return o;
		}

		uniform sampler2D _MainTex;
		sampler2D _REF;
		float3 _TexelOffsetScale;

		float4 frag( v2f i ) : COLOR
		{
			#define NUM_BLUR_SAMPLES 4
	
			float2 o = _TexelOffsetScale.xy;
    
			float4 ref = tex2D(_REF, i.uv);// * (NUM_BLUR_SAMPLES + 1);
			float4 color = tex2D(_MainTex, i.uv);
			
			return ref;
			return color+ref;
		}
		ENDCG
	}
}

Fallback off

}