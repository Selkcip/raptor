using UnityEngine;
using System.Collections;
using System.IO;

public class FileButton : MonoBehaviour {

	public GameObject fileWindow;
	public GameObject deleteButton;
	public GameObject loadButton;
	public string fileName;

	private string filePath;

	// Use this for initialization
	void Start () {
		filePath = Application.dataPath + "\\" + fileName + ".xml";
		fileWindow.SetActive(false);
	}

	void OnClick() {
		if(File.Exists(filePath)) {
			//load the file
			SaveLoad.instance.LoadData(fileName);
		}
		else {
			//save new file
			SaveLoad.instance.SaveData(fileName, true);
		}

		//update the window
		fileWindow.SendMessage("UpdateWindow", SendMessageOptions.DontRequireReceiver);
		//loadButton.GetComponent<LoadButtonMain>().fileName = fileName;
		LoadButtonMain.fileName = fileName;
		deleteButton.GetComponent<DeleteButtonMain>().fileName = fileName;
		fileWindow.SetActive(true);
	}
}
