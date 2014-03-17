using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MapOpenTrigger : MonoBehaviour {

	public LocationMap map;

	void OnTriggerEnter(Collider other) {
		if(other.tag == "Player") {
			//rotate = false;
			if(map != null) {
				//map.gameObject.SetActive(false);
				map.open = true;
			}
		}
	}

	void OnTriggerExit(Collider other) {
		if(other.tag == "Player") {
			//rotate = true;
			if(map != null) {
				map.open = false;
			}
		}
	}
}
