using UnityEngine;
using System.Collections;

public class SpaceCowboy : MonoBehaviour {
	public float fuseTime = 18;
	public float speed = 1;
	public SpaceCowboyExplosion explosionPrefab;

	float fuse = 0;
	bool attached = false;

	// Use this for initialization
	void Start () {
	
	}

	void OnCollisionEnter2D(Collision2D col) {
		//print("collision");
		if(!attached) {
			if(col.gameObject.GetComponent<ShipBullet>() == null) {
				attached = true;
				transform.parent = col.transform;
				transform.SetParent(col.transform, false);
				/*Rigidbody2D otherBody = col.rigidbody;
				if(otherBody != null) {
					DistanceJoint2D joint = gameObject.GetComponent<DistanceJoint2D>();
					joint.connectedBody = otherBody;
				}*/
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		fuse += Time.deltaTime;

		if(fuse >= fuseTime) {
			Detonate();
		}
		else {
			if(!attached) {
				transform.position += transform.up * speed;
			}
		}
	}

	void Detonate() {
		Instantiate(explosionPrefab, transform.position, transform.rotation);
		Destroy(gameObject);
	}
}
