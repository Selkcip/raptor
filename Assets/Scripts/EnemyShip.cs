using UnityEngine;
using System.Collections;

public class EnemyShip : MonoBehaviour {
	public float baseForce;
    public float maxRotateAngle;
    public float detectionRange;

    public Transform bullet;
    public float bulletSpeed;

	GameObject player;

	// Use this for initialization
	void Start() {
        player = GameObject.Find("PlayerShip");
	}
	
	// Update is called once per frame
	void Update() {
        Vector3 difference = player.transform.position - transform.position;
        float distance = difference.sqrMagnitude;
        if (!player.GetComponent<PlayerShipController>().isCloaked && distance <= detectionRange) {
			// aim and fire at player
			Vector3 targetDirection = player.transform.position - transform.position;
			float targetAngle = Vector2.Angle((Vector2)transform.up, (Vector2)targetDirection);
			transform.eulerAngles += new Vector3(0, 0, targetAngle);
			if (Vector2.Angle((Vector2)transform.up, (Vector2)targetDirection) != 0f) {
				transform.eulerAngles -= new Vector3(0, 0, targetAngle);
				transform.eulerAngles -= new Vector3(0, 0, Mathf.Min(targetAngle, maxRotateAngle * Time.deltaTime));
			}
			else {
				transform.eulerAngles -= new Vector3(0, 0, targetAngle);
				transform.eulerAngles += new Vector3(0, 0, Mathf.Min(targetAngle, maxRotateAngle * Time.deltaTime));
			}
			gameObject.renderer.material.color = Color.green;
		}
		else { // float around if player is not detected
			float direction = (int)((Random.value * 4) - 2);
			float amount = Random.value * 2 + 1;
			transform.eulerAngles += new Vector3(0, 0, direction / amount * maxRotateAngle * Time.deltaTime);
			if (Random.value < 0.05f) {
				Vector2 force = new Vector2(0, baseForce);
				force = Quaternion.Euler(transform.eulerAngles) * force;
				rigidbody2D.AddForce(force);
			}
		}
	}

    void OnCollisionEnter2D(Collision2D col) { 
        // detect if hit by a shot
    }
}
