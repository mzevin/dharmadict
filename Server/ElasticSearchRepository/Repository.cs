using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using DomainModel;
using Nest;

namespace ElasticSearchRepository
{
    public class Repository : IDictionaryRepository
    {
        private readonly string elasticSearchUrl;

        public Repository()
        {
            elasticSearchUrl = ConfigurationManager.AppSettings["elasticSearchUrl"];            
        }

        public List<Term> Search(string pattern)
        {
            var settings = new ConnectionSettings(new Uri(elasticSearchUrl));
            settings.DefaultIndex("dharma_dict");            
            var client = new ElasticClient(settings);

            var query = client.Search<Term>(s => s
                .Type("terms")
                //.From(0)
                //.Size(10)
                .Query(q => q.Term(t => t.Wylie, pattern)
                        //q.Term(t => t.Wylie, pattern) || q.Term("translations.translation", pattern)
                        //|| q.Match(mq => mq.Field(f => f.Translations).Query("nest"))
                    )
                );
            var result = query.Hits.Select(h => h.Source).ToList();
            
            return result;
        }
    }
}
