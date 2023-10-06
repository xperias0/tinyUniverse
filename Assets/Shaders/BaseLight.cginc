#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"
// #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
 //#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
// #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
// #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
// #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

struct appdata
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : NORMAL;
};

struct v2f
{
    float2 uv : TEXCOORD0;
                
    float4 vertex : SV_POSITION;

    float3 wldNormal : TEXCOORD1;
    float3 wldVertex : TEXCOORD2;
    float4 shadowCoord : TEXCOORD3;
//    LIGHTING_COORDS(5,6)
};

sampler2D _MainTex;
float4 _MainTex_ST;
half4 _MainColor;
half4 _AmbientLightColor;
float _AmbinetLightIntensity;
float _SpecularLightIntensity;
float _SpecularLightFactor;
uniform float _Height;
float _SmoothNess;

float4 VertexScale(float4 vertexPos)
{
    float4x4 scaleMatirx;
    
    scaleMatirx[0][0] = 1 + _Height;
    scaleMatirx[0][1] = 0 ; 
    scaleMatirx[0][2] = 0 ;
    scaleMatirx[0][3] = 0 ;
    scaleMatirx[1][0] = 0 ;
    scaleMatirx[1][1] = 1 + _Height ;
    scaleMatirx[1][2] = 0 ;
    scaleMatirx[1][3] = 0 ;
    scaleMatirx[2][0] = 0 ;
    scaleMatirx[2][1] = 0 ;
    scaleMatirx[2][2] = 1 + _Height;
    scaleMatirx[2][3] = 0 ;
    scaleMatirx[3][0] = 0 ;
    scaleMatirx[3][1] = 0 ;
    scaleMatirx[3][2] = 0 ;
    scaleMatirx[3][3] = 1 ;
                
    return mul(scaleMatirx , vertexPos);
}

v2f vert (appdata v)
{
    
    v2f o;
    
    o.vertex = UnityObjectToClipPos(VertexScale(v.vertex));
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.wldNormal = UnityObjectToWorldNormal( v.normal);
    o.wldVertex = mul(unity_ObjectToWorld,v.vertex);
    
    UNITY_TRANSFER_FOG(o,o.vertex);
    
    TRANSFER_VERTEX_TO_FRAGMENT(o);
    return o;
}

fixed4 frag (v2f i) : SV_Target
{
    // sample the texture
    float3 wldPos = i.wldVertex;
    fixed4 finalCol = (0,0,0,1);
    
    
    float attenuation = LIGHT_ATTENUATION(i);
    fixed4 col = tex2D(_MainTex, i.uv) * _MainColor;
    float3 wldNormal = normalize( i.wldNormal);
    float4 lightDir = normalize( float4(_WorldSpaceLightPos0.xyz,1));
    float diffuseLightFalloff = saturate( dot(wldNormal, lightDir)) * attenuation;
    half4 diffuseLight = ((diffuseLightFalloff * _AmbientLightColor));
    //half3 diffuseLight  = (0,0,0);
    //half3 specularLight = (0,0,0); 
    float3 viewDir = normalize(_WorldSpaceCameraPos - i.wldVertex);
    float3 halfDir = normalize( lightDir + viewDir);


    float specularLightFalloff = saturate( dot(halfDir, wldNormal)) * attenuation * _SpecularLightIntensity;
    fixed4 specularLight = pow(specularLightFalloff, _SpecularLightFactor) * _AmbientLightColor;
    fixed4 ambientLight = _AmbinetLightIntensity * _AmbientLightColor;


    
    finalCol = (specularLight + diffuseLight) * _MainColor;
                
    return finalCol;
}