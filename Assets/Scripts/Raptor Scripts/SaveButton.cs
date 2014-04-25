using UnityEngine;
using System.Collections;

public class SaveButton : MonoBehaviour {
	//disable when chased

	void OnClick() {
		//SaveLoad.instance.SaveData(LoadButtonMain.fileName, false);
		GameSaver.SaveGame(LoadButtonMain.fileName);
	}
}
