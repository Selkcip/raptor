using UnityEngine;
using System.Collections;

public class LevelSelector : MonoBehaviour {

	public float despawnRadius;
	public float spawnRadius;

	public int maxShips;
	public GameObject enemyShip;

	ArrayList ships;

	// Use this for initialization
	void Start() {
		ships = new ArrayList();
	}

	public void Load(){
		print("Loading");
		Application.LoadLevel("cargoship");
	}
	
	// Update is called once per frame
	void Update() {
		ArrayList toBeRemoved = new ArrayList();
		foreach (GameObject ship in ships) {
			if (Vector3.Distance(transform.position, ship.transform.position) > despawnRadius) {
				toBeRemoved.Add(ship);
			}
		}
		foreach (GameObject ship in toBeRemoved) {
			ships.Remove(ship);
			Destroy(ship);
		}

		while (ships.Count < maxShips) {
			Vector2 position = Random.insideUnitCircle.normalized * spawnRadius;
			float rotation = Random.value * 360;
			GameObject ship = (GameObject)Instantiate(enemyShip, transform.position + (Vector3)position, Quaternion.Euler(new Vector3(0, 0, rotation)));
			ships.Add(ship);
		}
	}
}
