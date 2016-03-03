using StructureMap;

namespace Core.Bootstrap
{
    public interface IBootstrapper
    {
        void Configure(Container container);
        ushort Priority { get; }
    }
}
