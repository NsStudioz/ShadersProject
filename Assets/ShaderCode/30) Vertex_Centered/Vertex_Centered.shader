Shader "Unlit/Vertex_Centered"
{
    Properties // input data
    {
        _ColorA("Color A", Color) = (1,1,1,1)   // define property.
        _ColorB("Color B", Color) = (1,1,1,1)   // define property.
        _ColorStart("Color Start", Range(0,1)) =  0  // define property.
        _ColorEnd("Color End", Range(0,1)) = 1       // define property.
        _WaveAmp("Wave Amplitude", Range(0,0.5)) = 0       // define property.
    }
        SubShader
    {
        Tags 
        { 
            "RenderType" = "Opaque" // inform the render pipeline of what type this is, suited for post processing purposes.
            //"Queue" = "Geometry" // Render Order. Opaque objects are queued under "Geometry".
        }

        Pass
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc" // code from another file.

            #define TAU 6.28318530718 // Preprocessor constant. Any instance of TAU will be replaced with the number.

            float4 _ColorA; // access property from here.
            float4 _ColorB; // access property from here.
            float _ColorStart; // access property from here.
            float _ColorEnd; // access property from here.
            float _WaveAmp; // access property from here.

            // automatically filled out by Unity:
            struct MeshData // per-vertex mesh data
            {
                float4 vertex : POSITION; // vertex position.
                float4 normals : NORMAL; // Normals = direction of the surface.
                float2 uv0 : TEXCOORD0;    // uv coordinates.
                float4 color : COLOR; // float4 = RGBA. A + Alpha (Usually Transparency)
                float4 tangent : TANGENT; // float4. first 3 components are the direction of the tangent. The 4th component is a sine information (w - mirrored or flipped).
            };

            //---------------------------------------------------------------------------------------------------------------------------------------------------------------
            // Math Functions:
            float InverseLerp(float a, float b, float v)
            {
                return (v - a) / (b - a);
            }

            //---------------------------------------------------------------------------------------------------------------------------------------------------------------

            struct Interpolators // vertex to fragment (V2F)
            {
                float4 vertex : SV_POSITION; // clip space position
                float3 normal : TEXCOORD0; // in the interpolators, 'TEXCOORD0' is just an index.
                float2 uv : TEXCOORD1;
            };

            Interpolators vert(MeshData v) // most of the times, it is preferrable to put code in the vertex shader, whenever possible since it is mostly more optimized.
            {
                Interpolators o; // o = output.

                //float wave = cos((v.uv0.y - _Time.y * 0.1) * TAU * 6);

                //v.vertex.y = wave * _WaveAmp;

                o.vertex = UnityObjectToClipPos(v.vertex); //UnityObjectToClipPos = Converts Local Space to Clip Space. multiplying by the model view projection matrix.
                o.normal = UnityObjectToWorldNormal( v.normals ); // passing data. Converting object's local space to world space = the rotation of the object will not change the vectors of the colors.  
                o.uv = v.uv0;
                return o;
            }

            float4 frag(Interpolators i) : SV_Target
            {

                float2 uvsCentered = i.uv * 2 - 1;  // centering UV coords.
                float radialDistance = length(uvsCentered); // radial circle.

                return float4 (radialDistance.xxx, 1); // Output.
            }
            ENDCG
        }
    }
}

// UVs - Directly correspond to 2d dimensional coordinates because colors are vectors and vectors are colors and shaders.
