using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LightFluid : MonoBehaviour {
	public float intensityScale = 1;
	public float lifeTime = 0.01f;
	public float flowRate = 0.5f;

	void Start() {
	}

	void Update() {
		if(light.enabled) {
			//if(Input.GetKeyDown(KeyCode.Space)) {
			ShipGrid.AddFluidI(transform.position, "light", light.intensity * intensityScale, lifeTime, flowRate);
			//}
		}
	}
}