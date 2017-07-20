using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager : MonoBehaviour {

	public Vector3 windDirection = new Vector3(0,5,0);
	public Vector3 currentDirection = new Vector3(0,2,0);


	public Camera MainCam;
	public Camera DepthCam;
	public Camera ReflectionCam;
	public bool depthTextureSet = false;
	public RenderTexture depthTexture;
	public bool renderTextureSet = false;
	public RenderTexture renderTexture;
	public Renderer[] water;
	public Shader depthShader;
	public bool transparencyAndReflection = true;

	static LevelManager instance;
	public static LevelManager GetSingleton()
	{
		if (instance == null)
		{
			instance = FindObjectOfType<LevelManager>();
			if (instance == null)
				Debug.LogError("A LevelManager is missing in your scene !");
		}
		return instance;
	}

	// Use this for initialization
	void Start () {
//		DepthCam.fieldOfView = MainCam.fieldOfView;
//		DepthCam.backgroundColor = new Color(0.0f,0.0f,0.0f,1.0f);
//
//		depthTexture = new RenderTexture(MainCam.pixelWidth,MainCam.pixelHeight,16,RenderTextureFormat.ARGBFloat);
//		renderTexture = new RenderTexture(MainCam.pixelWidth,MainCam.pixelHeight,16,RenderTextureFormat.ARGB32);
//
//		if (depthTextureEnabled)
//		{
//			foreach (Renderer rend in water)
//			{
//				rend.sharedMaterial.SetTexture("_Depth",depthTexture);
//				rend.sharedMaterial.SetTexture("_Render",renderTexture);
//			}
//			//DepthCam.depthTextureMode = DepthTextureMode.
//		}
	}

	// Update is called once per frame
	void Update () {
//		RenderDepth();

		if (transparencyAndReflection)
		{
			if (depthTextureSet && renderTextureSet)
			{
				Shader.EnableKeyword("REFLECTION_ON");
				Shader.DisableKeyword("REFLECTION_OFF");
			}
		}
	}

	void OnDestroy()
	{

		Shader.DisableKeyword("REFLECTION_ON");
		Shader.EnableKeyword("REFLECTION_OFF");
	}

	public void SetDepthRT(RenderTexture RT)
	{
		depthTextureSet = true;
		foreach (Renderer rend in water)
		{
			rend.sharedMaterial.SetTexture("_Depth",RT);
		}
	}

	public void SetRenderRT(RenderTexture RT)
	{
		renderTextureSet = true;
		foreach (Renderer rend in water)
		{
			rend.sharedMaterial.SetTexture("_Render",RT);
		}
	}

	public void RenderDepth()
	{
//		Debug.Log(MainCam.pixelWidth);
//		Debug.Log(depthTexture.width);

//		Texture2D tex = new Texture2D(textSize_x, textSize_y, TextureFormat.RGBAHalf, false);

//		DepthCam.targetTexture = depthTexture;
//		DepthCam.RenderWithShader(depthShader,"");
//
//		DepthCam.clearFlags = CameraClearFlags.Skybox;
//		DepthCam.targetTexture = renderTexture;
//		DepthCam.Render();
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
