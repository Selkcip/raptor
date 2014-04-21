/*Shader "Projector/Bumped Spec" {
    Properties {
      _Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
    }
    SubShader {
      Tags { "RenderType" = "Opaque" }
	  //Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

	  //Blend SrcAlpha OneMinusSrcAlpha

      CGPROGRAM
      #pragma surface surf BlinnPhong vertex:vert alpha

	  uniform float4x4 _Projector;

      struct Input {
          float2 uv_MainTex;
		  float4 posProj;
      };
      void vert (inout appdata_full v, out Input o) {
          UNITY_INITIALIZE_OUTPUT(Input,o);
		  o.posProj = mul(_Projector, v.vertex);
      }
     sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed4 _Color;
		half _Shininess;
      void surf (Input IN, inout SurfaceOutput o) {
		//fixed4 tex = tex2D (_MainTex, float2(IN.posProj) / IN.posProj.w);
        fixed4 c = tex2D (_MainTex, float2(IN.posProj) / IN.posProj.w) * _Color;
			o.Albedo = c.rgb;
			o.Gloss = c.a;
			o.Alpha = c.a;
			o.Specular = _Shininess;
			o.Normal = UnpackNormal (tex2D (_BumpMap, float2(IN.posProj) / IN.posProj.w));
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }*/

  Shader "Projector/Bumped Spec" {
    Properties {
      _Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
      //Tags { "RenderType" = "Opaque" }
	  //Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	  Tags {
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		//Offset -1, -1

	  //Blend SrcAlpha OneMinusSrcAlpha

      CGPROGRAM
      #pragma surface surf BlinnPhong vertex:vert alphatest:_Cutoff

	  uniform float4x4 _Projector;

      struct Input {
          float2 uv_MainTex;
          float2 uv_BumpMap;
		  float4 posProj;
      };
      void vert (inout appdata_full v, out Input o) {
          UNITY_INITIALIZE_OUTPUT(Input,o);
		  o.posProj = mul(_Projector, v.vertex);
      }
     sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed4 _Color;
		half _Shininess;
      void surf (Input IN, inout SurfaceOutput o) {
		//fixed4 tex = tex2D (_MainTex, float2(IN.posProj) / IN.posProj.w);
        fixed4 c = tex2D (_MainTex, float2(IN.posProj) / IN.posProj.w);
			o.Albedo = c.rgb * _Color.rgb;
			o.Gloss = 1;//c.a;
			o.Alpha = c.a * _Color.a;
			o.Specular = _Shininess;
			o.Normal = UnpackNormal (tex2D (_BumpMap, float2(IN.posProj) / IN.posProj.w));
			//o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
      }
      ENDCG
    } 
    Fallback "Diffuse"
  }