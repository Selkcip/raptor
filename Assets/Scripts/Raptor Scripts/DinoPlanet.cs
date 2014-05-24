using UnityEngine;
using System.Collections;

public class DinoPlanet : MonoBehaviour {
	public bool destroyOnStart = true;
	public bool playMusic = true;
	public AudioClip music;

	bool musicPlayer = false;

	// Use this for initialization
	void Start () {
		if(destroyOnStart && RaptorInteraction.mapAmountAcquired < 1) {
			Destroy(gameObject);
		}
	}

	void OnTriggerEnter2D(Collider2D other) {
		if(other.tag == "Player") {
			if(playMusic && !musicPlayer) {
				SoundManager.instance.Play2DSound(music, SoundManager.SoundType.Music);
				musicPlayer = true;
			}
		}
	}
}
