using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Pressureable : MonoBehaviour {
	protected ShipGridCell cell;

	void Start() {
		//cell = ShipGrid.GetPosI(transform.position);
	}

	public void Update() {
		if(rigidbody != null) {
			Vector3 force = new Vector3();
			ShipGridFluid pressure;
			float pLevel = 0;
			ShipGridCell cell = ShipGrid.GetPosI(transform.position);
			cell.fluids.TryGetValue("pressure", out pressure);
			if(pressure != null) {
				pLevel = pressure.level;
			}
			Vector3 diff = new Vector3();
			foreach(ShipGridCell neigh in cell.neighbors) {
				neigh.fluids.TryGetValue("pressure", out pressure);
				if(pressure != null) {
					diff.x = neigh.x - cell.x;
					diff.y = neigh.y - cell.y;
					diff.z = neigh.z - cell.z;
					force += (diff * (pLevel - pressure.level)).normalized*Mathf.Abs(pressure.level);
				}
			}

			if(force.magnitude > 0) {
				transform.SendMessageUpwards("KnockOut", 20, SendMessageOptions.DontRequireReceiver);
			}

			rigidbody.AddForce(force);
		}
	}
}