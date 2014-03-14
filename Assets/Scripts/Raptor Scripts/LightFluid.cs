using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LightFluid : MonoBehaviour {
	public float intensityScale = 1;
	public float falloff = 0.5f;

	void Start() {
	}

	void Update() {
		if(light.enabled) {
			ShipGrid.AddFluidI(transform.position, "light", light.intensity * intensityScale * Time.deltaTime, falloff, 0.01f);
		}
	}
}