using UnityEngine;
using System.Collections;

public class AttackUpgrade : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}

	void OnTriggerEnter(Collider other) {
		if(other.tag == "Player") {
			RaptorInteraction.attack += 10;

			//print(RaptorInteraction.attack);
			Destroy(gameObject);
		}
	}
}
