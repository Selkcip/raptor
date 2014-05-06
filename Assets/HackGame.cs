using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class HackGame : MonoBehaviour {
	public int tileCount = 8;

	float tileSize = 0;
	List<List<int>> tiles = new List<List<int>>();

	// Use this for initialization
	void Start () {
		tileSize = renderer.bounds.size.x / tileCount;

		for(int x = 0; x < tileCount; x++) {
			tiles[x] = new List<int>();
			for(int y = 0; y < tileCount; y++) {
				tiles[x][y] = 0;
			}
		}
	}

	void AddTiles() {

	}

	void MoveLeft() {
		int tilesMoved = 0;
		for(int y = 0; y < tileCount; y++) {
			for(int x = tileCount - 2; x > -1; x--) {
				int cur = tiles[x][y];
				int n = x+1;
				if(tiles[n][y] == 0 || tiles[n][y] == cur) {
					tiles[x][y] = 0;
					tiles[n][y] += cur;
					tilesMoved++;
				}
			}
		}
		if(tilesMoved > 0) {
			AddTiles();
		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
