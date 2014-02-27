Shader "Portal/PortalMask" {
	Properties {
		_PortalNumber ("Portal Number", Float) = 1
	}
	SubShader {
		Tags { "Queue"="Geometry-2" }
		ColorMask 0
		ZWrite Off
		
		Stencil {
			Ref [_PortalNumber]
			Comp always
			Pass replace
		}

		Blend SrcAlpha OneMinusSrcAlpha
		Pass {
			Stencil {
				Ref [_PortalNumber]
				Comp always
				Pass replace
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
