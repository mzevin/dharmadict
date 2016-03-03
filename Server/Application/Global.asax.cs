namespace Application
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class WebApplication : System.Web.HttpApplication
    {
        protected void Application_Start() 
        {
            Core.Bootstrap.ApplicationFactory.CreateApplication<Core.Web.WebApplication>().Start();
        }
    }
}