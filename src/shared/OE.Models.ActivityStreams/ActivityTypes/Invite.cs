﻿namespace OE.Models.ActivityStreams
{
	/// <summary>
	/// A specialization of Offer in which the actor is extending an invitation for the object to 
	/// the target. 
	/// </summary>
	public class Invite : Offer
	{
		public Invite()
		{
			Type = typeof(Invite).Name;
		}
	}
}
