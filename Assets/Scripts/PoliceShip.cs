using UnityEngine;
using System.Collections;

public class PoliceShip : MonoBehaviour {

	public float baseForce;
	public float turnRate; // deg/s
	public float detectionRange;
	public float fireAngle;
    public float maxSpeed;
    public float maxSearchTime; // max time spent searching for player

	public GameObject bullet;
	public float bulletSpeed;
	public float reloadTime;
	float reload = 0;

    public float searchTimer;

	public float health = 100;

	GameObject player;

	// Use this for initialization
	void Start()
	{
		player = GameObject.Find("PlayerShip");
        searchTimer = maxSearchTime;
	}

	// Update is called once per frame
	void Update()
	{
		if(player != null) {
			InterceptPlayer();
			//gameObject.renderer.material.color = Color.green;

			if(reload > 0) {
				reload -= Time.deltaTime;
			}

			// if the player is spotted reset search timer
			if(IsPlayerSpotted())
				searchTimer = maxSearchTime;
			else
				searchTimer -= Time.deltaTime;
		}

        Vector2 force = new Vector2(0, baseForce);
        force = Quaternion.Euler(transform.eulerAngles) * force;
        rigidbody2D.AddForce(force);

        if (rigidbody2D.velocity.magnitude > maxSpeed)
            rigidbody2D.velocity = rigidbody2D.velocity.normalized * maxSpeed;
	}

	public bool IsPlayerSpotted() {
		float distance = Vector3.Distance(player.transform.position, transform.position);
		return !player.GetComponent<PlayerShipController>().isCloaked && distance <= detectionRange;
	}

    // set destination away
    void LeaveArea() { }

    // head to latest known player position, fire if spotted
	void InterceptPlayer() {
		// get direction of intercept, 
		// Vector3 targetDirection = player.transform.position - transform.position;
        Vector3 targetDirection = player.GetComponent<LevelSelector>().lastDetectedLocation - transform.position;
		targetDirection += (Vector3)(player.rigidbody2D.velocity - rigidbody2D.velocity) * targetDirection.magnitude / bulletSpeed;

        Debug.DrawRay(transform.position, targetDirection);
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
			transform.eulerAngles += new Vector3(0, 0, Mathf.Min(diffAngle, turnRate * Time.deltaTime)); // rotate left
		else
			transform.eulerAngles -= new Vector3(0, 0, Mathf.Min(diffAngle, turnRate * Time.deltaTime)); // rotate right
        
        if (diffAngle < fireAngle && IsPlayerSpotted())
			Shoot();
	}

	void Shoot()
	{
		if (reload <= 0)
		{
			GameObject shot = (GameObject)Instantiate(bullet, transform.position + transform.up, Quaternion.Euler(transform.eulerAngles));
			shot.layer = LayerMask.NameToLayer("Enemy");
			shot.rigidbody2D.velocity = rigidbody2D.velocity + (Vector2)(transform.up * bulletSpeed);
			reload = reloadTime;
		}
	}

	void OnCollisionEnter2D(Collision2D col)
	{
		// detect if hit by a shot
	}

	public void Hurt(Damage damage) {
		health -= damage.amount;
	}
}
