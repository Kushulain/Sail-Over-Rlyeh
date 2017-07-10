using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class FloatingSpot
{
	public float factor;
	public Vector2 position;
	public float heightResult;
}

public class FloatCam : MonoBehaviour {

	public List<FloatingSpot> floatingSpots;
	public Camera cam;
	public int textSize_x = 64;
	public int textSize_y = 128;

	// Use this for initialization
	void Start () {
//		cam.
	}
	
	// Update is called once per frame
	void Update () {
		Shader.EnableKeyword("NO_DEPTH");
		Texture2D tex = new Texture2D(textSize_x, textSize_y, TextureFormat.RGB24, false);

		// Initialize and render
		RenderTexture rt = new RenderTexture(textSize_x, textSize_y, 24);
		cam.targetTexture = rt;
		cam.Render();
		RenderTexture.active = rt;

		// Read pixels
		tex.ReadPixels(new Rect(0,0,textSize_x,textSize_y), 0, 0);

		for (int i=0; i<floatingSpots.Count; i++)
		{
			Color c = tex.GetPixel((int)(floatingSpots[i].position.x * textSize_x),
				(int)(floatingSpots[i].position.y * textSize_y));
			floatingSpots[i].heightResult = c.r;
		}

		// Clean up
		cam.targetTexture = null;
		RenderTexture.active = null; // added to avoid errors 
		DestroyImmediate(rt);
		Shader.DisableKeyword("NO_DEPTH");

	}
}
