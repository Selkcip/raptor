using UnityEngine;
using System.Collections;

public class RaptorHUD : MonoBehaviour {

	private UISlider healthBar;
	public float health;

	private UISlider staminaBar;
	public float stamina {get; private set;}

	private UILabel stealthTimer;
	public static float sTime;

	//police timer
	public static float pTime = 180; //time in seconds before police come
	const float pAdjust = 20000f;

	// Use this for initialization
	void Start () {
		healthBar = GameObject.Find("HUD-Health").GetComponent<UISlider>();
		health = 1.0f;

		staminaBar = GameObject.Find("HUD-Pounce").GetComponent<UISlider>();
		stamina = 1.0f;

		if(GameObject.Find("HUD-StealthTimer") != null) {
			stealthTimer = GameObject.Find("HUD-StealthTimer").GetComponent<UILabel>();
			sTime = RaptorInteraction.stealthTime;

		}

		pTime = 180 - 170 * Mathf.Min(RaptorInteraction.notoriety / pAdjust, 1);
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

		//Stealth Timer Update
		if(Mathf.Floor(sTime) > 0 && stealthTimer != null) {
			sTime -= Time.deltaTime;
			int minutes = Mathf.FloorToInt(sTime / 60f);
			int seconds = Mathf.FloorToInt(sTime - minutes * 60f);
			stealthTimer.text = string.Format("{0:0}:{1:00}", minutes, seconds);
		}
		else if(Mathf.Floor(sTime) <= 0) { //Police are coming
			//activate alarms
			//turn off the ship shader

			pTime = Mathf.Max(0, pTime-Time.deltaTime);
			if(Mathf.Floor(pTime) > 0) {
				int minutes = Mathf.FloorToInt(pTime / 60f);
				int seconds = Mathf.FloorToInt(pTime - minutes * 60f);
				stealthTimer.text = "Police arrive in: " + string.Format("{0:0}:{1:00}", minutes, seconds);
			}
			else if(Mathf.Floor(pTime) <= 0) {
				//spawn the police
				stealthTimer.text  = "You gon die";
			}
		}
	}
}
