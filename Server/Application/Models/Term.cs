using System.Collections.Generic;

namespace Application.Models
{
    public class Term
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public List<Translation> Translations { get; set; } 
    }

    public class Translation
    {
        public string Name { get; set; }
        public string Language { get; set; }
        public string Translator { get; set; }
    }
}