using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Boat : MonoBehaviour {


	public FloatCam floatCam;
	public Rigidbody rigidb;

	public Vector3 dragXYZ;
	public Vector3 localVelocity;

	public float rudderEfficiency = 1.0f;
	public Transform rudder;
	public float mainSailEfficiency = 1.0f;
	public Transform mainSail;

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

		localVelocity = transform.InverseTransformDirection(rigidb.velocity);

		FixedUpdateDrag();
	}

	void FixedUpdateDrag()
	{
		rigidb.AddForce(-transform.forward*localVelocity.z*dragXYZ.z,ForceMode.Acceleration);
		rigidb.AddForceAtPosition(-transform.right*localVelocity.x*dragXYZ.x,rigidb.worldCenterOfMass - transform.forward * 0.02f, ForceMode.Acceleration);
	}

	//void Fixed
}
