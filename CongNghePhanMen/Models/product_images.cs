using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CongNghePhanMen.Models
{
    public class product_images
    {
        public int id { get; set; }
        public int product_id { get; set; }
        public string image_url { get; set; }
        public int display_order { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
        public string created_by { get; set; }
        public string updated_by { get; set; }
    }
}