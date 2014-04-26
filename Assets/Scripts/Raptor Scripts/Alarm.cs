using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Alarm : MonoBehaviour {

	public static bool activated = false;

	public static List<Alarm> alarms = new List<Alarm>();

	public static void ActivateAlarms() {
		if(!activated) {
			activated = true;
			foreach(Alarm alarm in alarms) {
				alarm.SoundAlarm();
			}
		}
	}

	void Awake() {
		alarms.Clear();
		activated = false;
	}

	// Use this for initialization
	void Start() {
		alarms.Add(this);
	}

	public void Use(GameObject user) {
		ActivateAlarms();
	}

	public void SoundAlarm() {
		//print("ALERT!");
		SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Alarm and Ticking/AlarmLooped"), SoundManager.SoundType.Sfx, gameObject);
		if(light != null) {
			light.enabled = !light.enabled;
		}

		GameObject gridObject = GameObject.Find("CA Grid");
		if(gridObject != null) {
			ShipGrid grid = gridObject.GetComponent<ShipGrid>();
			//ShipGridCell cell = grid.GetPos(transform.position);

			grid.AddFluid(transform.position, "noise", -1000, 1f, 0.01f);
		}

		Invoke("SoundAlarm", 1);
	}
}
