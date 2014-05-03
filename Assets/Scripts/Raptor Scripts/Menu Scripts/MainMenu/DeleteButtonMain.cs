using UnityEngine;
using System.Collections;

public class DeleteButtonMain : MonoBehaviour {
	[HideInInspector]
	public string fileName;
	public GameObject fileWindow;

	private UILabel name;

	// Use this for initialization
	void Start() {
		name = GameObject.Find("Input Label").GetComponent<UILabel>();
	}

	void OnClick() {
		//SaveLoad.instance.DeleteData(fileName);
		fileWindow.SetActive(true);
		//update the window
		//loadButton.GetComponent<LoadButtonMain>().fileName = fileName;

		LoadButtonMain.fileName = fileName;
		GameSaver.Delete(fileName);
		GameSaver.LoadGame(fileName);	
		fileWindow.SendMessage("UpdateWindow", SendMessageOptions.DontRequireReceiver);
	}
}
