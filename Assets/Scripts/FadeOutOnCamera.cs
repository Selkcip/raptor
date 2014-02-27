using UnityEngine;
using System.Collections;

public class FadeOutOnCamera : MonoBehaviour {

	public GameObject target;
	public GameObject whiteOut;

	// Use this for initialization
	void Start () {
	
	}

	public void TurnWhite() {
		SoundManager.instance.Play3DSound((AudioClip)Resources.Load("Sounds/ExplosionAndWeapons/FadeOutExplosion"), SoundManager.SoundType.Sfx, this.gameObject);
		this.GetComponent<FirstPersonHeadBob>().enabled = false;
		whiteOut.GetComponent<MeshRenderer>().enabled = true;
		//target.GetComponent<MeshRenderer>().enabled = false;
		this.GetComponent<SimpleMouseRotator>().enabled = false;
	}

	public void TurnBack() {
		this.GetComponent<FirstPersonHeadBob>().enabled = true;
		whiteOut.GetComponent<MeshRenderer>().enabled = false;
		target.GetComponent<MeshRenderer>().enabled = true;
		this.GetComponent<SimpleMouseRotator>().enabled = true;
	}
}
