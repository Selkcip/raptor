using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum WeaponType { projectile, melee }

public class Weapon : ShipGridItem {

	public WeaponType type;
	public float fireRate = 0.25f;
	public int clipSize = 15;
	public int ammo = 60;
	public float reloadTime = 1;
	public Transform muzzle;
	public Light flashLight;
	public GameObject projectile;
	public bool hasAmmo = false;
	public float damage = 1;

	private float fireCoolDown = 0;
	public int clip;
	public bool dropped = false;

	// Use this for initialization
	void Start() {
		clip = clipSize;
		ammo -= clipSize;

		if(dropped) {
			Drop();
		}
		else {
			PickUp();
		}
	}

	public bool Reload() {
		fireCoolDown = reloadTime;
		clip = Mathf.Max(0, clip);
		int newClip = Mathf.Min(Mathf.Max(0, clipSize-clip), ammo);
		clip += newClip;
		ammo -= newClip;
		return clip > 0;
	}

	public bool Use(GameObject user) {
		if(user.tag == "enemy" && dropped) {
			PlanningNPC npc = user.GetComponent<PlanningNPC>();
			if(npc != null && npc.weaponAnchor != null && npc.weapon == null) {
				PickUp(npc);
			}
		}
		else {
			if(clip > 0) {
				if(fireCoolDown <= 0) {
					fireCoolDown = fireRate;
					if(muzzle != null && projectile != null) {
						clip--;
						GameObject bullet = (GameObject)Instantiate(projectile, muzzle.position, muzzle.rotation);
						bullet.GetComponent<Bullet>().damage = damage;
						SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/Raptor Sounds/lasers/laser0"), SoundManager.SoundType.Sfx, gameObject);
					}
				}
				return true;
			}
			Reload();
		}
		return false;
	}

	public void Drop() {
		dropped = true;
		rigidbody.isKinematic = false;
		transform.parent = null;
		collider.enabled = true;
		interestLevel = 0.01f;
		base.Update();
	}

	public void PickUp(PlanningNPC npc = null) {
		if(npc != null) {
			dropped = false;
			rigidbody.isKinematic = true;
			collider.enabled = false;
			interestLevel = 10000000;
			npc.weapon = this;
			npc.carryingObject = true;
			transform.parent = npc.weaponAnchor;
			transform.localPosition = Vector3.zero;
			transform.localEulerAngles = Vector3.zero;
			if(cell != null) {
				cell.RemoveItem(this);
			}
		}
	}

	// Update is called once per frame
	public override void Update() {
		fireCoolDown = Mathf.Max(0, fireCoolDown - Time.deltaTime);
		hasAmmo = ammo + clip > 0;
	}
}
