using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class OptionsMenu : MonoBehaviour {

	//Graphics
	public GameObject resolutionOptions;
	public static Resolution[] resolutions { get { return Screen.resolutions; } }
	private UIPopupList list;

	public GameObject fullScreenInput;

	public UIPopupList bloom;
	public UIPopupList ssao;
	public UIToggle aa;
	public UIPopupList glow;
	public UIPopupList tiltShift;
	public GameObject reflections;

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
	void Apply () {
		GraphicsUpdate();
		AudioUpdate();
	}

	void GraphicsUpdate() {
		Screen.SetResolution(resolutions[list.items.IndexOf(list.value)].width, resolutions[list.items.IndexOf(list.value)].height, fullScreenInput.GetComponent<UIToggle>().value);
		Screen.fullScreen = fullScreenInput.GetComponent<UIToggle>().value;

		//Reflections
		if(reflections.GetComponent<UIToggle>().value) {
			GrapicsToggles.SSRQuality = 1;
		}
		else {
			GrapicsToggles.SSRQuality = -1;
		}

		//Bloom
		GrapicsToggles.BloomQuality = bloom.items.IndexOf(bloom.value) - 1;

		//AA
		if(aa.GetComponent<UIToggle>().value) {
			GrapicsToggles.AAQuality = 1;
		}
		else {
			GrapicsToggles.AAQuality = -1;
		}

		//SSAO
		GrapicsToggles.SSAOQuality = ssao.items.IndexOf(ssao.value) - 1;

		//Glow
		GrapicsToggles.GlowQuality = glow.items.IndexOf(glow.value) - 1;

		//Tilt Shift
		if(tiltShift.items.IndexOf(tiltShift.value) == 0) {
			GrapicsToggles.TiltShiftQuality = -1;
		}
		else {
			GrapicsToggles.TiltShiftQuality = tiltShift.items.IndexOf(tiltShift.value);
		}
	}

	void AudioUpdate() {
		SoundManager.musicVolume = musicSlider.GetComponent<UISlider>().value;
		SoundManager.sfxVolume = sfxSlider.GetComponent<UISlider>().value;
	}
}
