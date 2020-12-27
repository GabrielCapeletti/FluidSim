using UnityEngine;
using UnityEngine.UI;

public class FluidController : MonoBehaviour 
{
    private static readonly int ExternalForce = Shader.PropertyToID("_ExternalForce");
    private static readonly int MainTex = Shader.PropertyToID("_MainTex");
    private static readonly int CachedTex = Shader.PropertyToID("_CachedTex");
    private static readonly int ResultTex = Shader.PropertyToID("_ResultTex");
    private static readonly int BackgroundTex = Shader.PropertyToID("_BackgroundTex");

    [SerializeField]
    private int _brushSize = 10;
    [SerializeField]
    private Camera _mainCamera;
    [SerializeField]
    private Material _outputMaterial;
    [SerializeField]
    private Material _diffusionMaterial;
    [SerializeField]
    private RenderTexture _cachedTex;
    [SerializeField]
    private RenderTexture _resultTex;
    [SerializeField]
    private RenderTexture _backgroundTex;
    [SerializeField]
    private MeshRenderer _planeMesh;
    
    //We are going to draw the external force field into a raw image to help visualize each step
    [SerializeField] private RawImage _externalForceOutput;
    
    private Material _matInstance;
    private Texture2D _externalForceTex;
    private int _lastInputX = -1;
    private int _lastInputY = -1;
    private bool _dirtyBuffer = false;

    private void Start()
    { 
        _externalForceTex = new Texture2D(1000, 1000, TextureFormat.RGB24, false);
        
        for (int i = 0; i < _externalForceTex.width; i++)
        {
            for (int j = 0; j < _externalForceTex.height; j++)
            {
                _externalForceTex.SetPixel(i, j, Color.black);                
            }
        }
        _externalForceTex.Apply();

        _matInstance = Instantiate(_diffusionMaterial);
        
        _matInstance.SetTexture(BackgroundTex, _backgroundTex);
        _matInstance.SetTexture(CachedTex, _cachedTex);
        _matInstance.SetTexture(ExternalForce, _externalForceTex);
        _matInstance.SetTexture(ResultTex, _resultTex);

        _planeMesh.material = _matInstance;

        _externalForceOutput.texture = _externalForceTex;
    }
    
    private void Update()
    {
        if (_dirtyBuffer)
        {
            ApplyForce(_lastInputX, _lastInputY, Color.black);
            _dirtyBuffer = false;
        }

        if (Input.GetMouseButton(0))
        {
            int x = (int)((Input.mousePosition.x/_mainCamera.pixelWidth) * _externalForceTex.width);
            int y = (int)((Input.mousePosition.y/_mainCamera.pixelHeight) * _externalForceTex.height);

            _lastInputX = x;
            _lastInputY = y;
            _dirtyBuffer = true;
            
            ApplyForce(_lastInputX, _lastInputY, Color.white);
        }

        Graphics.Blit(_planeMesh.material.mainTexture, _matInstance);
        Graphics.Blit(_planeMesh.material.mainTexture, _resultTex, _matInstance);
    }

    private void ApplyForce(int x, int y, Color color)
    {
        int forceFieldSize = _brushSize;

        for (int i = -forceFieldSize / 2; i < forceFieldSize/2; i++)
        {
            for (int j = -forceFieldSize / 2; j < forceFieldSize / 2; j++)
            {
                _externalForceTex.SetPixel(x + i, y + j, color);
            }
        }
        _externalForceTex.Apply();
    }

    private void OnPostRender()
    {
        Graphics.Blit(_resultTex, _cachedTex);
    }
}
