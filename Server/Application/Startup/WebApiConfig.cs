using System.Web.Http;
using Core.Bootstrap;
using StructureMap;

namespace Application.Startup
{
    public class WebApiConfig : BootstrapperBase
    {
        public override void Configure(Container container)
        {
            GlobalConfiguration.Configuration.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );
        }
    }
}