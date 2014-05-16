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
	public StateUpdate Enter;
	public StateUpdate Exit;
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

	State cur;
	public void Update() {
		if(states.Count > 0) {
			states.Sort(delegate(State a, State b) {
				return b.priority - a.priority;
			});

			foreach(State state in states) {
				if(state == cur || state.Condition()) {
					if(state != cur){
						if(cur != null && cur.Exit != null) {
							cur.Exit();
						}
						if(state.Enter != null) {
							state.Enter();
						}
					}
					cur = state;
					break;
				}
			}

			if(cur != null) {
				if(cur.Update()) {
					cur = null;
				}
			}

			/*State cur = states[states.Count-1];

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
			}*/
		}
	}
}
