using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.ModelBinding;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.OAuth;
using TacPac_WebApp.Models;
using TacPac_WebApp.Providers;
using TacPac_WebApp.Results;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;

namespace TacPac_WebApp.Controllers
{
    [Authorize]
    [RoutePrefix("api/Tacpac")]
    public class TacpacController : ApiController
    {

        private ApplicationUserManager _userManager;
        public ApplicationUserManager UserManager
        {
            get
            {
                return _userManager ?? Request.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
            private set
            {
                _userManager = value;
            }
        }

        [Route("addMeasurement")]
        public string addMeasurement(Measurement measurement)
        {
            var user = UserManager.FindById(User.Identity.GetUserId());

            System.Diagnostics.Debug.WriteLine(User.Identity.GetUserId());
            //System.Diagnostics.Debug.WriteLine(user.Id);
            

            Patient m;
            using (var db = new ApplicationDbContext())
            {
                m = db.Patients.Find(User.Identity.GetUserId());
                m.measurements.Add(measurement);
                db.SaveChanges();
            }

            return "Concentration Saved: " + measurement.concentration;
        }

        [HttpPost]
        [Route("getPastMeasurement")]
        public List<Measurement> getPastMeasurement([FromBody]int amount)
        {
            var user = UserManager.FindById(User.Identity.GetUserId());
            Patient m;
            using (var db = new ApplicationDbContext())
            {
                m = db.Patients.Find(user.Id);

                var mList = m.measurements.Skip(Math.Max(0, m.measurements.Count() - amount)).ToList();

                return mList;
            }
        }

        [HttpPost]
        [Route("sendEmail")]
        public string sendEmail([FromBody]string recepients)
        {
            //var client = new SmtpClient("smtp.gmail.com", 587)
            //{
            //    Credentials = new NetworkCredential("gabrielblfernandes@gmail.com", "doctorG123!"),
            //    EnableSsl = true
            //};
            //client.Send("myusername@gmail.com", "gferna14@jhu.edu", "test", "testbody");

            //return "yay";

            /*Create new Mail Message */
            MailMessage mail = new MailMessage();

            /* Set From, To, Subject, Body of the email */
            mail.From = new MailAddress("UaBitch@Bitch.you");
            mail.To.Add(recepients);
            mail.Subject = "Test Mail - SmtpClientEmail";

            var sub = "<table><tr><th>id</th><th>date</th><th>measurement</th></tr>";

            var user = UserManager.FindById(User.Identity.GetUserId());
            using (var db = new ApplicationDbContext())
            {
                var patient = db.Patients.Find(user.Id);

                foreach (var i in patient.measurements)
                {
                    sub += "<tr><td>" + i.id + "</td><td>" + i.time + "</td><td>" + i.concentration + "</td></tr>";
                }
            }

            sub += "</table>";

            mail.IsBodyHtml = true;
                mail.Body = sub;

            /*Specify SMTPClient info - smtpserver, port, credentials, EnableSSL - if it needs SSL */
            SmtpClient smtpServer = new SmtpClient("smtp.gmail.com", 587);
            smtpServer.UseDefaultCredentials = false;
            smtpServer.Port = 587;
            smtpServer.Credentials = new System.Net.NetworkCredential("gabrielblfernandes@gmail.com", "doctorG123!");
            smtpServer.EnableSsl = true;
      

            /*Now you can send the email*/
            smtpServer.Send(mail);

            return "";
        }

    }
}