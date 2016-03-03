using System;
using System.IO;
using System.Web;
using System.Web.Http;
using Core.Bootstrap;

namespace Core.Web
{
    public class WebApplication : Application
    {
        private const string STARTUP_LOG_FILE_NAME = "startup.log";

        public override void Start() 
        {
            try
            {
                GlobalConfiguration.Configuration.DependencyResolver = new StructureMapDependencyResolver(Container);
                base.Start();
            }
            catch (Exception ex)
            {
                LogStartupException(ex);
                throw;
            }
        }

        private static void LogStartupException(Exception ex)
        {
            try
            {
                var logFolder = Path.Combine(HttpRuntime.AppDomainAppPath, "logs");
                if (!Directory.Exists(logFolder))
                    Directory.CreateDirectory(logFolder);

                var fullPath = Path.Combine(logFolder, STARTUP_LOG_FILE_NAME);
                using (var startupLog = new StreamWriter(fullPath, false))
                    startupLog.Write(DateTime.Now + " " + ex);
            }
            catch (Exception ex2)
            {                
            }
        }
    }
}