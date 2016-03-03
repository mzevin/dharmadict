using StructureMap.Configuration.DSL;

namespace Core.Bootstrap
{
    public class ApplicationRegistry : Registry {
        public ApplicationRegistry() {
            Scan(action => {
                    action.AssembliesFromApplicationBaseDirectory();
                    action.LookForRegistries();
                    action.WithDefaultConventions();
                    action.AssemblyContainingType<IBootstrapper>();
                    action.AddAllTypesOf<IBootstrapper>();
                 });
        }
    }
}