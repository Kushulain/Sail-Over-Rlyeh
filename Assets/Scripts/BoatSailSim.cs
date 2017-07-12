using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class BoatSailSim : MonoBehaviour {

	public Text shipAngleText;
	public Text sailAngleText;
	public Slider shipAngleSlider;
	public Slider sailAngleSlider;

	public LineRenderer l_boat;
	public LineRenderer l_sail;
	public LineRenderer l_wind;
	public LineRenderer l_windexit;
	public LineRenderer l_windiff;
	public LineRenderer l_windForce;

	public float sailStart = 0.1f;
	public float sailSurfaceMiddle = 0.33f;
	public float sailLength = 0.5f;
	public float centerGravity = 0.1f;
	Vector3 sailMiddlePosition;
	Vector3 windExitVec;
	Vector3 thrustVec;
	Vector3 centerGravVec;
	Vector3 bezierVec;


	public Text ThrustForwardText;
	public Text ThrustRollText;
	public Text ThrustRotationText;

	public float sailCurvature = 0.0f;
//	public LineRenderer windForce;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		shipAngleText.text = shipAngleSlider.value.ToString();
		sailAngleText.text = sailAngleSlider.value.ToString();

		DrawBoat();
		DrawSail();
		DrawWind();
		DrawExit();
		DrawThrust();

		ThrustForwardText.text = "Forward Thrust : " + Vector3.Dot(Quaternion.AngleAxis(shipAngleSlider.value,-Vector3.forward) * (Vector3.up),
			thrustVec).ToString("0.000");
		
		ThrustRollText.text = "Lateral Thrust : " + Vector3.Dot(Quaternion.AngleAxis(shipAngleSlider.value + 90f,-Vector3.forward) * (Vector3.up),
			thrustVec).ToString("0.000");

		centerGravVec = (Quaternion.AngleAxis(shipAngleSlider.value,-Vector3.forward) * (Vector3.up)) * centerGravity;

		float rotationTorque = Vector3.Dot(centerGravVec-sailMiddlePosition,
			Quaternion.AngleAxis(90f,-Vector3.forward) * thrustVec);
		
		ThrustRotationText.text = "Rotation Torque : " + rotationTorque.ToString("0.000");
	}

	void DrawThrust()
	{
		Vector3[] positions = new Vector3[2];

		thrustVec = new Vector3(0f,-1f,0.0f) - windExitVec;

		positions[0] = sailMiddlePosition + windExitVec * 0.5f;
		positions[1] = sailMiddlePosition - Vector3.up * 0.5f;

		l_windiff.numPositions = positions.Length;
		l_windiff.SetPositions(positions);


		positions[0] = sailMiddlePosition;
		positions[1] = sailMiddlePosition + thrustVec * 0.5f;

		l_windForce.numPositions = positions.Length;
		l_windForce.SetPositions(positions);
	}

	void DrawExit()
	{
		Vector3[] positions = new Vector3[2];

		Vector3 Saildirection = Quaternion.AngleAxis(shipAngleSlider.value + sailAngleSlider.value,-Vector3.forward) * (-Vector3.up);

		float yExit = Mathf.Cos((shipAngleSlider.value + sailAngleSlider.value)*Mathf.Deg2Rad);
//		yExit = Mathf.Max(0f,yExit);

		Vector3 sailStartVec = (Quaternion.AngleAxis(shipAngleSlider.value,-Vector3.forward) * (Vector3.up)) * sailStart;
		Vector3 endSailVec = sailStartVec + Saildirection * sailLength;
		windExitVec = (endSailVec-bezierVec).normalized * yExit;

		positions[0] = sailMiddlePosition;
		positions[1] = sailMiddlePosition + windExitVec * 0.5f ;

		positions[0] -= Vector3.forward;
		positions[1] -= Vector3.forward;

		l_windexit.numPositions = positions.Length;
		l_windexit.SetPositions(positions);
	}

	void DrawWind()
	{
		Vector3[] positions = new Vector3[2];

		positions[0] = sailMiddlePosition;
		positions[1] = sailMiddlePosition - Vector3.up * 0.5f;

		l_wind.numPositions = positions.Length;
		l_wind.SetPositions(positions);
	}

	void DrawSail()
	{

		int steps = 10;
		Vector3[] positions = new Vector3[steps];

		Vector3 Saildirection = Quaternion.AngleAxis(shipAngleSlider.value + sailAngleSlider.value,-Vector3.forward) * (-Vector3.up);
		Vector3 sailStartVec = (Quaternion.AngleAxis(shipAngleSlider.value,-Vector3.forward) * (Vector3.up)) * sailStart;

		Vector3 endSailVec = sailStartVec + Saildirection * sailLength;
		float coaxial = Vector3.Dot(Saildirection,-Vector3.up);
		bezierVec = Vector3.Lerp(sailStartVec,endSailVec, Mathf.Lerp(0.5f,0.35f,coaxial));

		if (Vector3.Dot(Vector3.Cross(-Vector3.up,-Vector3.forward),Saildirection) > 0f)
			bezierVec = Vector3.Lerp(bezierVec,bezierVec-Vector3.Cross(Saildirection,-Vector3.forward),(Mathf.Min(1f,(1f-coaxial)*5.0f))*sailCurvature);
		else
			bezierVec = Vector3.Lerp(bezierVec,bezierVec+Vector3.Cross(Saildirection,-Vector3.forward),(Mathf.Min(1f,(1f-coaxial)*5.0f))*sailCurvature);
			
//		bezierVec.y -= 0.2f;

		for (int i=0; i<steps; i++)
		{
			float progress = i/(steps-1.0f);
			Vector3 int_start = Vector3.Lerp(sailStartVec,bezierVec,progress);
			Vector3 int_end = Vector3.Lerp(bezierVec,endSailVec,progress);
			positions[i] = Vector3.Lerp(int_start,int_end,progress);
		}

		Vector3 int_start2 = Vector3.Lerp(sailStartVec,bezierVec,sailSurfaceMiddle);
		Vector3 int_end2 = Vector3.Lerp(bezierVec,endSailVec,sailSurfaceMiddle);
		sailMiddlePosition = Vector3.Lerp(int_start2,int_end2,sailSurfaceMiddle);

//		positions[0] = sailStartVec;
//		positions[1] = bezierVec;
//		positions[2] = endSailVec;

//		sailMiddlePosition = positions[0] * (1f-sailSurfaceMiddle) + positions[steps-1] * (sailSurfaceMiddle);

		l_sail.numPositions = positions.Length;
		l_sail.SetPositions(positions);
	}

	void DrawBoat()
	{

		float length = 0.9f;
		float width = 0.1f;
		int steps = 10;

		Vector3[] positions = new Vector3[steps * 2];

		Vector3 direction = Quaternion.AngleAxis(shipAngleSlider.value,-Vector3.forward) * (Vector3.up);
		Vector3 right = Quaternion.AngleAxis(shipAngleSlider.value - 90f,-Vector3.forward) * (Vector3.up);
//		right *= 0f;

		for (int i=0; i<steps; i++)
		{
			float progress = i/(steps-1.0f);
			float progressN = progress * 2.0f - 1.0f;
			progress -= 0.5f;

			progress = Mathf.Max(-0.4f,progress);


			positions[i] = length * direction * progress + width * right * (1f-(progressN*progressN));
		}

		for (int i=0; i<steps; i++)
		{
			float progress = i/(steps-1.0f);
			float progressN = progress * 2.0f - 1.0f;
			progress -= 0.5f;

			progress = Mathf.Max(-0.4f,progress);

			positions[steps+i] = length * direction * progress - width * right * (1f-(progressN*progressN));
		}
		l_boat.numPositions = positions.Length;
		l_boat.SetPositions(positions);
	}
}
