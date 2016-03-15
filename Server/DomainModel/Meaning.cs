using System.Collections.Generic;

namespace DomainModel
{
    public class Meaning
    {
        public int OrderNum { get; set; }
        public List<Version> Versions { get; set; }
    }
}