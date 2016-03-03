using log4net;
using StructureMap.Configuration.DSL;

namespace Application.Startup
{
    public class LoggingRegistry : Registry
    {
        public LoggingRegistry()
        {
            For<ILog>()
                .AlwaysUnique()
                .Use(ctx => ctx.ParentType == null 
                        ? LogManager.GetLogger(ctx.BuildStack.Current.ConcreteType) 
                        : LogManager.GetLogger(ctx.ParentType));
        }

        public ushort Priority
        {
            get { return 0; }
        }
    }

}

