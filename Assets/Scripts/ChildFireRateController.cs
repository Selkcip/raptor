using UnityEngine;
using System.Collections;

public class ChildFireRateController : MonoBehaviour {

	float rate;
	Vector3 scale;


	// Use this for initialization
	void Start() {
		rate = this.particleSystem.emissionRate;
		scale = this.transform.parent.localScale;
		this.particleSystem.emissionRate = scale.x * scale.y * scale.z * rate;
		
	}

	// Update is called once per frame
	void Update() {
	}
}
