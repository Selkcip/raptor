using UnityEngine;
using System.Collections;
using System.Collections.Generic;
// attach this to the player's ship object

public class LevelSelector : MonoBehaviour {

	public float despawnRadius;
	public float spawnRadius;

	public int maxShips;
	public GameObject policeShip;
    public float policeSpawnProximity;
    public float notorietyPerShip;

	public GameObject cargoShip;

	public DeliveryShip deliveryShip;
	public float deliveryShipSpawnDis = 10;
	public Texture2D deliveryShipIndicator;

	public List<CollectibleUpgrade> upgradPrefabs = new List<CollectibleUpgrade>();

    public Vector2 debrisRadius;
    public Vector2 debrisDepth; // min/max depth of debris
    public GameObject debrisObject;

    public bool isPlayerSpotted;
    public Vector3 lastDetectedLocation;
    bool leave = false;

    ArrayList features; // list of spawned space features

    ArrayList cargoShips; // list of active cargo ships
	ArrayList policeShips; // list of active police ships in the scene
	public static bool coastIsClear = true;

    ArrayList debris; // stationary background space debris

	// Use this for initialization
    void Start()
    {
        cargoShips = new ArrayList();
		policeShips = new ArrayList();
        debris = new ArrayList();
        features = new ArrayList();
        isPlayerSpotted = false;
        lastDetectedLocation = transform.position;

        CargoLane cargoLane = new CargoLane(new Vector2(25, 0), new Vector2(1, 1), new Vector2(10, 15), 10, new Vector2(11, 12));
        features.Add(cargoLane);

		foreach(CollectibleUpgrade upgrade in upgradPrefabs) {
			UpgradeSpawner.upgrades.Add(upgrade);
		}


		if(UpgradeSpawner.upgrades.Count > 0) {
			Vector3 pos = Random.insideUnitCircle.normalized * deliveryShipSpawnDis;
			DeliveryShip ship = (DeliveryShip)Instantiate(deliveryShip, pos, Quaternion.identity);
			Indicator indicator = Indicator.New(deliveryShipIndicator, ship.transform.position);
			indicator.target = ship.transform;
			indicator.tint = Color.green;
		}

        SpawnPolice();
	}

    public void SpawnPolice() {
        if (RaptorHUD.pTime < RaptorHUD.maxPTime) { 
            //spawn police
            Vector2 spawnLocation = Random.insideUnitCircle * RaptorHUD.pTime * policeShip.GetComponent<PoliceShip>().maxSpeed;
            for (float i = 0; i < RaptorInteraction.notoriety; i += notorietyPerShip) {
                GameObject ship = (GameObject)Instantiate(policeShip, spawnLocation, Quaternion.identity);
                ship.GetComponent<PoliceShip>().searchTimer = RaptorHUD.pTime + ship.GetComponent<PoliceShip>().maxSearchTime;
                policeShips.Add(ship);
                spawnLocation += Random.insideUnitCircle * policeSpawnProximity;
            }
        }
    }

	public void Load(){
		print("Loading");
		Application.LoadLevel("cargoship");
	}
	
	// Update is called once per frame
	void Update() {
        UpdateShips();

        foreach (SpaceyFeature feature in features) { 
            switch(feature.type) {
                case FeatureType.CargoLane:
                    UpdateCargoLane((CargoLane)feature);
                    break;
                // to add additional features:
                // at the bottom of the script add an enum type to FeatureType, 
                // a class implementing SpaceyFeature, and an update function for it
            }

        UpdateBackground();
        }
	}

    void UpdateShips() {
        isPlayerSpotted = false;
		ArrayList toBeRemoved = new ArrayList();

        // update police ships
		foreach (GameObject ship in policeShips) {
            if (ship.GetComponent<PoliceShip>().searchTimer <= 0) {
                if (!leave) {
                    leave = true;
                    lastDetectedLocation = Random.insideUnitCircle * despawnRadius;
                }
                if (Vector3.Distance(transform.position, ship.transform.position) > despawnRadius)
                    toBeRemoved.Add(ship);
            }
            else if (ship.GetComponent<PoliceShip>().IsPlayerSpotted()) {
                isPlayerSpotted = true;
                leave = false;
                lastDetectedLocation = transform.position;
            }
		}
		foreach (GameObject ship in toBeRemoved) {
			policeShips.Remove(ship);
			Destroy(ship);
		}

		coastIsClear = policeShips.Count <= 0;

        // update cargo ships
        toBeRemoved.Clear();
        foreach (GameObject ship in cargoShips)
        {
            if (Vector3.Distance(transform.position, ship.transform.position) > despawnRadius)
                toBeRemoved.Add(ship);
            else if (ship.GetComponent<CargoShip>().isPlayerSpotted())
            {
                isPlayerSpotted = true;
                lastDetectedLocation = transform.position;
            }
        }

        foreach (GameObject ship in toBeRemoved)
        {
            cargoShips.Remove(ship);
            Destroy(ship);
        }

		/*while (policeShips.Count < maxShips) {
			Vector2 position = Random.insideUnitCircle.normalized * spawnRadius;
			float rotation = Random.value * 360;
			GameObject ship = (GameObject)Instantiate(policeShip, transform.position + (Vector3)position, Quaternion.Euler(new Vector3(0, 0, rotation)));
			policeShips.Add(ship);
		}*/
    }

    void UpdateBackground() {

        ArrayList toBeRemoved = new ArrayList();
        foreach (GameObject derb in debris)
            if (Vector3.Distance(transform.position, derb.transform.position) > despawnRadius)
                toBeRemoved.Add(derb);

        foreach (GameObject derb in toBeRemoved)
        {
            debris.Remove(derb);
            Destroy(derb);
        }

        // background debris
        if (debris.Count < 1)
        {
            // place one near center if none yet
            Vector2 position = Random.insideUnitCircle.normalized * debrisRadius.x / 4;
            float z = Random.value * (debrisDepth.y - debrisDepth.x) + debrisDepth.x; // random depth

            GameObject derb = (GameObject)Instantiate(debrisObject, new Vector3(position.x, position.y, z), Quaternion.identity);
            debris.Add(derb);
        }
        ArrayList newDerbs = new ArrayList(debris);

        //while (newDerbs.Count > 0) {
        ArrayList toBeAdded = new ArrayList();
        foreach (GameObject derb in newDerbs)
        {
            Vector2 position = (Vector2)derb.transform.position + Random.insideUnitCircle.normalized * (debrisRadius.x + (debrisRadius.x - debrisRadius.y) * Random.value);
            bool add = true;
            if (((Vector2)transform.position - position).magnitude > despawnRadius)
            {
                add = false;
                continue;
            }
            foreach (GameObject oldDerb in debris)
                if (((Vector2)oldDerb.transform.position - position).magnitude < debrisRadius.x)
                {
                    add = false;
                    break;
                }
            foreach (GameObject oldDerb in toBeAdded)
                if (((Vector2)oldDerb.transform.position - position).magnitude < debrisRadius.x)
                {
                    add = false;
                    break;
                }
            if (add)
            {
                float z = Random.value * (debrisDepth.y - debrisDepth.x) + debrisDepth.x; // random depth
                GameObject newDerb = (GameObject)Instantiate(debrisObject, new Vector3(position.x, position.y, z), Quaternion.identity);
                toBeAdded.Add(newDerb);
            }
        }
        newDerbs.Clear();
        foreach (GameObject derb in toBeAdded)
        {
            newDerbs.Add(derb);
            debris.Add(derb);
        }
        //}
    }

    void UpdateCargoLane(CargoLane lane) {
        // update location of lane to spot closest to player along direction
        Vector2 distance = (Vector2)transform.position - lane.location;
        Vector2 closest = Vector3.Project(distance, lane.direction);
        lane.location += closest;

        // if within spawnradius spawn ships
        distance = (Vector2)transform.position - lane.location;
        if (distance.magnitude < spawnRadius) { 
            // get a spawn location
            float spawnWidth = Random.value * lane.width - lane.width / 2;
            float spawnDistance = Mathf.Sqrt(Mathf.Pow(spawnRadius, 2) - Mathf.Pow(distance.magnitude, 2));
            Vector2 spawnOriginBack = lane.location - lane.direction.normalized * spawnDistance;
            spawnOriginBack += (Vector2)(Quaternion.Euler(new Vector3(0, 0, 90)) * lane.direction.normalized) * spawnWidth;
            Vector2 spawnOriginFront = lane.location + lane.direction.normalized * spawnDistance;
            spawnOriginFront += (Vector2)(Quaternion.Euler(new Vector3(0, 0, 90)) * lane.direction.normalized) * spawnWidth;

            // check if it is not near an already spawned cargoship, then spawn
            bool spawnBack = true;
            bool spawnFront = true;
            foreach (GameObject ship in cargoShips) {
                if (Vector2.Distance(ship.transform.position, spawnOriginBack) < lane.nextSpawnDistance)
                    spawnBack = false;
                if (Vector2.Distance(ship.transform.position, spawnOriginFront) < lane.nextSpawnDistance)
                    spawnFront = false;
            }

            if (spawnBack) { 
                GameObject newShip = (GameObject)Instantiate(cargoShip, spawnOriginBack, Quaternion.FromToRotation(Vector2.up, lane.direction));
                newShip.rigidbody2D.velocity = (Vector2)newShip.transform.up * (lane.initialSpeed.x + Random.value * (lane.initialSpeed.y - lane.initialSpeed.x));
                cargoShips.Add(newShip);
                lane.CalculateNextSpawnDistance();
            }
            else if (spawnFront)
            {
                GameObject newShip = (GameObject)Instantiate(cargoShip, spawnOriginFront, Quaternion.FromToRotation(Vector2.up, lane.direction));
                newShip.rigidbody2D.velocity = (Vector2)newShip.transform.up * (lane.initialSpeed.x + Random.value * (lane.initialSpeed.y - lane.initialSpeed.x));
                cargoShips.Add(newShip);
                lane.CalculateNextSpawnDistance();
            }
        }
        // else do nothing
    }
}

public class SpaceyFeature {
    public Vector2 location;
    public FeatureType type;

    public SpaceyFeature()
    { }

    public SpaceyFeature(Vector2 location) {
        this.location = location;
        type = FeatureType.Empty;
    }
}

public class CargoLane : SpaceyFeature {
    public Vector2 direction;
    public Vector2 shipSpawnDistance; // min/max. Time in seconds until next ship spawns
    public float width;
    public Vector2 initialSpeed; // min/max. Velocity of ships spawned by this lane

    public float nextSpawnDistance;

    public CargoLane(Vector2 location, Vector2 direction, Vector2 spawnDistance, float width, Vector2 initialSpeed) {
        this.location = location;
        this.direction = direction;
        shipSpawnDistance = spawnDistance;
        this.width = width;
        this.initialSpeed = initialSpeed;
        type = FeatureType.CargoLane;
        CalculateNextSpawnDistance();
    }

    public void CalculateNextSpawnDistance() {
        nextSpawnDistance = shipSpawnDistance.x + Random.value * (shipSpawnDistance.y - shipSpawnDistance.x);
    }
}

// enum for different feature types
public enum FeatureType { Empty, CargoLane, UpgradeShip, SpaceStation }