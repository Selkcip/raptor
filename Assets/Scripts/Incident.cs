using System;
using System.Collections;
using System.Linq;
using System.Text;
using UnityEngine;

//TODO: Add puzzleCompleted Events that will send messages including target system.

public abstract class Incident : MonoBehaviour {
    public bool isSolved, isFailed;
	public Room room;

	public float threshold;
	private float damage;

	public void Damage(float value) {
		damage += value;
		if(damage >= threshold) {
			Activate();
		}
	}

	public abstract void Activate();

    // Update is called once per frame
	public virtual void Update() { }

    // Resets the puzzle
    public abstract void Reset();
}
