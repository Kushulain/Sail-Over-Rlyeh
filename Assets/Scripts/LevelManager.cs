using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager : MonoBehaviour {

	public Vector3 windDirection = new Vector3(0,5,0);
	public Vector3 currentDirection = new Vector3(0,2,0);


	public Camera MainCam;
	public Camera DepthCam;
	public bool depthTextureEnabled = true;
	public RenderTexture depthTexture;
	public bool renderTextureEnabled = true;
	public RenderTexture renderTexture;
	public Renderer water;
	public Shader depthShader;

	// Use this for initialization
	void Start () {
		DepthCam.fieldOfView = MainCam.fieldOfView;
		DepthCam.backgroundColor = new Color(0.0f,0.0f,0.0f,1.0f);

		depthTexture = new RenderTexture(MainCam.pixelWidth,MainCam.pixelHeight,16,RenderTextureFormat.ARGBFloat);
		renderTexture = new RenderTexture(MainCam.pixelWidth,MainCam.pixelHeight,16,RenderTextureFormat.ARGB32);

		if (depthTextureEnabled)
		{
			water.material.SetTexture("_Depth",depthTexture);
			water.material.SetTexture("_Render",renderTexture);
			//DepthCam.depthTextureMode = DepthTextureMode.
		}
	}

	// Update is called once per frame
	void Update () {
		RenderDepth();
	}

	public void RenderDepth()
	{
		Debug.Log(MainCam.pixelWidth);
		Debug.Log(depthTexture.width);
		if (MainCam.pixelWidth != depthTexture.width || MainCam.pixelHeight != depthTexture.height)
		{
//			depthTexture.width = MainCam.pixelWidth;
//			depthTexture.height = MainCam.pixelHeight;
//			renderTexture.width = MainCam.pixelWidth;
//			renderTexture.height = MainCam.pixelHeight;
			depthTexture = new RenderTexture(MainCam.pixelWidth,MainCam.pixelHeight,16,RenderTextureFormat.ARGBFloat);
			renderTexture = new RenderTexture(MainCam.pixelWidth,MainCam.pixelHeight,16,RenderTextureFormat.ARGB32);
			water.material.SetTexture("_Depth",depthTexture);
			water.material.SetTexture("_Render",renderTexture);
		}

//		Texture2D tex = new Texture2D(textSize_x, textSize_y, TextureFormat.RGBAHalf, false);

		Vector3 colorClear = DepthCam.transform.forward;
		colorClear = colorClear * 0.5f + Vector3.one * 0.5f;

		// Initialize and render
		DepthCam.backgroundColor = new Color(colorClear.x,colorClear.y,colorClear.z,1.0f);
		DepthCam.clearFlags = CameraClearFlags.Color;
		DepthCam.targetTexture = depthTexture;
		DepthCam.RenderWithShader(depthShader,"");

		DepthCam.clearFlags = CameraClearFlags.Skybox;
		DepthCam.targetTexture = renderTexture;
		DepthCam.Render();
//		RenderTexture.active = depthTexture;
//
//		// Read pixels
//		tex.ReadPixels(new Rect(0,0,textSize_x,textSize_y), 0, 0);
//		tex.Apply();
//
//		for (int i=0; i<floatingSpots.Count; i++)
//		{
//			Color c = tex.GetPixel((int)(floatingSpots[i].position.x * textSize_x),
//				(int)((floatingSpots[i].position.y) * textSize_y));
//			//			Debug.Log(c.r);
//			//			Debug.Log(c.r);
//			floatingSpots[i].heightResult = 1f - c.r ;
//		}
//
//		// Clean up
//		//		cam.targetTexture = null;
//		RenderTexture.active = null; // added to avoid errors 
	}

	public Vector3 GetWindDirection()
	{
		return windDirection;
	}

	public Vector3 GetCurrentDirection()
	{
		return currentDirection;
	}
}
