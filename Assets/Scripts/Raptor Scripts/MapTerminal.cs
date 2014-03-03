using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MapTerminal : MonoBehaviour {

	public float mapAvailable = 0.25f;
	public float alarmCountDown = 30;
	public bool hackable = true;
	public bool hacked = false;

	private float hackTime = 0;

	// Use this for initialization
	void Start() {
	}

	public float Hack() {
		hacked = hacked ? hacked : true;
		if(hackable) {
			return mapAvailable / alarmCountDown;
		}
		return 0;
	}

	// Update is called once per frame
	void Update() {
		if(hackable && hacked) {
			if(hackTime < alarmCountDown) {
				hackTime += Time.deltaTime;
			}
			else {
				Alarm.ActivateAlarms();
				hackable = false;
			}
		}
	}
}
