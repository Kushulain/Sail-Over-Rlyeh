using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Boat : MonoBehaviour {


	public FloatCam floatCam;
	public Rigidbody rigidb;

	// Use this for initialization
	void Start () {
		rigidb = GetComponent<Rigidbody>();
	}
	
	// Update is called once per frame
	void Update () {


	}

	void FixedUpdate()
	{
		for (int i=0; i<floatCam.floatingSpots.Count; i++)
		{
			Vector3 pos = floatCam.floatingSpots[i].GetPosition(floatCam);
			float force = floatCam.floatingSpots[i].Get(rigidb.GetPointVelocity(pos),transform);
			Debug.DrawLine(Vector3.zero, pos, Color.white, 1f);
			rigidb.AddForceAtPosition(transform.up * force,pos);
			Debug.DrawLine(pos, pos + transform.up * force * 0.001f, Color.red, 1f);
		}
	}
}
