using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(Rigidbody))]
public class Bullet : MonoBehaviour {

	public float velocity = 5;

	// Use this for initialization
	void Start() {
		if(rigidbody != null) {
			//rigidbody.isKinematic = true;
		}
	}

	void OnCollisionEnter(Collision col) {
		Destroy(gameObject);
		//Destroy(this);
	}

	// Update is called once per frame
	void Update() {
		if(rigidbody != null) {
			rigidbody.velocity = transform.forward * velocity;
		}
	}
}
