using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class HackGame : MonoBehaviour {
	public float moveTime = 1;
	public int tileCount = 8;
	public HackGameTile tile;

	public float tileSize = 0;
	public Vector3 offset;
	List<List<int>> spaces = new List<List<int>>();
	List<List<HackGameTile>> tiles = new List<List<HackGameTile>>();
	List<HackGameTile> movingTiles = new List<HackGameTile>();

	// Use this for initialization
	void Start () {
		tileSize = renderer.bounds.size.x / tileCount;
		offset = -renderer.bounds.size/2;
		offset.x += tileSize / 2;
		offset.y += tileSize / 2;

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
				if(tiles[x][y] == null) {
					empties.Add(new Vector3(x, y, 0));
				}
			}
		}
		if(empties.Count > 0) {
			Vector3 space = empties[Random.Range(0, empties.Count - 1)];
			//print(space);
			if(space != null) {
				HackGameTile newTile = (HackGameTile)Instantiate(tile, offset + space * tileSize, Quaternion.identity);
				tiles[(int)space.x][(int)space.y] = newTile;
				newTile.value = Random.Range(0, 2);
				newTile.pos = offset + space * tileSize;
				newTile.transform.localScale = new Vector3(tileSize, tileSize, tileSize);
			}
		}
	}

	void MoveRight() {
		int tilesMoved = 0;
		for(int y = 0; y < tileCount; y++) {
			int initN = tileCount - 1;
			for(int x = tileCount - 2; x > -1; x--) {
				HackGameTile cur = tiles[x][y];
				if(cur != null) {
					for(int n = initN; n > x; n--) {
						initN = x;
						HackGameTile neigh = tiles[n][y];
						if(neigh == null || (neigh != cur && neigh.value == cur.value)) {
							cur.pos.x = offset.x + n * tileSize;
							cur.pos.y = offset.y + y * tileSize;
							cur.mergeTarget = neigh;
							if(neigh != null) {
								neigh.value += 1;
								initN = n - 1;
							}
							else {
								tiles[n][y] = cur;
								initN = n;
							}
							tiles[x][y] = null;
							tilesMoved++;
							movingTiles.Add(cur);
							break;
						}
					}
				}
			}
		}
	}

	void MoveLeft() {
		int tilesMoved = 0;
		for(int y = 0; y < tileCount; y++) {
			int initN = 0;
			for(int x = 1; x < tileCount; x++) {
				HackGameTile cur = tiles[x][y];
				if(cur != null) {
					for(int n = initN; n < x; n++) {
						initN = x;
						HackGameTile neigh = tiles[n][y];
						if(neigh == null || neigh.value == cur.value) {
							cur.pos.x = offset.x + n * tileSize;
							cur.pos.y = offset.y + y * tileSize;
							cur.mergeTarget = neigh;
							if(neigh != null) {
								neigh.value += 1;
								initN = n + 1;
							}
							else {
								tiles[n][y] = cur;
								initN = n;
							}
							tiles[x][y] = null;
							tilesMoved++;
							movingTiles.Add(cur);
							break;
						}
					}
				}
			}
		}
	}

	void MoveUp() {
		int tilesMoved = 0;
		for(int x = 0; x < tileCount; x++) {
			int initN = tileCount - 1;
			for(int y = tileCount - 2; y > -1; y--) {
				HackGameTile cur = tiles[x][y];
				if(cur != null) {
					for(int n = initN; n > y; n--) {
						initN = y;
						HackGameTile neigh = tiles[x][n];
						if(neigh == null || (neigh != cur && neigh.value == cur.value)) {
							cur.pos.x = offset.x + x * tileSize;
							cur.pos.y = offset.y + n * tileSize;
							cur.mergeTarget = neigh;
							if(neigh != null) {
								neigh.value += 1;
								initN = n - 1;
							}
							else {
								tiles[x][n] = cur;
								initN = n;
							}
							tiles[x][y] = null;
							tilesMoved++;
							movingTiles.Add(cur);
							break;
						}
					}
				}
			}
		}
	}

	void MoveDown() {
		int tilesMoved = 0;
		for(int x = 0; x < tileCount; x++) {
			int initN = 0;
			for(int y = 1; y < tileCount; y++) {
				HackGameTile cur = tiles[x][y];
				if(cur != null) {
					for(int n = initN; n < y; n++) {
						initN = y;
						HackGameTile neigh = tiles[x][n];
						if(neigh == null || neigh.value == cur.value) {
							cur.pos.x = offset.x + x * tileSize;
							cur.pos.y = offset.y + n * tileSize;
							cur.mergeTarget = neigh;
							if(neigh != null) {
								neigh.value += 1;
								initN = n + 1;
							}
							else {
								tiles[x][n] = cur;
								initN = n;
							}
							tiles[x][y] = null;
							tilesMoved++;
							movingTiles.Add(cur);
							break;
						}
					}
				}
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		for(int x = 0; x < tileCount; x++) {
			for(int y = 0; y < tileCount; y++) {
				if(tiles[x][y] != null) {
					Debug.DrawRay(offset + new Vector3(x * tileSize, y * tileSize, -1), transform.right);
				}
			}
		}

		if(movingTiles.Count > 0) {
			//print("moving tiles");
			for(int i = 0; i < movingTiles.Count; i++) {
				HackGameTile cur = movingTiles[i];
				//cur.renderer.material.color = Color.red;
				//print("moving tile");
				Vector3 diff = cur.pos - cur.transform.position;
				if(diff.magnitude > 0.05f) {
					cur.transform.position += diff * Time.deltaTime / moveTime;
				}
				else {
					//cur.renderer.material.color = Color.green;
					cur.transform.position = cur.pos;
					movingTiles[i] = null;
					if(cur.mergeTarget != null && cur.mergeTarget != cur) {
						cur.mergeTarget.Merge(cur);
					}
				}
			}
			movingTiles.RemoveAll(delegate(HackGameTile tile) {
				return tile == null;
			});
			if(movingTiles.Count <= 0) {
				AddTiles();
			}
		}
		else {
			if(Input.GetKeyDown(KeyCode.D)) {
				MoveRight();
			}
			else if(Input.GetKeyDown(KeyCode.A)) {
				MoveLeft();
			}
			else if(Input.GetKeyDown(KeyCode.W)) {
				MoveUp();
			}
			else if(Input.GetKeyDown(KeyCode.S)) {
				MoveDown();
			}
		}
	}
}
