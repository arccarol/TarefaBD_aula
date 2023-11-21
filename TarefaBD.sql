CREATE DATABASE ex9
GO
USE ex9
GO
CREATE TABLE editora (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
site			VARCHAR(40)		NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
biografia		VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL	UNIQUE,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0.00),
codEditora		INT				NOT NULL,
codAutor		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo			INT				NOT NULL,
codEstoque		INT				NOT NULL,
qtdComprada		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
dataCompra		DATE			NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civiliza��o Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Mar�lia Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matem�tica da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Ling��stica Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ci�ncias da Computac�o pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Pol�tica',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de F�sica I',26,68.00,4,104),
(10005,'Geometria Anal�tica',1,95.00,3,105),
(10006,'Gram�tica Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de F�sica III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00,'04/07/2021'),
(15051,10008,1,95.00,'04/07/2021'),
(15051,10004,1,68.00,'04/07/2021'),
(15051,10007,1,78.00,'04/07/2021'),
(15052,10006,1,49.00,'05/07/2021'),
(15052,10002,3,165.00,'05/07/2021'),
(15053,10001,1,108.00,'05/07/2021'),
(15054,10003,1,79.00,'06/08/2021'),
(15054,10008,1,95.00,'06/08/2021')

SELECT SUM (C.valor / C.qtdComprada) As valorUnitario,
       A.nome,
       E.nome
FROM autor A
INNER JOIN estoque E ON E.codAutor = A.codigo
INNER JOIN editora ED ON ED.codigo = E.codEditora
INNER JOIN compra C ON C.codEstoque = E.codigo
WHERE 
   E.codAutor = 102 
   OR E.codAutor = 103
   OR E.codAutor = 104
   OR E.codAutor = 106
GROUP BY E.nome, A.nome

SELECT E.nome,
       C.qtdComprada,
	   C.valor
FROM estoque E
INNER JOIN compra C ON C.codEstoque = E.codigo
WHERE C.codigo = 15051

SELECT  E.nome,
        ED.site
FROM estoque E
INNER JOIN editora ED ON ED.codigo = E.codEditora
WHERE ED.nome = 'Makron Books'

SELECT E.nome,
       A.biografia
FROM estoque E
INNER JOIN autor A ON a.codigo = E.codAutor
WHERE 
    A.nome = 'David Halliday'

SELECT  C.codigo,
        C.qtdComprada
FROM compra C
INNER JOIN estoque E ON E.codigo = C.codEstoque
WHERE E.nome = 'Sistemas Operacionais Modernos'

SELECT E.nome
FROM estoque E
WHERE NOT EXISTS(
      SELECT 1
	  FROM compra C
	  WHERE C.codEstoque = E.codigo);

SELECT E.nome
FROM estoque E
INNER JOIN compra C ON C.codEstoque = E.codigo
WHERE C.codEstoque IS NULL;

SELECT E.nome,
       E.site
FROM editora E
WHERE NOT EXISTS(
      SELECT 1
	  FROM estoque ES
	  WHERE ES.codEditora = E.codigo);

SELECT A.nome,
       A.biografia
FROM autor A
WHERE NOT EXISTS(
          SELECT 1
		  FROM estoque E
		  WHERE E.codAutor = A.codigo);

SELECT A.nome, 
       MAX(E.valor / E.quantidade) AS valorMaximo
FROM estoque E
INNER JOIN autor A ON A.codigo = E.codAutor
GROUP BY A.nome
ORDER BY valorMaximo DESC;

SELECT C.codigo,
       SUM(C.qtdComprada) AS TotalLivrosComprados,
	   SUM(C.valor) As somaValoresGastos
FROM compra C
INNER JOIN estoque E ON E.codigo = C.codEstoque
GROUP BY C.codigo
ORDER BY C.codigo ASC;

SELECT E.nome,
       AVG(ES.valor / ES.quantidade) As MediaValor
FROM editora E
INNER JOIN estoque ES ON ES.codEditora = E.codigo
GROUP BY E.nome
ORDER BY MediaValor ASC;

SELECT E.codigo,
       E.nome,
	   A.nome,
	   ED.nome + '  ' + ED.site AS InfoEditora
FROM estoque E
INNER JOIN autor A ON A.codigo = E.codAutor
INNER JOIN editora ED ON ED.codigo = E.codEditora
WHERE ED.site IS NOT NULL;

SELECT codigo,
       SUM(valor) As somaValores
FROM compra 
GROUP BY codigo
HAVING SUM(valor) > 200.00

       

    











    





