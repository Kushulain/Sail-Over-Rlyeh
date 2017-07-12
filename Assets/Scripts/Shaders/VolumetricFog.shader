Shader "SOR/VolumetricFog"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1)
		_blurOffset ("_blurOffset", Range(0.0,0.5)) = 0.05
	}
	SubShader
	{
//   Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" } 
   Tags { "Queue"="Geometry" "RenderType"="Opaque" } 
		LOD 100

		Pass
		{
				Tags { "LightMode" = "ForwardBase" }
			Blend SrcAlpha OneMinusSrcAlpha 
			Cull Off
			ZWrite Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
		    	#pragma multi_compile_fwdbase
	        	#define UNITY_PASS_FORWARDBASE
			// make fog work
//			#pragma multi_compile_fog

			#include "AutoLight.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float2 blurcenter : TEXCOORD1;
				float4 pos : SV_POSITION;
			    #if (defined(DIRECTIONAL) )
			    half4 _ShadowCoord : TEXCOORD3;
			    #else
			    LIGHTING_COORDS(3,4)
			    #endif
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _blurOffset;

			fixed4 ComputeScreenPosTEST (float4 pos)
			{
				float4 o = pos * 0.5f;
			//#if defined(UNITY_HALF_TEXEL_OFFSET)
				o.xy = float2(o.x, o.y*_ProjectionParams.x) + o.w * _ScreenParams.zw;
			//#else
			////	o.xy = float2(o.x, o.y*_ProjectionParams.x) + o.w;
			//#endif
				o.zw = pos.zw;
				return o;
			}

			v2f vert (appdata v)
			{
				v2f o;
//				o.vertex = UnityObjectToClipPos(v.vertex);
				o.pos = v.vertex * 2.0;
				o.pos.z = 0.99;
				o.pos.w = 1.0;
//				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				#ifdef SHADOWS_DEPTH
				o.pos.x *= 0;
				#endif

				o.uv = v.uv;
					#ifndef SHADOWS_DEPTH
				    #if (defined(DIRECTIONAL) && !defined(SHADOWS_SCREEN))
				    o._ShadowCoord = ComputeScreenPosTEST(o.pos);// mul( unity_World2Shadow[0], mul( _Object2World, v.vertex ) );
				    //o._ShadowCoord = mul( unity_World2Shadow[0], mul( _Object2World, v.vertex ) );
				    //o._ShadowCoord.z += 0.1;
				    #else
				    TRANSFER_VERTEX_TO_FRAGMENT(o);
				    #endif
				    #endif
//				o.lightDir = WorldSpaceLightDir( float4_WorldSpaceCameraPos,1.0) );  	
//				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{

				i.blurcenter =  mul (UNITY_MATRIX_VP, float4(_WorldSpaceCameraPos + _WorldSpaceLightPos0.xyz,1.0));
				i.blurcenter.x = i.blurcenter.x;
				float4 blurDirection  = float4((-i.blurcenter.xy-(i.uv.xy - 0.5)) , 0.0, 0.0);
				blurDirection.x = -blurDirection.x;
//				blurDirection.y = -blurDirection.y;
				blurDirection *= _blurOffset;

//				return (i._ShadowCoord.w);
//				return  float4(blurDirection.xy,0.0,1.0);// length((i.pos.xy / i.pos.z)) * 0.005;//-i.pos.xy*0.001
//				return  float4((i.uv.xy - 0.5) - i.blurcenter.xy,0.0,1.0);// length((i.pos.xy / i.pos.z)) * 0.005;//-i.pos.xy*0.001
//    			fixed atten = LIGHT_ATTENUATION(i);// unitySampleShadowTest(_DepthColor);// LIGHT_ATTENUATION(i);
				// sample the texture
				fixed4 col = _Color;
				#if defined (DIRECTIONAL) && defined (SHADOWS_SCREEN) && !defined(UNITY_NO_SCREENSPACE_SHADOWS)
				 fixed2 firstAtten = tex2Dproj( _ShadowMapTexture, UNITY_PROJ_COORD(i._ShadowCoord) ).gb;
				 blurDirection *= saturate(1.0 - firstAtten.y );
				 fixed atten = tex2Dproj( _ShadowMapTexture, UNITY_PROJ_COORD(i._ShadowCoord+blurDirection) ).g;
				 atten += tex2Dproj( _ShadowMapTexture, UNITY_PROJ_COORD(i._ShadowCoord+blurDirection*2.0) ).g;
				 atten += tex2Dproj( _ShadowMapTexture, UNITY_PROJ_COORD(i._ShadowCoord-blurDirection) ).g;
				 atten += tex2Dproj( _ShadowMapTexture, UNITY_PROJ_COORD(i._ShadowCoord-blurDirection*2.0) ).g;

				 firstAtten = max(firstAtten,atten.x*0.25);
					col.a *= firstAtten;
				#endif



//				#if !defined(UNITY_NO_SCREENSPACE_SHADOWS)
//				 col.b = 1.0;
//				#endif
				return col;
			}
			ENDCG
		}
	}
}
