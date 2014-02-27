using UnityEngine;
using System.Collections;

public class SkyBoxCamera : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void LateUpdate () {
		transform.rotation = Camera.main.transform.rotation;
		//transform.position = Camera.main.transform.rotation;
	}
}
