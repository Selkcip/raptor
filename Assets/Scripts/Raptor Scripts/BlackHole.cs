using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BlackHole : Triggerable {

	public float force = -10;
	public float forceLifeTime = 0.01f;
	public float forceFlowRate = 0.9f;
	public new bool active = false;

	// Use this for initialization
	void Start() {
	}

	// Update is called once per frame
	void Update() {
		base.Update();
		if(active) {
			ShipGrid.AddFluidI(transform.position, "pressure", force, forceLifeTime, forceFlowRate);
		}
	}

	void Activate(bool triggered) {
		active = triggered;
	}
}
