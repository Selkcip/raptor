using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class TriggerableLight : Triggerable {
	public static List<TriggerableLight> lights = new List<TriggerableLight>();

	public string room = "ship";

	void OnLevelLoaded() {
		lights.Clear();
	}

	void Start () {
		activateOnStateChange = true;
		lights.Add(this);
	}

	public void Activate(bool triggered) {
		if(light != null) {
			light.enabled = triggered;
		}
	}
}
