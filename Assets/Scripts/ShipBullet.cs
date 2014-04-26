using UnityEngine;
using System.Collections;

public class ShipBullet : MonoBehaviour {

	public float time; // life time of the bullet
	public float damage = 5;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		time -= Time.deltaTime;
		if (time < 0)
			Destroy(this.gameObject);
	}

	void OnCollisionEnter2D(Collision2D col) {
		col.transform.SendMessage("Hurt", new Damage(damage, transform.position), SendMessageOptions.DontRequireReceiver);
		Destroy(gameObject);
	}
}
