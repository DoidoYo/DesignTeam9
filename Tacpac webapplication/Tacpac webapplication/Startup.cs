using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(Tacpac_webapplication.Startup))]
namespace Tacpac_webapplication
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
