using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class MusicPlayer : MonoBehaviour {

	public List<AudioClip> music = new List<AudioClip>();

	// Use this for initialization
	void Awake () {
		if(music.Count > 0){
			SoundManager.instance.PlayPA(music[0], SoundManager.SoundType.Music);
		}
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
