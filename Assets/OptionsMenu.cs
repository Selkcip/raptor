using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class OptionsMenu : MonoBehaviour {

	//Graphics
	public GameObject resolutionOptions;
	public static Resolution[] resolutions { get { return Screen.resolutions; } }
	private UIPopupList list;

	public GameObject fullScreenInput;

	//Audio
	public GameObject musicSlider;
	public GameObject sfxSlider;

	// Use this for initialization
	void Start () {
		//fill up the resolution drop down
		list = resolutionOptions.GetComponent<UIPopupList>();
		foreach(Resolution r in resolutions) {
			string option = r.width + "x" + r.height;
			list.items.Add(option);
		}
		resolutionOptions.GetComponent<UIPopupList>().value = list.items[0];
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetMouseButtonDown(1)) {
			GraphicsUpdate();
			AudioUpdate();
		}
	}

	void GraphicsUpdate() {
		Screen.SetResolution(resolutions[list.items.IndexOf(list.value)].width, resolutions[list.items.IndexOf(list.value)].height, fullScreenInput.GetComponent<UIToggle>().value);
		Screen.fullScreen = fullScreenInput.GetComponent<UIToggle>().value;
	}

	void AudioUpdate() {
		print(SoundManager.sfxVolume);
		SoundManager.musicVolume = musicSlider.GetComponent<UISlider>().value;
		SoundManager.sfxVolume = sfxSlider.GetComponent<UISlider>().value;

		print(SoundManager.sfxVolume);

	}
}
