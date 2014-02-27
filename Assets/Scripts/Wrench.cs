using UnityEngine;
using System.Collections;

[AddComponentMenu("Tools/Wrench")]
public class Wrench : EquipableObject {

	public float repairStrength;

	// Use this for initialization
	public override void Start() {

	}

	// Update is called once per frame
	public override void Update() {

	}

	public override void Action() {
		RaycastHit raycastHit;
		Ray ray = Camera.main.ScreenPointToRay(new Vector2(Screen.width / 2, Screen.height / 2));
		if(Physics.Raycast(ray, out raycastHit)) {
			Collider collider = raycastHit.collider;
			ShipSystem system = collider.gameObject.GetComponent<ShipSystem>();
			if(system != null) {
				system.Repair(repairStrength);
			}
		}
	}

	public override void Equip(Transform Tran) {
		throw new System.NotImplementedException();
	}
}
