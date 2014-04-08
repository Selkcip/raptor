using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Money : ShipGridItem {
	public int value = 1;

	void Start() {
		
	}

	void Update() {
		
	}

	public void Use(GameObject user) {
		user.SendMessage("TakeMoney", 1, SendMessageOptions.DontRequireReceiver);
		Destroy(gameObject);
	}
}