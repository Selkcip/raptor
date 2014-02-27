using UnityEngine;
using System.Collections;

public class ExplosionPipe : Incident {



	public AudioClip burstSound;

	public int index;

	// Use this for initialization
	void Start () {
	
	}

	public override void Activate() {
		particleSystem.Play();
	}

	// Update is called once per frame
	public override void Update() {
	
	}

	public void Seal() {
		isSolved = true;
		particleSystem.Stop();
		audio.Stop();
	}

	public override void Reset() {
		particleSystem.Play();
		audio.Play();
		isSolved = false;
	}
}
