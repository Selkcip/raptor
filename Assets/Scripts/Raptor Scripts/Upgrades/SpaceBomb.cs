using UnityEngine;
using System.Collections;

public class SpaceBomb : ConsumableUpgrade {

	public float fuseTime = 1;
	public bool sticky = true;
	public FlashingLight timerLight;
	public SpaceExplosion explosionPrefab;

	protected float fuse = 0;
	protected bool attached = false;
	protected Vector2 velocity;

	protected virtual void Start() {
		attached = !sticky;
		velocity = rigidbody2D.velocity;
	}

	protected virtual void OnTriggerEnter2D(Collider2D col) {
		if(!attached) {
			if(col.gameObject.GetComponent<ShipBullet>() == null) {
				attached = true;
				transform.parent = col.transform;
				transform.SetParent(col.transform, false);
			}
		}
	}

	protected virtual void Update() {
		if(timerLight != null) {
			timerLight.rate = 1 - fuse / fuseTime;
		}
		if(attached) {
			fuse += Time.deltaTime;
			if(fuse >= fuseTime) {
				Detonate();
			}
		}
	}

	protected virtual void Detonate() {
		Instantiate(explosionPrefab, transform.position, transform.rotation);
		Destroy(gameObject);
	}
}
