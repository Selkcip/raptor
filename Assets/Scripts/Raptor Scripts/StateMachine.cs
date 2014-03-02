using UnityEngine;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public delegate bool StateCondition();
public delegate bool StateUpdate();

public class State {
	public int priority;
	public StateCondition Condition;
	public StateUpdate Update;
	public List<State> states;

	public State(StateCondition condition, StateUpdate update, int priority = 0) {
		Condition = condition;
		Update = update;
		this.priority = priority;
		states = new List<State>();
	}

	public void Add(State state) {
		states.Remove(state);
		states.Add(state);
	}

	public void Remove(State state) {
		states.Remove(state);
	}
}

public class StateMachine {
	List<State> states;

	public StateMachine() {
		states = new List<State>();
	}

	public void Add(State state) {
		states.Remove(state);
		states.Add(state);
	}

	public void Remove(State state) {
		states.Remove(state);
	}

	public void Update() {
		if(states.Count > 0) {
			State cur = states[states.Count-1];

			cur.states.Sort(delegate(State a, State b) {
				return a.priority - b.priority;
			});

			foreach(State state in cur.states) {
				if(state.Condition()) {
					states.Add(state);
				}
			}

			cur = states[states.Count - 1];
			if(cur.Update()) {
				states.Remove(cur);
			}
		}
	}
}
