Shader ".Cat/Water" {
	Properties {
		_Cube ("Reflection Map", Cube) = "" {}
		_Color ("Main Color", Color) = (1,1,1,1)
		_ZColor ("Zenith Color", Color) = (1,1,1,1)
		_HColor ("horizon Color", Color) = (1,1,1,1)
		_SSSColor ("SSS Color", Color) = (1,1,1,1)
		_TextureA ("diffuse", 2D) = "white" { }
		_TextureB ("random", 2D) = "white" { }
		_TextureC ("detai", 2D) = "white" { }
		_Foam ("foam", 2D) = "white" { }
		_FoamAmount ("_FoamAmount", Range(-10.0,10.0)) = 0.5
		_windDirection ("Wind Direction", Vector) = (1,1,1,1)
		_windRandomness ("Wind Randomness", Range(0.0,2.0)) = 0.5
		_Size ("Size", Range(0,10)) = 0.5
		_NormalIntensity ("_NormalIntensity", Range(0,100)) = 0.5
		_RandomPosition ("_RandomPosition", Range(0,1)) = 0.5
		_RandomSize ("_RandomSize", Range(0,1)) = 0.5
		_ClippingStart ("_ClippingStart", Range(0,500)) = 40
		_ClippingEnd ("_ClippingEnd", Range(0,500)) = 80
		_Tess ("Tess", Range(0,100)) = 0.5
		_Waves1 ("Waves1", Vector) = (1,1,1,1)
		_Waves2 ("Waves2", Vector) = (1,1,1,1)
		_Waves3 ("Detail3", Vector) = (1,1,1,1)
		_Waves4 ("Detail4", Vector) = (1,1,1,1)
	}

	
	SubShader {
	Tags { "Queue" = "Geometry" "IgnoreProjector"="True" "RenderType"="Opaque"}
	

//             Pass {
//	            Name "ShadowCollector"
//	            Tags {"LightMode" = "ShadowCollector" }
//	            Fog {Mode Off}
//	            ZWrite On ZTest LEqual
//
//		        CGPROGRAM
//		        #define CUTOUT
//	        	#define pass_id 0.0
//           		#define GEOMETRYPASS
//				#pragma target 5.0
//
//				#pragma geometry GS_Main
//				#pragma vertex vert
//				#pragma fragment fragSC
//				#pragma fragmentoption ARB_precision_hint_fastest
//				#pragma multi_compile_shadowcollector
//				#define SHADOW_COLLECTOR_PASS
//				#include "UnityCG.cginc"
//				#define Geometry_Flat_Pass
//				#include "GrassPrograms.cginc"
//				#include "HLSLSupport.cginc"
//				#include "UnityShaderVariables.cginc"
//           		#include "GeometryGrassProgram.cginc"
//				
//		        ENDCG
//             }

             Pass {
		        Name "ShadowCaster"
		        Tags { "LightMode" = "ShadowCaster" }
				Fog {Mode Off}
				ZWrite On ZTest Less Cull Off
				Offset 1, 1

		        CGPROGRAM
		        #define CUTOUT
	        	#define pass_id 0.0
           		#define GEOMETRYPASS
           		#define CAM_ATTACHED
			#pragma target 5.0
			#pragma multi_compile NO_DEPTH_ON NO_DEPTH_OFF

			#pragma exclude_renderers gles
//				#pragma geometry GS_Main
			#pragma vertex tessvert
			#pragma hull hull
			#pragma domain domain
			#pragma fragment fragSCaster
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"
			#define SHADOW_CASTER_PASS
			#define Geometry_Flat_Pass
			#include "HLSLSupport.cginc"
			#include "UnityShaderVariables.cginc"
			#include "WaterPrograms.cginc"
           		//#include "GeometryWaterProgram.cginc"
           		#include "WaterTessellation.cginc"
				
		        ENDCG
             }

	

			Pass {
				ZWrite On
				 //AlphaTest Greater 0.5
				 AlphaToMask Off
				 Cull Off
				 ZTest Less
				 //Option1
				 //Option2
				 //Option3
				 //Option4
				 //Option5
				Blend One Zero
				Tags { "LightMode" = "ForwardBase" }

		        CGPROGRAM
		        #define CUTOUT
	        	#define pass_id 0.0
           		#define GEOMETRYPASS
           		#define CAM_ATTACHED
			#define Geometry_Flat_Pass
			#pragma target 5.0
			#pragma multi_compile NO_DEPTH_ON NO_DEPTH_OFF

//				#pragma geometry GS_Main
			#pragma vertex tessvert
			#pragma fragment frag
			#pragma hull hull
			#pragma domain domain

		    	#pragma multi_compile_fwdbase
	        	#define UNITY_PASS_FORWARDBASE

           		#include "WaterPrograms.cginc"
			#include "HLSLSupport.cginc"
			#include "UnityShaderVariables.cginc"
           		//#include "GeometryWaterProgram.cginc"
           		#include "WaterTessellation.cginc"
				
		        ENDCG
			}
	       //////////////////////////////////////////// GEOMETRY Light ADD
			Pass {
				Name "FORWARD"
				ZWrite On
//				 AlphaTest Greater 0.5
//				 AlphaToMask On
				 Cull Off
				 //ZTest Equal
				 //Cull Back
				 //Option1
				 //Option2
				 //Option3
				 //Option4
				 //Option5
				Blend One One
				Fog { Color (0,0,0,0) }
				Tags { "LightMode" = "ForwardAdd" }

		        CGPROGRAM
		        #define CUTOUT
	        	#define pass_id 0.0
           		#define GEOMETRYPASS
           		#define CAM_ATTACHED
			#pragma target 5.0
			#pragma multi_compile NO_DEPTH_ON NO_DEPTH_OFF

//				#pragma geometry GS_Main
			#pragma vertex tessvert
			#pragma fragment frag
			#pragma hull hull
			#pragma domain domain

			#pragma multi_compile_fwdadd
			#define UNITY_PASS_FORWARDADD
			#define Geometry_Flat_Pass
			#include "WaterPrograms.cginc"
			#include "HLSLSupport.cginc"
			#include "UnityShaderVariables.cginc"
   			#include "WaterTessellation.cginc"
				
		        ENDCG
			}
	
	}
	Fallback "VertexLit"
}