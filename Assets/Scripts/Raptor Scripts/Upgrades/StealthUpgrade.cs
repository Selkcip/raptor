using UnityEngine;
using System.Collections;

public class StealthUpgrade : CollectibleUpgrade {
	public override void Apply(RaptorInteraction player) {
		RaptorInteraction.stealthTime += 30;
	}

	/*void OnTriggerEnter(Collider other) {
		if(other.tag == "Player") {
			RaptorInteraction.stealthTime += 30;

			Destroy(gameObject);
		}
	}*/
}
