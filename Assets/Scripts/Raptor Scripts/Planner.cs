using UnityEngine;
using System;
using System.Collections;
using System.Linq;
using System.Text;
using System.Collections.Generic;
using System.Reflection;

/*public class PlanState {
	public Dictionary<string, object> conditions;

	public PlanState() {
		conditions = new Dictionary<string, object>();
	}
}*/
public class PlanState : Dictionary<string, object> {
	public int priority = 0;
	public string name;

	public PlanState(int priority = 0, string name = "state") {
		this.priority = priority;
		this.name = name;
	}

	public PlanState Extract(object planee) {
		PlanState state = new PlanState();

		foreach(KeyValuePair<string, object> condition in this) {
			//Debug.Log(condition.Key + ": " + condition.Value);
			FieldInfo info = planee.GetType().GetField(condition.Key);
			if(info != null) {
				object value = info.GetValue(planee);
				//Debug.Log(value);
				state.Add(condition.Key, value);
			}
		}

		return state;
	}

	public int Diff(PlanState current) {
		int diff = 0;
		foreach(KeyValuePair<string, object> condition in this) {
			//Debug.Log(condition.Key + ": " + condition.Value);
			object value;
			current.TryGetValue(condition.Key, out value);
			if(condition.Value != null) {
				if(value != null) {
					//Debug.Log(value);
					if(!condition.Value.Equals(value)) {//condition.Value.GetType().Equals(value.GetType())
						//Debug.Log(condition.Key + ": " + condition.Value + "!=" + value);
						diff++;
					}
				}
				else {
					diff++;
				}
			}
			else {
				if(value != null) {
					//Debug.Log(condition.Key + ": " + value.GetType());
					diff++;
				}
			}
			
		}

		return diff;
	}

	public PlanState Transform(PlanState current) {
		PlanState state = (PlanState)current.MemberwiseClone();
		//state.Concat<KeyValuePair<string, object>>(current);

		foreach(KeyValuePair<string, object> condition in this) {
			state[condition.Key] = condition.Value;
		}

		return state;
	}

	public string ToString() {
		string value = "";

		foreach(KeyValuePair<string, object> condition in this){
			value += "{ " + condition.Key + ": " + condition.Value + " } ";
		}

		return value;
	}
}


public class PlanAction {
	public PlanState input;
	public PlanState output;
	public StateUpdate Update;
	public string name = "action";

	public PlanAction(PlanState input, PlanState output, StateUpdate update) {
		this.input = input;
		this.output = output;
		this.Update = update;
	}
}

public class PlanListItem {
	public PlanState state;
	public PlanAction action;
	public int cost;
	public PlanListItem parent;

	public PlanListItem(PlanState state, PlanAction action, int cost, PlanListItem parent = null) {
		this.state = state;
		this.action = action;
		this.cost = cost;
		this.parent = parent;
	}
}

public class Planner {
	List<PlanAction> actions;
	public int maxPlanSteps = 100;

	public Planner() {
		actions = new List<PlanAction>();
	}

	public void Add(PlanAction action) {
		actions.Remove(action);
		actions.Add(action);
	}

	public void Remove(PlanAction action) {
		actions.Remove(action);
	}

	public List<PlanAction> Plan(object planee, PlanState target) {
		List<PlanListItem> open = new List<PlanListItem>();
		List<PlanAction> closed = new List<PlanAction>();

		PlanState current = target.Extract(planee);
		PlanListItem first = new PlanListItem(current, null, target.Diff(current));
		open.Add(first);
		//Debug.Log("internal diff: "+first.cost);

		for(int c = 0; open.Count > 0; c++) {
			open.Sort(delegate(PlanListItem a, PlanListItem b) {
				return b.cost - a.cost;
			});
			first = open[0];
			open.Remove(first);
			current = first.state;
			//Debug.Log("current length" + current.Count);

			//Debug.Log("action count: " + actions.Count);
			foreach(PlanAction action in actions) {
				//if(action != first.action && (first.parent != null ? action != first.parent.action : true) && action.input.Diff(current) <= 0) {
				//Debug.Log(action.input.Diff(current));
				PlanState temp = current.Transform(action.input.Extract(planee));
				//Debug.Log("current: "+current.ToString()+" input: " + action.input.ToString() + " state: " + temp.ToString());
				if(action != first.action && action.input.Diff(temp) <= 0) {
					if(!closed.Contains(action)) {
						temp = action.output.Transform(temp);
						//Debug.Log(action.output.ToString());
						//Debug.Log((first.action != null ? first.action.name : "null")+" > "+action.name+" "+temp.ToString());
						open.Add(new PlanListItem(temp, action, first.cost + target.Diff(action.output), first));
					}
				}
			}

			if(target.Diff(current) <= 0) {
				//Debug.Log(current.ToString());
				break;
			}
			else {
				if(open.Count <= 0) {
					first.action = null;
				}
			}

			closed.Add(first.action);

			if(c > maxPlanSteps) {
				Debug.Log("AI thought too long, bailing out.");
				break;
			}
		}

		List<PlanAction> plan = new List<PlanAction>();

		while(first.action != null){// && first.parent.action != null) {
			//Debug.Log(first.action.name);
			plan.Insert(0, first.action);
			first = first.parent;
		}

		return plan;// first.action;
	}

	/*public static PlanState GetState(object planee, PlanState target) {
		PlanState state = new PlanState();

		foreach(KeyValuePair<string, object> condition in target) {
			//Debug.Log(condition.Key + ": " + condition.Value);
			object value = planee.GetType().GetField(condition.Key);
			if(value != null) {
				//Debug.Log(condition.Key + ": " + value);
				state.Add(condition.Key, value);
			}
		}

		return state;
	}

	public static int StateDiff(PlanState current, PlanState target, bool ignoreNull = false) {
		int diff = 0;
		foreach(KeyValuePair<string, object> condition in current) {
			object value;
			target.TryGetValue(condition.Key, out value);
			if(value != null && condition.Value.GetType().Equals(value.GetType())) {
				if(!condition.Value.Equals(value)) {
					Debug.Log(condition.Key + ": " + value);
					diff++;
				}
			}
			else {
				if(!ignoreNull) {
					diff++;
				}
			}
		}

		return diff;
	}*/

	public void Update() {
		
	}
}
