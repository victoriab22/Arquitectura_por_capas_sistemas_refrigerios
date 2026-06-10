<?php

class Conexion
{
    private $host = "127.0.0.1";
    private $port = "3307";          
    private $db = "solicitud_final";
    private $usuario = "root";
    private $password = "";

    public function conectar()
    {
        try {
            $pdo = new PDO(
                "mysql:host={$this->host};port={$this->port};dbname={$this->db};charset=utf8mb4",
                $this->usuario,
                $this->password
            );

            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            return $pdo;

        } catch(PDOException $e) {
            die("Error de conexión: " . $e->getMessage());
        }
    }
}