using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlaneFollowCamXZ : MonoBehaviour {

	public Camera cam;

	// Use this for initialization
	void Start () {

		if (cam == null)
			cam = Camera.main;
	}

	// Update is called once per frame
	void Update () {
		transform.position = new Vector3(cam.transform.position.x, 0f, cam.transform.position.z);
		transform.rotation = Quaternion.identity;
	}
}
