using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BlackHole : MonoBehaviour {

	public float force = -10;
	public float falloff = 0.5f;
	public bool active = false;

	// Use this for initialization
	void Start() {
	}

	// Update is called once per frame
	void Update() {
		if(active) {
			ShipGrid.AddFluidI(transform.position, "pressure", force, falloff, 0.01f);
		}
	}
}
