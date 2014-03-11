using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ShipGridFluid {
	public string type;
	public float level;
	public float flowRate;

	public ShipGridFluid(string type, float level, float flowRate) {
		this.type = type;
		this.level = level;
		this.flowRate = flowRate;
	}
}

public class ShipGridCell {
	public int n;
	public int x, y, z;
	public List<ShipGridCell> neighbors = new List<ShipGridCell>();
	public List<ShipGridItem> contents = new List<ShipGridItem>();
	//public List<ShipGridFluid> fluids = new List<ShipGridFluid>();
	public Dictionary<string, ShipGridFluid> fluids = new Dictionary<string, ShipGridFluid>();

	public ShipGridCell(int x, int y, int z) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public void AddItem(ShipGridItem item) {
		contents.Remove(item);
		contents.Add(item);
	}

	public void RemoveItem(ShipGridItem item) {
		contents.Remove(item);
	}

	public void AddFluid(string type, float amount, float flowRate) {
		ShipGridFluid fluid;
		fluids.TryGetValue(type, out fluid);
		if(fluid == null) {
			fluid = new ShipGridFluid(type, 0, 0);
			fluids.Add(type, fluid);
		}
		fluid.level += amount;
		fluid.flowRate = flowRate;
	}

	/*public void AddFluid(string type, float amount, float flowRate, float cutoff, List<ShipGridCell> filled) {
		ShipGridFluid fluid = fluids.Find(delegate(ShipGridFluid item) {
			return item.type == type;
		});
		if(fluid == null) {
			fluid = new ShipGridFluid(type, amount, flowRate);
			fluids.Add(fluid);
		}

		fluid.level += amount;
		filled.Add(this);

		if(amount > cutoff) {
			foreach(ShipGridCell neigh in neighbors) {
				if(!filled.Contains(neigh)) {
					neigh.AddFluid(type, amount * flowRate, flowRate, cutoff, filled);
				}
			}
		}
	}*/

	/*public static void AddFluid(string type, float amount, float flowRate, float cutoff, List<ShipGridCell> current, List<ShipGridCell> filled) {
		List<ShipGridCell> newCurrent = new List<ShipGridCell>();
		foreach(ShipGridCell cur in current) {
			ShipGridFluid fluid = cur.fluids.Find(delegate(ShipGridFluid item) {
				return item.type == type;
			});
			if(fluid == null) {
				fluid = new ShipGridFluid(type, amount, flowRate);
				cur.fluids.Add(fluid);
			}
			fluid.level += amount;
			filled.Add(cur);

			if(Mathf.Abs(amount) > cutoff) {
				foreach(ShipGridCell neigh in cur.neighbors) {
					if(!filled.Contains(neigh) && !newCurrent.Contains(neigh)) {
						newCurrent.Add(neigh);
					}
				}
			}
		}
		//Debug.Log(newCurrent.Count);
		if(newCurrent.Count > 0) {
			AddFluid(type, amount * flowRate, flowRate, cutoff, newCurrent, filled);
		}
	}*/

	public void Update(float dTime) {
		foreach(KeyValuePair<string, ShipGridFluid> item in fluids) {
			ShipGridFluid fluid = item.Value;
			float nCount = Mathf.Max(1, neighbors.Count);
			float change = fluid.level;
			fluid.level *= fluid.flowRate;
			change -= fluid.level;
			change *= 0.99f;
			foreach(ShipGridCell neigh in neighbors) {
				neigh.AddFluid(fluid.type, change/nCount, fluid.flowRate);
			}
		}
	}
}

public class ShipGrid : MonoBehaviour {
	public Vector3 cellSize = new Vector3(5, 5, 5);
	public int updateStepSize = 10;
	public Vector3 divs;
	public bool debugLines = false;
	Vector3 size = new Vector3(10, 10, 10);
	/*int divX;
	int divY;
	int divZ;*/
	List<Vector3> nDirs = new List<Vector3>();
	List<List<List<ShipGridCell>>> cells = new List<List<List<ShipGridCell>>>();

	public static List<string> fluids = new List<string>();

	/*public float width { get { return size * divX; } }
	public float height { get { return size * divY; } }
	public float depth { get { return size * divZ; } }*/

	private static ShipGrid m_instance;

	public static ShipGrid instance {
		get {
			if(m_instance != null) {
				return m_instance;
			}
			Debug.LogError("No ShipGrid in scene!");
			return null;
		}
	}

	void Awake() {
		m_instance = this;

		if(collider != null) {
			Bounds bounds = collider.bounds;
			/*width = bounds.size.x;
			height = bounds.size.y;
			depth = bounds.size.z;*/
			size = bounds.size;
		}

		/*cellSize.x = size.x / divs.x;
		cellSize.y = size.y / divs.y;
		cellSize.z = size.z / divs.z;*/

		divs.x = Mathf.Ceil(size.x / cellSize.x);
		divs.y = Mathf.Ceil(size.y / cellSize.y);
		divs.z = Mathf.Ceil(size.z / cellSize.z);

		size.x = divs.x * cellSize.x;
		size.y = divs.y * cellSize.y;
		size.z = divs.z * cellSize.z;

		int cellCount = 0;
		int i, j, k;
		for(i = 0; i < divs.x; i++) {
			List<List<ShipGridCell>> col = new List<List<ShipGridCell>>();
			cells.Add(col);
			for(j = 0; j < divs.y; j++) {
				List<ShipGridCell> row = new List<ShipGridCell>();
				col.Add(row);
				for(k = 0; k < divs.z; k++) {
					cellCount++;
					ShipGridCell cell = new ShipGridCell(i, j, k);
					cell.n = cellCount;
					row.Add(cell);
				}
			}
		}

		i = 0;
		j = 0;
		k = 0;
		List<ShipGridCell> neighbors = new List<ShipGridCell>();
		neighbors.Add(GetIndex(i, j, k));

		nDirs.Add(new Vector3(1, 0, 0));
		nDirs.Add(new Vector3(-1, 0, 0));
		nDirs.Add(new Vector3(0, 1, 0));
		nDirs.Add(new Vector3(0, -1, 0));
		nDirs.Add(new Vector3(0, 0, 1));
		nDirs.Add(new Vector3(0, 0, -1));

		RebuildLinks();
	}

	public static void RebuildLinksI() {
		if(m_instance != null) {
			m_instance.RebuildLinks();
		}
	}

	public void RebuildLinks() {
		List<Vector3> nDirs = new List<Vector3>();
		nDirs.Add(new Vector3(1, 0, 0));
		nDirs.Add(new Vector3(-1, 0, 0));
		nDirs.Add(new Vector3(0, 1, 0));
		nDirs.Add(new Vector3(0, -1, 0));
		nDirs.Add(new Vector3(0, 0, 1));
		nDirs.Add(new Vector3(0, 0, -1));
		int i, j, k;
		for(i = 0; i < divs.x; i++) {
			for(j = 0; j < divs.y; j++) {
				for(k = 0; k < divs.z; k++) {
					ShipGridCell cur = GetIndex(i, j, k);
					if(cur != null) {
						Vector3 curPos = IndexToPos(i, j, k);// +cellSize / 2.0f;
						RaycastHit hit;
						foreach(Vector3 nDir in nDirs) {
							Vector3 step = new Vector3(cellSize.x * nDir.x, cellSize.y * nDir.y, cellSize.z * nDir.z);
							//print(step.magnitude);
							if(!Physics.Raycast(curPos, nDir, out hit, step.magnitude)) {
								ShipGridCell neigh = GetIndex(i + (int)nDir.x, j + (int)nDir.y, k + (int)nDir.z);
								if(neigh != null) {
									if(!cur.neighbors.Contains(neigh)) {
										cur.neighbors.Add(neigh);
										//neigh.neighbors.Add(cur);
										//neighbors.Add(neigh);
									}
								}
							}
						}
					}
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

	public static Vector3 IndexToPosI(Vector3 index) {
		return IndexToPosI((int)index.x, (int)index.x, (int)index.z);
	}

	public static Vector3 IndexToPosI(int x, int y, int z) {
		return instance.IndexToPos(x, y, z);
	}

	public Vector3 IndexToPos(Vector3 index) {
		return IndexToPos((int)index.x, (int)index.y, (int)index.z);
	}

	public Vector3 IndexToPos(int x, int y, int z) {
		float xpos = Mathf.Max(0, Mathf.Min(divs.x - 1, x));
		float ypos = Mathf.Max(0, Mathf.Min(divs.y - 1, y));
		float zpos = Mathf.Max(0, Mathf.Min(divs.z - 1, z));

		xpos = (xpos * cellSize.x) - size.x / 2;
		ypos = (ypos * cellSize.y) - size.y / 2;
		zpos = (zpos * cellSize.z) - size.z / 2;
		return new Vector3(xpos, ypos, zpos) + collider.bounds.center + cellSize/2;
	}

	public static Vector3 PosToIndexI(Vector3 pos) {
		return PosToIndexI(pos.x, pos.y, pos.z);
	}

	public static Vector3 PosToIndexI(float xpos, float ypos, float zpos) {
		return instance.PosToIndex(xpos, ypos, zpos);
	}

	public Vector3 PosToIndex(Vector3 pos) {
		return PosToIndex(pos.x, pos.y, pos.z);
	}

	public Vector3 PosToIndex(float xpos, float ypos, float zpos) {
		xpos -= collider.bounds.center.x;
		ypos -= collider.bounds.center.y;
		zpos -= collider.bounds.center.z;
		int x = Mathf.FloorToInt((xpos + size.x / 2) / cellSize.x);
		int y = Mathf.FloorToInt((ypos + size.y / 2) / cellSize.y);
		int z = Mathf.FloorToInt((zpos + size.z / 2) / cellSize.z);
		x = (int)Mathf.Max(0, Mathf.Min(divs.x - 1, x));
		y = (int)Mathf.Max(0, Mathf.Min(divs.y - 1, y));
		z = (int)Mathf.Max(0, Mathf.Min(divs.z - 1, z));
		return new Vector3(x, y, z);
	}

	public static ShipGridCell GetIndexI(Vector3 index) {
		return GetIndexI((int)index.x, (int)index.y, (int)index.z);
	}

	public static ShipGridCell GetIndexI(int x, int y, int z) {
		return instance.GetIndex(x, y, z);
	}

	public ShipGridCell GetIndex(Vector3 index) {
		return GetIndex((int)index.x, (int)index.y, (int)index.z);
	}

	public ShipGridCell GetIndex(int x, int y, int z) {
		if(x < 0 || x >= divs.x || y < 0 || y >= divs.y || z < 0 || z >= divs.z) {
			return null;
		}
		return cells[x][y][z];
	}

	public static ShipGridCell GetPosI(Vector3 pos) {
		return GetPosI(pos.x, pos.y, pos.z);
	}

	public static ShipGridCell GetPosI(float x, float y, float z) {
		return instance.GetPos(x, y, z);
	}

	public ShipGridCell GetPos(Vector3 pos) {
		return GetPos(pos.x, pos.y, pos.z);
	}

	public ShipGridCell GetPos(float xpos, float ypos, float zpos) {
		xpos -= collider.bounds.center.x;
		ypos -= collider.bounds.center.y;
		zpos -= collider.bounds.center.z;
		int x = Mathf.FloorToInt((xpos + size.x / 2) / cellSize.x);
		int y = Mathf.FloorToInt((ypos + size.y / 2) / cellSize.y);
		int z = Mathf.FloorToInt((zpos + size.z/ 2) / cellSize.z);
		x = (int)Mathf.Max(0, Mathf.Min(divs.x - 1, x));
		y = (int)Mathf.Max(0, Mathf.Min(divs.y - 1, y));
		z = (int)Mathf.Max(0, Mathf.Min(divs.z - 1, z));
		return cells[x][y][z];
	}

	public static void AddFluidI(Vector3 pos, string type, float amount, float flowRate, float cutoff) {
		AddFluidI(pos.x, pos.y, pos.z, type, amount, flowRate, cutoff);
	}

	public static void AddFluidI(float x, float y, float z, string type, float amount, float flowRate, float cutoff) {
		instance.AddFluid(x, y, z, type, amount, flowRate, cutoff);
	}

	public void AddFluid(Vector3 pos, string type, float amount, float flowRate, float cutoff) {
		AddFluid(pos.x, pos.y, pos.z, type, amount, flowRate, cutoff);
	}

	public void AddFluid(float x, float y, float z, string type, float amount, float flowRate, float cutoff) {
		ShipGridCell cur = GetPos(x, y, z);
		cur.AddFluid(type, amount, flowRate);

		if(!fluids.Contains(type)) {
			fluids.Add(type);
		}
		/*List<ShipGridCell> current = new List<ShipGridCell>();
		current.Add(cur);*/
		//ShipGridCell.AddFluid(type, amount, flowRate, cutoff, current, new List<ShipGridCell>());
	}

	int startIndex = 0;
	int stepSize = 4;
	void Update() {
		int i, j, k;
		for(i = 0; i < divs.x; i += 1) {
			for(j = 0; j < divs.y; j += 1) {
				for(k = startIndex; k < divs.z; k += updateStepSize) {
					ShipGridCell cur = GetIndex(i, j, k);
					if(cur != null) {
						cur.Update(Time.deltaTime);
						if(debugLines) {
							Vector3 curPos = IndexToPos(i, j, k);

							float level = 1.0f;
							foreach(KeyValuePair<string, ShipGridFluid> item in cur.fluids) {
								ShipGridFluid fluid = item.Value;
								Debug.DrawLine(curPos + transform.forward * 0.1f, curPos + transform.forward * 0.1f + transform.up * fluid.level, Color.red, 0, true);
								level = fluid.level;
							}

							//Debug.DrawLine(curPos, curPos+transform.up);
							foreach(ShipGridCell neigh in cur.neighbors) {
								//print(neigh.n);
								Vector3 nPos = IndexToPos(neigh.x, neigh.y, neigh.z);
								Debug.DrawLine(curPos, curPos + (nPos - curPos).normalized * 0.5f * level, Color.white, 0, true);
							}
						}
					}
				}
			}
		}

		startIndex = (startIndex + 1) % updateStepSize;

		/*List<Vector3> nDirs = new List<Vector3>();
		nDirs.Add(new Vector3(1, 0, 0));
		nDirs.Add(new Vector3(-1, 0, 0));
		nDirs.Add(new Vector3(0, 1, 0));
		nDirs.Add(new Vector3(0, -1, 0));
		nDirs.Add(new Vector3(0, 0, 1));
		nDirs.Add(new Vector3(0, 0, -1));
		for(i = 0; i < divs.x; i++) {
			for(j = 0; j < divs.y; j++) {
				for(k = 0; k < divs.z; k++) {
					ShipGridCell cur = GetIndex(i, j, k);
					cur.neighbors.Clear();
					if(cur != null) {
						Vector3 curPos = IndexToPos(i, j, k) + cellSize / 2.0f;
						RaycastHit hit;
						foreach(Vector3 nDir in nDirs) {
							Vector3 step = new Vector3(cellSize.x * nDir.x, cellSize.y * nDir.y, cellSize.z * nDir.z);
							//print(step.magnitude);
							//Debug.DrawLine(curPos, curPos + nDir * step.magnitude);
							if(!Physics.Raycast(curPos, nDir, out hit, step.magnitude)) {
								ShipGridCell neigh = GetIndex(i + (int)nDir.x, j + (int)nDir.y, k + (int)nDir.z);
								if(neigh != null) {
									if(!cur.neighbors.Contains(neigh)) {
										cur.neighbors.Add(neigh);
										//Debug.DrawLine(curPos, curPos + nDir*0.5f);
										//neigh.neighbors.Add(cur);
										//neighbors.Add(neigh);
									}
								}
							}
						}

						foreach(ShipGridCell neigh in cur.neighbors) {
							//print(neigh.n);
							Vector3 nPos = IndexToPos(neigh.x, neigh.y, neigh.z) + cellSize / 2.0f;
							//Debug.DrawLine(curPos, nPos);
						}
					}
				}
			}
		}*/
	}
}
