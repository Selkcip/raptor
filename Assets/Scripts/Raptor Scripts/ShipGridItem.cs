using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class ShipGridItem : MonoBehaviour {
	public float interestLevel = 15;
	public bool carryable = false;
	public Transform useTarget;

	protected ShipGridCell cell;

	void Start() {
		//cell = ShipGrid.GetPosI(transform.position);
	}

	public void Update() {
		ShipGridCell newCell = ShipGrid.GetPosI(transform.position);
		if(newCell != null && newCell != cell) {
			cell = newCell;
			cell.AddItem(this);
		}
	}
}