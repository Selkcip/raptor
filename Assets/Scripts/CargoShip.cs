using UnityEngine;
using System.Collections;

public class CargoShip : MonoBehaviour {
    public float maxRotateAngle;
    public float detectionRange;

    public GameObject bullet;
    public float bulletSpeed;
	float reload = 0;
	public float reloadTime;

	public float health = 100;

	GameObject player;

	// Use this for initialization
	void Start() {
        player = GameObject.Find("PlayerShip");
	}
	
	// Update is called once per frame
	void Update() {
		if(player != null) {
			if(isPlayerSpotted()) {
				Shoot();
			}

			if(reload > 0) {
				reload -= Time.deltaTime;
			}
		}
	}

	public bool isPlayerSpotted()
	{
		Vector3 targetDirection = player.transform.position - transform.position;
		float distance = targetDirection.magnitude;
		return !player.GetComponent<PlayerShipController>().isCloaked && distance <= detectionRange;
	}

	void Shoot() {
		if (reload <= 0) {
			Vector3 targetDirection = player.transform.position - transform.position;
			targetDirection += (Vector3)(player.rigidbody2D.velocity - rigidbody2D.velocity) * targetDirection.magnitude / bulletSpeed;

            //Debug.DrawRay(transform.position, targetDirection);

			GameObject shot = (GameObject)Instantiate(bullet, transform.position, Quaternion.FromToRotation(Vector3.up, targetDirection));
			shot.layer = LayerMask.NameToLayer("Enemy");
			shot.rigidbody2D.velocity = rigidbody2D.velocity + (Vector2)(shot.transform.up * bulletSpeed);
			reload = reloadTime;
		}
	}

    void OnCollisionEnter2D(Collision2D col) { 
        // detect if hit by a shot
    }

	public void Hurt(Damage damage) {
		health -= damage.amount;
	}
}
