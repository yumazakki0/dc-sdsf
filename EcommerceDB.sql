-- ============================================================
-- CRIAÇÃO DO BANCO DE DADOS
-- ============================================================
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- ============================================================
-- 1. TABELA CLIENTES
-- Guarda informações das pessoas que compram no sistema
-- ============================================================
CREATE TABLE Clientes (
    ID_Cliente INT PRIMARY KEY AUTO_INCREMENT,   -- Identificador único do cliente
    Nome VARCHAR(150) NOT NULL,                  -- Nome completo do cliente
    Email VARCHAR(150) UNIQUE NOT NULL,          -- Email único
    Endereco VARCHAR(255),                       -- Endereço completo
    Telefone VARCHAR(20)                         -- Telefone para contato
);

-- ============================================================
-- INSERINDO DADOS NA TABELA CLIENTES
-- Dados reais para simular um e-commerce
-- ============================================================
INSERT INTO Clientes (Nome, Email, Endereco, Telefone) VALUES
('Lucas Andrade', 'lucas.andrade@gmail.com', 'Rua das Flores, 120 - São Paulo', '11988776655'),
('Mariana Ribeiro', 'mariana.rib@gmail.com', 'Av. Paulista, 900 - São Paulo', '11999887766'),
('Carlos Teixeira', 'carlos.tx@hotmail.com', 'Rua das Acácias, 45 - Rio de Janeiro', '21977889966'),
('Ana Beatriz', 'ana.bia@gmail.com', 'Rua do Carmo, 210 - Curitiba', '41966554433');

-- ============================================================
-- 2. TABELA PRODUTOS
-- Catálogo de todos os produtos disponíveis para venda
-- ============================================================
CREATE TABLE Produtos (
    ID_Produto INT PRIMARY KEY AUTO_INCREMENT,   -- Identificador único do produto
    Nome_Produto VARCHAR(200) NOT NULL,          -- Nome do produto
    Descricao TEXT,                               -- Descrição detalhada do produto
    Preco DECIMAL(10,2) NOT NULL,                -- Preço unitário
    Qtd_Estoque INT NOT NULL                     -- Quantidade disponível no estoque
);

-- ============================================================
-- INSERINDO DADOS NA TABELA PRODUTOS
-- Produtos reais, com descrição e preço
-- ============================================================
INSERT INTO Produtos (Nome_Produto, Descricao, Preco, Qtd_Estoque) VALUES
('Teclado Mecânico Redragon Kumara', 'Teclado mecânico switch Redragon blue, RGB', 189.90, 35),
('Mouse Gamer Logitech G203', 'Sensor HERO 8000 DPI com RGB personalizável', 129.99, 50),
('Monitor LG 24” Full HD', 'Monitor IPS com 75Hz e Freesync', 899.00, 20),
('Headset HyperX Cloud II', 'Som surround virtual 7.1, espuma especial memory foam', 499.90, 15),
('Cadeira Gamer ThunderX3', 'Cadeira ergonômica com apoio lombar', 1299.00, 7);

-- ============================================================
-- 3. TABELA PEDIDOS
-- Representa a compra feita por um cliente
-- ============================================================
CREATE TABLE Pedidos (
    ID_Pedido INT PRIMARY KEY AUTO_INCREMENT,    -- Identificador único do pedido
    ID_Cliente_FK INT NOT NULL,                  -- Chave estrangeira que liga ao cliente
    Data_Pedido DATETIME NOT NULL,               -- Data e hora da compra
    Valor_Total DECIMAL(10,2),                   -- Valor total do pedido
    Previsao_Entrega DATE,                       -- Data prevista para entrega
    Status_Pedido VARCHAR(50),                   -- Status atual do pedido
    FOREIGN KEY (ID_Cliente_FK) REFERENCES Clientes(ID_Cliente) -- Relacionamento
);

-- ============================================================
-- INSERINDO DADOS NA TABELA PEDIDOS
-- Simulação de pedidos reais
-- ============================================================
INSERT INTO Pedidos (ID_Cliente_FK, Data_Pedido, Valor_Total, Previsao_Entrega, Status_Pedido) VALUES
(1, '2025-11-10 14:33:00', 319.89, '2025-11-17', 'Processando'),
(2, '2025-11-11 09:21:00', 1899.90, '2025-11-20', 'Enviado'),
(3, '2025-11-11 19:45:00', 129.99, '2025-11-16', 'Aguardando Pagamento');

-- ============================================================
-- 4. TABELA ITENS_PEDIDO
-- Mostra quais produtos fazem parte de quais pedidos
-- TABELA DE RELACIONAMENTO (N:N)
-- ============================================================
CREATE TABLE Itens_Pedido (
    ID_Pedido_FK INT NOT NULL,                   -- FK ligada ao pedido
    ID_Produto_FK INT NOT NULL,                  -- FK ligada ao produto
    Quantidade INT NOT NULL,                     -- Quantidade comprada
    Preco_Unitario DECIMAL(10,2) NOT NULL,       -- Preço do produto no momento da compra
    PRIMARY KEY (ID_Pedido_FK, ID_Produto_FK),   -- Chave primária composta
    FOREIGN KEY (ID_Pedido_FK) REFERENCES Pedidos(ID_Pedido),
    FOREIGN KEY (ID_Produto_FK) REFERENCES Produtos(ID_Produto)
);

-- ============================================================
-- INSERINDO ITENS NOS PEDIDOS
-- Liga produtos aos pedidos com quantidade e preço
-- ============================================================
INSERT INTO Itens_Pedido VALUES
(1, 1, 1, 189.90),   -- Pedido 1: Teclado
(1, 2, 1, 129.99),   -- Pedido 1: Mouse

(2, 3, 1, 899.00),   -- Pedido 2: Monitor
(2, 5, 1, 1299.00),  -- Pedido 2: Cadeira

(3, 2, 1, 129.99);   -- Pedido 3: Mouse

-- ============================================================
-- MOSTRAR AS TABELAS (SELECTS PARA APRESENTAÇÃO)
-- ============================================================

-- Mostrar clientes cadastrados
SELECT * FROM Clientes;

-- Mostrar lista de produtos
SELECT * FROM Produtos;

-- Mostrar pedidos e seus detalhes
SELECT * FROM Pedidos;

-- Mostrar itens de cada pedido (JOIN completo)
SELECT 
    p.ID_Pedido,
    c.Nome AS Cliente,
    pr.Nome_Produto,
    ip.Quantidade,
    ip.Preco_Unitario
FROM Itens_Pedido ip
JOIN Pedidos p ON ip.ID_Pedido_FK = p.ID_Pedido
JOIN Produtos pr ON ip.ID_Produto_FK = pr.ID_Produto
JOIN Clientes c ON p.ID_Cliente_FK = c.ID_Cliente;

-- ============================================================
-- 3 COMANDOS EXIGIDOS PARA A AVALIAÇÃO
-- ============================================================

-- 1) ALTER TABLE -> adicionar coluna para observações
ALTER TABLE Pedidos
ADD Observacoes VARCHAR(255);

-- 2) UPDATE -> mudar status de um pedido
UPDATE Pedidos
SET Status_Pedido = 'Entregue'
WHERE ID_Pedido = 1;

-- 3) UPDATE -> reduzir estoque após venda
UPDATE Produtos
SET Qtd_Estoque = Qtd_Estoque - 1
WHERE ID_Produto = 3;
