//// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
//
//
//#ifndef GEOMETRY_GRASS_PROGRAM_INCLUDED
//#define GEOMETRY_GRASS_PROGRAM_INCLUDED
//#define stepCount 4.0
//
//
//
////#if defined (REALISTIC_SHADOWS)
////	#if !defined (SHADOW_COLLECTOR_PASS) && defined (DIRECTIONAL)
////		#if defined (UNITY_NO_SCREENSPACE_SHADOWS) 
////		#define TRANSFERSHADOWS(a,b) a._ShadowCoord = mul( unity_WorldToShadow[0], b);
////		#else
////		#define TRANSFERSHADOWS(a,b) a._ShadowCoord = ComputeScreenPos(a.pos);
////		#endif
////	#else
////		#define TRANSFERSHADOWS(a,b)
////	#endif
////#else
////	#if defined(DIRECTIONAL) 
////		#if defined(SHADOWS_SCREEN) 
////			#define TRANSFERSHADOWS(a,b) a._ShadowCoord.x = LIGHT_ATTENUATION(a);
////		#else
////			#define TRANSFERSHADOWS(a,b) 
////		#endif
////	#else
////		#define TRANSFERSHADOWS(a,b) 
////	#endif
////#endif
//
//#if !defined (SHADOW_COLLECTOR_PASS) && defined (DIRECTIONAL)
//	#if defined (UNITY_NO_SCREENSPACE_SHADOWS) 
//	#define TRANSFERSHADOWS(a,b) a._ShadowCoord = mul( unity_WorldToShadow[0], b);
//	#else
//	#define TRANSFERSHADOWS(a,b) a._ShadowCoord = ComputeScreenPos(a.pos);
//	#endif
//#else
//	#define TRANSFERSHADOWS(a,b)
//#endif
//
//#if !defined(SHADOW_CASTER_PASS) && !defined(SHADOW_COLLECTOR_PASS)
//	#define SETVERTEX(apos,auv,anormal) \
//		pIn.pos = mul(vp, apos); \
//		TRANSFERSHADOWS(pIn,apos) \
//		pIn.uv.xy = auv; \
//		pIn.normal = anormal;
//#else
//	#define SETVERTEX(apos,auv,anormal) \
//		pIn.pos = mul(vp, apos); \
//		pIn.uv.xy = auv;
//#endif
//
////#define DIRECTIONNAL_SHADOW \
//
////a._ShadowCoord = LIGHT_ATTENUATION(a)
//
//float _Size;
//float _RandomPosition;
//float _RandomSize;
//half4 _WindDirection;
//float _ClippingStart;
//float _ClippingEnd;
//half4 _RightCam;
////float _Time;
//
//// Geometry Shader -----------------------------------------------------
////#ifdef SHADOW_CASTER_PASS
////[maxvertexcount(12)]
////#else
//[maxvertexcount(8)]
////#endif
//void GS_Main(triangle v2f p[3], inout TriangleStream<v2f> triStream)
//{
////	v2f pIn = p[0];
////	triStream.Append(pIn);
//
//	//float3 viewDir = UNITY_MATRIX_IT_MV[2].xyz;
////	#ifdef EDITORTIME_ON
//	float3 right = -UNITY_MATRIX_IT_MV[0].xyz;
////	#else
////	float3 right = _RightCam.xyz;//-UNITY_MATRIX_IT_MV[0].xyz;
////	#endif
//	float up = 1.0+normalize(_WorldSpaceCameraPos-p[0].pos).y;
//	float dist = length(_WorldSpaceCameraPos-p[0].pos);//length(ObjSpaceViewDir(p[0].pos));
//	float dist2 = (1.0-smoothstep(_ClippingStart,_ClippingEnd,dist*0.5));
////	dist = (1.0-smoothstep(_ClippingStart,_ClippingEnd,dist));
//	float4x4 vp = UNITY_MATRIX_VP;// mul(UNITY_MATRIX_MVP, unity_WorldToObject);
//
//
//	float4 basePosition = (p[0].pos+p[1].pos+p[2].pos)/3.0;
////	basePosition = min(min(p[0].pos,p[1].pos),p[2].pos);
//
//	float3 lengths = float3(length(p[0].pos.xyz-p[1].pos.xyz),
//							length(p[1].pos.xyz-p[2].pos.xyz),
//							length(p[2].pos.xyz-p[0].pos.xyz));
//    float maxlengths = max(lengths.x,max(lengths.y,lengths.z));
//	float flatness = min(lengths.x,min(lengths.y,lengths.z)) / maxlengths;
//	_Size *= min(1.0,max(0.0,flatness*3.0 - 0.3));
//
//	float4 random = tex2Dlod(_TextureB,float4(basePosition.xz*0.145173,0.1,0.0));
//
//	#ifdef SHADOWS_DEPTH
////	float sizeScreen = length(mul(vp,float4(0.0,1.0,0.0,1.0)));
////	_Size *= min(1.0, sizeScreen * 0.6);
////	_Size *= random.z;
//	#endif
//
//	basePosition.xz += _RandomPosition*(random.xz*2.0 - 1.0);
//	half4 wind;
////	half wind3 = sin(((p[0].pos.x)+_WindDirection.w*(_Time+p[0].pos.z*_WindDirection.y))*17.0)*
////	sin(sin(((p[0].pos.x)+_WindDirection.w*(_Time+p[0].pos.z*_WindDirection.y))*7.0)*13.0);
//
//	float4 windTex = tex2Dlod(_TextureB,float4(basePosition.xz*0.001 - _Time.xx*_WindDirection.xz,0.0,0.0));
//	windTex *= windTex;
//	windTex = windTex * 2.0 - 0.4;
//
//	#ifdef SHADOWS_DEPTH
////	p[0].pos.xyz -= UNITY_MATRIX_IT_MV[2].xyz * _Size;
//	#endif
//
////	windTex = max(windTex,-0.4);
////	windTex = windTex*sin(-windTex*3.1415*1.565);
////	windTex = windTex*sin(windTex*3.1415*0.645);
//
//
//	wind.xyz = _WindDirection.xyz * windTex.x * _WindDirection.w ;
////	wind.xyz = _WindDirection.xyz *  sin(_Time * 20.0);
////	_Size *= windTex.x * 1.9;
////	wind.xyz = float3(wind3*_WindDirection.x,0,0);
//	wind.w = 0.0;
//	windTex.x = 1.0 + windTex.x * 0.05 * _WindDirection.w ;
////	wind.xyzw = 0.0;
//    float4 windFold = float4(0.0,dot(wind.x,wind)*_Size,0.0,0.0);
//	//float3 look = _WorldSpaceCameraPos - p[0].pos;
//	//look.y = 0;
//	//look = normalize(look);
//	//float3 right = cross(up, look);
//	_Size *= lerp(1.0,random.z*2.0,_RandomSize);
////	_Size *= min(1.0,2.0 * random.x * (dist));
//	v2f pIn = p[0];
////	if (UNITY_MATRIX_VP[3].w  != 1.0) //IS COLLECTOR
////	{
////		float size = (_Size) ;// *right);// p[0].pos.z);
////		float halfSize = size*0.5;
////		float4 v[4];
////		v[0] = float4(p[0].pos +  2.0 *random.x*halfSize * right, 1.0f);
////		v[1] = float4(p[0].pos +  2.0 *random.x*halfSize * right + size * up, 1.0f);
////		v[2] = float4(p[0].pos -  2.0 *random.x*halfSize * right, 1.0f);
////		v[3] = float4(p[0].pos -  2.0 *random.x*halfSize * right + size * up, 1.0f);
////
////
////	//	pIn.col = p[0].col;
////
////		random = (random-0.5)*2.0;
////		//billboard
////
////		SETVERTEX(v[0],float2(1.0f, 0.0f),normalize(UNITY_MATRIX_IT_MV[2].xyz + random.xyz + right + float4(0.0,1.0,0.0,0.0)))
////		triStream.Append(pIn);
////
////		SETVERTEX(v[1]+wind*_Size-windFold,float2(1.0f, 0.99f),windTex.x * normalize(float4(0.0,1.0,0.0,0.0) + random.xyz + right * 0.5))
////		triStream.Append(pIn);
////
////		SETVERTEX(v[2],float2(0.0f, 0.0f),normalize(UNITY_MATRIX_IT_MV[2].xyz + random.xyz - right + float4(0.0,1.0,0.0,0.0)))
////		triStream.Append(pIn);
////
////		SETVERTEX(v[3]+wind*_Size-windFold,float2(0.0f, 0.99f),windTex.x * normalize( float4(0.0,1.0,0.0,0.0)+ random.xyz - right * 0.5 ))
////		triStream.Append(pIn);
////	}
//
//
//	random = random*2.0 - 1.0;
//	//static
//	float4 normalUp = float4(0.0,1.0,0.0,0.0);
//	float4 bendDirection = float4(cross(normalUp.xyz,float3(random.x,0.0,random.y)),0.0);
//
////	_Size *= pIn.uv.x ;
////		_Size *= dist;
//
////	_Size *= pIn.uv.x ;
////		_Size *= dist;
//	float4 newPos = 0;
//	float stepProgress = 0;
//	float width = 0.1*_Size*min(2.0,max(1,up*2.0+dist*0.8-5.0));
//	float4 bend = 0;
//	float4 orientation = 0;
//	float3 bendNormal = 0;
////
////	triStream.RestartStrip();
//	for (int i=0; i<stepCount; i++)
//	{
////		stepProgress = saturate((float)i/(stepCount-1.0));
//		bend = bendDirection * stepProgress * stepProgress;
//		orientation = float4(width*random.x,0.0,width*random.y,0.0);
//		orientation *= 1.0-stepProgress;
//		orientation *= max(1,up*dist * 0.15);
//		bendNormal = lerp(-bendDirection.xyz,normalUp,stepProgress); //stepProgress * 1.0
//		bendNormal.xyz += lerp(bendNormal,wind,0.8);
//
//		newPos = basePosition - orientation + _Size * (stepProgress * (normalUp+wind) + bend);
//		newPos.y -= windFold * stepProgress;
//		SETVERTEX(newPos,stepProgress,windTex.x * (bendNormal))
//		triStream.Append(pIn);
//
//		newPos = basePosition + orientation + _Size * (stepProgress * (normalUp+wind) + bend);
//		newPos.y -= windFold * stepProgress;
//		SETVERTEX(newPos,stepProgress,windTex.x * (bendNormal))
//		triStream.Append(pIn);
//
//		stepProgress += 0.33;
//	}
//
//
////	pIn.pos = mul(vp, p[0].pos + float4(halfSize*random.x,0.0,halfSize*random.y,0.0));
////	pIn.uv.xy = float2(1.0f, 0.0f);
////	triStream.Append(pIn);
////
////	pIn.pos =  mul(vp, p[0].pos + float4(halfSize*random.x,0.0,halfSize*random.y,0.0) + normalUp + bendDirection);
////	pIn.uv.xy = float2(1.0f, 1.0f);
////	triStream.Append(pIn);
////
////	pIn.pos =  mul(vp, p[0].pos + float4(-random.x*halfSize,0.0,-halfSize*random.y,0.0));
////	pIn.uv.xy = float2(0.0f, 0.0f);
////	triStream.Append(pIn);
////
////	pIn.pos =  mul(vp, p[0].pos + float4(-random.x*halfSize,0.0,-halfSize*random.y,0.0) + normalUp + bendDirection);
////	pIn.uv.xy = float2(0.0f, 1.0f);
////	triStream.Append(pIn);
//}
//
//
//
//#endif
//	        