using UnityEngine;
using System.Collections;

public class ContinueButton : MonoBehaviour {
	public string sceneName;

	void OnClick() {
		//SaveLoad.instance.LoadData(LoadButtonMain.fileName);
		string oldLevel = RaptorInteraction.level;
		GameSaver.LoadGame(LoadButtonMain.fileName);
		Time.timeScale = 1;
		Pause.paused = false;
		Application.LoadLevel(oldLevel);
	}
}
