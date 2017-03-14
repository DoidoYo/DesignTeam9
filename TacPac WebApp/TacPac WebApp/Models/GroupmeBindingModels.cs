using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace TacPac_WebApp.Models
{
    public class GroupmeMessageModel
    {
        public string text { get; set; }
        public string bot_id { get; set; }
    }

    public class GroupmeBindingModel
    {
        public List<AttachmentBindingModel> attachments { get; set; }
        public string avatar_url { get; set; }
        public long created_at { get; set; }
        public long group_id { get; set; }
        public long id { get; set; }
        public string name { get; set; }
        public long sender_id { get; set; }
        public string sender_type { get; set; }
        public string source_guid { get; set; }
        public bool system { get; set; }
        public string text { get; set; }
        public long user_id { get; set; }
    }

    public class AttachmentBindingModel
    {
        public string type { get; set; }
        public string lng { get; set; }
        public string lat { get; set; }
        public string name { get; set; }
        public string url { get; set; }
        public List<List<int>> loci { get; set; }
        public List<long> user_ids { get; set; }
    }

}