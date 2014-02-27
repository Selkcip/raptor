Shader "Portal/PortalCameraMask" {
	Properties {
		_PortalNumber ("Portal Number", Float) = 0
	}

	SubShader {
		Tags { "Queue"="Geometry-1" }
		ColorMask 0
		ZWrite On

		Pass {
			Stencil {
				Ref [_PortalNumber]
				Comp NotEqual
				Pass keep
				Fail keep
			}

			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert
			#pragma fragment frag

			struct vertexInput {
				float4 vertex : POSITION;
			};

			struct fragmentInput {
				float4 pos : SV_POSITION;
				float4 color : COLOR0;
			};

			fragmentInput vert(vertexInput i) {
				fragmentInput o;
				o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
				o.color = float4(0, 0, 0, 0);
				return o;
			}

			half4 frag(fragmentInput i) : COLOR {
				return i.color;
			}

			ENDCG
		}
	} 

	FallBack "Diffuse"
}
