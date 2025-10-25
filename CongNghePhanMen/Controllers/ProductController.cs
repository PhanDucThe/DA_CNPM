using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using CongNghePhanMen.Models;



namespace CongNghePhanMen.Controllers
{
    public class ProductController : Controller
    {
        // GET: Product
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Details()
        {
            return View();
        }
        public ActionResult DanhSachSP(int? id, string kw)
        {
            DuLieu model = new DuLieu();
            string connStr = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["QLNT"].ConnectionString;

            try
            {
                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string prodQuery = "SELECT * FROM products WHERE 1=1";
                    using (var cmd = new SqlCommand())
                    {
                        cmd.Connection = conn;

                        if (id.HasValue && id.Value > 0)
                        {
                            prodQuery += " AND category_id = @category_id";
                            cmd.Parameters.AddWithValue("@category_id", id.Value);
                        }

                        if (!string.IsNullOrEmpty(kw))
                        {
                            prodQuery += " AND name LIKE @name";
                            cmd.Parameters.AddWithValue("@name", "%" + kw + "%");
                        }

                        cmd.CommandText = prodQuery;

                        // Fill products
                        var prodAdapter = new SqlDataAdapter(cmd);
                        var prodTable = new DataTable();
                        prodAdapter.Fill(prodTable);

                        // Debug: số dòng trả về từ DB
                        ViewBag.DbRowCount = prodTable.Rows.Count;

                        foreach (DataRow rw in prodTable.Rows)
                        {
                            var p = new products
                            {
                                id = rw["id"] == DBNull.Value ? 0 : Convert.ToInt32(rw["id"]),
                                name = rw["name"] == DBNull.Value ? "" : rw["name"].ToString(),
                                sku = rw["sku"] == DBNull.Value ? "" : rw["sku"].ToString(),
                                slug = rw["slug"] == DBNull.Value ? "" : rw["slug"].ToString(),
                                thumbnail_url = rw["thumbnail_url"] == DBNull.Value ? "" : rw["thumbnail_url"].ToString(),
                                sale_price = rw["sale_price"] == DBNull.Value ? 0m : Convert.ToDecimal(rw["sale_price"]),
                                original_price = rw["original_price"] == DBNull.Value ? 0m : Convert.ToDecimal(rw["original_price"]),
                                stock_quantity = rw["stock_quantity"] == DBNull.Value ? 0 : Convert.ToInt32(rw["stock_quantity"]),
                                category_id = rw["category_id"] == DBNull.Value ? (int?)null : Convert.ToInt32(rw["category_id"])
                            };

                            // Lấy ảnh cho product p
                            using (var imgCmd = new SqlCommand("SELECT * FROM product_images WHERE product_id = @pid ORDER BY display_order", conn))
                            {
                                imgCmd.Parameters.AddWithValue("@pid", p.id);
                                var imgAdapter = new SqlDataAdapter(imgCmd);
                                var imgTable = new DataTable();
                                imgAdapter.Fill(imgTable);

                                foreach (DataRow ir in imgTable.Rows)
                                {
                                    p.Images.Add(new product_images
                                    {
                                        id = ir["id"] == DBNull.Value ? 0 : Convert.ToInt32(ir["id"]),
                                        product_id = ir["product_id"] == DBNull.Value ? 0 : Convert.ToInt32(ir["product_id"]),
                                        image_url = ir["image_url"] == DBNull.Value ? "" : ir["image_url"].ToString(),
                                        display_order = ir["display_order"] == DBNull.Value ? 0 : Convert.ToInt32(ir["display_order"])
                                    });
                                }
                            }

                            model.SanPham.Add(p);
                        }
                    } 
                } 
            }
            catch (Exception ex)
            {
                // Hiện lỗi tạm thời để debug
                return Content("Error in DanhSachSP: " + ex.Message + "\n" + ex.ToString());
            }

            // Debug cho View: tổng sản phẩm đã đổ vào model
            ViewBag.ModelCount = model.SanPham.Count;
            ViewBag.DebugNames = string.Join(", ", model.SanPham.Select(s => s.name));

            return View(model);
        }
    }
}