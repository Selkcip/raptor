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
	public int count = 0;
	public int planSteps = 1;
	public float walkTime = 0;
	public bool doneWalking = false;
	PlanState targetState;

	// Use this for initialization
	void Start() {

		// get the components on the object we need ( should not be null due to require component so no need to check )
		agent = GetComponentInChildren<NavMeshAgent>();
		character = GetComponent<ThirdPersonCharacter>();

		targetState = new PlanState() {
			{"doneWalking", true}
		};

		PlanAction walk = new PlanAction(new PlanState() { {"doneWalking", false} }, new PlanState() { { "doneWalking", true } }, delegate() {
			character.Move(transform.forward, false, false, transform.position + transform.forward * 100);
			walkTime += Time.deltaTime;
			if(walkTime >= 5) {
				doneWalking = true;
				//targetState["doneWalking"] = false;
			}
			return true;
		});
		walk.name = "walk";
		planner.Add(walk);

		PlanAction walkBack = new PlanAction(new PlanState() { { "doneWalking", true } }, new PlanState() { { "doneWalking", false } }, delegate() {
			character.Move(-transform.forward, false, false, transform.position + transform.forward * 100);
			walkTime -= Time.deltaTime;
			if(walkTime <= 0) {
				doneWalking = false;
				targetState["doneWalking"] = true;
			}
			return true;
		});
		walkBack.name = "walkBack";
		planner.Add(walkBack);

		/*for(int i = 0; i < planSteps; i++) {
			print("external diff: " + targetState.Diff(targetState.Extract(this)));
			PlanAction action = planner.Plan(this, targetState);
			if(action != null) {
				print(action.name);
				action.Update();
			}
			else {
				print("target state reached");
			}
		}*/

		RagDoll(transform, false);
	}

	// Update is called once per frame
	void Update() {

		//print(targetState.Diff(targetState.Extract(this)));

		PlanAction action = planner.Plan(this, targetState);
		if(action != null) {
			//print(action.name);
			action.Update();
		}
		else {
			print("target state reached");
		}

		if(target != null) {

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

		}
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
	}
}
