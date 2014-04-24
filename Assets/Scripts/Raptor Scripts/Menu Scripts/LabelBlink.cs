using UnityEngine;
using System.Collections;

public class LabelBlink : MonoBehaviour {
	private TweenAlpha labelAlpha;

	// Use this for initialization
	void Start () {
		 labelAlpha = TweenAlpha.Begin(gameObject, 1f, 0f);
	
	}
	
	// Update is called once per frame
	void Update () {
		//fade the label text in and out
		if(labelAlpha.value == 0f) {
			TweenAlpha.Begin(gameObject, 2f, 1f);
		}
		else if(labelAlpha.value == 1f) {
			TweenAlpha.Begin(gameObject, 1f, 0f);
		}
	}
}
