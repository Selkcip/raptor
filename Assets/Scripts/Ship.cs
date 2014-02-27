using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Ship : MonoBehaviour {
	public static Ship s_instance = null;

	public ShipSystem[] shipSystems;
	public List<Room> rooms = new List<Room>();
	
	public float health;

	public static Ship instance { 
		get {
			if(s_instance == null)
				Debug.LogError("Ship instance not found.");
			return s_instance;
		}
	}

	void Awake() {
		s_instance = this;
	}

	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
