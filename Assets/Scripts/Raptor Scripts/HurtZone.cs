using UnityEngine;
using System.Collections;

public class HurtZone : MonoBehaviour {
	public float damage = 10000;
	public Vector3 force = Vector3.zero;

	void OnTriggerStay(Collider other) {
		other.SendMessage("Hurt", new Damage(damage, transform.position), SendMessageOptions.DontRequireReceiver);
		if(other.rigidbody != null) {
			other.rigidbody.AddForce(force);
		}
	}
}
