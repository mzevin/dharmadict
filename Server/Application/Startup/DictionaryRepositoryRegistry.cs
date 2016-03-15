using DomainModel;
using StructureMap.Configuration.DSL;

namespace Application.Startup
{
    public class DictionaryRepositoryRegistry : Registry
    {
        public DictionaryRepositoryRegistry()
        {
            For<IDictionaryRepository>().Use<ElasticSearchRepository.Repository>();
        }         
    }
}