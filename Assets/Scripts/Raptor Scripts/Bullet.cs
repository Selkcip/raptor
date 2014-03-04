using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(Rigidbody))]
public class Bullet : MonoBehaviour {

	public float velocity = 5;
	public float damage = 5;
	public float life = 30;

	// Use this for initialization
	void Start() {
		if(rigidbody != null) {
			//rigidbody.isKinematic = true;
		}
	}

	void OnCollisionEnter(Collision col) {
		col.other.SendMessage("Hurt", damage, SendMessageOptions.DontRequireReceiver);
		Destroy(gameObject);
		//Destroy(this);
	}

	// Update is called once per frame
	void FixedUpdate() {
		if(rigidbody != null) {
			rigidbody.velocity = transform.forward * velocity;
		}
		life -= Time.deltaTime;
		if(life <= 0) {
			Destroy(gameObject);
		}
	}
}
