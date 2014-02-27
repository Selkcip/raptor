using UnityEngine;
using System.Collections;

public class FireStartTrigger : MonoBehaviour {
	public Room room;
	bool started = false;

	public void OnTriggerEnter(Collider other) {
		if(!started) {
			room.fireZones[0].fireEmitterList[0].ToggleFire(true);
			room.fireZones[0].zoneOnFire = true;
			room.fireZones[0].StartCoroutine("SpreadFire");
			print("fire pls");
			started = true;
			SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/voices/demo/guns burning"), SoundManager.SoundType.Dialogue);
		}
	}
}
