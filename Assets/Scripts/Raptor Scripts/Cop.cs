using UnityEngine;
using System.Collections;

public class Cop : Guard {

	public Transform room;

	public bool roomSet = false;
	public bool roomChecked = false;

	// Use this for initialization
	public override void Start() {
		base.Start();
	}

	protected PlanGoal gCheckRoom;
	public override void InitGoals() {
		base.InitGoals();

		gCheckRoom = new PlanGoal(
			"check room",
			new PlanState() {
				{"roomChecked", false}
			},
			new PlanState() {
				{"roomChecked", true},
				{"running", true}
			},
			40);
		goals.Add(gCheckRoom);
	}

	PlanAction aCheckRoom;
	public override void InitActions() {
		base.InitActions();

		aCheckRoom = new PlanAction(
			new PlanState() {
				{ "enemySeen", false },
				{ "enemyVisible", false },
				{ "roomSet", true },
				{ "roomChecked", false },
				{ "running", true },
				{ "knockedOut", false },
				{ "dead", false }
			},
			new PlanState() {
				{ "roomChecked", true }
			},
			delegate() {
				agent.SetDestination(room.position);

				// update the agents posiiton 
				agent.transform.position = transform.position;

				if(agent.remainingDistance <= targetChangeTolerance || agent.pathStatus == NavMeshPathStatus.PathPartial) {
					roomChecked = true;
				}

				// use the values to move the character
				Move(agent.desiredVelocity);

				return false;
			});
		aCheckRoom.name = "check room";
		planner.Add(aCheckRoom);
	}

	// Update is called once per frame
	public override void Update() {
		//Set bools and stuff up here
		roomSet = room != null;

		if(weapon != null) {
			weapon.damage = (RaptorInteraction.notoriety / RaptorInteraction.notorietyStep) * 0.1f;
		}

		//This should be last in most cases
		base.Update();
	}
}
