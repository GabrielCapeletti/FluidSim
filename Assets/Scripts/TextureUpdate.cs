using UnityEngine;
using UnityEngine.UI;

public class TextureUpdate : MonoBehaviour 
{
    public Material material;
    public Material resultMaterial;
    public Camera camera;
    
    [HideInInspector] 
    public Material matInstance;
    
    private RenderTexture tempRT;
    private RenderTexture cacheRT;

    void Start()
    {
        camera = GetComponent<Camera>();
        cacheRT = new RenderTexture(camera.pixelWidth, this.camera.pixelHeight,  16, RenderTextureFormat.ARGB32);
        cacheRT.Create();
        
        matInstance = Instantiate(material);
        matInstance.SetTexture("_CacheTex", cacheRT);
    }
    
    private void OnRenderImage(RenderTexture src, RenderTexture dest) 
    {
        Graphics.Blit(src, dest, matInstance);    
    }
    
    private void OnPostRender()
    {
        resultMaterial.SetTexture("_MainTex", this.camera.targetTexture);
        Graphics.Blit(this.camera.targetTexture, cacheRT);
    }
}
