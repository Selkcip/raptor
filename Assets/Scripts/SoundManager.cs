﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class SoundManager : MonoBehaviour {

	private List<GameObject> speakers = new List<GameObject>();
	
	//Volume
	public static float sfxVolume = 1.0f;
	public static float musicVolume = 1.0f;
	public static float dialogueVolume = 1.0f;

	public enum SoundType {Sfx, Music, Dialogue}

	// Use this for initialization
	void Start () {
	
	}

	private static SoundManager s_instance = null;

	public static SoundManager instance {
		get {
			if(s_instance == null) {
				GameObject go = new GameObject("SoundManager");
				s_instance = go.AddComponent<SoundManager>();
			}
			return s_instance;
		}
	}

	public void AddSpeaker(GameObject source) {
		speakers.Add(source);
	}

	public AudioSource Play2DSound(AudioClip clip, SoundType type, bool loop = false, float volumeMult = 1.0f, bool deleteOnFinished = true) {
		//AudioSource.PlayClipAtPoint(clip, Camera.main.transform.position);
		GameObject newObj = new GameObject("SoundPlayer");
		newObj.transform.position = Camera.main.transform.position;
		newObj.transform.parent = Camera.main.transform;
		AudioSource newSource = newObj.AddComponent<AudioSource>();
		newSource.clip = clip;
		newSource.volume *= Volume(type) * volumeMult;
		//print(newSource.audio.volume);
		newSource.dopplerLevel = 0;
		newSource.loop = loop;
		newSource.Play();
		if(deleteOnFinished) {
			StartCoroutine("DeleteSource", newObj);
		}
		return newSource;
	}

	public AudioSource Play3DSound(AudioClip clip, SoundType type, GameObject obj, bool echo = false, bool reverb = false, bool deleteOnFinished = true) {
		GameObject newObj = new GameObject("SoundPlayer");
		newObj.transform.position = obj.transform.position;
		newObj.transform.parent = obj.transform;
		AudioSource newSource = newObj.AddComponent<AudioSource>() as AudioSource;
		newSource.audio.clip = clip;
		newSource.audio.volume *= Volume(type);
		if(reverb) {
			AudioReverbFilter rFilter = newObj.AddComponent<AudioReverbFilter>() as AudioReverbFilter;
			//arbitrary value since 0, the default and max, seemed too much
			rFilter.room = -400;
		}
		newSource.audio.Play();
		if(deleteOnFinished) {
			StartCoroutine("DeleteSource", newObj);
		}
		return newSource;
	}

 public void PlayPA(AudioClip clip, SoundType type, bool echo = false) {
  foreach(GameObject source in speakers) {
			Debug.Log(source);
   GameObject newObj = new GameObject("SoundPlayer");
   newObj.transform.position = source.transform.position;
   newObj.transform.parent = source.transform;
   AudioSource newSource = newObj.AddComponent<AudioSource>() as AudioSource;
   newSource.audio.clip = clip;
			newSource.audio.volume = Volume(type);
   /*
   //Issue is that it kills sound when it is done playing the original sound, not when the echo is done.
   if(echo) {
    AudioEchoFilter eFilter = newObj.AddComponent<AudioEchoFilter>() as AudioEchoFilter;
   }
   */
   AudioReverbFilter rFilter = newObj.AddComponent<AudioReverbFilter>() as AudioReverbFilter;
   //arbitrary value since 0, the default and max, seemed too much
   rFilter.room = -400;
   newSource.audio.Play();
   StartCoroutine("DeleteSource", newObj);
  }
 }

 IEnumerator DeleteSource(GameObject obj) {
  while(obj.audio.isPlaying)
   yield return null;
  Destroy(obj);
 }

	float Volume(SoundType type) {
		if(type == SoundType.Sfx) {
			return sfxVolume;
		}
		else if(type == SoundType.Music) {
			return musicVolume;
		}
		else if(type == SoundType.Dialogue) {
			return dialogueVolume;
		}
		return -1f; 
	}

	// Update is called once per frame
	void Update() {
  
 }
}
