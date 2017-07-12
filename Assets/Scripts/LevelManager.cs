using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager : MonoBehaviour {

	public Vector3 windDirection = new Vector3(0,5,0);
	public Vector3 currentDirection = new Vector3(0,2,0);

	// Use this for initialization
	void Start () {
		
	}

	// Update is called once per frame
	void Update () {
		
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
