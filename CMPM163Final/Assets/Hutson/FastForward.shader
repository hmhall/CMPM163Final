Shader "Custom/FastForward"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Noise Texture", 2D) = "white"{} 
        _StaticTex ("Static Texture", 2D) = "white"{}
    }
    SubShader
    {        

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            uniform float4 _MainTex_TexelSize;
            
            uniform sampler2D _NoiseTex; 
            uniform sampler2D _StaticTex;

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

            fixed4 frag (v2f i) : SV_Target
            {

                fixed4 col;
                
                //distortion bars
                float distortBarYTop = _Time.y-floor(_Time.y) /*_MainTex_TexelSize.w*((sin(_Time.y)+1)/2)*/;
                float distortBarYBot = _Time.y-floor(_Time.y)-0.1;
                if(i.uv.y<distortBarYTop&&i.uv.y>distortBarYBot&&floor(_Time.y)%2==0){
                    col=tex2D(_MainTex, i.uv-_MainTex_TexelSize.x*5);
                }
                else{ 
                    col = tex2D(_MainTex, i.uv);
                }
                
                //chromatic aberration
                //credit to https://www.shadertoy.com/view/Ms3XWH for aberrationRed and aberrationGreen formula values
                float aberrationRed = 0.006*_SinTime.y*0.3;
                float aberrationGreen = 0.0073*cos(_Time.y*0.97)*0.3;
            
                col.r = tex2D(_MainTex, float2(i.uv.x - aberrationRed, i.uv.y)).r;
                col.g = tex2D(_MainTex, float2(i.uv.x + aberrationGreen, i.uv.y)).g;
            
                
                //grain
                half2 noiseUV = half2(i.uv.x + (_SinTime.z * 100), 
                                                 i.uv.y + (_Time.x * 100)); 
                fixed4 noiseTex = tex2D(_NoiseTex, noiseUV); 
                noiseTex*=2;
                col*=noiseTex;
                

                //static
                float staticBarYBot = 1-2*(_Time.y-floor(_Time.y));
                float staticBarYTop = 1-2*(_Time.y-floor(_Time.y)-0.03);
                if(i.uv.y>staticBarYBot&&i.uv.y<staticBarYTop){
                    col=tex2D(_StaticTex, i.uv);
                }
                
                if(i.uv.y<distortBarYTop&&i.uv.y>distortBarYBot&&floor(_Time.y)%2==0){
                    col=tex2D(_MainTex, i.uv-_MainTex_TexelSize.x*5);
                }
                
                return col;
                
                
            }
            ENDCG
        }
    }
}
