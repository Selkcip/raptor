using UnityEngine;
using System.Collections;

public class TitleScreen : MonoBehaviour {

	public GameObject backgroundMesh;
	public GameObject mainMenu;

	private bool started = false;
	private TweenAlpha titleAlpha;

	// Use this for initialization
	void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.anyKeyDown && !started){
			titleAlpha = TweenAlpha.Begin(gameObject, 3f, 0f);
			TweenAlpha.Begin(backgroundMesh, 2f, 1f);
			started = true;
		}

		if(started && titleAlpha.value == 0f) {
			mainMenu.SetActive(true);
		}
	}
}
