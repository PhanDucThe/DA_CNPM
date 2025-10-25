using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CongNghePhanMen.Models
{
    public class products
    {
        public int id { get; set; }
        public string name { get; set; }
        public string sku { get; set; }
        public string slug { get; set; }
        public string thumbnail_url { get; set; }
        public string description { get; set; }
        public string content { get; set; }
        public string ingredients { get; set; }
        public string dosage { get; set; }
        public string contraindications { get; set; }
        public string packaging_details { get; set; }
        public bool prescription_required { get; set; }
        public decimal original_price { get; set; }
        public decimal sale_price { get; set; }
        public int stock_quantity { get; set; }
        public int? stock { get; set; }
        public bool is_active { get; set; }
        public int? category_id { get; set; }
        public int? brand_id { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
        public string created_by { get; set; }
        public string updated_by { get; set; }

        public List<product_images> Images { get; set; }

        public products()
        {
            Images = new List<product_images>();
        }
    }
}