using UnityEngine;
using System.Collections;

public class Speaker : MonoBehaviour {


	// Use this for initialization
	void Awake () {
        SoundManager.instance.AddSpeaker(gameObject);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
