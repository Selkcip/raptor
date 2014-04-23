using UnityEngine;
using System.Collections;

public class LoadButtonMain : MonoBehaviour {
	public static string fileName;

	private UILabel name;

	// Use this for initialization
	void Start () {
		name = GameObject.Find("Input Label").GetComponent<UILabel>();
		RaptorInteraction.name = name.text;
	}

	void OnClick() {
		RaptorInteraction.name = name.text;
		SaveLoad.instance.SaveData(fileName, false);
		Application.LoadLevel("shiptest");
	}
}
