-- Arquivo: data_completo.sql
-- Este script POPULA o banco com dados de exemplo.
-- Execute-o DEPOIS do schema_completo.sql

-- === DADOS V4a (ABC) ===
INSERT INTO Pacientes (nome_completo, data_nascimento) VALUES
('Ana Clara Gomes', '2018-05-10');
INSERT INTO Terapeutas (nome_completo, registro_conselho) VALUES
('Dr. Lucas Mendes', 'CRP-06/12345');
INSERT INTO Sessoes (paciente_id, terapeuta_id, data_hora_sessao, status_sessao) VALUES
(1, 1, '2025-11-15 10:00:00', 'Realizada');

INSERT INTO Dicionario_Antecedentes (categoria, descricao) VALUES
('Demanda', 'Terapeuta apresentou instrução de tarefa'),
('Atenção', 'Terapeuta desviou a atenção (ex: celular)'),
('Transição', 'Paciente foi instruído a mudar de atividade');

INSERT INTO Dicionario_Comportamentos (nome_comportamento) VALUES
('Gritar'),
('Jogar Objeto'),
('Pedido verbal adequado (ex: "ajuda")');

INSERT INTO Dicionario_Consequencias (categoria, descricao) VALUES
('Reforço Negativo', 'Demanda foi removida (tarefa retirada)'),
('Atenção', 'Terapeuta forneceu atenção (verbal ou física)'),
('Reforço Positivo', 'Terapeuta elogiou e entregou reforçador');

INSERT INTO RegistrosABC (sessao_id, antecedente_id, comportamento_id, consequencia_id, timestamp_evento)
VALUES
(1, 1, 2, 1, '2025-11-15 10:05:00'),
(1, 2, 1, 2, '2025-11-15 10:15:00'),
(1, 1, 3, 3, '2025-11-15 10:20:00');

-- === DADOS V4b (Intervalo) ===
INSERT INTO FolhasRegistroIntervalo 
    (sessao_id, comportamento_id, total_intervalos, duracao_intervalo_seg, tipo_registro)
VALUES
    (1, 1, 10, 60, 'Parcial');

INSERT INTO DadosIntervalo (folha_id, numero_intervalo, ocorreu)
VALUES
(1, 1, false), (1, 2, true), (1, 3, true), (1, 4, false), (1, 5, false),
(1, 6, false), (1, 7, false), (1, 8, true), (1, 9, false), (1, 10, false);

-- === DADOS V5 (Metas) ===
INSERT INTO Metas 
    (paciente_id, comportamento_id, descricao, tipo_meta, 
     tipo_dado_rastreio, criterio_texto, criterio_valor_alvo, criterio_unidade, status_meta)
VALUES
    (
        1, 1, 'Reduzir comportamento de gritar para < 20% dos intervalos',
        'Redução', 'Intervalo', 'Alcançar menos de 20% dos intervalos por 3 sessões consecutivas',
        20.0, 'Porcentagem', 'Ativo'
    );