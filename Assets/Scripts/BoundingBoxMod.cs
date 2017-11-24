using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BoundingBoxMod : MonoBehaviour {

	MeshFilter MF;

	// Use this for initialization
	void Start () {
		MF = GetComponent<MeshFilter>();

		Bounds bounds = MF.mesh.bounds;
		Vector3 tmp = bounds.max;
		tmp.y = 30f;
		bounds.max = tmp;
		tmp = bounds.min;
		tmp.y = -30f;
		bounds.min = tmp;

		MF.mesh.bounds = bounds;
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
