using UnityEngine;
using System.Collections;

public class FireStarter : Incident {

	public override void Activate() {
		int randomZone = Random.Range(0, room.fireZones.Count);
		int randomFire = Random.Range(0, room.fireZones[randomZone].fireEmitterList.Count);
		room.fireZones[randomZone].fireEmitterList[randomFire].GetComponent<Fire>().ToggleFire(true);
	}

	public override void Reset() {
		foreach(FireZone fireZone in room.fireZones) {
			foreach(Fire fire in fireZone.fireEmitterList) {
				fire.ToggleFire(false);
			}
		}
	}
}
