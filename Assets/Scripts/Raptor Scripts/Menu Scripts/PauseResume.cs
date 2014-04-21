using UnityEngine;
using System.Collections;

public class PauseResume : MonoBehaviour {
	GameObject pauseMenu;

	void Start() {
		pauseMenu = GameObject.Find("Pause Menu");
	}

	void OnClick() {
		pauseMenu.SendMessage("Unpause", SendMessageOptions.DontRequireReceiver);	
	}
}
