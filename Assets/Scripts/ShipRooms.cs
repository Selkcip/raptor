using UnityEngine;
using System.Collections;

public class ShipRooms : MonoBehaviour {
	public float width = 50;
	public float height = 50;
	public float roomSize = 10;
	public int minRooms = 5;
	public int maxRooms = 10;

	private ShipGrid roomGrid;

	// Use this for initialization
	void Start () {
		int cols = Mathf.FloorToInt(width/roomSize);
		int rows = Mathf.FloorToInt(height/roomSize);
		roomGrid = new ShipGrid(cols, rows, roomSize);

		int roomCount = Random.Range(minRooms, maxRooms);
		for(int i = 0; i < roomCount; i++) {

		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
