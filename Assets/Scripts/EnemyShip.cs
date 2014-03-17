using UnityEngine;
using System.Collections;

public class EnemyShip : MonoBehaviour {
	public float baseForce;
    public float maxRotateAngle;
    public float detectionRange;
	public float fireAngle;

    public GameObject bullet;
    public float bulletSpeed;
	float reload = 0;
	public float reloadTime;

	GameObject player;

	// Use this for initialization
	void Start() {
        player = GameObject.Find("PlayerShip");
	}
	
	// Update is called once per frame
	void Update() {
        Vector3 targetDirection = player.transform.position - transform.position;
        float distance = targetDirection.magnitude;
		if (!player.GetComponent<PlayerShipController>().isCloaked && distance <= detectionRange)
		{
			// aim and fire at player
			targetDirection += (Vector3)(player.rigidbody2D.velocity - rigidbody2D.velocity) * targetDirection.magnitude / bulletSpeed;
			float diffAngle = Vector2.Angle(transform.up, targetDirection); // angle between target direction and current
			// determine if left or right
			float targetAngle = Vector2.Angle(Vector2.up, targetDirection); // preliminary target angle
			if (targetDirection.x > 0)
				targetAngle = 360 - targetAngle; // actual target angle

			float testLeft = transform.eulerAngles.z + diffAngle; // test angle from adding angle difference (rotating left)
			if (testLeft > 360)
				testLeft -= 360;

			float testRight = transform.eulerAngles.z - diffAngle; // test angle from adding angle difference (rotating right)
			if (testRight < 0)
				testRight += 360;

			if (Mathf.Abs(testLeft - targetAngle) < Mathf.Abs(targetAngle - testRight))
				transform.eulerAngles += new Vector3(0, 0, Mathf.Min(diffAngle, maxRotateAngle * Time.deltaTime)); // rotate left
			else
				transform.eulerAngles -= new Vector3(0, 0, Mathf.Min(diffAngle, maxRotateAngle * Time.deltaTime)); // rotate right
			if (diffAngle < fireAngle)
					Shoot();
			gameObject.renderer.material.color = Color.green;
		}
		else
		{ // float around if player is not detected
			float direction = (int)((Random.value * 4) - 2);
			float amount = Random.value * 2 + 1;
			transform.eulerAngles += new Vector3(0, 0, direction / amount * maxRotateAngle * Time.deltaTime);
			if (Random.value < 0.05f)
			{
				Vector2 force = new Vector2(0, baseForce);
				force = Quaternion.Euler(transform.eulerAngles) * force;
				rigidbody2D.AddForce(force);
			}
		}

		if (reload > 0) {
			reload -= Time.deltaTime;
		}
	}

	void Shoot() {
		if (reload <= 0) {
			GameObject shot = (GameObject)Instantiate(bullet, transform.position + transform.up, Quaternion.Euler(transform.eulerAngles));
			shot.rigidbody2D.velocity = rigidbody2D.velocity + (Vector2)(transform.up * bulletSpeed);
			reload = reloadTime;
		}
	}

    void OnCollisionEnter2D(Collision2D col) { 
        // detect if hit by a shot
    }
}
