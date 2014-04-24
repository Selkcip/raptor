using UnityEngine;
using System.Collections;

public class FluidMeter : MonoBehaviour {
	public string fluidName = "light";
	public float fluidLevel = 0;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		ShipGridCell cell = ShipGrid.GetPosI(transform.position);

		//Listen for noise
		ShipGridFluid fluid;
		cell.fluids.TryGetValue(fluidName, out fluid);
		if(fluid != null) {
			fluidLevel = fluid.level;
		}
	}
}
