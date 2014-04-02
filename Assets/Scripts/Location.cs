using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class Location {
    public enum EncounterType { normal, dangerous };

	public enum LocationType { gas, solar, blackhole, asteroid }

	public string name = "Unidentified Location";
	public List<Location> neighbors;
    public EncounterType encounterType;
    //public Encounter encounter;
	public Vector3 point;

	public bool start = false;
	public bool end = false;

	//path stuff
	public bool reachable = false;
	public float distance;
	public Location previous;

	public LocationType locationType;

	public GameObject marker;

	public Location(Vector3 randomPoint) {
		point = randomPoint;// != null ? randomPoint : Vector3.zero;
		neighbors = new List<Location>();
		encounterType = EncounterType.normal;
		locationType = (LocationType)UnityEngine.Random.Range(0, Enum.GetNames(typeof(LocationType)).Length);
		//encounter = null;
	}

	public Location() {
		new Location(Vector3.zero);
	}
}
