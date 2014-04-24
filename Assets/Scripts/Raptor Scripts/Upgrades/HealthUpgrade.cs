using UnityEngine;
using System.Collections;

public class HealthUpgrade : CollectibleUpgrade {
	public override void Apply(RaptorInteraction player) {
		RaptorInteraction.maxHealth += 50;
		GameObject.Find("Player").GetComponent<RaptorHUD>().health = 1f;
		player.health = RaptorInteraction.maxHealth;

		//print(RaptorInteraction.maxHealth + " : " + other.GetComponent<RaptorInteraction>().health);
		//Destroy(gameObject);
	}

	/*void OnTriggerEnter(Collider other) {
		if(other.tag == "Player") {
			RaptorInteraction.maxHealth += 50;
			hud.health = 1f;
			other.GetComponent<RaptorInteraction>().health = RaptorInteraction.maxHealth;

			//print(RaptorInteraction.maxHealth + " : " + other.GetComponent<RaptorInteraction>().health);
			Destroy(gameObject);
		}
	}*/
}
