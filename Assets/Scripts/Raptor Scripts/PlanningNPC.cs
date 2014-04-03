using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(NavMeshAgent))]
[RequireComponent(typeof(ThirdPersonCharacter))]
public class PlanningNPC : MonoBehaviour {

	public NavMeshAgent agent { get; private set; }                 // the navmesh agent required for the path finding
	public ThirdPersonCharacter character { get; private set; }     // the character we are controlling
	public Transform target;										// target to aim for
	public float targetChangeTolerance = 1;				            // distance to target before target can be changed

	Vector3 targetPos;

	public bool knockedOut = false;
	private bool ragDoll = false;

	Planner planner = new Planner();
	List<PlanAction> plan = new List<PlanAction>();
	List<PlanState> goals = new List<PlanState>();
	PlanState goal;
	public string actionName = "no action";
	public bool hasTarget = false;
	public bool atTarget = false;
	public bool standing = false;

	// Use this for initialization
	void Start() {

		// get the components on the object we need ( should not be null due to require component so no need to check )
		agent = GetComponentInChildren<NavMeshAgent>();
		character = GetComponent<ThirdPersonCharacter>();

		agent.updatePosition = false;
		agent.updateRotation = false;

		goals.Add(new PlanState(1) {
			{"atTarget", true}
		});

		goals.Add(new PlanState() {
			{"standing", true}
		});

		goals.Sort(delegate(PlanState a, PlanState b) {
			return b.priority - a.priority;
		});


		PlanAction stand = new PlanAction(new PlanState() { { "standing", false } }, new PlanState() { { "standing", true } }, delegate() {
			character.Move(Vector3.zero, false, false, transform.position + transform.forward * 100);
			if(!character.moving){
				standing = true;
			}
			return false;
		});
		stand.name = "stand";
		planner.Add(stand);

		PlanAction followTarget = new PlanAction(new PlanState() { { "atTarget", false } }, new PlanState() { { "atTarget", true } }, delegate() {
			//character.Move(transform.forward, false, false, transform.position + transform.forward * 100);
			// update the progress if the character has made it to the previous target
			if((target.position - targetPos).magnitude > targetChangeTolerance) {
				targetPos = target.position;
				agent.SetDestination(targetPos);
			}

			// update the agents posiiton 
			agent.transform.position = transform.position;

			// use the values to move the character
			character.Move(agent.desiredVelocity, false, false, targetPos);
			standing = false;

			return false;
		});
		followTarget.name = "followTarget";
		planner.Add(followTarget);

		RagDoll(transform, false);
	}

	// Update is called once per frame
	void Update() {

		if(plan.Count > 0) {
			PlanAction action = plan[0];
			//print("Acting: " + action.name);
			actionName = action.name;
			action.Update();
			if(goal.Diff(goal.Extract(this)) <= 0) {
				print("action complete");
				plan.Remove(action);
			}
		}
		else {
			//print("Planning");
			foreach(PlanState state in goals) {
				//print(this);
				plan = planner.Plan(this, state);
				if(plan.Count > 0) {
					goal = state;
					break;
				}
			}
		}

		hasTarget = target != null;
		atTarget = (target.position - transform.position).magnitude < targetChangeTolerance;

		/*if(target != null) {

			// update the progress if the character has made it to the previous target
			if((target.position - targetPos).magnitude > targetChangeTolerance) {
				targetPos = target.position;
				agent.SetDestination(targetPos);
			}

			// update the agents posiiton 
			agent.transform.position = transform.position;

			// use the values to move the character
			character.Move(agent.desiredVelocity, false, false, targetPos);

		}
		else {

			// We still need to call the character's move function, but we send zeroed input as the move param.
			character.Move(Vector3.zero, false, false, transform.position + transform.forward * 100);

		}*/
	}

	public void SetTarget(Transform target) {
		this.target = target;
	}

	void RagDoll(Transform obj, bool on) {
		Transform[] children = transform.GetAllComponentsInChildren<Transform>();
		foreach(Transform child in children) {
			if(child.name == "Gun") {
				continue;
			}

			child.tag = "enemy";
			if(child.rigidbody != null) {
				child.rigidbody.isKinematic = !on;

				if(on) {
					//This is wrong I think. This should be based off the player's direction and point of impact
					child.rigidbody.AddForce(Camera.main.transform.forward * 5f, ForceMode.Impulse);
				}
			}

			if(child.collider != null) {
				child.collider.enabled = on;
			}
			//RagDoll(child, on);
		}
		ragDoll = on;
		RagdollHelper helper = GetComponent<RagdollHelper>();
		helper.ragdolled = on;
		rigidbody.isKinematic = on;
		collider.enabled = !on;
	}
}
