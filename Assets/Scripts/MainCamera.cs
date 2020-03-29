using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainCamera : MonoBehaviour 
{
    public TextureUpdate textureUpdater;
 
    private void OnPostRender()
    {
        GL.PushMatrix();
        this.textureUpdater.resultMaterial.SetPass(0);
        GL.LoadOrtho();
        GL.Begin(GL.QUADS);
        
        GL.TexCoord2(0, 0);
        GL.Vertex3(0, 0, 0);
        GL.TexCoord2(0, 1);
        GL.Vertex3(0, 1, 0);
        GL.TexCoord2(1, 1);
        GL.Vertex3(1, 1, 0);
        GL.TexCoord2(1, 0);
        GL.Vertex3(1, 0, 0);
        
        GL.End();
        GL.PopMatrix();
    }
}
