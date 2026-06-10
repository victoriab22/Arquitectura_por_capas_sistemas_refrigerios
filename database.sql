-- =============================================
-- Script completo para MySQL 5.7+
-- =============================================
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA IF EXISTS `solicitud_final`;
CREATE SCHEMA IF NOT EXISTS `solicitud_final` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `solicitud_final`;

-- -----------------------------------------------------
-- Tabla: roles
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`roles` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(255) NULL DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_rol_nombre` (`nombre` ASC)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Tabla: usuarios
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`usuarios` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(150) NOT NULL,
  `apellido` VARCHAR(150) NOT NULL,
  `email` VARCHAR(150) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `cargo` VARCHAR(150) NULL DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT '1',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_email` (`email` ASC)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Tabla: dependencias
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`dependencias` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  `codigo` VARCHAR(50) NULL DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT '1',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Tabla: estados_solicitud
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`estados_solicitud` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `descripcion` VARCHAR(255) NULL DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_estado_nombre` (`nombre` ASC)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Tabla: fondos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`fondos` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(500) NOT NULL,
  `codigo` VARCHAR(20) NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT '1',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_ff_codigo` (`codigo` ASC)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Tabla: centros_costo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`centros_costo` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(255) NOT NULL,
  `codigo` INT UNSIGNED NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT '1',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_cc_codigo` (`codigo` ASC)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Tabla: funcion
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`funcion` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(500) NOT NULL,
  `codigo` VARCHAR(20) NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT '1',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_ff_codigo` (`codigo` ASC)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Tabla: solicitudes (estructura base)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`solicitudes` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `numero_radicado` VARCHAR(30) NOT NULL,
  `usuario_id` INT UNSIGNED NOT NULL,
  `dependencia_id` INT UNSIGNED NOT NULL,
  `estado_id` INT UNSIGNED NOT NULL,
  `fecha_solicitud` DATE NOT NULL,
  `justificacion` TEXT NULL DEFAULT NULL,
  `valor_total` DECIMAL(18,2) NOT NULL DEFAULT '0.00',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `uq_radicado` (`numero_radicado` ASC),
  INDEX `usuario_id` (`usuario_id` ASC),
  INDEX `dependencia_id` (`dependencia_id` ASC),
  INDEX `estado_id` (`estado_id` ASC),
  CONSTRAINT `solicitudes_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `solicitudes_ibfk_2` FOREIGN KEY (`dependencia_id`) REFERENCES `dependencias` (`id`),
  CONSTRAINT `solicitudes_ibfk_3` FOREIGN KEY (`estado_id`) REFERENCES `estados_solicitud` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Tabla: archivos_adjuntos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`archivos_adjuntos` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `solicitud_id` INT UNSIGNED NOT NULL,
  `nombre_archivo` VARCHAR(255) NOT NULL,
  `ruta_archivo` VARCHAR(500) NOT NULL,
  `tipo_mime` VARCHAR(100) NULL DEFAULT NULL,
  `tamano_bytes` INT UNSIGNED NULL DEFAULT NULL,
  `uploaded_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `solicitud_id` (`solicitud_id` ASC),
  CONSTRAINT `archivos_adjuntos_ibfk_1` FOREIGN KEY (`solicitud_id`) REFERENCES `solicitudes` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Tabla: items_solicitud_refrigerio_almuerzo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`items_solicitud_refrigerio_almuerzo` (
  `iditems_solicitud_refrigerio_almuerzo` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `dia` ENUM('1','2','3','4','5','6') NOT NULL,
  `hora` VARCHAR(15) NOT NULL,
  `cantidad` INT NOT NULL,
  `alimentos` VARCHAR(100) NULL DEFAULT NULL,
  `bebidas` VARCHAR(100) NULL DEFAULT NULL,
  `tipo_solicitud` ENUM('Refrigerio','Desayuno','Almuerzo','Cena') NOT NULL,
  `requiere_mesero` ENUM('Si','No') NOT NULL,
  `lugar_entrega` VARCHAR(100) NOT NULL,
  `id_solicitud` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`iditems_solicitud_refrigerio_almuerzo`),
  INDEX `id_solicitud_idx` (`id_solicitud` ASC),
  CONSTRAINT `id_solicitud` FOREIGN KEY (`id_solicitud`) REFERENCES `solicitudes` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Tabla: historial_estados
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`historial_estados` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `solicitud_id` INT UNSIGNED NOT NULL,
  `estado_anterior_id` INT UNSIGNED NULL DEFAULT NULL,
  `estado_nuevo_id` INT UNSIGNED NOT NULL,
  `usuario_id` INT UNSIGNED NOT NULL,
  `observacion` TEXT NULL DEFAULT NULL,
  `notificado` TINYINT(1) NOT NULL DEFAULT '0',
  `fecha_notificado` TIMESTAMP NULL DEFAULT NULL,
  `fecha` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `solicitud_id` (`solicitud_id` ASC),
  INDEX `estado_anterior_id` (`estado_anterior_id` ASC),
  INDEX `estado_nuevo_id` (`estado_nuevo_id` ASC),
  INDEX `usuario_id` (`usuario_id` ASC),
  CONSTRAINT `historial_estados_ibfk_1` FOREIGN KEY (`solicitud_id`) REFERENCES `solicitudes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `historial_estados_ibfk_2` FOREIGN KEY (`estado_anterior_id`) REFERENCES `estados_solicitud` (`id`),
  CONSTRAINT `historial_estados_ibfk_3` FOREIGN KEY (`estado_nuevo_id`) REFERENCES `estados_solicitud` (`id`),
  CONSTRAINT `historial_estados_ibfk_4` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- -----------------------------------------------------
-- Tabla: usuario_rol
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `solicitud_final`.`usuario_rol` (
  `usuario_id` INT UNSIGNED NOT NULL,
  `rol_id` INT UNSIGNED NOT NULL,
  `asignado_desde` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`usuario_id`, `rol_id`),
  INDEX `rol_id` (`rol_id` ASC),
  CONSTRAINT `usuario_rol_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE,
  CONSTRAINT `usuario_rol_ibfk_2` FOREIGN KEY (`rol_id`) REFERENCES `roles` (`id`)
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- =============================================
-- AGREGAR COLUMNAS FALTANTES A SOLICITUDES
-- =============================================
ALTER TABLE `solicitud_final`.`solicitudes`
ADD COLUMN `tipo_servicio` ENUM('Refrigerio', 'Almuerzo') NULL AFTER `estado_id`,
ADD COLUMN `telefono` VARCHAR(30) NULL AFTER `tipo_servicio`,
ADD COLUMN `cargo_solicitante` VARCHAR(150) NULL AFTER `telefono`,
ADD COLUMN `nombre_evento` VARCHAR(255) NULL AFTER `cargo_solicitante`,
ADD COLUMN `lugar_evento` VARCHAR(255) NULL AFTER `nombre_evento`,
ADD COLUMN `fecha_inicio` DATE NULL AFTER `lugar_evento`,
ADD COLUMN `fecha_fin` DATE NULL AFTER `fecha_inicio`,
ADD COLUMN `cantidad_dias` INT UNSIGNED NULL AFTER `fecha_fin`,
ADD COLUMN `fondo_id` INT UNSIGNED NULL AFTER `cantidad_dias`,
ADD COLUMN `centro_costo_id` INT UNSIGNED NULL AFTER `fondo_id`,
ADD COLUMN `funcion_id` INT UNSIGNED NULL AFTER `centro_costo_id`,
ADD COLUMN `disponibilidad_presupuestal` DECIMAL(18,2) NULL AFTER `funcion_id`,
ADD INDEX `idx_solicitudes_fondo` (`fondo_id` ASC),
ADD INDEX `idx_solicitudes_centro_costo` (`centro_costo_id` ASC),
ADD INDEX `idx_solicitudes_funcion` (`funcion_id` ASC),
ADD CONSTRAINT `fk_solicitudes_fondo` FOREIGN KEY (`fondo_id`) REFERENCES `fondos` (`id`),
ADD CONSTRAINT `fk_solicitudes_centro_costo` FOREIGN KEY (`centro_costo_id`) REFERENCES `centros_costo` (`id`),
ADD CONSTRAINT `fk_solicitudes_funcion` FOREIGN KEY (`funcion_id`) REFERENCES `funcion` (`id`);

-- =============================================
-- DATOS DE CATÁLOGOS (INSERCIÓN)
-- =============================================
INSERT IGNORE INTO `fondos` (`nombre`, `codigo`) VALUES
('empleados', 'F001'),
('trabajo', 'F002'),
('general', 'F003');

INSERT IGNORE INTO `centros_costo` (`nombre`, `codigo`) VALUES
('Administración', 1001),
('Académico', 2001),
('Investigación', 3001);

INSERT IGNORE INTO `funcion` (`nombre`, `codigo`) VALUES
('Docencia', 'F01'),
('Extensión', 'F02'),
('Investigación', 'F03');

INSERT IGNORE INTO `dependencias` (`nombre`, `codigo`) VALUES
('Recursos Humanos', 'RH'),
('Tecnología de la Información', 'TI'),
('Bienestar Universitario', 'BU');

INSERT IGNORE INTO `estados_solicitud` (`nombre`, `descripcion`) VALUES
('Pendiente', 'Esperando revisión'),
('Aprobado', 'Aprobado por revisor'),
('Rechazado', 'Rechazado'),
('En tránsito', 'En proceso logístico'),
('Completada', 'Servicio finalizado');

INSERT IGNORE INTO `roles` (`nombre`, `descripcion`) VALUES
('solicitante', 'Usuario que crea solicitudes'),
('revisor', 'Usuario que aprueba o rechaza solicitudes');

-- =============================================
-- USUARIOS DE PRUEBA (contraseña: 1234)
-- Usando el hash real generado en tu servidor
-- =============================================
INSERT IGNORE INTO `usuarios` (`nombre`, `apellido`, `email`, `password_hash`, `cargo`, `activo`) VALUES
('Victoria', 'Barrios', 'victoriabarrios@cecar.edu.co', '$2y$10$7r2luMLkY5/3J2JdMbZ7w.VevwfM8zlhnoikrwr5RApd8raj5iSwe', 'Solicitante', 1),
('Yulianis', 'Oviedo', 'yulianisoviedo@cecar.edu.co', '$2y$10$7r2luMLkY5/3J2JdMbZ7w.VevwfM8zlhnoikrwr5RApd8raj5iSwe', 'Revisor', 1);

INSERT IGNORE INTO `usuario_rol` (`usuario_id`, `rol_id`) VALUES
(1, 1),
(2, 2);

-- =============================================
-- FIN DEL SCRIPT
-- =============================================
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;