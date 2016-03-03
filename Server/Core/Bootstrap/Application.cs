using System.Linq;
using StructureMap;

namespace Core.Bootstrap
{
    public class Application
    {
        public Container Container { get; protected set; }
    
        protected Application()
        {
            Container = new Container(new ApplicationRegistry());
        }

        public virtual void Start()
        {
            foreach (var bootstrapper in Container.GetAllInstances<IBootstrapper>().OrderBy(b => b.Priority))
                bootstrapper.Configure(Container);
        }
    }
}