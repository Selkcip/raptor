using UnityEngine;
using System.Collections;

// attach this to the player's ship object
public class LevelSelector : MonoBehaviour {

	public float despawnRadius;
	public float spawnRadius;

	public int maxShips;
	public GameObject policeShip;
	public GameObject cargoShip;

    public Vector2 debrisSpawn; // x, y between debris
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

        //print(debris.Count);
        ArrayList newDerbs = new ArrayList(debris);
        // background debris
        if (newDerbs.Count < 1) {
            // place one near center if none yet
			float x = Random.value * debrisSpawn.x - debrisSpawn.x / 2; // random x
        	float y = Random.value * debrisSpawn.y - debrisSpawn.y / 2; // random y
            float z = -Random.value * (debrisDepth.y - debrisDepth.x) - debrisDepth.x; // random depth

            GameObject derb = (GameObject)Instantiate(debrisObject, new Vector3(x, y, z), Quaternion.identity);
			newDerbs.Add(derb);
        }


        //while (newDerbs.Count > 0) {
            // spawn debris
            ArrayList toBeAdded = new ArrayList();
			foreach(GameObject derb in newDerbs) {
                // check if there is a derb above/below/left/right and is within despawnRadius
                bool above = false, below = false, left = false, right = false;
                foreach (GameObject oldDerb in debris) {
                    Rect rect = new Rect(derb.transform.position.x - debrisSpawn.x / 2, derb.transform.position.y + debrisSpawn.y * 2, debrisSpawn.x, debrisSpawn.y); // above
                    if (rect.Contains(oldDerb.transform.position) && rect.yMin - transform.position.y < despawnRadius)
                        above = true;
                    rect = new Rect(derb.transform.position.x - debrisSpawn.x / 2, derb.transform.position.y - debrisSpawn.y, debrisSpawn.x, debrisSpawn.y); // below
                    if (rect.Contains(oldDerb.transform.position) && transform.position.y - rect.yMax < despawnRadius)
                        below = true;
                    rect = new Rect(derb.transform.position.x - debrisSpawn.x * 2, derb.transform.position.y + debrisSpawn.y / 2, debrisSpawn.x, debrisSpawn.y); // left
                    if (rect.Contains(oldDerb.transform.position) && transform.position.x - rect.xMin < despawnRadius)
                        left = true;
                    rect = new Rect(derb.transform.position.x + debrisSpawn.x , derb.transform.position.y + debrisSpawn.y / 2, debrisSpawn.x, debrisSpawn.y); // right
                    if (rect.Contains(oldDerb.transform.position) && rect.xMax - transform.position.x < despawnRadius)
                        right = true;
                }

                // if empty place a new one, add it to new derb list
                if (!above) { // above
                    float x = derb.transform.position.x + Random.value * debrisSpawn.x - debrisSpawn.x / 2; // random x
                    float y = derb.transform.position.y + Random.value * debrisSpawn.y + debrisSpawn.y; // random y
                    float z = -Random.value * (debrisDepth.y - debrisDepth.x) - debrisDepth.x; // random depth
                    GameObject newDerb = (GameObject)Instantiate(debrisObject, new Vector3(x, y, z), Quaternion.identity);
                    toBeAdded.Add(newDerb);
                    print("above");
                }
                if (!below) { 
                    // below
                    float x = derb.transform.position.x + Random.value * debrisSpawn.x - debrisSpawn.x / 2; // random x
                    float y = derb.transform.position.y - Random.value * debrisSpawn.y - debrisSpawn.y; // random y
                    float z = -Random.value * (debrisDepth.y - debrisDepth.x) - debrisDepth.x; // random depth
                    GameObject newDerb = (GameObject)Instantiate(debrisObject, new Vector3(x, y, z), Quaternion.identity);
                    toBeAdded.Add(newDerb);
                    print("below");
                }
                if (!left) {                    
                    // left
                    float x = derb.transform.position.x - Random.value * debrisSpawn.x - debrisSpawn.x; // random x
                    float y = derb.transform.position.y + Random.value * debrisSpawn.y - debrisSpawn.y / 2; // random y
                    float z = -Random.value * (debrisDepth.y - debrisDepth.x) - debrisDepth.x; // random depth
                    GameObject newDerb = (GameObject)Instantiate(debrisObject, new Vector3(x, y, z), Quaternion.identity);
                    toBeAdded.Add(newDerb);
                    print("left");
                }
                if (!right) {
                    // right
                    float x = derb.transform.position.x + Random.value * debrisSpawn.x + debrisSpawn.x; // random x
                    float y = derb.transform.position.y + Random.value * debrisSpawn.y - debrisSpawn.y / 2; // random y
                    float z = -Random.value * (debrisDepth.y - debrisDepth.x) - debrisDepth.x; // random depth
                    GameObject newDerb = (GameObject)Instantiate(debrisObject, new Vector3(x, y, z), Quaternion.identity);
                    toBeAdded.Add(newDerb);
                    print("right");
                }
            }
            // place checked in actual
            foreach (GameObject derb in newDerbs)
            {
                debris.Add(derb);
            }
            // remove checked derbs from new derb list
            newDerbs.Clear();

            print("Added: " + toBeAdded.Count);
            // add the new derbs
            foreach (GameObject derb in toBeAdded)
                newDerbs.Add(derb);
        //}
	}
}
