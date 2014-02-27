using UnityEngine;
using System.Collections;

public class EmergencyCabinet : MonoBehaviour {
	public float maskCoolDown = 60f;
	public float extinguisherCoolDown = 60f;

	PartAcceptor maskAcceptor;
	PartAcceptor extinguisherAcceptor;
	public GameObject mask;
	public GameObject extinguisher;

	private bool maskRefilled = false;
	private bool extinguisherRefilled = false;

	// Use this for initialization
	void Start () {
		maskAcceptor = transform.FindChild("Mask Acceptor").GetComponent<PartAcceptor>();
		extinguisherAcceptor = transform.FindChild("Extinguisher Acceptor").GetComponent<PartAcceptor>();
		Instantiate(mask, maskAcceptor.transform.position, mask.transform.rotation);
		Instantiate(extinguisher, extinguisherAcceptor.transform.position, extinguisher.transform.rotation);
	}
	
	// Update is called once per frame
	void Update () {
		//Mask stuff
		if(maskAcceptor.heldPart != null) {
			mask = maskAcceptor.heldPart;
			if(mask.tag == "carry"){
				StartCoroutine("RefillMask");
			}
		}

		//Extinguisher stuff
		if(extinguisherAcceptor.heldPart != null) {
			extinguisher = extinguisherAcceptor.heldPart;
			if(extinguisher.GetComponent<FireExtinguisher>().ammo < extinguisher.GetComponent<FireExtinguisher>().maxAmmo){
				StartCoroutine("RefillExtinguisher");
			}
		}
	}

	IEnumerator RefillMask() {
		mask.tag = "equip";
		maskAcceptor.lockPart = true;
		mask.GetComponent<CarryableObject>().isLocked = true;

		yield return new WaitForSeconds(maskCoolDown);
		maskAcceptor.lockPart = false;
		mask.GetComponent<CarryableObject>().isLocked = false;
	}

	IEnumerator RefillExtinguisher() {
		extinguisher.GetComponent<FireExtinguisher>().ammo = extinguisher.GetComponent<FireExtinguisher>().maxAmmo;
		extinguisherAcceptor.lockPart = true;
		extinguisher.GetComponent<CarryableObject>().isLocked = true;

		yield return new WaitForSeconds(extinguisherCoolDown);
		extinguisherAcceptor.lockPart = false;
		extinguisher.GetComponent<CarryableObject>().isLocked = false;
	}
}
