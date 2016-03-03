using System.Web.Http;
using Core.Bootstrap;
using Newtonsoft.Json.Serialization;
using StructureMap;

namespace Application.Startup
{
    public class JsonSerializationConfiguration : BootstrapperBase
    {
        public override void Configure(Container container)
        {
            var json = GlobalConfiguration.Configuration.Formatters.JsonFormatter;
            json.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
        }
    }
}