using UnityEngine;
using System.Collections;

public abstract class EquipableObject : MonoBehaviour {

	public string partName;

	// Use this for initialization
	public virtual void Start () {
	
	}
	
	// Update is called once per frame
	public abstract void Update ();	

	public abstract void Action();

	public virtual void StopAction(){}

	public virtual void DropTool(){}

	public abstract void Equip(Transform Tran);

}
