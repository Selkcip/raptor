using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Collectible : ShipGridItem {
	public bool droppable = true;
	public bool keyCard = false;
	public int value = 1;

	void Start() {
		useTarget = transform;
		interestLevel = 0;
	}

	public override void Update() {
		base.Update();
	}

	public void Use(GameObject user) {
		if(cell != null) {
			cell.RemoveItem(this);
		}

		Rigidbody[] bodies = GetComponents<Rigidbody>();
		foreach(Rigidbody body in bodies) {
			body.velocity *= 0;
		}

		user.SendMessage("Collect", this, SendMessageOptions.DontRequireReceiver);
	}
}