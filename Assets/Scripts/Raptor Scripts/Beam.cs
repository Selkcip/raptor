using UnityEngine;
using System.Collections;

public class Beam : MonoBehaviour {
	public Transform line;

	// Use this for initialization
	void Start() {

	}

	// Update is called once per frame
	void Update() {
		Vector3 camPos = Camera.main.transform.position - line.position;
		//camPos.z = line.transform.position.z;// line.transform.TransformPoint(Vector3.zero).x;
		line.LookAt(line.TransformPoint(0, 0, 1), camPos);
	}
}
