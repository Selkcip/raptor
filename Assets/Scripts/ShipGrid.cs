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
	public List<GameObject> contents = new List<GameObject>();
	public List<ShipGridFluid> fluids = new List<ShipGridFluid>();
}

class ShipGrid {
	float size;
	int cols;
	int rows;
	List<List<ShipGridCell>> cells = new List<List<ShipGridCell>>();

	public float width { get { return size * cols; } }
	public float height { get { return size * rows; } }

	public ShipGrid(int cols, int rows, float size) {
		this.cols = cols;
		this.rows = rows;
		this.size = size;
		for(int i = 0; i < cols; i++) {
			List<ShipGridCell> col = new List<ShipGridCell>();
			cells.Add(col);
			for(int j = 0; j < rows; j++) {
				ShipGridCell cell = new ShipGridCell();
				col.Add(cell);
			}
		}
	}

	public List<GameObject> GetIndex(int x, int y){
		return cells[x][y].contents;
	}

	public List<GameObject> GetPos(float xpos, float ypos) {
		int x = Mathf.FloorToInt((xpos + width / 2) / size);
		int y = Mathf.FloorToInt((ypos + height / 2) / size);
		x = Mathf.Max(0, Mathf.Min(cols - 1, x));
		y = Mathf.Max(0, Mathf.Min(rows - 1, y));
		return cells[x][y].contents;
	}
}
