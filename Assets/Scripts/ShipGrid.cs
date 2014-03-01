using UnityEngine;
using System.Collections;
using System.Collections.Generic;

class ShipGridFluid {
	public string type;
	public float level;
	public float flowRate;

	public ShipGridFluid(string type, float level, float flowRate) {
		this.type = type;
		this.level = level;
		this.flowRate = flowRate;
	}
}

class ShipGridCell {
	public List<ShipGridCell> neighbors = new List<ShipGridCell>();
	public List<GameObject> contents = new List<GameObject>();
	public List<ShipGridFluid> fluids = new List<ShipGridFluid>();
}

class ShipGrid : MonoBehaviour {
	public Vector3 divs;
	Vector3 cellSize;
	Vector3 size = new Vector3(10, 10, 10);
	/*int divX;
	int divY;
	int divZ;*/
	List<List<List<ShipGridCell>>> cells = new List<List<List<ShipGridCell>>>();

	/*public float width { get { return size * divX; } }
	public float height { get { return size * divY; } }
	public float depth { get { return size * divZ; } }*/

	void Start() {
		if(collider != null) {
			Bounds bounds = collider.bounds;
			/*width = bounds.size.x;
			height = bounds.size.y;
			depth = bounds.size.z;*/
			size = bounds.size;
		}

		cellSize.x = size.x / divs.x;
		cellSize.y = size.y / divs.y;
		cellSize.z = size.z / divs.z;

		for(int i = 0; i < divs.x; i++) {
			List<List<ShipGridCell>> col = new List<List<ShipGridCell>>();
			cells.Add(col);
			for(int j = 0; j < divs.y; j++) {
				List<ShipGridCell> row = new List<ShipGridCell>();
				col.Add(row);
				for(int k = 0; k < divs.y; k++) {
					ShipGridCell cell = new ShipGridCell();
					row.Add(cell);
				}
			}
		}

		List<ShipGridCell> neighbors = new List<ShipGridCell>();
		neighbors.Add(GetIndex(0, 0, 0));

		while(neighbors.Count > 0) {
			RaycastHit hit;
			if(Physics.Raycast(transform.position + new Vector3(0, 1, 0), enemyDiff, out hit, curViewDis)) {
				if(hit.collider.tag == "Player") {
					enemyVisible = true;
					enemySeen = true;
					enemyPos = enemyHead.position;
					enemyDir = enemyHead.forward;
				}
			}
		}
	}

	/*public ShipGrid(int x, int y, int z, float size) {
		this.divX = x;
		this.divY = y;
		this.divZ = z;
		this.size = size;
		for(int i = 0; i < x; i++) {
			List<List<ShipGridCell>> col = new List<List<ShipGridCell>>();
			cells.Add(col);
			for(int j = 0; j < y; j++) {
				List<ShipGridCell> row = new List<ShipGridCell>();
				col.Add(row);
				for(int k = 0; k < y; k++) {
					ShipGridCell cell = new ShipGridCell();
					row.Add(cell);
				}
			}
		}
	}*/

	public Vector3 IndexToPos(int x, int y, int z) {
		float xpos = Mathf.Max(0, Mathf.Min(divs.x - 1, x));
		float ypos = Mathf.Max(0, Mathf.Min(divs.y - 1, y));
		float zpos = Mathf.Max(0, Mathf.Min(divs.z - 1, z));

		xpos = (xpos * cellSize.x) - size.x / 2;
		ypos = (ypos * cellSize.y) - size.y / 2;
		zpos = (zpos * cellSize.z) - size.z / 2;
		return new Vector3(xpos, ypos, zpos);
	}

	public ShipGridCell GetIndex(int x, int y, int z) {
		return cells[x][y][z];
	}

	public ShipGridCell GetPos(float xpos, float ypos, float zpos) {
		int x = Mathf.FloorToInt((xpos + size.x / 2) / cellSize.x);
		int y = Mathf.FloorToInt((ypos + size.y / 2) / cellSize.y);
		int z = Mathf.FloorToInt((zpos + size.z/ 2) / cellSize.z);
		x = (int)Mathf.Max(0, Mathf.Min(divs.x - 1, x));
		y = (int)Mathf.Max(0, Mathf.Min(divs.y - 1, y));
		z = (int)Mathf.Max(0, Mathf.Min(divs.z - 1, z));
		return cells[x][y][z];
	}
}
