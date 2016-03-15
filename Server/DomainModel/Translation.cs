using System.Collections.Generic;

namespace DomainModel
{
    public class Translation
    {
        public string Translator { get; set; }
        public string Comment { get; set; }
        public List<Meaning> Meanings { get; set; }
    }
}