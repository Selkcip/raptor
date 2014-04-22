﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;

// attach this to the player's ship object
public class LevelSelector : MonoBehaviour {

	public float despawnRadius;
	public float spawnRadius;

	public int maxShips;
	public GameObject policeShip;
	public GameObject cargoShip;
	public DeliveryShip deliveryShip;
	public float deliveryShipSpawnDis = 10;

    public Vector2 debrisRadius;
    public Vector2 debrisDepth; // min/max depth of debris
    public GameObject debrisObject;

    public bool isPlayerSpotted;
    public Vector3 lastDetectedLocation;

	ArrayList ships; // list of active ships in the scene (besides player)

    ArrayList debris; // stationary background space debris

	public static List<Upgrade> upgrades = new List<Upgrade>();

	// Use this for initialization
    void Start()
    {
		ships = new ArrayList();
        debris = new ArrayList();
        isPlayerSpotted = false;
        lastDetectedLocation = transform.position;

		if(upgrades.Count > 0) {
			Vector3 pos = Random.insideUnitCircle.normalized * deliveryShipSpawnDis;
			DeliveryShip ship = (DeliveryShip)Instantiate(deliveryShip, pos, Random.rotation);
			ship.upgrade = upgrades[0];
			upgrades.Remove(ship.upgrade);
		}
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

        // background debris
        if (debris.Count < 1) {
            // place one near center if none yet
            Vector2 position = Random.insideUnitCircle.normalized * debrisRadius.x / 4;
            float z = Random.value * (debrisDepth.y - debrisDepth.x) + debrisDepth.x; // random depth

            GameObject derb = (GameObject)Instantiate(debrisObject, new Vector3(position.x, position.y, z), Quaternion.identity);
            debris.Add(derb);
        }
        ArrayList newDerbs = new ArrayList(debris);

        //while (newDerbs.Count > 0) {
            ArrayList toBeAdded = new ArrayList();
            foreach (GameObject derb in newDerbs) {
                Vector2 position = (Vector2)derb.transform.position + Random.insideUnitCircle.normalized * (debrisRadius.x + (debrisRadius.x - debrisRadius.y) * Random.value);
                bool add = true;
                if (((Vector2)transform.position - position).magnitude > despawnRadius) { 
                    add = false;
                    continue;
                }
                foreach (GameObject oldDerb in debris)
                    if (((Vector2)oldDerb.transform.position - position).magnitude < debrisRadius.x) { 
                        add = false;
                        break;
                    }
                foreach (GameObject oldDerb in toBeAdded)
                    if (((Vector2)oldDerb.transform.position - position).magnitude < debrisRadius.x) { 
                        add = false;
                        break;
                    }
                if (add) {
                    float z = Random.value * (debrisDepth.y - debrisDepth.x) + debrisDepth.x; // random depth
                    GameObject newDerb = (GameObject)Instantiate(debrisObject, new Vector3(position.x, position.y, z), Quaternion.identity);
                    toBeAdded.Add(newDerb);
                }
            }
            newDerbs.Clear();
            print(newDerbs.Count);
            foreach (GameObject derb in toBeAdded) {
                newDerbs.Add(derb);
                debris.Add(derb);
            }
        //}
	}
}
