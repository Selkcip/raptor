Shader "Portal/DepthTest" {

	Properties { }

	SubShader {
		Tags { "Queue"="Geometry-1" }
		ColorMask 0
		ZWrite On

		CGPROGRAM
		#pragma surface surf Lambert

		struct Input {
			float4 COLOR;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = float3(0,0,0);
			o.Alpha = float(0);
		}

		ENDCG
	}

}