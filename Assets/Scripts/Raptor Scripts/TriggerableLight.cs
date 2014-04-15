using UnityEngine;
using System.Collections;

public class TriggerableLight : Triggerable {

	void Start () {
		activateOnStateChange = true;
	}

	void Activate(bool triggered) {
		if(light != null) {
			light.enabled = triggered;
		}
	}
}
