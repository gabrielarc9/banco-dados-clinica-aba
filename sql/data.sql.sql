-- Bloco de Código: data.sql (Versão 3.0)
INSERT INTO Pacientes (nome_completo, data_nascimento) VALUES
('Ana Clara Gomes', '2018-05-10'), ('Bruno Viana', '2019-11-22');
INSERT INTO Terapeutas (nome_completo, registro_conselho) VALUES
('Dr. Lucas Mendes', 'CRP-06/12345'), ('Dra. Sofia Almeida', 'CRP-06/54321');
INSERT INTO ComportamentosAlvo (nome_comportamento, tipo_medicao) VALUES
('Pedir Ajuda', 'Frequencia'), ('Contato Visual', 'Frequencia'), ('Permanecer na Tarefa', 'Duracao');
INSERT INTO PlanosTratamento (paciente_id, comportamento_id, status_plano) VALUES
(1, 1, 'Ativo'), (1, 2, 'Ativo'), (2, 3, 'Ativo');
INSERT INTO Sessoes (paciente_id, terapeuta_id, data_hora_sessao, status_sessao) VALUES
(1, 1, '2025-11-10 09:00:00', 'Realizada'), (1, 1, '2025-11-12 09:00:00', 'Realizada'), (2, 2, '2025-11-10 10:00:00', 'Realizada');
INSERT INTO RegistrosSessao (sessao_id, plano_id, valor_medido) VALUES
(1, 1, 5), (1, 2, 10), (2, 1, 8), (2, 2, 12), (3, 3, 300);