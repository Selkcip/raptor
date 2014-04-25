using UnityEngine;
using System.Collections;

public class DinoPlanet : MonoBehaviour {
	public AudioClip music;

	bool musicPlayer = false;

	// Use this for initialization
	void Start () {
		if(RaptorInteraction.mapAmountAcquired < 1) {
			Destroy(gameObject);
		}
	}

	void OnTriggerEnter2D(Collider2D other) {
		if(other.tag == "Player") {
			if(!musicPlayer) {
				SoundManager.instance.Play2DSound(music, SoundManager.SoundType.Music);
				musicPlayer = true;
			}
		}
	}
}
