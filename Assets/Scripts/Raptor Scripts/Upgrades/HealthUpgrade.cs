using UnityEngine;
using System.Collections;

public class HealthUpgrade : MonoBehaviour {

	private RaptorHUD hud;

	void Start() {
		hud = GameObject.Find("Player").GetComponent<RaptorHUD>();
	}

	void OnTriggerEnter(Collider other) {
		if(other.tag == "Player") {
			RaptorInteraction.maxHealth += 50;
			hud.health = 1f;
			other.GetComponent<RaptorInteraction>().health = RaptorInteraction.maxHealth;

			//print(RaptorInteraction.maxHealth + " : " + other.GetComponent<RaptorInteraction>().health);
			Destroy(gameObject);
		}
	}
}
