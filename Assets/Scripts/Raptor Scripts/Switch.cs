using UnityEngine;
using System.Collections;

public class Switch : Triggerable {
	float toggleTime = 0.1f;
	float toggleTimer = 0;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		//base.Update();
	}

	public void Use(GameObject user) {
		if(toggleTimer <= 0) {
			isTriggered = !isTriggered;
			toggleTimer = toggleTime;
		}
		else {
			toggleTimer -= Time.deltaTime;
		}
	}
}
