// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/DepthTexture" {
SubShader {
    Tags { "RenderType"="Opaque" }
    Pass {
        Fog { Mode Off }
CGPROGRAM
 
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
 
	struct v2f {
	    float4 pos : SV_POSITION;
	    float4 wposDepth : TEXCOORD0;
	};
	 
	v2f vert (appdata_base v) {
	    v2f o;
	    o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
	    o.wposDepth.xyz = mul (unity_ObjectToWorld, v.vertex).xyz;
	    o.wposDepth.a = length(mul (UNITY_MATRIX_MV, v.vertex).xyz);
//	    UNITY_TRANSFER_DEPTH(o.depth);
	    return o;
	}
	 
	half4 frag(v2f i) : COLOR {
		return i.wposDepth / 500.0 + 0.5;
//	    UNITY_OUTPUT_DEPTH(i.depth);
	}
ENDCG
    }
}
}
 