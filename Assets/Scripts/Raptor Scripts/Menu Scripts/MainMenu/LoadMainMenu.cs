using UnityEngine;
using System.Collections;

public class LoadMainMenu : MonoBehaviour {

	void OnClick() {
		Pause.paused = false;
		Application.LoadLevel("MainMenu");
	}
}
