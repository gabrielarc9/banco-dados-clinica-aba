CREATE TABLE Pacientes (
    paciente_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_completo VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL
    );
CREATE TABLE Terapeutas(
    terapeuta_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_completo VARCHAR(100) NOT NULL,
    registro_conselho VARCHAR(20) NOT NULL UNIQUE
    );
CREATE TABLE Sessoes (
    sessao_id INTEGER PRIMARY KEY AUTOINCREMENT,
    paciente_id INTEGER NOT NULL,
    terapeuta_id INTEGER NOT NULL,
    data_hora_sessao TIMESTAMP NOT NULL,
    status_sessao VARCHAR(20) DEFAULT 'agendada',

    CONSTRAINT fk_paciente
        FOREIGN KEY (paciente_id)
        REFERENCES Pacientes(paciente_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_terapeuta
        FOREIGN KEY (terapeuta_id)
        REFERENCES Terapeutas(terapeuta_id)
        ON DELETE CASCADE
    );
CREATE TABLE ComportamentosAlvo (
    comportamento_id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome_comportamento VARCHAR(100) NOT NULL,
    tipo_medicao VARCHAR (20) NOT NULL
    );
CREATE TABLE PlanosTratamento (
    plano_id INTEGER PRIMARY KEY AUTOINCREMENT,
    paciente_id INTEGER NOT NULL,
    comportamento_id INTEGER NOT NULL,
    status_plano VARCHAR(20) DEFAULT 'ativo',
    
CONSTRAINT fk_plano_paciente 
    FOREIGN KEY (paciente_id) 
    REFERENCES Pacientes(paciente_id),
    CONSTRAINT fk_plano_comportamento 
    FOREIGN KEY (comportamento_id) 
    REFERENCES ComportamentosAlvo(comportamento_id),
    UNIQUE(paciente_id, comportamento_id)
    );
CREATE TABLE RegistrosSessao (
    registro_id INTEGER PRIMARY KEY AUTOINCREMENT,
    sessao_id INTEGER NOT NULL,
    plano_id INTEGER NOT NULL,
    valor_medido REAL NOT NULL,
    
    CONSTRAINT fk_reg_sessao
        FOREIGN KEY (sessao_id)
        REFERENCES Sessoes(sessao_id),
    CONSTRAINT fk_reg_plano
        FOREIGN KEY (plano_id)
        REFERENCES PLanosTratamento(plano_id)
    );
