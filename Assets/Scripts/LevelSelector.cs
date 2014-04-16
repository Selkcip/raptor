using UnityEngine;
using System.Collections;

// attach this to the player's ship object
public class LevelSelector : MonoBehaviour {

	public float despawnRadius;
	public float spawnRadius;

	public int maxShips;
	public GameObject policeShip;
	public GameObject cargoShip;

    public Vector2 debrisSpawn; // min x, y betweem debris
    public Vector2 debrisDepth; // min/max depth of debris
    public GameObject debrisObject;

    public bool isPlayerSpotted;
    public Vector3 lastDetectedLocation;

	ArrayList ships; // list of active ships in the scene (besides player)

    ArrayList debris; // stationary background space debris

	// Use this for initialization
    void Start()
    {
		ships = new ArrayList();
        debris = new ArrayList();
        isPlayerSpotted = false;
        lastDetectedLocation = transform.position;
	}

	public void Load(){
		print("Loading");
		Application.LoadLevel("cargoship");
	}
	
	// Update is called once per frame
	void Update() {
        isPlayerSpotted = false;
		ArrayList toBeRemoved = new ArrayList();
		foreach (GameObject ship in ships) {
            if (Vector3.Distance(transform.position, ship.transform.position) > despawnRadius)
                toBeRemoved.Add(ship);
            else if (ship.GetComponent<PoliceShip>().isPlayerSpotted()) {
                isPlayerSpotted = true;
                lastDetectedLocation = transform.position;
            }
		}
		foreach (GameObject ship in toBeRemoved) {
			ships.Remove(ship);
			Destroy(ship);
		}

		while (ships.Count < maxShips) {
			Vector2 position = Random.insideUnitCircle.normalized * spawnRadius;
			float rotation = Random.value * 360;
			GameObject ship = (GameObject)Instantiate(policeShip, transform.position + (Vector3)position, Quaternion.Euler(new Vector3(0, 0, rotation)));
			ships.Add(ship);
		}

        toBeRemoved = new ArrayList();
        foreach (GameObject derb in debris)
            if (Vector3.Distance(transform.position, derb.transform.position) > despawnRadius)
                toBeRemoved.Add(derb);

        foreach (GameObject derb in toBeRemoved) {
            debris.Remove(derb);
            Destroy(derb);
        }

        /*bool hasAvailable = true;
        while (hasAvailable) {
            // spawn debris
            // check for available locations within despawnRadius adjacent to existing
                        
            // place one near center if none yet
            if (debris.Count < 1) {
                GameObject derb = (GameObject)Instantiate(debrisObject, );
            }
        }*/


	}
}
