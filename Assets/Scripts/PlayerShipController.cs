using UnityEngine;
using System.Collections;

public class PlayerShipController : MonoBehaviour {

    public float forwardForce, reverseForce, sideForce;

    public bool isCloaked;

    public Transform bullet;
    public float bulletSpeed;

	// Use this for initialization
	void Start() {
	
	}
	
	// Update is called once per frame
	void Update() {
        // rotate ship to point at current mouse position on screen
        float distance = transform.position.z - Camera.main.transform.position.z;
        Vector3 mouse = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, distance));
        mouse -= transform.position;
        float targetAngle = Vector2.Angle(Vector2.up, new Vector2(mouse.x, mouse.y));
        if (mouse.x > Vector2.up.x)
            targetAngle = -targetAngle;
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
            isCloaked = !isCloaked;
            if (isCloaked)
                renderer.material.color = Color.blue;
            else
                renderer.material.color = Color.white;
        }
        if (Input.GetKey(KeyCode.Space)) {
            // shoot
        }

        force = Quaternion.Euler(transform.eulerAngles) * force;
        rigidbody2D.AddForce(force);
	}

    void OnCollisionEnter2D(Collision2D col) {
        // detect if player is hit with a shot
        // detect player collides with a ship and is cloaked
        if (col.gameObject.tag == "enemy" && isCloaked) {
            col.gameObject.renderer.material.color = Color.red;
            // check collision is in back of ship and front of player
			foreach (ContactPoint2D contact in col.contacts) {
				if (col.collider.transform.InverseTransformPoint(contact.point).y < 0)
					col.gameObject.renderer.material.color = Color.blue;
			}
                // load level
        }            
    }
}
