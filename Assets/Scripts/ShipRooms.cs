using UnityEngine;
using System.Collections;

public class ShipRooms : MonoBehaviour {
	public float width = 50;
	public float height = 50;
	public float depth = 50;
	public float roomSize = 10;
	public int minRooms = 5;
	public int maxRooms = 10;

	private ShipGrid roomGrid;

	// Use this for initialization
	void Start () {
		if(collider != null) {
			Bounds bounds = collider.bounds;
			width = bounds.size.x;
			height = bounds.size.y;
			depth = bounds.size.z;
		}
		int divX = Mathf.FloorToInt(width/roomSize);
		int divY = Mathf.FloorToInt(height / roomSize);
		int divZ = Mathf.FloorToInt(depth / roomSize);
		//roomGrid = new ShipGrid(divX, divY, divZ, roomSize);

		int roomCount = Random.Range(minRooms, maxRooms);
		for(int i = 0; i < roomCount; i++) {

		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
