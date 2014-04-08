using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Collectible : ShipGridItem {
	public float value = 1;

	void Start() {
	}

	public override void Update() {
		base.Update();
	}

	public void Use(GameObject user) {
		user.SendMessage("Collect", this, SendMessageOptions.DontRequireReceiver);
	}
}