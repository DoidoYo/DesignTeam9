using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Mvc;
using TacPac_WebApp.Models;

namespace TacPac_WebApp.Controllers
{
    public class GroupmeController : Controller
    {
        ConsoleModel console = new ConsoleModel();

        static string BOT_ID = "cc65881e13e1ad55e34ec4f403";
        static string GROUPME_URL = "https://api.groupme.com/v3/bots/post";

        // GET: Groupme
        public ActionResult Index()
        {
            
            System.Diagnostics.Debug.Write("Count -- ");
            System.Diagnostics.Debug.WriteLine(ConsoleModel.log.Count);

            ViewData["console"] = ConsoleModel.log;

            return View();
        }
        
        private void sendMsg(string msg)
        {
            GroupmeMessageModel mMsg = new GroupmeMessageModel();

            mMsg.text = msg;
            mMsg.bot_id = BOT_ID;

            var msgJ = JsonConvert.SerializeObject(mMsg);

            // Create a request using a URL that can receive a post.   
            WebRequest request = WebRequest.Create(GROUPME_URL);
            // Set the Method property of the request to POST.  
            request.Method = "POST";
            // Create POST data and convert it to a byte array.  
            string postData = msgJ;
            byte[] byteArray = Encoding.UTF8.GetBytes(postData);
            // Set the ContentType property of the WebRequest.  
            request.ContentType = "application/x-www-form-urlencoded";
            // Set the ContentLength property of the WebRequest.  
            request.ContentLength = byteArray.Length;
            // Get the request stream.  
            Stream dataStream = request.GetRequestStream();
            // Write the data to the request stream.  
            dataStream.Write(byteArray, 0, byteArray.Length);
            // Close the Stream object.  
            dataStream.Close();
            // Get the response.  
            WebResponse response = request.GetResponse();
            // Display the status.  
            Console.WriteLine(((HttpWebResponse)response).StatusDescription);
            // Get the stream containing content returned by the server.  
            dataStream = response.GetResponseStream();
            // Open the stream using a StreamReader for easy access.  
            StreamReader reader = new StreamReader(dataStream);
            // Read the content.  
            string responseFromServer = reader.ReadToEnd();
            // Display the content.  
            Console.WriteLine(responseFromServer);
            // Clean up the streams.  
            reader.Close();
            dataStream.Close();
            response.Close();
        }

        [HttpPost]
        public ActionResult msg(string secret)
        {
            Request.InputStream.Seek(0, SeekOrigin.Begin);
            string jsonString = new StreamReader(Request.InputStream).ReadToEnd();

            GroupmeBindingModel groupme = JsonConvert.DeserializeObject<GroupmeBindingModel>(jsonString);

            ConsoleModel.log.Add("---------------");

            using (var db = new GroupmeDbContext())
            {

                //if register is typed
                if (groupme.text.Contains("register"))
            {
                AttachmentBindingModel mentionsAttach = null;
                foreach(var i in groupme.attachments)
                {
                    if (i.type == "mentions")
                    {
                        mentionsAttach = i;
                    }
                }

                if (mentionsAttach != null)
                {
                    string msg = "";
                    for (var i = 0; i < mentionsAttach.user_ids.Count; i++)
                    {
                        Phikeia phi = new Phikeia();
                        phi.Groupme_Id = mentionsAttach.user_ids[i];
                        phi.Name = groupme.text.Substring(mentionsAttach.loci[i][0]+1, mentionsAttach.loci[i][1]-1);

                        msg += phi.Name + " Registered!\n";
                            
                        db.phikeia.Add(phi);
                            
                       

                    }
                    sendMsg(msg);
                } else
                {
                    sendMsg("You fucked up! Please tag a Phikeia (or multiple!)");
                }
            }

            //if merit or demerit is typed
            if (groupme.text.Contains("merit"))
            {
                int diff = 0;
                if (groupme.text.Contains("demerit")) {
                    diff = -1;
                }
                else
                {
                    diff = 1;
                }

                AttachmentBindingModel mentionsAttach = null;
                foreach (var i in groupme.attachments)
                {
                    if (i.type == "mentions")
                    {
                        mentionsAttach = i;
                    }
                }

                if (mentionsAttach != null)
                {
                    string msg = "";
                    for (var i = 0; i < mentionsAttach.user_ids.Count; i++)
                    {
                        string name = groupme.text.Substring(mentionsAttach.loci[i][0], mentionsAttach.loci[i][1]);
                        bool found = false;
                            int points = 0;
                            foreach (var phi in db.phikeia.ToList())
                            {
                                if (phi.Groupme_Id == mentionsAttach.user_ids[i])
                                {
                                    phi.Points += diff;
                                    phi.Name = name.Substring(1);
                                    found = true;
                                    points = phi.Points;
                                }
                            }
                        if(!found)
                        {
                            msg += "Could not find " + name + "!\n";
                        } else
                        {
                            if (diff == 1)
                            {
                                msg += "1 Point for " + name + "! NICE!";
                            } else
                            {
                                msg += "1 Point REMOVED from " + name + "!Fucking Phikeia!";
                            }
                                msg += " Total of " + points + " points\n";
                        }
                    }
                    sendMsg(msg);
                }
            }
            if (groupme.text.Contains("@bot") && groupme.text.Contains("score"))
                {
                    string msg = "Score:\n";
                    foreach (var phi in db.phikeia.ToList())
                    {
                        msg += phi.Name + " : " + phi.Points + "\n";
                    }
                    sendMsg(msg);
                    }

                db.SaveChanges();
            }
            //ConsoleModel.log.Add("---------------");
            //ConsoleModel.log.Add(groupme.text);
            //ConsoleModel.log.Add(groupme.attachments[0].type);
            //ConsoleModel.log.Add(groupme.attachments[0].user_ids[0]+"");


            return null;
        }

    }
}