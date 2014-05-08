using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class HackGame : MonoBehaviour {
	public int tileCount = 8;
	public HackGameTile tile;

	public float tileSize = 0;
	public Vector3 offset;
	List<List<int>> spaces = new List<List<int>>();
	List<List<HackGameTile>> tiles = new List<List<HackGameTile>>();

	// Use this for initialization
	void Start () {
		tileSize = renderer.bounds.size.x / tileCount;
		offset = -renderer.bounds.size/2;

		for(int x = 0; x < tileCount; x++) {
			spaces.Add(new List<int>());
			tiles.Add(new List<HackGameTile>());
			for(int y = 0; y < tileCount; y++) {
				spaces[x].Add(0);
				tiles[x].Add(null);
			}
		}

		AddTiles();
	}

	void AddTiles() {
		List<Vector3> empties = new List<Vector3>();
		for(int x = 0; x < tileCount; x++) {
			for(int y = 0; y < tileCount; y++) {
				if(spaces[x][y] == 0) {
					empties.Add(new Vector3(x, y, -1));
				}
			}
		}
		Vector3 space = new Vector3(0, 0, 0);// empties[Random.Range(0, empties.Count - 1)];
		//print(space);
		if(space != null) {
			spaces[(int)space.x][(int)space.y] = 1;
			HackGameTile newTile = (HackGameTile)Instantiate(tile, offset+space * tileSize, Quaternion.identity);
			tiles[(int)space.x][(int)space.y] = newTile;
			newTile.pos = offset + space * tileSize;
			newTile.transform.localScale = new Vector3(tileSize, tileSize, tileSize);
		}
	}

	void MoveRight() {
		int tilesMoved = 0;
		for(int y = 0; y < tileCount; y++) {
			for(int x = tileCount - 2; x > -1; x--) {
				HackGameTile cur = tiles[x][y];
				if(cur != null) {
					int n = tileCount - 1;
					for(; n > x; n--) {
						HackGameTile neigh = tiles[n][y];
						if(neigh == null || neigh.value == cur.value) {
							cur.pos.x = offset.x + n * tileSize;
							cur.pos.y = offset.y + y * tileSize;
							cur.mergeTarget = neigh;
							if(neigh != null) {
								//print("c "+cur.value+" n "+neigh.value);
								neigh.value += cur.value;
							}
							else {
								tiles[n][y] = cur;
							}
							tiles[x][y] = null;
							tilesMoved++;
							break;
						}
					}
				}
			}
		}
		if(tilesMoved > 0) {
			AddTiles();
		}
	}

	void MoveLeft() {
		int tilesMoved = 0;
		for(int y = 0; y < tileCount; y++) {
			for(int x = 1; x < tileCount; x++) {
				int v = spaces[x][y];
				if(v > 0) {
					int n = 0;
					for(; n < x; n++) {
						if(spaces[n][y] == 0 || spaces[n][y] == v) {
							spaces[n][y] += v;
							spaces[x][y] = 0;
							HackGameTile cur = tiles[x][y];
							if(cur) {
								cur.pos.x = offset.x + n * tileSize;
								cur.pos.y = offset.y + y * tileSize;
								cur.mergeTarget = tiles[n][y];
								tilesMoved++;
								break;
							}
						}
					}
				}
			}
		}
		if(tilesMoved > 0) {
			AddTiles();
		}
	}
	
	// Update is called once per frame
	void Update () {
		if(Input.GetKeyDown(KeyCode.D)) {
			MoveRight();
		}
		else if(Input.GetKeyDown(KeyCode.A)) {
			MoveLeft();
		}
	}
}
