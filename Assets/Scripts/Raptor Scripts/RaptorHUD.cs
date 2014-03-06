using UnityEngine;
using System.Collections;

public class RaptorHUD : MonoBehaviour {

	private UISlider healthBar;
	public float health;

	private UISlider staminaBar;
	public float stamina {get; private set;}


	// Use this for initialization
	void Start () {
		healthBar = GameObject.Find("HUD-Health").GetComponent<UISlider>();
		health = 1.0f;

		staminaBar = GameObject.Find("HUD-Pounce").GetComponent<UISlider>();
		stamina = 1.0f;
	}

	public void Deplete(string bar, float amount) {
		if(bar == "stamina") {
			stamina -= amount;
		}
		else if(bar == "health") {
			health -= amount;
		}
	}

	public void Regenerate(string bar, float amount) {
		if(bar == "stamina") {
			stamina += amount;
		}
		else if(bar == "health") {
			health += amount;
		}
	}

	// Update is called once per frame
	void Update () {
		//stamina updates
		if(stamina < 0f) {
			stamina = 0f;
		}
		else if(stamina > 1f) {
			stamina = 1f;
		}
		staminaBar.value = stamina;

		//health updates
		if(health < 0f) {
			health = 0f;
		}
		else if(health > 1f) {
			health = 1f;
		}
		healthBar.value = health;
	}
}
