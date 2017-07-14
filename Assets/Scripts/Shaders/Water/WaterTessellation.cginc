// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

#ifndef GRASS_TESSELLATION_PROGRAM_INCLUDED
#define GRASS_TESSELLATION_PROGRAM_INCLUDED

#include "Tessellation.cginc"

#ifdef UNITY_CAN_COMPILE_TESSELLATION


float _Tess;

// tessellation vertex shader
struct TessVertex {
    float4 vertex : INTERNALTESSPOS;
    float3 normal : NORMAL;
//    float4 tangent : TANGENT;
//    float2 texcoord0 : TEXCOORD0;
//    float2 texcoord1 : TEXCOORD1;
//    float2 texcoord2 : TEXCOORD2;
//    float2 texcoord3 : TEXCOORD3;
//    float4 vertexColor : COLOR;
};
TessVertex tessvert (appdata_simple v) {
    TessVertex o = (TessVertex)0;
    o.vertex = v.vertex;

    #ifdef CAM_ATTACHED
    float dist = length(v.vertex.xz);
    dist /= 50.0;
    dist = smoothstep(0.01,0.03,dist);


    o.vertex.xz *= 20.0;
//    o.vertex.xz +=     _WorldSpaceCameraPos.xz;
    o.vertex.xz += lerp(_WorldSpaceCameraPos.xz,
    floor(_WorldSpaceCameraPos.xz/5.0) * 5.0,
    dist);
//    o.vertex.xz = floor(o.vertex.xz/50.0) * 50.0;
    #endif

    o.normal = v.normal;
//    o.tangent = v.tangent;
//    o.texcoord0 = v.texcoord0;
//    o.texcoord1 = v.texcoord1;
//    o.texcoord2 = v.texcoord2;
//    o.texcoord3 = v.texcoord3;
//    o.vertexColor = v.vertexColor;
    return o;
}
v2f vertTess (appdata_simple v) {
    v2f o = (v2f)0;
//    o.uv0 = v.texcoord0;
//    o.uv1 = v.texcoord1;
//    o.uv2 = v.texcoord2;
//    o.uv3 = v.texcoord3;
//    o.vertexColor = v.vertexColor;
//    o.normal = UnityObjectToWorldNormal(v.normal);
//    o.posWorld = mul(_Object2World, v.vertex);
//    o.pos = mul(UNITY_MATRIX_MVP, v.vertex);


    o.pos = (v.vertex);
    o.normal = float4(v.normal,0.0);
    return o;
}
//struct UnityTessellationFactors {
//    float edge[3] : SV_TessFactor;
//    float inside : SV_InsideTessFactor;
//};
struct OutputPatchConstant {
    float edge[3]         : SV_TessFactor;
    float inside          : SV_InsideTessFactor;
    // I previously had other components here, but they aren't needed for this.
};

float UnityCalcEdgeTessFactorNotScreenDependant (float3 wpos0, float3 wpos1, float edgeLen)
{
	// distance to edge center
	float dist = distance (0.5 * (wpos0+wpos1), _WorldSpaceCameraPos);
	// length of the edge
	float len = distance(wpos0, wpos1);
	// edgeLen is approximate desired size in pixels
	float f = max(len * 1000.0 / (edgeLen * dist), 1.0);
	return f;
}

float4 UnityEdgeLengthBasedTessCullNotScreenDependant (float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement)
{

	    #ifdef CAM_ATTACHED
	float3 pos0 = (v0).xyz;
	float3 pos1 = (v1).xyz;
	float3 pos2 = (v2).xyz;
	    #else
	float3 pos0 = mul(unity_ObjectToWorld,v0).xyz;
	float3 pos1 = mul(unity_ObjectToWorld,v1).xyz;
	float3 pos2 = mul(unity_ObjectToWorld,v2).xyz;
	    #endif
	float4 tess;

	if (UnityWorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement))
	{
		tess = 0.0f;
	}
	else
	{
		tess.x = UnityCalcEdgeTessFactorNotScreenDependant (pos1, pos2, edgeLength);
		tess.y = UnityCalcEdgeTessFactorNotScreenDependant (pos2, pos0, edgeLength);
		tess.z = UnityCalcEdgeTessFactorNotScreenDependant (pos0, pos1, edgeLength);
		tess.w = (tess.x + tess.y + tess.z) / 3.0f;
	}
	return tess;
}

float4 Tessellation(TessVertex v, TessVertex v1, TessVertex v2){


//    return UnityDistanceBasedTess(v.vertex, v1.vertex, v2.vertex, 0.0, 100.0, _Tess);
    return UnityEdgeLengthBasedTessCullNotScreenDependant(v.vertex, v1.vertex, v2.vertex, _Tess,20.0);
//	return (_Tess);
}
// tessellation hull constant shader
OutputPatchConstant hullconst (InputPatch<TessVertex,3> v) {
    OutputPatchConstant o;
    float4 ts = Tessellation( v[0], v[1], v[2] );
//    ts = min(20.0,ts);

//    ts.xyz *= float3(1.0,1.3,1.6);

    o.edge[0] = ts.x;
    o.edge[1] = ts.y;
    o.edge[2] = ts.z;
    o.inside = ts.w;
//    o.edge[0] = pow(2.0,floor(log2(ts.x)-1.0));
//    o.edge[1] = pow(2.0,floor(log2(ts.y)-1.0));
//    o.edge[2] = pow(2.0,floor(log2(ts.z)-1.0));
//    o.inside = pow(2.0,floor(log2(ts.w)-1.0));
//    o.edge[0] = 1.0;
//    o.edge[1] = 1.0;
//    o.edge[2] = 1.0;
//    o.inside = 3.0;
    return o;
}


[domain("tri")]
[partitioning("integer")]//fractional_odd
[outputtopology("triangle_cw")]
[patchconstantfunc("hullconst")]
[outputcontrolpoints(3)]
TessVertex hull (InputPatch<TessVertex,3> v, uint id : SV_OutputControlPointID) {
    return v[id];
}



// tessellation domain shader
[domain("tri")]
v2f domain (OutputPatchConstant tessFactors, const OutputPatch<TessVertex,3> vi, float3 bary : SV_DomainLocation) {
    appdata_simple v = (appdata_simple)0;
//    v.vertex = vi[0].vertex;
//    v.normal = vi[0].normal;
    v.vertex = vi[0].vertex*bary.x + vi[1].vertex*bary.y + vi[2].vertex*bary.z;
    v.normal = vi[0].normal*bary.x + vi[1].normal*bary.y + vi[2].normal*bary.z;
//    v.vertex = vi[0].vertex;
//    v.normal = vi[0].normal;
//    v.tangent = vi[0].tangent*bary.x + vi[1].tangent*bary.y + vi[2].tangent*bary.z;
//    v.texcoord0 = vi[0].texcoord0*bary.x + vi[1].texcoord0*bary.y + vi[2].texcoord0*bary.z;
//    v.texcoord1 = vi[0].texcoord1*bary.x + vi[1].texcoord1*bary.y + vi[2].texcoord1*bary.z;
//    v.texcoord2 = vi[0].texcoord2*bary.x + vi[1].texcoord2*bary.y + vi[2].texcoord2*bary.z;
//    v.texcoord3 = vi[0].texcoord3*bary.x + vi[1].texcoord3*bary.y + vi[2].texcoord3*bary.z;
//    v.vertexColor = vi[0].vertexColor*bary.x + vi[1].vertexColor*bary.y + vi[2].vertexColor*bary.z;
//    displacement(v);
//    v2f o = vert(v,tessFactors.inside);
//    float generated = 1/(1+min(bary.x,min(bary.y,bary.z)));
    v2f o = vert(v);
//	v2f o = (v2f)0;
//	o.pos = v.vertex;
//	o.normal = v.normal;
    return o;
}


#endif
#endif
	        