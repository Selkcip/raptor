using UnityEngine;
using System.Collections;

public class AttackUpgrade : CollectibleUpgrade {
	public override void Apply(RaptorInteraction player) {
		RaptorInteraction.attack += 10;
	}

	/*void OnTriggerEnter(Collider other) {
		if(other.tag == "Player") {
			RaptorInteraction.attack += 10;

			//print(RaptorInteraction.attack);
			Destroy(gameObject);
		}
	}*/
}
