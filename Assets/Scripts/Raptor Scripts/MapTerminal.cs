using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MapTerminal : MonoBehaviour {

	public float mapAvailable = 0.25f;
	public float transferRate = 29;
	public float alarmCountDown = 30;
	public float notorietyToLock = 10000;
	public bool hackable = true;
	public bool hacked = false;
	public UISlider mapBar;
	public UISlider alarmBar;
	public UILabel alarmLabel;

	private float initMapAvailable;

	private float hackTime = 0;

	public float mapRemaining { get { return mapAvailable / initMapAvailable; } }
	public float timeRemaining { get { return hackTime / alarmCountDown; } }

	// Use this for initialization
	void Start() {
		transferRate = mapAvailable / alarmCountDown;
		initMapAvailable = mapAvailable;

		if(RaptorInteraction.notoriety >= notorietyToLock) {
			alarmCountDown = 0;
			alarmLabel.enabled = true;
		}
	}

	public void Use(GameObject user) {
		hacked = hacked ? hacked : true;
		RaptorInteraction.notoriety += Notoriety.hack*Time.deltaTime;
		if(hackable) {
			float amount = Mathf.Min(transferRate*Time.deltaTime, mapAvailable);
			mapAvailable -= amount;
			user.SendMessage("TransferMap", amount, SendMessageOptions.DontRequireReceiver);
		}
		else {
			alarmLabel.enabled = true;
			Alarm.ActivateAlarms();
		}
	}

	// Update is called once per frame
	void Update() {
		if(hackable && hacked) {
			if(hackTime < alarmCountDown) {
				hackTime += Time.deltaTime;
			}
			else {
				hackable = false;
			}
		}
		mapBar.value = mapRemaining;
		alarmBar.value = timeRemaining;
	}
}
