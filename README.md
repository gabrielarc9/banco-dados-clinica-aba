# Projeto de Banco de Dados V5: Clínica de Análise do Comportamento (ABA)

Este é um projeto de portfólio que demonstra a criação de um banco de dados relacional (PostgreSQL) para uma clínica de Análise do Comportamento Aplicada (ABA).

O banco foi projetado para ser uma fundação robusta para uma aplicação de software (WebApp, IA) e é capaz de lidar com os dois principais métodos de coleta de dados de ABA:

1.  **Análise Funcional (ABC)** (V4a)
2.  **Registro por Intervalo** (V4b)
3.  **Rastreio de Metas** (V5)

## 🚀 Tecnologias Utilizadas
* **Banco de Dados:** PostgreSQL
* **Hospedagem (Exemplo):** Supabase
* **Linguagem:** SQL

## 🧠 O que este Banco de Dados Faz?
Este schema resolve os problemas centrais da coleta de dados em ABA:

* **V4a (Análise ABC):** Permite o registro de Antecedente-Comportamento-Consequência usando "Dicionários" padronizados, tornando os dados limpos para análise de IA.
* **V4b (Registro por Intervalo):** Permite o registro de dados de "Sim/Não" em intervalos de tempo (ex: 60 intervalos de 1 minuto), o que é crucial para calcular a porcentagem de ocorrência.
* **V5 (Metas):** Cria uma camada de "inteligência" que define metas terapêuticas (ex: "Reduzir comportamento X para < 20%") e usa SQL para comparar a meta com os dados reais coletados.

## 🛠️ Como Usar
Este repositório contém os *scripts* para construir o banco, não o banco em si.

1.  **Crie um Banco:** Crie um novo banco de dados PostgreSQL (ex: em um projeto gratuito do Supabase).
2.  **Execute o Schema:** Copie e execute o conteúdo de `schema_completo.sql` no seu editor SQL. Isso criará todas as 11 tabelas.
3.  **Execute os Dados:** Copie e execute o conteúdo de `data_completo.sql` para popular o banco com dados de exemplo.
4.  **Analise:** Execute as consultas em `consultas_analise.sql` para ver o sistema em ação.

## 📈 Consulta de Exemplo (A "Mágica" da V5)
A consulta a seguir une 5 tabelas e uma subconsulta para comparar automaticamente a meta de um paciente com seu desempenho real, gerando um relatório de progresso.

```sql
-- CONSULTA 5: (O "RELATÓRIO DE PROGRESSO FINAL")
WITH DadosReais AS (
    SELECT
        F.folha_id, S.paciente_id, F.comportamento_id, S.data_hora_sessao,
        (SUM(CASE WHEN D.ocorreu THEN 1 ELSE 0 END) * 100.0 / COUNT(D.numero_intervalo)) AS porcentagem_real
    FROM FolhasRegistroIntervalo AS F
    JOIN DadosIntervalo AS D ON F.folha_id = D.folha_id
    JOIN Sessoes AS S ON F.sessao_id = S.sessao_id
    GROUP BY F.folha_id, S.paciente_id, F.comportamento_id, S.data_hora_sessao
)
SELECT 
    P.nome_completo AS Paciente,
    C.nome_comportamento AS Comportamento_Alvo,
    M.criterio_valor_alvo AS Meta_Porcentagem,
    DR.porcentagem_real AS Real_Porcentagem,
    (DR.porcentagem_real - M.criterio_valor_alvo) AS Diferenca_Para_Meta
FROM Metas AS M
JOIN Pacientes AS P ON M.paciente_id = P.paciente_id
JOIN Dicionario_Comportamentos AS C ON M.comportamento_id = C.comportamento_id
JOIN DadosReais AS DR ON M.paciente_id = DR.paciente_id AND M.comportamento_id = DR.comportamento_id
WHERE M.status_meta = 'Ativo';
