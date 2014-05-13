using UnityEngine;
using System.Collections;

public class RaptorHUD : MonoBehaviour {

	private RaptorInteraction player;

	public UISlider health;
	public UISlider stamina;
	public UISlider defuse;

	public UILabel keycard;
	public UILabel timer;

	// Use this for initialization
	void Start () {
		player = GameObject.Find("Player").GetComponent<RaptorInteraction>();
	}
	
	// Update is called once per frame
	void Update () {
		health.value = player.health / RaptorInteraction.maxHealth;
		stamina.value = player.stamina;

		keycard.text = "Key Cards: " + RaptorInteraction.keyCount;

		TimerUpdate();
		DefuseUpdate();
	}

	void TimerUpdate() {
		int minutes = Mathf.FloorToInt(Timer.displayTime / 60f);
		int seconds = Mathf.FloorToInt(Timer.displayTime - minutes * 60f);

		if(Timer.inStealth) {
			timer.text = string.Format("{0:0}:{1:00}", minutes, seconds);
		}
		else if(!Timer.inStealth && !Timer.policeArrived) {
			timer.text = "Police arrive in: " + string.Format("{0:0}:{1:00}", minutes, seconds);
		}
		else if(Timer.policeArrived) {
			timer.text = "Police have arrived";
		}
	}

	void DefuseUpdate() {
		if(RaptorInteraction.defusing) {
			defuse.gameObject.SetActive(true);
			defuse.value += 0.25f * Time.deltaTime;
		}
		else if(!RaptorInteraction.defusing) {
			defuse.value = 0;
			defuse.gameObject.SetActive(false);
		}

		//hide when complete
		if(defuse.value >= 1.0f) {
			RaptorInteraction.defusing = false;
			defuse.gameObject.SetActive(false);
		}
	}
}
