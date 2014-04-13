using UnityEngine;
using System.Collections;

public class Tripwire : Triggerable {

	public float playerDamage = 50f;

	public bool hacked = false;
	public bool explosive = true;

	public Transform emitter1;
	public Transform emitter2;

	// Use this for initialization
	void Start() {
		//Adjusts the length of the laser to fit between the two things
		float distance = Vector3.Distance(emitter1.position, emitter2.position);
		float currentSize = renderer.bounds.size.y;

		 Vector3 scale = transform.localScale;
		scale.y = distance * scale.y / currentSize / 2;

		transform.localScale = scale;
		transform.localPosition = emitter1.localPosition + new Vector3(emitter2.localPosition.x - emitter1.localPosition.x,
											emitter2.localPosition.y - emitter1.localPosition.y,
											emitter2.localPosition.z - emitter1.localPosition.z) * 0.5f;

	}

	void OnTriggerEnter(Collider other) {
		isTriggered = true;
		if(!hacked && other.tag == "Player") {
			if(explosive) {
				Explosion(other.transform, playerDamage);
			}
		}
	}

	void Explosion(Transform other, float damageValue) {
		other.transform.SendMessageUpwards("Hurt", new Damage(damageValue, transform.position), SendMessageOptions.DontRequireReceiver);
		ShipGrid.AddFluidI(transform.position, "pressure", 200f, 1f, 0.01f);
		hacked = true;
		renderer.enabled = false;
		//add sound and explosion effect
	}

	public void Use() {
		//make an upgrade for dis shit
		if(!hacked) {
			RaptorInteraction.defusing = true;

			if(RaptorHUD.defuseTime >= 1.0f) {
				hacked = true;
				renderer.enabled = false;
			}
		}
	}
}
