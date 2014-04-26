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
		RaptorInteraction.name = name.text;
	}

	void OnClick() {
		//SaveLoad.instance.DeleteData(fileName);
		fileWindow.SetActive(true);
		//update the window
		fileWindow.SendMessage("UpdateWindow", SendMessageOptions.DontRequireReceiver);
		//loadButton.GetComponent<LoadButtonMain>().fileName = fileName;
		LoadButtonMain.fileName = fileName;
		GameSaver.Delete(fileName);
	}
}
