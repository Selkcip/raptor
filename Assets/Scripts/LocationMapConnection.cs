using UnityEngine;
using System.Collections;

public class LocationMapConnection : MonoBehaviour {
	public Transform line;
	public Location start;
	public Location end;

	// Use this for initialization
	void Start() {

	}

	// Update is called once per frame
	void Update() {
		Vector3 camPos = Camera.main.transform.position - line.position;
		//camPos.z = line.transform.position.z;// line.transform.TransformPoint(Vector3.zero).x;
		line.LookAt(line.TransformPoint(0,0,1), camPos);

		Location current = LocationManager.instance.currentLocation;
		Color color = Color.white;
		color.a = 0;
		if(start != null && end != null) {
			if(start == current || end == current) {
				color = Color.blue;
				color.a = 0.25f;
			}
			else if(start.end || end.end) {
				color = Color.green;
				color.a = 0.25f;
			}
		}
		//line.GetChild(0).renderer.material.color = color;
		line.GetChild(0).renderer.material.SetColor("_TintColor", color);
	}
}
