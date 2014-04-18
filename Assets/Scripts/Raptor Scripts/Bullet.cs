using UnityEngine;
using System.Collections;
using System.Collections.Generic;

[RequireComponent(typeof(Rigidbody))]
public class Bullet : MonoBehaviour {

	public float velocity = 5;
	public float damage = 10;
	public float life = 30;

	// Use this for initialization
	void Start() {
		if(rigidbody != null) {
			//rigidbody.isKinematic = true;
		}
	}

	void OnCollisionEnter(Collision col) {
		if(col.transform.tag != "weapon") {
			col.transform.SendMessage("Hurt", new Damage(damage, transform.position), SendMessageOptions.DontRequireReceiver);

			DecalSystem decals = DecalSystem.instance;
			if(decals != null) {
				decals.CreateDecal(col.contacts[0].point, transform.forward, col.collider, 0);
				//Debug.DrawRay(transform.position - transform.forward * 2, transform.forward, Color.red, 5);
			}

			Destroy(gameObject);
			//Destroy(this);
		}
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
