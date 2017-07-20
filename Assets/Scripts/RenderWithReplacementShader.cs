using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RenderWithReplacementShader : MonoBehaviour {


	public enum SpecialRT
	{
		NONE,
		DEPTH,
		RENDER
	}


	public SpecialRT specialOperation = SpecialRT.NONE;
	public RenderTexture renderTexture;
	public Camera _camera;
	public Shader replacementShader;
	public RenderTextureFormat RTcolorFormat = RenderTextureFormat.ARGB32;
	Camera mainCam;

	// Use this for initialization
	void Start () {
		mainCam = Camera.main;

		if (_camera == null)
			_camera = GetComponent<Camera>();

		_camera.fieldOfView = mainCam.fieldOfView;
		_camera.backgroundColor = new Color(0.0f,0.0f,0.0f,1.0f);

		renderTexture = new RenderTexture(mainCam.pixelWidth,mainCam.pixelHeight,16,RTcolorFormat);

		if (specialOperation == SpecialRT.DEPTH)
			LevelManager.GetSingleton().SetDepthRT(renderTexture);
		if (specialOperation == SpecialRT.RENDER)
			LevelManager.GetSingleton().SetRenderRT(renderTexture);

		if (replacementShader != null)
			_camera.SetReplacementShader(replacementShader,"");

	}
	
//	// Update is called once per frame
//	void Update () {
//		
//	}

	void OnPreRender()
	{

		if (mainCam.pixelWidth != renderTexture.width || mainCam.pixelHeight != renderTexture.height)
		{
			renderTexture = new RenderTexture(mainCam.pixelWidth,mainCam.pixelHeight,16,RTcolorFormat);

			if (specialOperation == SpecialRT.DEPTH)
				LevelManager.GetSingleton().SetDepthRT(renderTexture);
			if (specialOperation == SpecialRT.RENDER)
				LevelManager.GetSingleton().SetRenderRT(renderTexture);

		}


		if (specialOperation == SpecialRT.DEPTH)
		{
			Vector3 colorClear = _camera.transform.forward;
			colorClear = colorClear * 0.5f + Vector3.one * 0.5f;

			_camera.backgroundColor = new Color(colorClear.x,colorClear.y,colorClear.z,1.0f);
			_camera.clearFlags = CameraClearFlags.Color;
		}

		_camera.targetTexture = renderTexture;
	}
}
