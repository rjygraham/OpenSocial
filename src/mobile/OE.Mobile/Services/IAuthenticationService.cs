﻿using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace OE.Mobile.Services
{
	public interface IAuthenticationService
	{
		string AccessToken { get; }
		Task<bool> LoginAsync();
		Task<bool> LogoutAsync();
	}
}
