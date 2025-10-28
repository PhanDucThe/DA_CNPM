using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using CongNghePhanMen.Models.DataAccess;
namespace CongNghePhanMen.Controllers.Admin
{
    public class OrderManagementController : Controller
    {
        private readonly QL_THUOCEntities data = new QL_THUOCEntities();
        // GET: OderManagement
        
        // GET: OderManagement
        public ActionResult Index()
        {
            var orders = data.orders.Include("user").ToList();
            return View(orders);
        }
        public ActionResult Details(int? id)// int? giá trị có thể là null
        {
            if (id == null)
            {
                return RedirectToAction("Index");
            }
            var order = data.orders.FirstOrDefault(o => o.id == id);

            if (order == null)
                return HttpNotFound();

            return View(order);
        }
        [HttpPost]
        public ActionResult UpdateStatus(int id, string status)
        {

            var order = data.orders.FirstOrDefault(o => o.id == id);
            if (order == null)
            {
                return HttpNotFound();
            }

            order.status = status;
            order.updated_at = DateTime.Now;

            data.SaveChanges();

            // Sau khi cập nhật xong, chuyển hướng về trang danh sách
            return RedirectToAction("Index");
        }


    }
}