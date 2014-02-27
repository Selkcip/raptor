using UnityEngine;
using System.Collections;

public class PipeEmitters : MonoBehaviour {

	public GameObject[] Emitters;
	
	private bool allOn = false;

	int counter = 0;
	// Use this for initialization
	void Start () {
		foreach(GameObject emitter in Emitters) {
			emitter.particleSystem.Pause();
			emitter.audio.Pause();
			//emitter.GetComponent<ExplosionPipe>().index = counter;  
			counter++;
		}
	}
	
	public void ActivateLeak() {
		int rand = Random.Range(0, Emitters.Length);
		if(Emitters[rand].particleSystem.isPlaying && !allOn) ActivateLeak();
		//if(!Emitters[rand].particleSystem.isPlaying) SoundManager.instance.Play3DSound(Emitters[rand].GetComponent<ExplosionPipe>().burstSound, 
			//SoundManager.SoundType.Sfx, Emitters[rand]);
		Emitters[rand].particleSystem.Play();
		Emitters[rand].audio.Play();
	}

	public void DisableLeak(int i) {
		Emitters[i].audio.Pause();
		Emitters[i].particleSystem.Pause();
	}
	
	// Update is called once per frame
	void Update () {
		foreach(GameObject emitter in Emitters) {
			if(!emitter.particleSystem.isPlaying) allOn = false;
			else allOn = true;
		}


		if(Input.GetKeyDown(KeyCode.T)) {
			ActivateLeak();
		}
	}
}
