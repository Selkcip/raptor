using UnityEngine;
using System.Collections;
using Holoville.HOTween;

public class Credits : MonoBehaviour {
	public float time = 45;
	public float position = 200f;
	public GameObject menu;
	public GameObject credits;

	private Vector3 defaultPos;

	// Use this for initialization
	void Start () {
		defaultPos = credits.transform.localPosition;
		HOTween.To(credits.transform, time, new TweenParms().Prop("localPosition", new Vector3(0f, position, 0f), true).OnComplete(Close));
	}

	void Close() {
		HOTween.Kill(credits.transform);
		credits.transform.localPosition = defaultPos;
		menu.SetActive(true);
		gameObject.SetActive(false);
	}

	void Restart() {	
		HOTween.To(credits.transform, time, new TweenParms().Prop("localPosition", new Vector3(0f, position, 0f), true).OnComplete(Close));
	}
}
