using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Switch : Triggerable {
	public static List<Switch> switches = new List<Switch>();

	public string room = "ship";
	public Transform useTarget;
	public Transform lever;
	public float leverSpeed = 1;

	float toggleTime = 0.1f;
	float toggleTimer = 0;
	bool inUse = false;
	bool doneUsing = true;

	// Use this for initialization
	void Start () {
		switches.Add(this);
	}
	
	// Update is called once per frame
	void Update () {
		if(!inUse) {
			doneUsing = true;
		}
		inUse = false;

		if(lever != null) {
			Vector3 rotation = lever.localEulerAngles;
			if(isTriggered && rotation.z > 45) {
				rotation.z -= leverSpeed * Time.deltaTime;
			}
			else if(!isTriggered && rotation.z < 135){
				rotation.z += leverSpeed * Time.deltaTime;
			}
			lever.localEulerAngles = rotation;
		}
	}

	public void Use(GameObject user) {
		//print("using");
		inUse = true;
		if(doneUsing) {
			doneUsing = false;
			isTriggered = !isTriggered;
			print("toggling: " + isTriggered);

			foreach(Switch lSwitch in switches) {
				if(lSwitch.room == room) {
					lSwitch.isTriggered = isTriggered;
				}
			}

			foreach(TriggerableLight light in TriggerableLight.lights) {
				if(light.room == room) {
					light.Activate(!isTriggered);
				}
			}
		}
	}
}
