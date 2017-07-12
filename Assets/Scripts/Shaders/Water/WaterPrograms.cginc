// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'


#ifndef FUR_PROGRAM_INCLUDED
#define FUR_PROGRAM_INCLUDED

#define DOT_TO_RIM(dot,coord) max(0.0,1.0-abs(dot-coord))

	       // #define pass_Count 2
	       // #define sample_per_pass 3
#define SAMPLE_NUMBER 6
//#pragma target 3.0

#ifndef pass_Count
	#define pass_Count 16
#endif

#define sample_per_pass 2
//#define pass_id 0.5

#ifndef alphaThreshold
#define alphaThreshold 0.0
#endif

#include "AutoLight.cginc"
#include "UnityCG.cginc"
#include "Lighting.cginc"
            
sampler2D _TextureA;

sampler2D _TextureB;
sampler2D _TextureC;
sampler2D _Foam;

float4 _TextureA_ST;
float4 _TextureB_ST;
float4 _windDirection;
float _windRandomness;
float4 _Color;
float4 _HColor;
float4 _ZColor;
float4 _Waves1;
float4 _Waves2;
float4 _Waves3;
float4 _Waves4;
float _NormalIntensity;
float _ClippingStart;
float _ClippingEnd;
float _FoamAmount;


struct v2f {

    #if (defined(GEOMETRYPASS) )
    float4 pos : SV_POSITION;
    #else
    float4 pos : POSITION;
    #endif
    float4 wPos : TEXCOORD0;
//    float4 uv2 : TEXCOORD1;
    fixed3 normal : NORMAL;
    fixed3 tangent : TANGENT;
    fixed3 binormal : TEXCOORD1 ;
    //float3 alphaMulti : TEXCOORD2;
    ////TESTING
    //#if (defined(DIRECTIONAL) && !defined(SHADOWS_SCREEN))
    
    #if (defined(DIRECTIONAL) )
    half4 _ShadowCoord : TEXCOORD3;
    #else
    LIGHTING_COORDS(3,4)
    #endif

    //half3 _LightCoord : TEXCOORD3;
    //half4 _ShadowCoord : TEXCOORD3;
	#ifndef SHADOWS_DEPTH
    fixed4 _viewDir : TEXCOORD5; // .w : distance with screen center
//    float4 colo : TEXCOORD6;
    fixed3 lightDir : TEXCOORD7;
    #endif
    
};

//#if ((defined(DIRECTIONAL) && defined(SHADOWS_SCREEN) && defined(LIGHTMAP_OFF) && defined(DIRLIGHTMAP_OFF)) || (defined(DIRECTIONAL) && defined(SHADOWS_SCREEN) && defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_OFF)) || (defined(DIRECTIONAL) && defined(SHADOWS_SCREEN) && defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_ON)) ||  (defined(DIRECTIONAL) && defined(SHADOWS_SCREEN) && defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_OFF) && defined(VERTEXLIGHT_ON)))
//
//uniform sampler2D _ShadowMapTexture;
//#endif


//Transparent shadow receive
//#if (!defined(DIRECTIONAL) || !defined(SHADOWS_SCREEN))



//#if (defined(DIRECTIONAL) && !defined(SHADOWS_SCREEN))
//uniform sampler2D _ShadowMapTexture;
//#endif



struct appdata_simple {
    float4 vertex : POSITION;
//    float4 tangent : TANGENT;
    float3 normal : NORMAL;
    float4 texcoord : TEXCOORD0;
//    float4 color : COLOR;
};


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

v2f vert (appdata_simple v)
{
    v2f o = (v2f)0;
    #ifdef CAM_ATTACHED
    o.wPos = v.vertex;
    #else
    o.wPos = mul (unity_ObjectToWorld, v.vertex);
    #endif


    float dist = length(_WorldSpaceCameraPos-o.wPos);//length(ObjSpaceViewDir(p[0].pos));
    dist = (1.0-smoothstep(_ClippingStart,_ClippingEnd,dist));
    dist *= dist * dist;

    float minTess = 0.1;
    o.binormal.x = minTess;
    o.tangent.z = minTess;


    float waves1 = tex2Dlod(_TextureB,float4(o.wPos.xz * _Waves1.zz * float2(2.0,1.0) + _Time.xx * _Waves1.xy,1,1)).a;
    float waves1x = tex2Dlod(_TextureB,float4((float2(minTess,0.0) + o.wPos.xz) * _Waves1.zz * float2(2.0,1.0) + _Time.xx * _Waves1.xy,1,1)).a;
    float waves1y = tex2Dlod(_TextureB,float4((float2(0.0,minTess) + o.wPos.xz) * _Waves1.zz * float2(2.0,1.0) + _Time.xx * _Waves1.xy,1,1)).a;
//    waves1.xyz = waves1.xyz * 2.0 - 1.0;
    float waves2 = tex2Dlod(_TextureB,float4(o.wPos.xz * _Waves2.zz * float2(2.0,1.0) + _Time.xx * _Waves2.xy,1,1)).a;
    float waves2x = tex2Dlod(_TextureB,float4((float2(minTess,0.0) + o.wPos.xz) * _Waves2.zz * float2(2.0,1.0) + _Time.xx * _Waves2.xy,1,1)).a;
    float waves2y = tex2Dlod(_TextureB,float4((float2(0.0,minTess) + o.wPos.xz) * _Waves2.zz * float2(2.0,1.0) + _Time.xx * _Waves2.xy,1,1)).a;
//    waves2.xyz = waves2.xyz * 2.0 - 1.0;
    //float4 detail += tex2Dlod(_TextureB,float4(o.wPos.xz*0.145173,0.1,0.0));
    o.binormal.y = (_Waves1.w * waves1x + _Waves2.w * waves2x) - (_Waves1.w * waves1 + _Waves2.w * waves2);
    o.binormal.y *= dist;
    o.tangent.y = (_Waves1.w * waves1y + _Waves2.w * waves2y) - (_Waves1.w * waves1 + _Waves2.w * waves2);
    o.tangent.y *= dist;

    float results =  _Waves1.w * waves1 + _Waves2.w * waves2;
    results *=  dist;
    o.wPos.y += results;
    o.pos = mul (UNITY_MATRIX_VP, o.wPos);
//    o.pos = o.wPos;

    o.tangent = normalize(o.tangent);
    o.binormal = normalize(o.binormal);
    o.normal = cross(o.tangent,o.binormal);
//    o.normal = (_Waves1.w * waves1x + _Waves2.w * waves2x) - (_Waves1.w * waves1 + _Waves2.w * waves2);


//Transparent shadow receive
	#ifndef SHADOWS_DEPTH
    #if (defined(DIRECTIONAL) && !defined(SHADOWS_SCREEN))
    o._ShadowCoord = ComputeScreenPosTEST(o.pos);// mul( unity_World2Shadow[0], mul( _Object2World, v.vertex ) );
    //o._ShadowCoord = mul( unity_World2Shadow[0], mul( _Object2World, v.vertex ) );
    //o._ShadowCoord.z += 0.1;
    #else
    TRANSFER_VERTEX_TO_FRAGMENT(o);
    #endif
    #endif
//    o.pos = mul (unity_ObjectToWorld, v.vertex);
//    o.uv = v.texcoord.y;
//    o.uv.xy = TRANSFORM_TEX (v.texcoord, _TextureA);
//    o.uv.zw = TRANSFORM_TEX (v.texcoord, _TextureB);

	#ifndef SHADOWS_DEPTH
//	o._viewDir.xyz =  WorldSpaceViewDir(v.vertex);
	o._viewDir = float4(o.wPos.xyz - _WorldSpaceCameraPos,0);

	o.lightDir = WorldSpaceLightDir( v.vertex );  	
//  	float3 worldN = (results.xzy);
//    	worldN.y *= _NormalIntensity;
//  	o.normal = normalize(worldN);
  	#endif
	
    return o;
}

//#if (defined(DIRECTIONAL) && !defined(SHADOWS_SCREEN))
//fixed unitySampleShadowTest (float4 shadowCoord)
//{
////	shadowCoord.w += _Test1;
//
////	fixed shadow = UNITY_SAMPLE_SHADOW(_ShadowMapTexture, shadowCoord.xyz);
////	shadow = _LightShadowData.r + shadow * (1-_LightShadowData.r);
////	return shadow;
//
//	fixed shadow = tex2Dproj( _ShadowMapTexture, UNITY_PROJ_COORD(shadowCoord) ).r;
//	return shadow;
//}
//#endif

#ifndef SHADOWS_DEPTH
half4 frag (v2f i) : COLOR
{
	#ifdef NO_DEPTH_OFF
		return length(i._viewDir) / _ProjectionParams.z;
	#endif
//	return float4(i.normal,1);
	half4 texcol;
	float dist = (smoothstep(_ClippingStart,_ClippingEnd,length(i._viewDir.xyz)));


    fixed atten = LIGHT_ATTENUATION(i);// unitySampleShadowTest(_DepthColor);// LIGHT_ATTENUATION(i);

	float4 waves1 = tex2D(_TextureB,float2(i.wPos.xz * _Waves1.zz + _Time.xx * _Waves1.xy));
	waves1.xyz = waves1.xyz * 2.0 - 1.0;
	float4 waves2 = tex2D(_TextureB,float2(i.wPos.xz * _Waves2.zz + _Time.xx * _Waves2.xy));
	waves2.xyz = waves2.xyz * 2.0 - 1.0;
	float4 waves3 = tex2D(_TextureC,float2(i.wPos.xz * _Waves3.zz + _Time.xx * _Waves3.xy));
	waves3.xyz = waves3.xyz * 2.0 - 1.0;
	float4 waves4 = tex2D(_TextureC,float2(i.wPos.xz * _Waves4.zz + _Time.xx * _Waves4.xy));
	waves4.xyz = waves4.xyz * 2.0 - 1.0;

	float3x3 nBasis = float3x3(
	    float3(waves3.z, waves3.y, -waves3.x), // +90 degree rotation around y axis
	    float3(waves3.x, waves3.z, -waves3.y), // -90 degree rotation around x axis
	    float3(waves3.x, waves3.y,  waves3.z));

	float3x3 tangentSpace = float3x3(
	    i.binormal, // +90 degree rotation around y axis
	    i.tangent, // -90 degree rotation around x axis
	    i.normal);

	

	float3 results = normalize(waves4.x*nBasis[0] + waves4.y*nBasis[1] + waves4.z*nBasis[2]);
//	float3 results =  _Waves1.w * waves1 + _Waves2.w * waves2;
//	float4 results =  _Waves1.w * waves1 + _Waves2.w * waves2 + _Waves3.w * waves3;
//	results += waves3 *  _Waves3.w;
//	results += waves4 *  _Waves4.w;
	float3 fragNormal = lerp(mul(tangentSpace, results),i.normal,1.0/(1+_Waves4.w + _Waves3.w));//(results.xzy);
//	fragNormal.y += _NormalIntensity + dist * 33.0;
	fragNormal = normalize(fragNormal) ;

//	return float4(fragNormal.y * 0.5 + 0.5,0.0,0.0,1.0);

	float foam = waves1.a * _Waves1.w + 
	waves2.a * _Waves2.w +
	(waves3.a * _Waves3.w +
	waves4.a * _Waves4.w);

	foam /= (_Waves1.w+_Waves2.w+_Waves3.w+_Waves4.w);
	foam = 1-(waves3.a-waves4.a) * 2.0;
	foam *= _FoamAmount;
//	foam = pow(tex2D(_Foam,float2(i.wPos.xz * 0.1)),1.0+foam * 2.0);
	foam = tex2D(_Foam,float2(i.wPos.xz * 0.5))*(foam);
	foam *= foam;
	foam *= tex2D(_Foam,float2(i.wPos.xz * 2.0));
//	return float4(fragNormal.xyz*0.5 + 0.5,1.0);

//    return 0.5
    //texcol = (half4)1.0;
    //transparency == bottleneck !!! beacause of AA & alpha to coverage
	texcol  =  lerp(_Color,float4(1,1,1,1),foam * 0.99);
//	return float4(i._viewDir.xyz * 0.5 + 0.5,1) ;
//	return float4(i.normal.z,0,0,1) ;
//	texcol  =  _Color ;
//	texcol.xyz = i.normal.rgb;
//	texcol.rgb *=  0.5 + (i.uv.x*0.5);
//	texcol.a = texcol.a * 5.0 - 2.0;
//	texcol.a = (texcol.a -0.5) * 1000.0 + 0.5;
//	#ifdef CUTOUT
//    clip(texcol.a-0.1);
//    #endif
//	texcol.a = floor(texcol.a * 3.0) * 0.5 ; // OPTIMIZATION
//    #if (defined(OPTIMIZATION))
//	#endif
//	texcol.a = 0.1;

    
//Transparent shadow receive
//	fixed atten = 0.0;
//    #if (defined(DIRECTIONAL) && !defined(SHADOWS_SCREEN))
//    fixed atten = LIGHT_ATTENUATION(i._ShadowCoord) ; //unitySampleShadowTest(i._ShadowCoord)  * 0.5;// LIGHT_ATTENUATION(i);
//    #else
//    #endif

//    fixed atten = 1.0;



    //texcol = min(float4(1),texcol);

	#ifndef USING_DIRECTIONAL_LIGHT
	fixed3 lightDir = normalize(i.lightDir);
	#else
	fixed3 lightDir = i.lightDir;
	#endif
  
    //DIFF LIGHT
  	float dot1 =  pow(max(0,dot(fragNormal,lightDir)),1.0);
//  	return dot1;
//	dot1 *= (1.0-smoothstep(_ClippingStart,_ClippingEnd,dist));
//  	dot1 *= 2.0;
    	float3 viewDirN = normalize(i._viewDir.xyz);

	float3 reflectionDirection = reflect((viewDirN),fragNormal);
	float mixReflectionColor = (reflectionDirection.y-0.1);
//	return mixReflectionColor;
//	return float4(reflect(i._viewDir.xyz,i.normal),1.0);
//	mixReflectionColor = pow(mixReflectionColor,0.7);
//	return mixReflectionColor;
	float reflectionHorizon = pow(saturate(mixReflectionColor),0.6);
	float3 reflectionColor = (1-reflectionHorizon)*_HColor + reflectionHorizon * _ZColor;
	mixReflectionColor *= -4.0;
//	mixReflectionColor += 1.0;
	mixReflectionColor = saturate(mixReflectionColor);
//	return mixReflectionColor;
	reflectionColor = (1-mixReflectionColor)*reflectionColor + mixReflectionColor * (_Color);

	texcol.rgb += reflectionColor;

  	dot1 *= atten;

//	#ifdef UNITY_PASS_FORWARDBASE
//    texcol.rgb *= ((_LightColor0.rgb * dot1) + UNITY_LIGHTMODEL_AMBIENT /*+ _customFog*/);
////    texcol = 0;
//	#else
//    texcol.rgb *= ((_LightColor0.rgb * dot1));
////    texcol.rgb = _LightColor0.rgb;
////    texcol = 1;
////  	return float4(_LightColor0.rgb,1.0);
//	#endif
    

//  	float dot2 = pow(DOT_TO_RIM(dot(i.normal,normalize(lightDir+i._viewDir.xyz)),0.4),10);
  	float dot2 = pow(max(dot(reflectionDirection,lightDir),0.0),80.0);

//  	dot2 *= max(1.0,(1.0 - texcol.a) * 4.0);
//    return float4(dot1+dot2,dot1+dot2,dot1+dot2,1.0);
//  	return float4(dot2,dot2,dot2,1.0);
    texcol.rgb +=  0.8 * atten * dot2 * _LightColor0.rgb;

//    return float4(i.normal*0.5+0.5,1.0);
//  	float dot3 = pow(DOT_TO_RIM(dot(i.normal,normalize(lightDir*2+i._viewDir.xyz*0.5)),0),40);
//  	dot3 *= dot1;
//    texcol.rgb += dot3 * 5 * _LightColor0.rgb ; // 1.5 * dot3 * _aDiffColor.rgb * (dot1*2) * texcol.a * atten;

//    texcol.rgb +=  _DepthColor.rgb * (8 * _DepthColor.a - 4)  * pow(1.0-i.colo.w,4);



//	texcol = lerp(texcol,float4(1,1,1,1), max(0.0,atten  - 0.0));
    return texcol;
}
#endif

half4 fragSC (v2f i) : COLOR
{

	return 1;
//    half4 texcol;
//	texcol  =  tex2D (_TextureA, i.uv.xy);
//    return texcol;
}

half4 fragSCaster (v2f i) : COLOR
{
//	return 1; //procedural ? 
//	return 1;
//	clip(sin(i.uv.x*100.0) * 0.5 - i.uv.y);
//    clip(tex2D (_TextureA, i.uv.xy).a-0.5);
    return 1;
}

#endif
	        