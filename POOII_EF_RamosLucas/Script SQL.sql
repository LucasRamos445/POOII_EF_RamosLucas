-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema cibertecdb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `cibertecdb` ;

-- -----------------------------------------------------
-- Schema cibertecdb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cibertecdb` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `cibertecdb` ;

-- -----------------------------------------------------
-- Table `cibertecdb`.`seminario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cibertecdb`.`seminario` ;

CREATE TABLE IF NOT EXISTS `cibertecdb`.`seminario` (
  `CodigoSeminario` INT NOT NULL,
  `NombreCurso` VARCHAR(100) NOT NULL,
  `HorarioClase` VARCHAR(50) NOT NULL,
  `Capacidad` INT NOT NULL DEFAULT '0',
  PRIMARY KEY (`CodigoSeminario`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

INSERT INTO Seminario (CodigoSeminario, NombreCurso, HorarioClase, Capacidad) VALUES
(1, 'Programación en C#', 'Lunes y Miércoles 08:00 - 10:00', 30),
(2, 'Base de Datos MySQL', 'Martes y Jueves 10:00 - 12:00', 25),
(3, 'Desarrollo Web', 'Lunes y Viernes 14:00 - 16:00', 20),
(4, 'Java Fundamentals', 'Miércoles 16:00 - 18:00', 15),
(5, 'Python Básico', 'Sábados 09:00 - 13:00', 40),
(6, 'ASP.NET MVC', 'Domingos 08:00 - 12:00', 10);

-- -----------------------------------------------------
-- Table `cibertecdb`.`registroasistencia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `cibertecdb`.`registroasistencia` ;

CREATE TABLE IF NOT EXISTS `cibertecdb`.`registroasistencia` (
  `NumeroRegistro` INT NOT NULL,
  `CodigoSeminario` INT NOT NULL,
  `CodigoEstudiante` INT NOT NULL,
  `FechaRegistro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`CodigoSeminario`, `CodigoEstudiante`),
  CONSTRAINT `FK_RegistroAsistencia_Seminario`
    FOREIGN KEY (`CodigoSeminario`)
    REFERENCES `cibertecdb`.`seminario` (`CodigoSeminario`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `cibertecdb` ;

-- -----------------------------------------------------
-- procedure sp_ListarSeminariosDisponibles
-- -----------------------------------------------------

USE `cibertecdb`;
DROP procedure IF EXISTS `cibertecdb`.`sp_ListarSeminariosDisponibles`;

DELIMITER $$
USE `cibertecdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_ListarSeminariosDisponibles`()
BEGIN
    SELECT 
        CodigoSeminario,
        NombreCurso,
        HorarioClase,
        Capacidad
    FROM Seminario
    WHERE Capacidad > 0;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_RegistrarAsistencia
-- -----------------------------------------------------

USE `cibertecdb`;
DROP procedure IF EXISTS `cibertecdb`.`sp_RegistrarAsistencia`;

DELIMITER $$
USE `cibertecdb`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_RegistrarAsistencia`(
    IN p_CodigoSeminario INT,
    IN p_CodigoEstudiante INT,
    OUT p_NumeroRegistro INT
)
BEGIN
    DECLARE v_capacidad INT;
	DECLARE v_nro_registro INT;
    SELECT Capacidad
    INTO v_capacidad
    FROM Seminario
    WHERE CodigoSeminario = p_CodigoSeminario;

    IF v_capacidad > 0 THEN
    
		SELECT COUNT(NumeroRegistro) + 1 
        INTO v_nro_registro 
        FROM RegistroAsistencia;
		
        INSERT INTO RegistroAsistencia (NumeroRegistro, CodigoSeminario, CodigoEstudiante)
        VALUES (v_nro_registro, p_CodigoSeminario, p_CodigoEstudiante);
        
		SET p_NumeroRegistro = v_nro_registro;

        UPDATE Seminario
        SET Capacidad = Capacidad - 1
        WHERE CodigoSeminario = p_CodigoSeminario;
        
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay cupos disponibles';
    END IF;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


