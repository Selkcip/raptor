using UnityEngine;
using System.Collections;

public class ContinueButton : MonoBehaviour {
	public string sceneName;

	void OnClick() {
		SaveLoad.instance.LoadData(LoadButtonMain.fileName);
		Application.LoadLevel(sceneName);
	}
}
