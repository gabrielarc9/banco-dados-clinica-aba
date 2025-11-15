-- Arquivo: consultas_analise.sql
-- Um menu de consultas analíticas para demonstrar o poder do banco.

-- CONSULTA 1: Log ABC completo da Sessão 1 (V4a)
SELECT 
    R.timestamp_evento AS Horario,
    P.nome_completo AS Paciente,
    A.descricao AS Antecedente,
    C.nome_comportamento AS Comportamento,
    CQ.descricao AS Consequencia
FROM RegistrosABC AS R
JOIN Sessoes AS S ON R.sessao_id = S.sessao_id
JOIN Pacientes AS P ON S.paciente_id = P.paciente_id
JOIN Dicionario_Antecedentes AS A ON R.antecedente_id = A.antecedente_id
JOIN Dicionario_Comportamentos AS C ON R.comportamento_id = C.comportamento_id
JOIN Dicionario_Consequencias AS CQ ON R.consequencia_id = CQ.consequencia_id
WHERE S.sessao_id = 1
ORDER BY R.timestamp_evento;

-- CONSULTA 2: Análise de Função (Sugestão para IA) - V4a
SELECT 
    CQ.descricao AS Consequencia_Comum,
    COUNT(R.registro_abc_id) AS Frequencia_Total
FROM RegistrosABC AS R
JOIN Dicionario_Consequencias AS CQ ON R.consequencia_id = CQ.consequencia_id
JOIN Dicionario_Comportamentos AS C ON R.comportamento_id = C.comportamento_id
WHERE C.nome_comportamento = 'Jogar Objeto'
GROUP BY CQ.descricao
ORDER BY Frequencia_Total DESC;

-- CONSULTA 3: Cálculo de Porcentagem (V4b)
SELECT
    F.folha_id,
    C.nome_comportamento,
    (SUM(CASE WHEN D.ocorreu THEN 1 ELSE 0 END) * 100.0 / COUNT(D.numero_intervalo)) AS porcentagem_ocorrencia
FROM FolhasRegistroIntervalo AS F
JOIN DadosIntervalo AS D ON F.folha_id = D.folha_id
JOIN Dicionario_Comportamentos AS C ON F.comportamento_id = C.comportamento_id
WHERE F.folha_id = 1
GROUP BY F.folha_id, C.nome_comportamento;

-- CONSULTA 4: Relatório de Progresso vs. Meta (V5)
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