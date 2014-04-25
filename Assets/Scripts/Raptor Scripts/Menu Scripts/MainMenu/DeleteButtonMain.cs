using UnityEngine;
using System.Collections;

public class DeleteButtonMain : MonoBehaviour {
	[HideInInspector]
	public string fileName;

	private UILabel name;

	// Use this for initialization
	void Start() {
		name = GameObject.Find("Input Label").GetComponent<UILabel>();
		RaptorInteraction.name = name.text;
	}

	void OnClick() {
		//SaveLoad.instance.DeleteData(fileName);
		GameSaver.Delete(fileName);
	}
}
