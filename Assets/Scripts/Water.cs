using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Water : MonoBehaviour {

	public Texture2D water;

	Renderer rend;
	MeshFilter meshF;

	public int waterResolution = 256;
	public float waterSize = 100;
	public float displacementMultiplier = 2.0f;
	public Vector2 waterSpeed1 = new Vector2(0.2f,0.1f);
	public Vector2 waterSpeed2 = new Vector2(0.1f,0.08f);
	public Vector2 waterSpeed3 = new Vector2(0.05f,0.02f);
	// Use this for initialization
	void Start () {
		rend = GetComponent<Renderer>();
		meshF = GetComponent<MeshFilter>();
	}
	
	// Update is called once per frame
	void Update () {


		Mesh newMesh = new Mesh();

		Vector3[] newVertices = new Vector3[waterResolution*waterResolution];

		int id = 0;

		for (int i=0; i<waterResolution; i++)
		{
			for (int k=0; k<waterResolution; k++)
			{
				float displacement = water.GetPixel((int)(((waterSpeed1.x*Time.time+k)/(1f*waterResolution))*water.width),
					(int)(((waterSpeed1.y*Time.time+i)/(1f*waterResolution))*water.height)).r;
				displacement += water.GetPixel((int)(((waterSpeed2.x*Time.time+k)/(1f*waterResolution))*water.width),
					(int)(((waterSpeed2.y*Time.time+i)/(1f*waterResolution))*water.height)).g;
				displacement += water.GetPixel((int)(((waterSpeed3.x*Time.time+k)/(1f*waterResolution))*water.width),
					(int)(((waterSpeed3.y*Time.time+i)/(1f*waterResolution))*water.height)).b;

				newVertices[id++] = new Vector3(waterSize*(-0.5f + k / 256f),
					waterSize*(-0.5f + i / 256f),
					(displacement)*displacementMultiplier);
			}
		}

		newMesh.vertices = newVertices;

		int[] newTriangles = new int[(waterResolution-1)*(waterResolution-1)*2*3];

		id = 0;

		for (int i=0; i<waterResolution-1; i++)
		{
			for (int k=0; k<waterResolution-1; k++)
			{
				newTriangles[id++] = i*waterResolution+k;
				newTriangles[id++] = i*waterResolution+k+1;
				newTriangles[id++] = (i+1)*waterResolution+k+1;
				newTriangles[id++] = (i+1)*waterResolution+k+1;
				newTriangles[id++] = (i+1)*waterResolution+k;
				newTriangles[id++] = i*waterResolution+k;
			}
		}

		newMesh.triangles = newTriangles;

		id = 0;

		Vector3[] newNormals = new Vector3[waterResolution*waterResolution];

		for (int i=0; i<waterResolution; i++)
		{
			for (int k=0; k<waterResolution; k++)
			{
				newNormals[id++] = new Vector3(0f,1f,0f);
			}
		}

		newMesh.normals = newNormals;

		meshF.mesh = newMesh;
		meshF.mesh.RecalculateBounds();
		meshF.mesh.RecalculateNormals();
		
	}
}
