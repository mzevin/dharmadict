using System.Web.Http.Filters;
using log4net;

namespace Core.Web.Logging
{
    public class UnhandledExceptionFilter : ExceptionFilterAttribute
    {
        private readonly ILog logger;

        public UnhandledExceptionFilter(ILog logger)
        {
            this.logger = logger;
        }

        public override void OnException(HttpActionExecutedContext context)
        {
            logger.Error(string.Format("Unhandled exception: {0}", context.Exception.Message), context.Exception);
        }
    }
}