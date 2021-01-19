﻿using Newtonsoft.Json;
using System;

namespace Open.Models
{
	public class Profile
	{
		[JsonProperty("id")]
		public string Id { get; set; }

		[JsonProperty("username")]
		public string Username { get; set; }

		[JsonProperty("displayName")]
		public string DisplayName { get; set; }
	}
}
