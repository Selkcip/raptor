using UnityEngine;
using System.Collections;

public class BribeMenu : MonoBehaviour {

	//slider stuff
	public UISlider slider;
	public UILabel sliderLabel;

	//Current labels
	public UILabel currMoney;
	public UILabel currNotoriety;

	//New labels
	public UILabel newMoney;
	public UILabel newNotoriety;

	private int max;
	private int money;
	private float notoriety;
	
	// Update is called once per frame
	void Update () {
		max = 5 * (int)RaptorInteraction.notoriety;

		currMoney.text = "Money: $" + RaptorInteraction.money;
		currNotoriety.text = "Notoriety: " + RaptorInteraction.notoriety;

		money = RaptorInteraction.money - (int)((float)RaptorInteraction.money * slider.value);
		notoriety = Mathf.Max(0, RaptorInteraction.notoriety - (int)((float)RaptorInteraction.money * slider.value) / 5);

		//prevents user from spending more money than they have to
		if(notoriety <= 0) {
			money = RaptorInteraction.money - max;
		}

		sliderLabel.text = "$" + Mathf.Min((int)((float)RaptorInteraction.money * slider.value), max);

		newMoney.text = "Money: $" + money;
		newNotoriety.text = "Notoriety: " + notoriety;
	}

	void Confirm() {
		RaptorInteraction.money = money;
		RaptorInteraction.notoriety = notoriety;
		RaptorInteraction.notoriety = 2000;
	}
}
