using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Options : MonoBehaviour {

	public static Resolution[] resolutions { get { return Screen.resolutions; } }



	// Use this for initialization
	void Start () {
		//resolutions = Screen.resolutions;
	}
	
	// Update is called once per frame
	void Update () {
	}

	public static void Resolution(int width, int height) {
		Screen.SetResolution(width, height, Screen.fullScreen);
	}

	public static void FullScreen(bool option) {
		Screen.fullScreen = option;
	}

	public static void AntiAliasing(int filter) {

	}

	public static void HeadBob(bool option) {
		GameObject.Find("Player").GetComponent<FirstPersonHeadBob>().enabled = option;
	}

	public static void InvertAxis(bool option) {
		GameObject.Find("Player").GetComponent<SimpleMouseRotator>().invert = option;
		Camera.main.GetComponent<SimpleMouseRotator>().invert = option;
	}

	public static void AdjustVolume(SoundManager.SoundType type, float volume) {
		if(type == SoundManager.SoundType.Sfx) {
			SoundManager.sfxVolume = volume;
		}
		else if(type == SoundManager.SoundType.Music) {
			SoundManager.musicVolume = volume;
		}
		else if(type == SoundManager.SoundType.Dialogue) {
			SoundManager.dialogueVolume = volume;
		}	
	}

	public static void KeyMapping(string action, KeyCode key) {
		RebindableData data = GameObject.Find("Rebindable Manager").GetComponent<RebindableData>();
		foreach(RebindableKey playerAction in data.rebindableKeys) {
			if(playerAction.inputName == action) {
				playerAction.input = key;	
			}
		}
	}

	public static void AxisMapping(string axis, string direction, KeyCode key) {
		RebindableData data = GameObject.Find("Rebindable Manager").GetComponent<RebindableData>();
		foreach(RebindableAxis thing in data.rebindableAxes) {
			if(thing.axisName == axis) {
				if(thing.axisPosName == direction) {
					thing.axisPos = key;
				}
				else if(thing.axisNegName == direction) {
					thing.axisNeg = key;
				}
			}
		}
	}
}
