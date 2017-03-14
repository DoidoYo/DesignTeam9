using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.AspNet.Identity.Owin;
using System.Data.Entity;
using System.ComponentModel.DataAnnotations;

namespace TacPac_WebApp.Models
{
    // You can add profile data for the user by adding more properties to your ApplicationUser class, please visit http://go.microsoft.com/fwlink/?LinkID=317594 to learn more.
    public class ApplicationUser : IdentityUser
    {
        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<ApplicationUser> manager, string authenticationType)
        {
            // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
            var userIdentity = await manager.CreateIdentityAsync(this, authenticationType);
            // Add custom user claims here
            return userIdentity;
        }
            
        public string FirstName { get; set; }
            
        public string LastName { get; set; }

        public string Birthday { get; set; }

    }

    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        public ApplicationDbContext()
            : base("DefaultConnection", throwIfV1Schema: false)
        {
        }
        
        public static ApplicationDbContext Create()
        {
            return new ApplicationDbContext();
        }

        public DbSet<Physician> Physicians { get; set; }
        public DbSet<Patient> Patients { get; set; }

    }

    public class GroupmeDbContext: DbContext
    {
        public GroupmeDbContext() : base("GroupmeConnection")
        {
        }

        public DbSet<Phikeia> phikeia { get; set; }

    }

    public class Phikeia
    {
        [Key]
        public long ID { get; set; }
        public long Groupme_Id { get; set; }
        public string Name { get; set; }
        public int Points { get; set; }

    }

}