using System.Threading.Tasks;
using System.Web.Http;
using Core.Web.Logging;
using log4net;
using StructureMap;
using IBootstrapper = Core.Bootstrap.IBootstrapper;

namespace Application.Startup
{
    public class UnhandledExceptionsConfig : IBootstrapper
    {
        public void Configure(Container container)
        {
            var logger = container.GetInstance<ILog>();
            GlobalConfiguration.Configuration.Filters.Add(new UnhandledExceptionFilter(logger));

            TaskScheduler.UnobservedTaskException += (sender, excArgs) =>
            {
                excArgs.SetObserved();
                excArgs.Exception.Flatten().Handle(ex =>
                {
                    container.GetInstance<ILog>().Error(string.Format("Unhandled exception: {0}", ex.Message), ex);
                    return true;
                });
            };
        
        }

        public ushort Priority
        {
            get { return 1; }
        }
    }
}