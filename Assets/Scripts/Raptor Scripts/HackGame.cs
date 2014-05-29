using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class HackGame : MonoBehaviour {
	public float moveTime = 1;
	public int tileCount = 8;
	public float zOffset = 1;
	public HackGameTile tile;
	public UISlider progressBar;
	public UILabel alarmLabel;
	public LocationMap map;
	public MapOpenTrigger mapTrigger;
	public GameObject terminal;
	public List<Texture2D> textures = new List<Texture2D>();

	public float mapAvailable = 1;
	public float maxTileValue = 0.25f;
	public float mapPerLevel = 0;
	public float notorietyToLock = 10000;

	float hackDis = -2.0f;

	public float tileSize = 0;
	public Vector3 offset;
	List<List<int>> spaces = new List<List<int>>();
	List<List<HackGameTile>> tiles = new List<List<HackGameTile>>();
	List<HackGameTile> movingTiles = new List<HackGameTile>();
	bool madeMove = false;

	float initAmount;

	bool hacking = false;
	bool hackable = true;
	FirstPersonCharacter fpc;

	// Use this for initialization
	void Start () {
		//renderer.enabled = false;

		tileSize = 1f / tileCount;
		offset = -Vector3.one/2;
		offset.x += tileSize / 2;
		offset.y += tileSize / 2;
		offset.z = -zOffset;

		mapPerLevel = maxTileValue / Mathf.Pow(11, 3);

		initAmount = mapAvailable;

		for(int x = 0; x < tileCount; x++) {
			spaces.Add(new List<int>());
			tiles.Add(new List<HackGameTile>());
			for(int y = 0; y < tileCount; y++) {
				spaces[x].Add(0);
				tiles[x].Add(null);
			}
		}

		if(RaptorInteraction.notoriety >= notorietyToLock) {
			hackable = false;
		}
		else {
			AddTiles();
		}
	}

	public void Use(GameObject user) {
		fpc = user.GetComponent<FirstPersonCharacter>();
		if(fpc != null) {
			if(hackable && !hacking) {
				hacking = true;
				fpc.enabled = false;
				user.rigidbody.velocity *= 0;
			}
			else {
				StopHacking();
			}
		}
	}

	void StopHacking() {
		hacking = false;
		if(fpc != null) {
			fpc.enabled = true;
		}
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
				HackGameTile newTile = (HackGameTile)Instantiate(tile, Vector3.zero, Quaternion.identity);
				newTile.gameObject.SetActive(true);
				tiles[(int)space.x][(int)space.y] = newTile;
				newTile.transform.parent = transform;
				newTile.value = Random.Range(0, 2);
				newTile.transform.localPosition = offset + space * tileSize;
				newTile.transform.localEulerAngles = Vector3.zero;
				newTile.pos = newTile.transform.localPosition;
				newTile.transform.localScale = new Vector3(tileSize, tileSize, tileSize);
				newTile.renderer.material.mainTexture = textures[newTile.value];

				if(empties.Count <= 1) {
					bool canMove = false;
					for(int x = 0; x < tileCount; x++) {
						for(int y = 0; y < tileCount; y++) {
							HackGameTile curTile = tiles[x][y];
							if(curTile == null) {
								canMove = true;
							}
							else {
								int nx = x + 1;
								int ny = y;
								if(nx >= 0 && nx <= tileCount - 1 && ny >= 0 && ny <= tileCount - 1) {
									canMove = tiles[nx][ny].value == curTile.value ? true : canMove;
								}
								nx = x - 1;
								ny = y;
								if(nx >= 0 && nx <= tileCount - 1 && ny >= 0 && ny <= tileCount - 1) {
									canMove = tiles[nx][ny].value == curTile.value ? true : canMove;
								}
								nx = x;
								ny = y + 1;
								if(nx >= 0 && nx <= tileCount - 1 && ny >= 0 && ny <= tileCount - 1) {
									canMove = tiles[nx][ny].value == curTile.value ? true : canMove;
								}
								nx = x;
								ny = y - 1;
								if(nx >= 0 && nx <= tileCount - 1 && ny >= 0 && ny <= tileCount - 1) {
									canMove = tiles[nx][ny].value == curTile.value ? true : canMove;
								}
							}
						}
					}

					if(!canMove) {
						print("no moves left");
						Alarm.ActivateAlarms();
						RaptorInteraction.notoriety += Notoriety.hack;
					}
				}
			}
		}
		else {
			Alarm.ActivateAlarms();
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
		hackable = (Alarm.activated || mapAvailable <=0) ? false : hackable;

		progressBar.value = mapAvailable / initAmount;
		alarmLabel.enabled = !hackable;
		if(!hackable) {
			if(map != null){
				map.open = false;
				map.light.color = Color.red;
			}
			if(mapTrigger != null) {
				mapTrigger.collider.enabled = false;
			}
			if(terminal != null) {
				terminal.renderer.materials[1].color = Color.red;
			}
		}
		/*for(int x = 0; x < tileCount; x++) {
			for(int y = 0; y < tileCount; y++) {
				if(tiles[x][y] != null) {
					Debug.DrawRay(transform.TransformPoint(offset + new Vector3(x * tileSize, y * tileSize, -1)), transform.right);
				}
			}
		}*/

		if(fpc != null && hacking) {
			Vector3 hackPos = transform.TransformPoint(0, 0, hackDis);
			hackPos.y = fpc.transform.position.y;
			if((hackPos - fpc.transform.position).magnitude > 0.25f) {
				fpc.transform.position = Vector3.Lerp(fpc.transform.position, hackPos, 0.1f * Time.timeScale);
			}
		}

		if(movingTiles.Count > 0) {
			//print("moving tiles");
			for(int i = 0; i < movingTiles.Count; i++) {
				HackGameTile cur = movingTiles[i];
				//cur.renderer.material.color = Color.red;
				//print("moving tile");
				Vector3 diff = cur.pos - cur.transform.localPosition;
				if(diff.magnitude > 0.05f) {
					cur.transform.localPosition += diff * (moveTime > 0 ? Time.deltaTime / moveTime : 0);
				}
				else {
					//cur.renderer.material.color = Color.green;
					cur.transform.localPosition = cur.pos;
					movingTiles[i] = null;
					if(cur.mergeTarget != null && cur.mergeTarget != cur) {
						HackGameTile target = cur.mergeTarget;
						target.Merge(cur);
						float mapValue = Mathf.Min(mapAvailable, Mathf.Pow(target.value / 11f, 4) * initAmount);
						mapAvailable -= mapValue;
						RaptorInteraction.mapAmountAcquired += mapValue;
						target.renderer.material.mainTexture = textures[target.value];
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
			if(hacking) {
				if(!hackable || RebindableInput.GetKeyDown("Jump")) {
					StopHacking();
				}
				else {
					float v = RebindableInput.GetAxis("Vertical");
					float h = RebindableInput.GetAxis("Horizontal");

					if(!madeMove) {
						if(h > 0) {
							MoveRight();
						}
						else if(h < 0) {
							MoveLeft();
						}
						else if(v > 0) {
							MoveUp();
						}
						else if(v < 0) {
							MoveDown();
						}
					}

					madeMove = Mathf.Abs(v + h) > 0;
				}
			}
		}
	}
}
