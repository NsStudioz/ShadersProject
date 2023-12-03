Shader "Unlit/Shader"
{
    Properties // input data
    {
        //_MainTex ("Texture", 2D) = "white" {}
        _Value ("Value", Float) = 1.0
        _Color ("Color", Color) = (1,1,1,1) // define property.
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc" // code from another file.

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Value;
            float4 _Color; // access property from here.

            // automatically filled out by Unity:
            struct MeshData // per-vertex mesh data
            {
                float4 vertex : POSITION; // vertex position.
                float2 uv0 : TEXCOORD0;    // uv coordinates.
                float4 color : COLOR; // float4 = RGBA. A + Alpha (Usually Transparency)
                float4 tangent : TANGENT; // float4. first 3 components are the direction of the tangent. The 4th component is a sine information (w - mirrored or flipped).
            };

            struct Interpolators // vertex to fragment (V2F)
            {
                float4 vertex : SV_POSITION; // clip space position
                //float2 uv : TEXCOORD0;
            };

            Interpolators vert(MeshData v)
            {
                Interpolators o; // o = output.
                o.vertex = UnityObjectToClipPos(v.vertex); //UnityObjectToClipPos = Converts Local Space to Clip Space. multiplying by the model view projection matrix.
                return o;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                return _Color;
            }
            ENDCG
        }
    }
}
