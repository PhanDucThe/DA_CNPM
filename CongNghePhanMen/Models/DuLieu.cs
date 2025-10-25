using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CongNghePhanMen.Models
{
    public class DuLieu
    {
        public List<categories> DanhMuc { get; set; }
        public List<products> SanPham { get; set; }

        public DuLieu()
        {
            DanhMuc = new List<categories>();
            SanPham = new List<products>();
        }
    }
}