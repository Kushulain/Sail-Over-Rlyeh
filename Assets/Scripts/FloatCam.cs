using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public class FloatingSpot
{
	public float factor;
	public float dragVertical;
	public float height;
	public Vector2 position;
	public float heightResult;
//	public float factor;

	public float Get(Vector3 velocity, Transform transform)
	{
		float correctedHeight = heightResult;

		if (correctedHeight > height)
		{
			float drag = Vector3.Dot(velocity,-transform.up);
			drag = Mathf.Max(drag,0f);
			drag *= dragVertical;

			return drag + (correctedHeight-height) * factor;
		}

		return 0f;
	}

	public Vector3 GetPosition(FloatCam floatCam)
	{
		float ratio = (float)floatCam.textSize_x / floatCam.textSize_y;

		Vector3 pos = floatCam.transform.position + floatCam.transform.forward * floatCam.cam.farClipPlane * (1f-height);
		pos += 2.0f *  floatCam.cam.orthographicSize * floatCam.transform.right * (position.x - 0.5f) * ratio;
		pos += 2.0f * floatCam.cam.orthographicSize * floatCam.transform.up * (position.y - 0.5f);

		return pos;
	}

	//public Vector3
}

public class FloatCam : MonoBehaviour {

	public List<FloatingSpot> floatingSpots;
	public Camera cam;
	public int textSize_x = 64;
	public int textSize_y = 128;

	public RenderTexture RTT;

	// Use this for initialization
	void Start () {
		//		cam.
		RTT = new RenderTexture(textSize_x, textSize_y, 24, RenderTextureFormat.ARGBFloat);
	}
	
	// Update is called once per frame
	void Update () {
		Shader.EnableKeyword("NO_DEPTH_OFF");
		Shader.DisableKeyword("NO_DEPTH_ON");
		Texture2D tex = new Texture2D(textSize_x, textSize_y, TextureFormat.RGBAHalf, false);

		// Initialize and render
		cam.targetTexture = RTT;
//		cam.ra
		cam.Render();
		RenderTexture.active = RTT;

		// Read pixels
		tex.ReadPixels(new Rect(0,0,textSize_x,textSize_y), 0, 0);
		tex.Apply();

		for (int i=0; i<floatingSpots.Count; i++)
		{
			Color c = tex.GetPixel((int)(floatingSpots[i].position.x * textSize_x),
				(int)((floatingSpots[i].position.y) * textSize_y));
			Debug.Log(c.r);
//			Debug.Log(c.r);
			floatingSpots[i].heightResult = 1f - c.r ;
		}

		// Clean up
//		cam.targetTexture = null;
		RenderTexture.active = null; // added to avoid errors 
		//		DestroyImmediate(rt);
		Shader.EnableKeyword("NO_DEPTH_ON");
		Shader.DisableKeyword("NO_DEPTH_OFF");

	}
}
