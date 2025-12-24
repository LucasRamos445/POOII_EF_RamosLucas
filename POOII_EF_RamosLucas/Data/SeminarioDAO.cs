using MySql.Data.MySqlClient;
using POOII_EF_RamosLucas.Models;

namespace POOII_EF_RamosLucas.Data
{
    public class SeminarioDAO
    {
        private readonly string _cn = default!;

        public SeminarioDAO(IConfiguration config)
        {
            _cn = config.GetConnectionString("MySqlConnection")!;
        }


        public List<Seminario> ListarDisponibles()
        {
            List<Seminario> lista = new List<Seminario>();

            using (MySqlConnection cn = new MySqlConnection(_cn))
            {
                MySqlCommand cmd = new MySqlCommand("sp_ListarSeminariosDisponibles", cn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cn.Open();
                var dr = cmd.ExecuteReader();

                while (dr.Read())
                {
                    lista.Add(new Seminario
                    {
                        CodigoSeminario = dr.GetInt32(0),
                        NombreCurso = dr.GetString(1),
                        HorarioClase = dr.GetString(2),
                        Capacidad = dr.GetInt32(3)
                    });
                }
            }
            return lista;
        }

      
        public Seminario ObtenerPorCodigo(int codigo)
        {
            Seminario s = null;

            using (MySqlConnection cn = new MySqlConnection(_cn))
            {
                MySqlCommand cmd = new MySqlCommand(
                    "SELECT * FROM Seminario WHERE CodigoSeminario = @cod", cn);
                cmd.Parameters.AddWithValue("@cod", codigo);

                cn.Open();
                var dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    s = new Seminario
                    {
                        CodigoSeminario = dr.GetInt32(0),
                        NombreCurso = dr.GetString(1),
                        HorarioClase = dr.GetString(2),
                        Capacidad = dr.GetInt32(3)
                    };
                }
            }
            return s;
        }

    
        public int RegistrarAsistencia(int codSeminario, int codEstudiante)
        {
            int numeroRegistro;

            using (MySqlConnection cn = new MySqlConnection(_cn))
            {
                MySqlCommand cmd = new MySqlCommand("sp_RegistrarAsistencia", cn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("p_CodigoSeminario", codSeminario);
                cmd.Parameters.AddWithValue("p_CodigoEstudiante", codEstudiante);

                MySqlParameter pOut = new MySqlParameter("p_NumeroRegistro", MySqlDbType.Int32);
                pOut.Direction = System.Data.ParameterDirection.Output;
                cmd.Parameters.Add(pOut);

                cn.Open();
                cmd.ExecuteNonQuery();

                numeroRegistro = Convert.ToInt32(pOut.Value);
            }

            return numeroRegistro;
        }
    }
}
