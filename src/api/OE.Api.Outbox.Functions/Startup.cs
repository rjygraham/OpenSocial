﻿using Azure.Identity;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json;
using OE.Api.Data;
using OE.Api.Outbox;
using System;

[assembly: FunctionsStartup(typeof(Startup))]

namespace OE.Api.Outbox
{
	public class Startup : FunctionsStartup
	{
		public override void Configure(IFunctionsHostBuilder builder)
		{
			// Set the default Newtonsoft settings to user the custom ActivityStreamsSerializationBinder 
			JsonConvert.DefaultSettings = () => Extensions.Constants.Serialization.JsonSerializerSettings;

			builder.Services.AddSingleton(new CosmosClient(Environment.GetEnvironmentVariable("CosmosDbSqlAccountEndpoint"), new DefaultAzureCredential(), Constants.CosmosDb.ClientOptions));
			builder.Services.AddSingleton<IOutboxStore, CosmosDbOutboxStore>();
			builder.Services.AddSingleton<IInvitationStore, CosmosDbInvitationStore>();
		}
	}
}
