// Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'

// Upgrade NOTE: replaced 'samplerRECT' with 'sampler2D'

Shader "Fluid/diffusion"
{
    Properties
    {
        _CachedTex ("Cached Texture", 2D) = "black" {}        
        _BackgroundTex ("Background", 2D) = "black" {}
        _ExternalForce ("External Texture", 2D) = "black" {}
        _ResultTex ("Result Texture", 2D) = "black" {}  
        
        _DiffusionRate ("Diffusion Rate", float) = 0.001
        _GridCellSize ("Grid Cell Size", float) = 0.002        
    }
    SubShader
    {
        Cull Off
        
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
           
            sampler2D _CachedTex;
            sampler2D _ResultTex;
            sampler2D _ExternalForce;
            sampler2D _BackgroundTex;       
            float _DiffusionRate;  
            float _GridCellSize;  
            
            //Unity predefined variable to grab texture dimensions
            float4 _MainTex_TexelSize;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            /*               
            */
            fixed4 diffusion(v2f i)
            {                                
                const float GRID_WIDTH = 2000;
                                
                float diffusionAmount = unity_DeltaTime * _DiffusionRate * GRID_WIDTH * GRID_WIDTH;
            
                fixed4 centerCell = tex2D(_ResultTex, i.uv);
                
                
                fixed4 topCell = tex2D(_CachedTex, i.uv + float2(0, _GridCellSize));
                fixed4 bottomCell = tex2D(_CachedTex, i.uv - float2(0, _GridCellSize));
                fixed4 rightCell = tex2D(_CachedTex, i.uv + float2(_GridCellSize, 0));
                fixed4 leftCell = tex2D(_CachedTex, i.uv - float2(_GridCellSize, 0));
                
                //return centerCell + topCell + bottomCell + rightCell + leftCell;
                return centerCell + diffusionAmount*(topCell + bottomCell + rightCell + leftCell)/(1 + 4*diffusionAmount);               
            }         

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = fixed4(0,0,0,1);
                
                col += tex2D(_ExternalForce, i.uv);
                col += diffusion(i);                
                //col += tex2D(_BackgroundTex, i.uv);                            
                //return fixed4(0,0.6,1,1); 
                return col;                
            }
        
            ENDCG
        }
    }
}
