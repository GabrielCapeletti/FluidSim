// Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'

// Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'

Shader "Fluid/output"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "black" {}
        _ExternalForce ("External Texture", 2D) = "black" {}        
    }
    SubShader
    {
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

            sampler2D _MainTex;
            sampler2D _ExternalForce;
            
            //Unity predefined variable to grab texture dimensions
            float4 _MainTex_TexelSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {                
		        int gridSize = 2;
                fixed4 col = fixed4(0, 0, 0, 0);
                
                col = tex2D(_ExternalForce, i.uv);
                            
                return col;                
            }        
            
            /*               
            */
            float diffusion()
            {
                //x[IX(i,j)] = (x0[IX(i,j)] + a*(x[IX(i-1,j)]+x[IX(i+1,j)]+ x[IX(i,j-1)]+x[IX(i,j+1)]))/(1+4*a);
            }
            
            /*
            void force(float2 coords   : WPOS,
                       out float4 xNew : COLOR,              
                       uniform sampler2D u)
            {                          
                xNew += tex2D(_ConstForce, coords);
            }
            
            void advect(float2 coords   : VPOS ,   // grid coordinates          
                        out float4 xNew : COLOR,  // advected qty                        
                        uniform float timestep,
                        uniform float rdx,        // 1 / grid scale                        
                        uniform sampler2D velocityField,    // input velocity                        
                        uniform sampler2D x)    // qty to advect
            {
                // follow the velocity field "back in time"              
                float pos = coords - timestep * rdx * tex2D(velocityField, coords);
                                
                // interpolate and write to the output fragment
                xNew = tex2D(x, pos);
            }
            
            void diffusion(half2 coords   : VPOS ,   // grid coordinates            
                            out half4 xNew : COLOR,  // result           
                            uniform half alpha,
                            uniform half rBeta,      // reciprocal beta            
                            uniform sampler2D x,   // x vector (Ax = b)            
                            uniform sampler2D b)   // b vector (Ax = b)
            {
                // left, right, bottom, and top x samples               
                half4 xL = tex2D(x, coords - half2(1, 0));
                half4 xR = tex2D(x, coords + half2(1, 0));
                half4 xB = tex2D(x, coords - half2(0, 1));
                half4 xT = tex2D(x, coords + half2(0, 1));
                
                // b sample, from center
               
                half4 bC = tex2D(b, coords);
                
                // evaluate Jacobi iteration
                xNew = (xL + xR + xB + xT + alpha * bC) * rBeta;
            }
            */
            ENDCG
        }
    }
}
