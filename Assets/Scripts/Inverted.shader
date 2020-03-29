// Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'

// Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'

Shader "Hidden/Inverted"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "black" {}
        _CacheTex ("Texture", 2D) = "black" {}        
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            sampler2D _CacheTex;
            float _Int;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 colCache = tex2D(_CacheTex, i.uv);
                // just invert the colors
                col.rgb = col.rgb * colCache.rgb;                
                
                return col;
            }
            
//            void advect(float2 coords   : WPOS,   // grid coordinates          
//                        out float4 xNew : COLOR,  // advected qty                        
//                        uniform float timestep,
//                        uniform float rdx,        // 1 / grid scale                        
//                        uniform sampler2D u,    // input velocity                        
//                        uniform sampler2D x)    // qty to advect
//            {
//                // follow the velocity field "back in time"              
//                float2 pos = coords - timestep * rdx * f2texRECT(u, coords);
//                
//                // interpolate and write to the output fragment
//                xNew = f4texRECTbilerp(x, pos);
//            }
//            
//            void jacobi(half2 coords   : WPOS,   // grid coordinates            
//                        out half4 xNew : COLOR,  // result           
//                        uniform half alpha,
//                        uniform half rBeta,      // reciprocal beta            
//                        uniform sampler2D x,   // x vector (Ax = b)            
//                        uniform sampler2D b)   // b vector (Ax = b)
//            {
//                // left, right, bottom, and top x samples
//                
//                half4 xL = h4texRECT(x, coords - half2(1, 0));
//                half4 xR = h4texRECT(x, coords + half2(1, 0));
//                half4 xB = h4texRECT(x, coords - half2(0, 1));
//                half4 xT = h4texRECT(x, coords + half2(0, 1));
//                
//                // b sample, from center
//                
//                half4 bC = h4texRECT(b, coords);
//                
//                // evaluate Jacobi iteration
//                xNew = (xL + xR + xB + xT + alpha * bC) * rBeta;
//            }
//            
            ENDCG
        }
    }
}
