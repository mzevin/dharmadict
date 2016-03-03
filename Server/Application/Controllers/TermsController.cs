using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Application.Models;

namespace Application.Controllers
{
    public class TermsController : ApiController
    {
        public List<Term> Get()
        {
            return new List<Term>
            {
                new Term
                {
                    Id = "1",
                    Name = "chos",
                    Description =
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce condimentum augue vitae erat viverra ullamcorper. Sed porttitor eget odio in fermentum. Fusce est ipsum, porttitor id eros sit amet, mollis iaculis enim. In accumsan fringilla nisl, condimentum aliquet arcu blandit vitae. In felis velit, lacinia a odio ac, tincidunt interdum quam. Praesent aliquam nulla ut turpis pretium, sed imperdiet mi varius. Pellentesque nec turpis rutrum, pretium massa eu, ornare justo. Praesent et lacus est. Fusce at risus vel lacus vestibulum scelerisque. Morbi tempor mauris sit amet arcu faucibus, quis porta elit facilisis. Praesent malesuada leo sit amet elit pellentesque, ullamcorper suscipit est scelerisque.",
                    Translations = new List<Translation>
                    {
                        new Translation
                        {
                            Name = "дхарма",
                            Language = "rus",
                            Translator = "Маргарита Кожевникова"
                        },
                        new Translation
                        {
                            Name = "духовное учение",
                            Language = "rus",
                            Translator = "Маргарита Кожевникова"
                        },
                    }
                }
                , new Term
                {
                    Id = "2",
                    Name = "chos nyid",
                    Description =
                        "Pellentesque tempor vel sapien nec ornare. Duis ut elementum dolor. Vestibulum condimentum, diam ut rutrum gravida, nunc eros feugiat nibh, in accumsan justo magna quis augue. Maecenas auctor sagittis est, eget porttitor ligula sagittis eget. Proin eleifend dui ac diam elementum, rutrum sollicitudin eros dictum. Vestibulum hendrerit est at risus rhoncus rhoncus. Nullam sollicitudin vehicula libero in congue. Nam ornare tristique ullamcorper. Mauris euismod vestibulum risus, id ullamcorper nibh maximus at. Nunc in ipsum quis ipsum ullamcorper pulvinar eget in urna. Donec in metus luctus, viverra ex eu, consequat massa. Aliquam quis massa auctor, ultricies nisi in, consequat purus. Sed felis massa, rutrum id tempor quis, egestas et sem. In consectetur eget nisi nec venenatis.",
                    Translations = new List<Translation>
                    {
                        new Translation
                        {
                            Name = "подлинное-бытие",
                            Language = "rus",
                            Translator = "Маргарита Кожевникова"
                        }
                    }
                }
            };
        }
    }
}
