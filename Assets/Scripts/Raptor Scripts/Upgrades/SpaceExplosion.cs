using UnityEngine;
using System.Collections;

public class SpaceExplosion : MonoBehaviour {
	public float finalRadius = 5;
	public float lifeTime = 2;
	public float damage = 1;

	Vector3 halfSpeed;
	float life = 0;

	// Use this for initialization
	protected virtual void Start() {
		float expansionSpeed = finalRadius / lifeTime;
		halfSpeed = new Vector3(expansionSpeed, expansionSpeed, expansionSpeed) * 0.5f;
	}

	protected virtual void OnTriggerEnter2D(Collider2D col) {
		if(col.gameObject.GetComponent<PlayerShipController>() == null) {
			col.transform.SendMessage("Hurt", new Damage(damage, transform.position), SendMessageOptions.DontRequireReceiver);
		}
	}

	// Update is called once per frame
	protected virtual void Update() {
		transform.localScale += halfSpeed * Time.deltaTime;
		life += Time.deltaTime;
		Color color = renderer.material.GetColor("_TintColor");
		color.a = 1 - Mathf.Pow(life / lifeTime, 2);
		renderer.material.SetColor("_TintColor", color);

		audio.volume = SoundManager.sfxVolume * 1 - Mathf.Pow(life / lifeTime, 2);

		if(life >= lifeTime) {
			Destroy(gameObject);
		}
	}
}
