using UnityEngine;
using System.Collections;

public class PlayerShipController : MonoBehaviour {

    public float forwardForce, reverseForce, sideForce;

    public bool isCloaked, isDead;
	public float cloakTime, cloakRechargeTime, cloakLerpTime; // time full cloak lasts, time full recharge takes, time of cloak transition
	float cloakCharge, cloakTrans; // betw/ 0(empty) and 1(full)

	//public Material cloaked, uncloaked;

	public float maxHealth;
	float health;
	
    public Transform bullet;
    public float bulletSpeed;

	// Use this for initialization
	void Start() {
		health = maxHealth;
		cloakCharge = 1;
		cloakTrans = 0;
	}
	
	// Update is called once per frame
	void Update() {
		if (!isDead) {
			print(cloakTrans);
			renderer.material.SetFloat("_CloakAmt", cloakTrans * 128);
			// rotate ship to point at current mouse position on screen
			float distance = transform.position.z - Camera.main.transform.position.z;
			Vector3 mouse = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, distance));
			mouse -= transform.position;
			float targetAngle = Vector2.Angle(Vector2.up, mouse);
			if (mouse.x > 0)
				targetAngle = 360 - targetAngle;
			transform.eulerAngles = new Vector3(0, 0, targetAngle);

			// add force from movement keys
			Vector2 force = new Vector2(0, 0);
			if (Input.GetKey(KeyCode.W)) {
				force.y += forwardForce;
			}
			if (Input.GetKey(KeyCode.S)) {
				force.y -= reverseForce;
			}
			if (Input.GetKey(KeyCode.A)) {
				force.x -= sideForce;
			}
			if (Input.GetKey(KeyCode.D)) {
				force.x += sideForce;
			}
			if (Input.GetKeyDown(KeyCode.Q)) { // cloak
				if (isCloaked) {
					isCloaked = false;
				}
				else if (cloakCharge >= 1) {
					isCloaked = true;
				}
			}
			if (Input.GetKey(KeyCode.Space)) {
				// shoot
			}

			force = Quaternion.Euler(transform.eulerAngles) * force;
			rigidbody2D.AddForce(force);

			if (cloakCharge < 0 && isCloaked)
			{
				isCloaked = false;
			}

			if (cloakTrans > 1)
				cloakTrans = 1;
			else if (cloakTrans < 0)
				cloakTrans = 0;

			if (isCloaked) {
				cloakCharge -= 1 / cloakTime * Time.deltaTime;
				cloakTrans += 1 / cloakLerpTime * Time.deltaTime;
			}
			else {
				cloakCharge += 1 / cloakRechargeTime * Time.deltaTime;
				cloakTrans -= 1 / cloakLerpTime * Time.deltaTime;
			}

			if (cloakCharge > 1)
				cloakCharge = 1;
		}
		else {
			renderer.material.color = Color.red;
		}
	}

    void OnCollisionEnter2D(Collision2D col) {
        // detect if player is hit with a shot
		if (col.gameObject.tag == "bullet") {
			Destroy(col.gameObject);
			health -= 1;
			if (health <= 0)
				isDead = true;
		}
        // detect player collides with a ship and is cloaked
        if (col.gameObject.tag == "enemy" && isCloaked) {
            col.gameObject.renderer.material.color = Color.red;
            // check collision is in back of ship and front of player
			foreach (ContactPoint2D contact in col.contacts) {
				if (col.collider.transform.InverseTransformPoint(contact.point).y < 0)
					col.gameObject.renderer.material.color = Color.blue;
					// load level
			}
        }
    }
}
