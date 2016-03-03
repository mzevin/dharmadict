namespace Core.Bootstrap
{
    public class BootstrapperBase : IBootstrapper
    {
        public ushort Priority { get { return 65535; } }

        public virtual void Configure(StructureMap.Container container)
        {
        }
    }
}
