using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CongNghePhanMen.Models
{
    public class categories
    {
        public int category_id { get; set; }
        public string category_name { get; set; }
        public int parent_id { get; set; }
        public string slug { get; set; }
        public int is_active { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
        public string created_by { get; set; }
        public string updated_by { get; set; }

    }
}