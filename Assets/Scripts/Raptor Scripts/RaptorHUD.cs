using UnityEngine;
using System.Collections;

public class RaptorHUD : MonoBehaviour {

	private UISlider staminaBar;
	public float stamina {get; private set;}

	// Use this for initialization
	void Start () {
		staminaBar = GameObject.Find("HUD-Pounce").GetComponent<UISlider>();
		stamina = 1.0f;
	}

	public void Deplete(float amount) {
		stamina -= amount;
	}

	public void Regenerate(float amount) {
		stamina += amount;
	}

	// Update is called once per frame
	void Update () {
		if(stamina < 0f) {
			stamina = 0f;
		}
		else if(stamina > 1f) {
			stamina = 1f;
		}
		staminaBar.value = stamina;
	}
}
