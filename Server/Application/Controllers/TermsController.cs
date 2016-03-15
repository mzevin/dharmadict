using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using DomainModel;

namespace Application.Controllers
{
    public class TermsController : ApiController
    {
        private readonly IDictionaryRepository repository;

        public TermsController(IDictionaryRepository repository)
        {
            this.repository = repository;
        }

        public List<Term> Get(string pattern = "")
        {
            return repository.Search(pattern);
        }
    }
}
