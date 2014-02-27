using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LocationMap : MonoBehaviour {
	//be careful when adjusting these or you may have an infinite loop
	public float radius = 30f;
	public float minDistance = 5f;
	public int numberOfLocations = 100;
	public float dangerZoneChance = 45f;

	public int maxNeighbors = 5;
	public float maxDistanceToNeighbor = 15f;

	public Vector3 origin = Vector3.zero;
	public float visualScale = 1.0f;
	public float verticalScale = 1.0f;
	public Vector3 rotateSpeed = new Vector3(0, 0.1f, 0);
	public GameObject starObject;
	public GameObject connectionLine;
	public LocationMapReticle reticle;
	public Transform playerMarker;
	public Transform destMarker;
	public List<Location> locationList = new List<Location>();
	public List<Location> shortestPath = new List<Location>();


	public Location end;
	private bool goodPoint = false;
	private Vector3 randomPoint;
	private List<GameObject> locationObjects = new List<GameObject>();
	private List<LocationMapConnection> connectionlines = new List<LocationMapConnection>();
	private LocationMarker currentTarget;
	private bool rotate = true;

	private static LocationMap s_instance = null;
	public static LocationMap instance {
		get {
			if(s_instance == null) {
				Debug.LogError("LocationMap is missing.");
			}
			return s_instance;
		}
	}

	public void Awake() {
		s_instance = this;
		//GenerateMap();
	}

	public void GenerateMap() {
		locationList.Clear();
		shortestPath.Clear();
		MakePoints();
		MakeConnections();
		FindShortestPath();
		DangerZone();
		printLocations();
	}

	public void Restart() {
		//Debug.Log("Mother fucking oops");
		locationList.Clear();
		shortestPath.Clear();
		MakePoints();
		MakeConnections();
		FindShortestPath();
		DangerZone();
		printLocations();
	}

	public void MakePoints() {
		locationList.Add(new Location(new Vector3(Random.Range(-radius, radius),
								Random.Range(-radius, radius),
								Random.Range(-radius, radius))));

		locationList[0].start = true;

		for(int i = 1; i < numberOfLocations; i++) {
			goodPoint = false;
			while(!goodPoint) {
				randomPoint = new Vector3(Random.Range(-radius, radius),
										Random.Range(-radius, radius),
										Random.Range(-radius, radius));

				foreach(Location location in locationList) {
					if(!(Vector3.Distance(location.point, randomPoint) > minDistance &&
							Vector3.Distance(origin, randomPoint) < radius)) {

						goodPoint = false;
						break;
					}
					goodPoint = true;
				}
			}
			locationList.Add(new Location(randomPoint));
		}
	}

	public void MakeConnections() {
		foreach(Location location in locationList) {
				foreach (Location otherLocation in locationList){
					float distance  = Vector3.Distance(location.point,otherLocation.point);
					if (location.neighbors.Count >= maxNeighbors ||
						otherLocation.neighbors.Count >= maxNeighbors ||
						distance > maxDistanceToNeighbor || distance <= 0){
						continue;
					}

					location.neighbors.Add(otherLocation);
					otherLocation.neighbors.Add(location);
			}

		}
		FindFarthestPoint();
	}

	public void printLocations() {
		foreach(GameObject star in locationObjects) {
			Destroy(star);
		}
		locationObjects.Clear();
		foreach(LocationMapConnection connection in connectionlines) {
			Destroy(connection);
		}
		connectionlines.Clear();
		foreach(Location location in locationList) {
			GameObject debugStar;
			if(starObject != null) {
				debugStar = (GameObject)GameObject.Instantiate(starObject);
				debugStar.GetComponent<LocationMarker>().location = location;
			}
			else {
				debugStar = GameObject.CreatePrimitive(PrimitiveType.Cube);
			}
			debugStar.transform.parent = transform;
			Vector3 scaledPos = location.point * visualScale;
			scaledPos.y *= verticalScale;
			debugStar.transform.localPosition = scaledPos;
			locationObjects.Add(debugStar);
			location.marker = debugStar;

			if(connectionLine != null) {
				foreach(Location neighbor in location.neighbors) {
					bool exists = false;
					foreach(LocationMapConnection con in connectionlines) {
						if((con.start == location && con.end == neighbor) || (con.end == location && con.start == neighbor)) {
							exists = true;
							break;
						}
					}
					if(!exists) {
						LocationMapConnection connection = ((GameObject)GameObject.Instantiate(connectionLine)).GetComponent < LocationMapConnection>();
						connection.start = location;
						connection.end = neighbor;

						connection.transform.parent = transform;
						connection.transform.localPosition = debugStar.transform.localPosition;

						scaledPos = neighbor.point * visualScale;
						scaledPos.y *= verticalScale;

						Vector3 diff = scaledPos - connection.transform.localPosition;
						Vector3 scale = connection.line.transform.localScale;
						scale.z = diff.magnitude;
						connection.line.transform.localScale = scale;

						connection.transform.LookAt(transform.TransformPoint(scaledPos));
						connectionlines.Add(connection);
					}
				}
			}

			if(location.encounterType == Location.EncounterType.dangerous) {
				//debugStar.transform.renderer.material.color = Color.red;
			}

			if(location.start) {
				//debugStar.transform.renderer.material.color = Color.blue;
			}

			if(location.end) {
				//debugStar.transform.renderer.material.color = Color.green;
			}
			//print(locationList.IndexOf(location) + ": " + location.point);
			//print(location.neighbors.Count);
		}
	}

	public void FindFarthestPoint() {
		end = locationList[0];
		foreach(Location location in locationList) {
			if(Vector3.Distance(locationList[0].point, location.point) > Vector3.Distance(locationList[0].point, end.point)) {
				end = location;
			}
		}
		end.end = true;

		BFS();
	}

	public void FindShortestPath() {
		//setup
		foreach(Location location in locationList) {
			location.distance = Mathf.Infinity;
			location.previous = null;
		}

		locationList[0].distance = 0;
		List<Location> queue = new List<Location>(locationList);
		Location tempLocation = new Location();
		//The search
		while(queue.Count != 0) {
			float temp = Mathf.Infinity;
			foreach(Location location in queue) {
				if(location.distance < temp) {
					temp = location.distance;
					tempLocation = location;
				}
			}

			if(tempLocation.end) {
				break;
			}

			queue.Remove(tempLocation);
			if(tempLocation.distance == Mathf.Infinity) {
				break;
			}

			foreach(Location neighbor in tempLocation.neighbors) {
				float alt = tempLocation.distance + Vector3.Distance(neighbor.point, tempLocation.point);
				if(alt < neighbor.distance) {
					neighbor.distance = alt;
					neighbor.previous = tempLocation;
				}
			}
		}
		
		//poop out a path?
		shortestPath = new List<Location>();
		while(tempLocation.previous != null) {
			shortestPath.Add(tempLocation);
			tempLocation = tempLocation.previous;
		}
		//print(shortestPath.Count);
	}

	public void BFS() {
		List<Location> queue = new List<Location>();
		List<Location> copy = new List<Location>(locationList);

		queue.Add(copy[0]);

		while(queue.Count != 0) {
			Location temp = queue[0];
			queue.Remove(temp);
			foreach(Location neighbor in temp.neighbors) {
				if(neighbor.end) {
					neighbor.reachable = true;
					//print("Start connected to End");
					return;
				}

				if(neighbor.reachable) {
					continue;
				}
				neighbor.reachable = true;
				queue.Add(neighbor);
			}
		}

		if(!end.reachable) {
			Restart();
		}

		//remove any unconnected nodes
		/*foreach(Location location in locationList) {
			if(location.neighbors.Count == 0) {
				locationList.Remove(location);
			}
		}*/
	}

	public void DangerZone() {
		foreach(Location location in locationList) {
			if(shortestPath.Contains(location)) {
				//print("DANGER ZOOOONE");
				location.encounterType = Location.EncounterType.dangerous;
			}
			else if (Random.Range(0f,100f) < dangerZoneChance){
				location.encounterType = Location.EncounterType.dangerous;
			}
		}
		locationList[0].encounterType = Location.EncounterType.normal;
		end.encounterType = Location.EncounterType.normal;
	}

	//debug stuff that can be removed later
	public void DebugLines() {
		foreach(Location location in locationList) {
			foreach(Location neighbor in location.neighbors) {
				Debug.DrawLine(transform.position + location.point * visualScale, transform.position + neighbor.point * visualScale, Color.cyan);
			}
		}

		foreach(Location location in shortestPath) {
			if(location.previous != null) {
				Debug.DrawLine(transform.position + location.point * visualScale, transform.position + location.previous.point * visualScale, Color.red);
			}
		}
	}

	void OnTriggerEnter(Collider other) {
		if(other.tag == "Player") {
			rotate = false;
		}
	}

	void OnTriggerExit(Collider other) {
		if(other.tag == "Player") {
			rotate = true;
		}
	}

	public void Update() {
		//DebugLines();

		if(rotate) {
			transform.Rotate(rotateSpeed);
		}

		/*foreach(GameObject obj in locationObjects) {
			if(LocationManager.instance != null) {
				LocationMarker marker = obj.GetComponent<LocationMarker>();
				if(marker.location == LocationManager.instance.currentLocation) {

				}
				else if(marker.location.neighbors.Contains(LocationManager.instance.currentLocation)) {

				}
			}
		}*/

		RaycastHit raycastHit;
		Ray ray = Camera.main.ScreenPointToRay(new Vector2(Screen.width / 2, Screen.height / 2));
		int mask = 1 << LayerMask.NameToLayer("StarMap");
		if(Physics.Raycast(ray, out raycastHit, 15.0f, mask)) {
			LocationMarker marker = raycastHit.collider.gameObject.GetComponent<LocationMarker>();
			if(marker != null) {
				currentTarget = marker;
				if(reticle != null) {
					reticle.location = marker.location;
					reticle.Show();
					if(Input.GetMouseButtonUp(0)) {
						LocationManager.instance.Move(LocationManager.instance.currentLocation.neighbors.IndexOf(marker.location));
					}
				}
			}
		}

		if(reticle != null && currentTarget != null) {
			reticle.transform.position = currentTarget.transform.position;
		}

		if(playerMarker != null) {
			playerMarker.parent = LocationManager.instance.currentLocation.marker.transform;
			playerMarker.localPosition = new Vector3(0,0,0);
		}

		if(destMarker != null) {
			destMarker.parent = end.marker.transform;
			destMarker.localPosition = new Vector3(0, 0, 0);
		}
	}
}
