using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Alarm : MonoBehaviour {

	public static bool activated = false;

	public static List<Alarm> alarms = new List<Alarm>();

	// Use this for initialization
	void Start() {
		alarms.Add(this);
	}

	public void Activate() {
		if(!activated) {
			activated = true;
			foreach(Alarm alarm in alarms) {
				alarm.SoundAlarm();
			}
		}
	}

	// Update is called once per frame
	void Update() {
	}

	public void SoundAlarm() {
		print("ALERT!");
		//SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Alarm and Ticking/AlarmLooped"), SoundManager.SoundType.Sfx, gameObject);
		if(light != null) {
			light.enabled = !light.enabled;
		}
		Invoke("SoundAlarm", 1);
	}
}
