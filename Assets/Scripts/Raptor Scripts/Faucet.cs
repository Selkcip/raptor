using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Faucet : MonoBehaviour {

	public string fluid = "noise";
	public float amount = 1;
	public float lifeTime = 0.01f;
	public float flowRate = 0.9f;
	public new bool active = false;

	// Use this for initialization
	void Start() {
	}

	// Update is called once per frame
	void Update() {
		if(active) {
			ShipGrid.AddFluidI(transform.position, fluid, amount, lifeTime, flowRate);
		}
	}
}
