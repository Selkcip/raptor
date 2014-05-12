using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class UpgradeCount {
	public string type;
	public ConsumableUpgrade upgrade;
	public int count = 0;

	public UpgradeCount(ConsumableUpgrade upgrade) {
		this.upgrade = upgrade;
	}
}

public class PlayerShipController : MonoBehaviour {

	public Texture2D painIndicator;

    public float forwardForce, reverseForce, sideForce;
	public float turnRate; // deg/s
    public float maxSpeed;

    public bool isCloaked, isDead;
	public float cloakTime, cloakRechargeTime, cloakLerpTime; // time full cloak lasts, time full recharge takes, time of cloak transition
	float cloakCharge, cloakTrans = 0; // betw/ 0(empty) and 1(full)

	//public Material cloaked, uncloaked;

	public float maxHealth;
	float reload;

	[HideInInspector]
	public float health = 1000;
	
    public GameObject bullet;
    public float bulletSpeed, reloadTime;

	public LevelSelector levelSelector;

	public static float damage = 10;
	public static List<UpgradeCount> consumables = new List<UpgradeCount>();
	public static int currentConsumable = 0;

	public static void AddConsumable(ConsumableUpgrade upgrade) {
		UpgradeCount count = consumables.Find(delegate(UpgradeCount cur) {
			return cur.upgrade = upgrade;
		});
		if(count == null) {
			count = new UpgradeCount(upgrade);
			consumables.Add(count);
		}
		count.count++;
	}

	// Use this for initialization
	void Start() {
		levelSelector = this.GetComponent<LevelSelector>();
		health = maxHealth;
		cloakCharge = 1;
		cloakTrans = 0;
		reload = 0;
	}
	
	// Update is called once per frame
	void Update() {
		if (!isDead)
		{
			//print(cloakTrans);
			renderer.material.SetFloat("_CloakAmt", cloakTrans * 128);
			// rotate ship to point at current mouse position on screen
			/*float distance = transform.position.z - Camera.main.transform.position.z;
			Vector3 mouse = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, distance));
			mouse -= transform.position;
			mouse = -mouse;
			float targetAngle = Vector2.Angle(Vector2.up, mouse);
			if (mouse.x > 0)
				targetAngle = 360 - targetAngle;
			transform.eulerAngles = new Vector3(0, 0, targetAngle);*/



			// add force from movement keys
			Vector2 force = new Vector2(0, 0);
			if (Input.GetKey(KeyCode.W))
			{
				force.y += forwardForce;
			}
			if (Input.GetKey(KeyCode.S))
			{
				force.y -= reverseForce;
			}
			if (Input.GetKey(KeyCode.A))
			{
				transform.eulerAngles += new Vector3(0, 0, turnRate * Time.deltaTime);
				//force.x -= sideForce;
			}
			if (Input.GetKey(KeyCode.D))
			{
				transform.eulerAngles += new Vector3(0, 0, -turnRate * Time.deltaTime);
				//force.x += sideForce;
			}
			if (Input.GetKeyDown(KeyCode.Q))
			{ // cloak
				if (isCloaked)
				{
					isCloaked = false;
				}
				else //if (cloakCharge >= 1) 
				{
					isCloaked = true;
				}
			}
			if (Input.GetKey(KeyCode.Space))
			{
				Shoot();
			}

			force = Quaternion.Euler(transform.eulerAngles) * force;
			rigidbody2D.AddForce(force);

			/*if (cloakCharge < 0 && isCloaked)
			{
				isCloaked = false;
			}*/

			if (cloakTrans > 1)
				cloakTrans = 1;
			else if (cloakTrans < 0)
				cloakTrans = 0;

			if (isCloaked)
			{
				cloakCharge -= 1 / cloakTime * Time.deltaTime;
				cloakTrans += 1 / cloakLerpTime * Time.deltaTime;
			}
			else
			{
				cloakCharge += 1 / cloakRechargeTime * Time.deltaTime;
				cloakTrans -= 1 / cloakLerpTime * Time.deltaTime;
			}

			if (cloakCharge > 1)
				cloakCharge = 1;

			currentConsumable = Mathf.Max(0, Mathf.Min(consumables.Count - 1, currentConsumable));
			if(Input.GetKeyDown(KeyCode.E)) {
				if(consumables.Count > 0) {
					UpgradeCount count = consumables[currentConsumable];
					if(count.count > 0) {
						Instantiate(count.upgrade, transform.position, transform.rotation);
						count.count--;
						if(count.count <= 0) {
							consumables.Remove(count);
						}
					}
				}
			}
		}

		if (reload > 0)
		{
			reload -= Time.deltaTime;
		}

        if (rigidbody2D.velocity.magnitude > maxSpeed)
            rigidbody2D.velocity = rigidbody2D.velocity.normalized * maxSpeed;
	}

	void Shoot()
	{
		if (reload <= 0)
		{
			GameObject shot = (GameObject)Instantiate(bullet, transform.position + transform.up, Quaternion.Euler(transform.eulerAngles));
			shot.layer = LayerMask.NameToLayer("Player");
			shot.rigidbody2D.velocity = rigidbody2D.velocity + (Vector2)(transform.up * bulletSpeed);
			reload = reloadTime;
		}
	}

	public void Hurt(Damage damage) {
		health -= damage.amount;
		print(health);

		if(health <= 0) {
			gameObject.SetActive(false);
		}

		Indicator indicator = Indicator.New(painIndicator, damage.pos);
		indicator.tint = Color.red;
		indicator.dontDestroy = false;

		//print(health);
		//SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/raptor/hurt"), SoundManager.SoundType.Sfx);
	}
}
