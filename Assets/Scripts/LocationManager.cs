using UnityEngine;
using System.Collections;

public class LocationManager : MonoBehaviour {

    // Location manager is a singleton.
    private static LocationManager s_instance = null;

    public static LocationManager instance {
        get {
            if(s_instance == null) {
				//Debug.LogError("LocationManager is missing.");
            }
            return s_instance;
        }
    }

    private Location m_currentLocation;
    public Location currentLocation { get { return m_currentLocation; } }

	private Location m_currentDest;
	public Location currentDestination { get { return m_currentDest; } }

	void Start() {
		s_instance = this;

		LocationMap.instance.GenerateMap();
		m_currentLocation = LocationMap.instance.locationList[0];
		m_currentLocation.encounter = EncounterManager.instance.NextEncounter();
		EncounterManager.instance.LoadEncounter(m_currentLocation.encounter);

		m_currentDest = LocationMap.instance.end;
	}

    public void Move(int newLocation) {
		if(newLocation >= m_currentLocation.neighbors.Count)
			Debug.LogError("Move() received invalid input: " + newLocation + " out of " + (m_currentLocation.neighbors.Count - 1) + ".", this);

        m_currentLocation = m_currentLocation.neighbors[newLocation];
		if(m_currentLocation.encounter == null) {
			// Store new encounter in location and load it.
			m_currentLocation.encounter = EncounterManager.instance.NextEncounter();
			SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/voices/demo/init jump"), SoundManager.SoundType.Dialogue);
			Invoke("StartWarp", 2.0f);
		}
    }

	void StartWarp() {
		GameObject tunnel = GameObject.Find("WarpTunnel");
		tunnel.renderer.enabled = true;
		tunnel.audio.Play();
		StartCoroutine("EndWarp");

		GameObject star = GameObject.Find("Star");
		star.SetActive(false);
	}

	IEnumerator EndWarp() {
		yield return new WaitForSeconds(5.0f);
		EncounterManager.instance.LoadEncounter(m_currentLocation.encounter);
		GameObject tunnel = GameObject.Find("WarpTunnel");
		tunnel.renderer.enabled = false;
		tunnel.audio.Stop();
		yield return new WaitForSeconds(0.5f);
		SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/voices/demo/ship detected"), SoundManager.SoundType.Dialogue);
		yield return new WaitForSeconds(3.0f);
		SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/voices/demo/hostile ship"), SoundManager.SoundType.Dialogue);
		yield return new WaitForSeconds(3.5f);

		FireLaser[] lasers = GameObject.FindObjectsOfType<FireLaser>();
		foreach(FireLaser laser in lasers) {
			laser.StartFiring();
		}
		GameObject gameManagerObject = GameObject.Find("Game Manager");
		GameManager gameManager = gameManagerObject.GetComponent<GameManager>();
		gameManager.StartShaking();

		SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/voices/demo/puny weapons"), SoundManager.SoundType.Dialogue);

		yield return new WaitForSeconds(12.5f);
		SoundManager.instance.Play2DSound((AudioClip)Resources.Load("Sounds/voices/demo/weapons damaged"), SoundManager.SoundType.Dialogue);
	}
}
