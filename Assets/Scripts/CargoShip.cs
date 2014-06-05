using UnityEngine;
using System.Collections;

public class CargoShip : MonoBehaviour {
    public float maxRotateAngle;
    public float detectionRange;

    public GameObject bullet;
    public float bulletSpeed;
	public float reloadTime;
	float reload = 0;
	public float stunTime = 0;

	public float health = 100;

	GameObject player;

    public Transform leftTurret, rightTurret;

	// Use this for initialization
	void Start() {
        player = GameObject.Find("PlayerShip");
	}
	
	// Update is called once per frame
	void Update() {
		stunTime = Mathf.Max(stunTime - Time.deltaTime, 0);
		if(player != null && stunTime <= 0) {
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

    void Shoot()
    {
        Vector3 position, targetPosition, targetDirection;
        targetDirection = player.transform.position - transform.position;
        targetDirection += (Vector3)(player.rigidbody2D.velocity - rigidbody2D.velocity) * targetDirection.magnitude / bulletSpeed;
        targetPosition = transform.position + targetDirection;
        if (Vector2.Distance(rightTurret.transform.position, targetPosition) < Vector2.Distance(leftTurret.transform.position, targetPosition))
        {
            position = rightTurret.transform.position;
            targetDirection = player.transform.position - position;
            targetDirection += (Vector3)(player.rigidbody2D.velocity - rigidbody2D.velocity) * targetDirection.magnitude / (bulletSpeed);
            targetPosition = rightTurret.transform.position + targetDirection;
            rightTurret.LookAt(new Vector3(targetPosition.x, targetPosition.y, targetPosition.z));
            leftTurret.transform.eulerAngles = new Vector3(270, 0, 0);
        }
        else {
            position = leftTurret.transform.position;
            targetDirection = player.transform.position - position;
            targetDirection += (Vector3)(player.rigidbody2D.velocity - rigidbody2D.velocity) * targetDirection.magnitude / (bulletSpeed);
            targetPosition = leftTurret.transform.position + targetDirection;
            leftTurret.LookAt(new Vector3(targetPosition.x, targetPosition.y, targetPosition.z));
            rightTurret.transform.eulerAngles = new Vector3(270, 0, 0);
        }
        //Debug.DrawRay(transform.position, targetDirection);

        if (reload <= 0) {
            GameObject shot = (GameObject)Instantiate(bullet, position, Quaternion.FromToRotation(Vector3.up, targetDirection));
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

	public void Stun(Damage damage) {
		stunTime += damage.amount;
	}
}
