using UnityEngine;
using System.Collections;

public class GameManager : MonoBehaviour {

	public CameraShaker shaker;

	// Use this for initialization
	void Start() {
		StartGame();
		StartCoroutine("DemoScripting");
	}
	
	public void StartDemo(){
		StartCoroutine(DemoScripting());
	}

	public void StartShaking() {
		StartCoroutine("ScreenShaking");
	}

	IEnumerator ScreenShaking() {
		yield return new WaitForSeconds(0.5f);
		while(true) {
			yield return new WaitForSeconds(6.0f);
			shaker.Shake();
		}
	}

	IEnumerator DemoScripting(){
		SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/background_darksider"), SoundManager.SoundType.Music, true, 0.3f);
		yield return new WaitForSeconds(4.0f);
		SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/voices/demo/damage imminent"), SoundManager.SoundType.Dialogue);
		yield return new WaitForSeconds(3.5f);
		SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/voices/demo/supa nova 2"), SoundManager.SoundType.Dialogue);
	}

	// Update is called once per frame
	void Update() {
		/*
		if(GameObject.Find("Player").GetComponent<PlayerInteraction>().playerRoom.air == 0.0f &&
			!GameObject.Find("Player").GetComponent<PlayerInteraction>().wearing)
			endGame();
		if(Ship.instance.health == 0.0f)
			endGame();
		 */
	}

	void StartGame() {
		// Initialize Managers
		//gameObject.AddComponent<EncounterManager>();
		gameObject.AddComponent<LocationManager>();
		gameObject.AddComponent<ResourceManager>();
		gameObject.AddComponent<SoundManager>();
	}

	void endGame() {
		//TO DO: implement game ending logic.
	}
}
