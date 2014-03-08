using UnityEngine;
using System.Collections;

public class PlayerShipController : MonoBehaviour {

    public float forwardForce, reverseForce, sideForce;
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
        //transform.Rotate(Vector3.forward, Vector2.Angle(new Vector2(transform.up.x, transform.up.y), new Vector2(mouse.x, mouse.y))); 

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

        force = Quaternion.Euler(transform.eulerAngles) * force;
        rigidbody2D.AddForce(force);
	}
}
