using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MusicPlayer : MonoBehaviour {

	public float volume = 0.25f;
	public List<AudioClip> music = new List<AudioClip>();
	AudioSource player;
	int index = 0;

	// Use this for initialization
	void Awake () {
		if(music.Count > 0){
			SoundManager.musicVolume = volume;
			player = SoundManager.instance.Play2DSound(music[index++], SoundManager.SoundType.Music);
		}
	}
	
	// Update is called once per frame
	void Update () {
		player.volume = SoundManager.musicVolume;
		if(player.time >= player.clip.length) {
			index = index % music.Count;
			player = SoundManager.instance.Play2DSound(music[index++], SoundManager.SoundType.Music);
		}
	}
}
