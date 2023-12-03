Shader "Unlit/UV_Zigzag_AnimBlended"
{
    Properties // input data
    {
        _ColorA("Color A", Color) = (1,1,1,1)   // define property.
        _ColorB("Color B", Color) = (1,1,1,1)   // define property.
        _ColorStart("Color Start", Range(0,1)) =  0  // define property.
        _ColorEnd("Color End", Range(0,1)) = 1       // define property.
    }
        SubShader
    {
        Tags 
        { 
            "RenderType" = "Transparent" // inform the render pipeline of what type this is, suited for post processing purposes.
            "Queue" = "Transparent" // Render Order. Rendered after opaque objects, to prevent opaque overriding drawings when behind transparent objects.
        }

        Pass
        {
            Cull Off // Render both faces.
            ZWrite Off // don't write into the depth buffer
            Blend One One // Additive.
            //Blend DstColor Zero // multiply.

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc" // code from another file.

            #define TAU 6.28318530718 // Preprocessor constant. Any instance of TAU will be replaced with the number.

            float4 _ColorA; // access property from here.
            float4 _ColorB; // access property from here.
            float _ColorStart; // access property from here.
            float _ColorEnd; // access property from here.

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

            float InverseLerp(float a, float b, float v) 
            {
                return (v - a) / (b - a);
            }

            float4 frag(Interpolators i) : SV_Target
            {
                

                float xOffset = cos(i.uv.x * TAU * 8) * 0.01; // reduce last value in the calculations to soften the ZigZag pattern (0.01).
                float t = cos( (i.uv.y + xOffset - _Time.y * 0.1) * TAU * 5) * 0.5 + 0.5; // still a repeating pattern but the range has been shifted when multiply by 0.5 & add 0.5.
                                                                                          // negate _Time.y. This animates the pattern based on time.
                t *= 1 - i.uv.y; // 1- to reverse the direction.


                //Cosine Wave on the X + Y axes. We're also visualizing them separately using the red channel and green channel.
                return t * (abs(i.normal.y) < 0.999); // Remove Top and Bottom drawings.
            }
            ENDCG
        }
    }
}

// UVs - Directly correspond to 2d dimensional coordinates because colors are vectors and vectors are colors and shaders.
