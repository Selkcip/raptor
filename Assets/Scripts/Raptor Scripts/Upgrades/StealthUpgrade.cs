using UnityEngine;
using System.Collections;

public class StealthUpgrade : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}

	void OnTriggerEnter(Collider other) {
		if(other.tag == "Player") {
			RaptorInteraction.stealthTime += 30;

			Destroy(gameObject);
		}
	}
}
