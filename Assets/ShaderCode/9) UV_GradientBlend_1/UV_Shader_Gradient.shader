Shader "Unlit/UV_Shader_Gradient"
{
    Properties // input data
    {
        _ColorA("Color A", Color) = (1,1,1,1) // define property.
        _ColorB("Color B", Color) = (1,1,1,1) // define property.
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


            float4 _ColorA; // access property from here.
            float4 _ColorB; // access property from here.

            // automatically filled out by Unity:
            struct MeshData // per-vertex mesh data
            {
                float4 vertex : POSITION; // vertex position.
                float4 normals : NORMAL; // Normals = direction of the surface.
                float2 uv0 : TEXCOORD0;    // uv coordinates.
                float4 color : COLOR; // float4 = RGBA. A + Alpha (Usually Transparency)
                float4 tangent : TANGENT; // float4. first 3 components are the direction of the tangent. The 4th component is a sine information (w - mirrored or flipped).
            };

            struct Interpolators // vertex to fragment (V2F)
            {
                float4 vertex : SV_POSITION; // clip space position
                float3 normal : TEXCOORD0; // in the interpolators, 'TEXCOORD0' is just an index.
                float2 uv : TEXCOORD1;
            };

            Interpolators vert(MeshData v) // most of the times, it is preferrable to put code in the vertex shader, whenever possible since it is mostly more optimized.
            {
                Interpolators o; // o = output.
                o.vertex = UnityObjectToClipPos(v.vertex); //UnityObjectToClipPos = Converts Local Space to Clip Space. multiplying by the model view projection matrix.
                o.normal = UnityObjectToWorldNormal( v.normals ); // passing data. Converting object's local space to world space = the rotation of the object will not change the vectors of the colors.  
                o.uv = v.uv0;
                return o;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                // blend between two colors based on the X UV coordinate
                float4 outColor = lerp(_ColorA, _ColorB, i.uv.x);

                return outColor;
            }
            ENDCG
        }
    }
}

// UVs - Directly correspond to 2d dimensional coordinates because colors are vectors and vectors are colors and shaders.
