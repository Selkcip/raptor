using UnityEngine;
using System.Collections;

public class SaveButton : MonoBehaviour {
	void Update() {
		 if (!LevelSelector.coastIsClear) {
			GetComponent<UIButton>().isEnabled = false;
		}
		 else if (!GetComponent<UIButton>().isEnabled){
			 GetComponent<UIButton>().isEnabled = true;
		 }
	}

	void OnClick() {
		//SaveLoad.instance.SaveData(LoadButtonMain.fileName, false);
		GameSaver.SaveGame(LoadButtonMain.fileName);
	}
}
