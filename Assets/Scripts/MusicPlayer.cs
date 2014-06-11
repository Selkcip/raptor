using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MusicPlayer : MonoBehaviour {

	public float baseVolume = 1;
	public bool muted = false;
	public List<AudioClip> music = new List<AudioClip>();
	//AudioSource player;
	int index = 0;

	// Use this for initialization
	void Awake () {
		if(music.Count > 0){
			//SoundManager.musicVolume = volume;
			audio.clip = music[index++];
			audio.Play();
			//player = SoundManager.instance.Play2DSound(music[index++], SoundManager.SoundType.Music);
		}
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetKeyUp(KeyCode.Delete)) {
			muted = !muted;
		}

		index = index % music.Count;
		audio.volume = muted ? 0 : baseVolume * SoundManager.musicVolume;
		if(audio.time >= audio.clip.length) {
			audio.clip = music[index++];
			audio.Play();
		}
	}
}
