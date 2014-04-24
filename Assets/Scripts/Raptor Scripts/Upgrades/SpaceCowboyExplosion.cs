using UnityEngine;
using System.Collections;

public class SpaceCowboyExplosion : MonoBehaviour {
	public float finalRadius = 10;
	public float lifeTime = 5;

	Vector3 halfSpeed;
	float life = 0;

	// Use this for initialization
	void Start () {
		float expansionSpeed = finalRadius / lifeTime;
		halfSpeed = new Vector3(expansionSpeed, expansionSpeed, expansionSpeed) * 0.5f;
	}

	void OnTriggerEnter2D(Collider2D col) {
		if(col.gameObject.GetComponent<PlayerShipController>() == null) {
			Destroy(col.gameObject);
		}
	}
	
	// Update is called once per frame
	void Update () {
		transform.localScale += halfSpeed*Time.deltaTime;
		life += Time.deltaTime;
		Color color = renderer.material.GetColor("_TintColor");
		color.a = 1 - Mathf.Pow(life / lifeTime, 2);
		renderer.material.SetColor("_TintColor", color);
		if(life >= lifeTime) {
			Destroy(gameObject);
		}
	}
}
