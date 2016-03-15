using System.Collections.Generic;

namespace DomainModel
{
    public class Term
    {
        public string Wylie { get; set; }
        public string Sanskrit { get; set; }
        public string Wikipedia { get; set; }
        public List<Translation> Translations { get; set; }
        public List<Term> SubTerms { get; set; }
    }
}
