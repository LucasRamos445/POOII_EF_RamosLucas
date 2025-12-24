using Microsoft.AspNetCore.Mvc;
using POOII_EF_RamosLucas.Data;

namespace POOII_EF_RamosLucas.Controllers
{
    public class SeminarioController : Controller
    {
        private readonly SeminarioDAO _dao;

        public SeminarioController(SeminarioDAO dao)
        {
            _dao = dao;
        }
       
        public IActionResult Index()
        {
            return View(_dao.ListarDisponibles());
        }

      
        public IActionResult Detalle(int id)
        {
            return View(_dao.ObtenerPorCodigo(id));
        }
      
        [HttpPost]
        public IActionResult Registrar(int codigoSeminario, int codigoEstudiante)
        {
            int nroRegistro = _dao.RegistrarAsistencia(codigoSeminario, codigoEstudiante);
            TempData["Mensaje"] = "Registro exitoso. N° Registro: " + nroRegistro;
            return RedirectToAction("Index");
        }
    }
}
