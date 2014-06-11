using UnityEngine;
using System.Collections;

public class DinoPlanet : MonoBehaviour {
	public bool destroyOnStart = true;
	public bool playMusic = true;
	public AudioClip music;
	public Texture2D planetIndicator;
	public GameObject winScreen;
	public MusicPlayer gameMusicPlayer;

	bool musicPlayer = false;

	// Use this for initialization
	void Start () {
		if(destroyOnStart && RaptorInteraction.mapAmountAcquired < 1) {
			Destroy(gameObject);
		}
		else {
			Indicator indicator = Indicator.New(planetIndicator, transform.position);
			indicator.target = transform;
			indicator.tint = Color.blue;
		}
	}

	void OnTriggerEnter2D(Collider2D other) {
		if(other.tag == "Player") {
			if(winScreen != null && !winScreen.active) {
				winScreen.SetActive(true);
			}
			if(playMusic && !musicPlayer) {
				SoundManager.instance.Play2DSound(music, SoundManager.SoundType.Music);
				musicPlayer = true;
			}
		}
	}

	void Update() {
		if(musicPlayer && gameMusicPlayer != null) {
			Time.timeScale = Mathf.Max(0.25f, Time.timeScale*0.99f);
			gameMusicPlayer.baseVolume *= 0.95f;
			//gameMusicPlayer.SetActive(false);
		}
	}
}
