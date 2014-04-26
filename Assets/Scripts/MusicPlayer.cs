using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MusicPlayer : MonoBehaviour {

	public float volume = 0.25f;
	public List<AudioClip> music = new List<AudioClip>();

	// Use this for initialization
	void Awake () {
		if(music.Count > 0){
			SoundManager.musicVolume = volume;
			SoundManager.instance.Play2DSound(music[0], SoundManager.SoundType.Music, true);
		}
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
