using UnityEngine;
using System.Collections;

public class Mine : MonoBehaviour {

	public float damage = 100f;
	public float playerDamage = 50f;
	
	public bool hacked = false;
	public bool activated = true;

	public float notorietyToSpawn = 10000;

	public Explosion explosionPrefab;

	private Transform center;

	// Use this for initialization
	void Start () {
		if(RaptorInteraction.notoriety < notorietyToSpawn) Destroy(gameObject);

		center = transform.FindChild("center");
	}

	void OnCollisionEnter(Collision col) {
		if(!hacked && col.transform.tag == "Player") {
			Explosion(col.transform, playerDamage);
		}
		else if(hacked && col.transform.tag == "enemy" && activated) {
			Explosion(col.transform, damage);
		}
	}

	void Explosion(Transform other, float damageValue) {
		other.transform.SendMessageUpwards("Hurt", new Damage(damageValue, transform.position), SendMessageOptions.DontRequireReceiver);
		//ShipGrid.AddFluidI(transform.position, "pressure", 50f, 0.00001f, 0.9f);

		Explosion exp = (Explosion)Instantiate(explosionPrefab, transform.position, transform.rotation);
		exp.explodeOnStart = true;

		Destroy(gameObject);
	}

	public void Use() {
		//make an upgrade for dis shit
		if(!hacked) {
			RaptorInteraction.defusing = true;

			if(RaptorHUD.defuseTime >= 1.0f) {
				hacked = true;
				center.renderer.material.color = Color.blue;
			}
		}
		else if(hacked) {
			if(Input.GetKeyDown(KeyCode.E)) {
				activated = !activated;
				if(activated) {
					center.renderer.material.color = Color.black;
				}
				else {
					center.renderer.material.color = Color.blue;
				}
			}
		}
	}
}
