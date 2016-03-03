using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http.Dependencies;
using StructureMap;

namespace Application.Startup
{
    public class StructureMapDependencyResolver : IDependencyResolver
    {

        private readonly IContainer container;

        public StructureMapDependencyResolver(IContainer container)
        {
            if (container == null)
            {
                throw new ArgumentNullException("container");
            }

            this.container = container;
        }

        public void Dispose()
        {
            container.Dispose();
        }

        public IEnumerable<object> GetServices(Type serviceType)
        {
            return container.GetAllInstances(serviceType).Cast<object>();
        }


        public object GetService(Type serviceType)
        {
            return serviceType.IsAbstract || serviceType.IsInterface
                       ? container.TryGetInstance(serviceType)
                       : container.GetInstance(serviceType);
        }

        public IDependencyScope BeginScope()
        {
            return new StructureMapDependencyResolver(container.GetNestedContainer());
        }
    }
}
