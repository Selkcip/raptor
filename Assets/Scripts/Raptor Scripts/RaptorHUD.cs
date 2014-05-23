using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class RaptorHUD : MonoBehaviour {

	private RaptorInteraction player;

	public UISlider health;
	public UISlider stamina;
	public UISlider defuse;

	public UILabel keycard;
	public UILabel timer;

	public UILabel usePrompt;

	private List<string> useMessages = new List<string>();

	// Use this for initialization
	void Start () {
		player = GameObject.Find("Player").GetComponent<RaptorInteraction>();

		useMessages.Add("Press E to enter your ship");//0
		useMessages.Add("Press E to pick up the item");//1
		useMessages.Add("Press E to begin hacking");//2
		useMessages.Add("Press E to use the light switch");//3
		useMessages.Add("Hold E to defuse the trap");//4
		useMessages.Add("Press E to toggle the trap");
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

	public void UsePromptUpdate(bool enable, int index, GameObject hit) {
		usePrompt.enabled = enable;
		if(!enable) {
			return;
		}

		if (hit.GetComponent<Mine>() != null){
			if(!hit.GetComponent<Mine>().hacked) {
				usePrompt.text = useMessages[index];
			}
			else {
				usePrompt.text = useMessages[index+1];
			}
		}
		else{
			usePrompt.text = useMessages[index];
		}
	}
}
