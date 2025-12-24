using System.ComponentModel;

namespace POOII_EF_RamosLucas.Models
{
    public class Seminario
    {
        [DisplayName("Codigo de Seminario")]
        public int CodigoSeminario { get; set; }

        [DisplayName("Nombre del Curso")]
        public string NombreCurso { get; set; }

        [DisplayName("Horario de Clase")]
        public string HorarioClase { get; set; }

        [DisplayName("Capacidad")]
        public int Capacidad { get; set; }
    }
}
