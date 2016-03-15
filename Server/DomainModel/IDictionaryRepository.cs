using System.Collections.Generic;

namespace DomainModel
{
    public interface IDictionaryRepository
    {
        List<Term> Search(string pattern);
    }
}