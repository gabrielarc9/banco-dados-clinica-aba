SELECT
    P.nome_completo AS Paciente,
    C.nome_comportamento AS Comportamento,
    C.tipo_medicao AS "Como Medir"
FROM
    Pacientes AS P
JOIN
    PlanosTratamento AS PT ON P.paciente_id = PT.paciente_id
JOIN
    ComportamentosAlvo AS C ON PT.comportamento_id = C.comportamento_id
WHERE
    P.nome_completo = 'Ana Clara Gomes' AND PT.status_plano = 'Ativo'