using UnityEngine;
using System.Collections;

public class ContinueButton : MonoBehaviour {
	public string sceneName;

	void OnClick() {
		//SaveLoad.instance.LoadData(LoadButtonMain.fileName);
		GameSaver.LoadGame(LoadButtonMain.fileName);
		Time.timeScale = 1;
		Application.LoadLevel(RaptorInteraction.level);
	}
}
