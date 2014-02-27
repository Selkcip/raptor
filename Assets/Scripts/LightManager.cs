using UnityEngine;
using System.Collections;

public class LightManager : MonoBehaviour {

	public bool startOn = true;
	public bool warning;
	public bool flashing = false;

	public Color normalColor;
	public Color warningColor;

	public Light[] lights;

	void Start() {
		if(!startOn) TurnOffLights();
	}


	public void TurnOnLights() {
		foreach(Light light in lights) {
			light.enabled = true;
		}
	}

	public void TurnOffLights() {
		foreach(Light light in lights) {
			light.enabled = false;
		}
	}

	public void StartWarning() {
		foreach(Light light in lights) {
			if(warning) light.color = warningColor;
		}
	}

	public void EndWarning() {
		foreach(Light light in lights) {
			if(!warning) light.color = normalColor;
		}
	}

	//for short term flashes
	IEnumerator Flash(float delay, int duration) {
		while(flashing && duration > 0) {
			Debug.Log("got here");
			TurnOffLights();
			yield return new WaitForSeconds(delay / 2.0f);
			TurnOnLights();
			yield return new WaitForSeconds(delay / 2.0f);
			duration--;
		}
		flashing = false;
	}


	//For long turn flashing
	IEnumerator Flash(float delay) {
		while(flashing) {
			Debug.Log("got here");
			TurnOffLights();
			yield return new WaitForSeconds(delay / 2.0f);
			TurnOnLights();
			yield return new WaitForSeconds(delay / 2.0f);
		}
		flashing = false;
	}
}
