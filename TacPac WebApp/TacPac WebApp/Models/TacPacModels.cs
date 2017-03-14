using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace TacPac_WebApp.Models
{

    public class Patient
    {
        [Key]
        public string UserId { get; set; }
        public virtual ICollection<Measurement> measurements { get; set; }
        public virtual ICollection<Physician> physicians { get; set; }
    }

    public class Measurement
    {
        [Key]
        public int id { get; set; }
        public double concentration { get; set; }
        public string time { get; set; }
    }

    public class Physician
    {
        [Key]
        public string UserId { get; set; }
        public virtual ICollection<Patient> patients { get; set; }
    }

}