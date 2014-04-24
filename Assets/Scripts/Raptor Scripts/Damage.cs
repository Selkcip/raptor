using UnityEngine;
using System;
using System.Collections;
using System.Linq;
using System.Text;
using System.Collections.Generic;
using System.Reflection;

public class Damage {
	public float amount;
	public Vector3 pos;

	public Damage(float amount, Vector3 pos) {
		this.amount = amount;
		this.pos = pos;
	}
}