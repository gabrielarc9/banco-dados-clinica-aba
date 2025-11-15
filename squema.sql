### Bloco 3: O Schema Completo

(Crie este arquivo e combine TODOS os scripts de `schema.sql` (V4a, V4b, V5) que rodamos com sucesso)

```sql
-- Arquivo: schema_completo.sql
-- Este script cria a ESTRUTURA COMPLETA do banco V5.
-- Execute-o em um banco PostgreSQL limpo.

-- === SCHEMA V4a (ABC) ===
CREATE TABLE Pacientes (
    paciente_id SERIAL PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL
);

CREATE TABLE Terapeutas (
    terapeuta_id SERIAL PRIMARY KEY,
    nome_completo VARCHAR(100) NOT NULL,
    registro_conselho VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Sessoes (
    sessao_id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL REFERENCES Pacientes(paciente_id),
    terapeuta_id INT NOT NULL REFERENCES Terapeutas(terapeuta_id),
    data_hora_sessao TIMESTAMP NOT NULL,
    status_sessao VARCHAR(20) DEFAULT 'Agendada'
);

CREATE TABLE Dicionario_Antecedentes (
    antecedente_id SERIAL PRIMARY KEY,
    categoria VARCHAR(50),
    descricao TEXT NOT NULL
);

CREATE TABLE Dicionario_Comportamentos (
    comportamento_id SERIAL PRIMARY KEY,
    nome_comportamento VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE Dicionario_Consequencias (
    consequencia_id SERIAL PRIMARY KEY,
    categoria VARCHAR(50),
    descricao TEXT NOT NULL
);

CREATE TABLE RegistrosABC (
    registro_abc_id SERIAL PRIMARY KEY,
    sessao_id INT NOT NULL REFERENCES Sessoes(sessao_id),
    antecedente_id INT NOT NULL REFERENCES Dicionario_Antecedentes(antecedente_id),
    comportamento_id INT NOT NULL REFERENCES Dicionario_Comportamentos(comportamento_id),
    consequencia_id INT NOT NULL REFERENCES Dicionario_Consequencias(consequencia_id),
    timestamp_evento TIMESTAMP NOT NULL DEFAULT NOW(),
    notas_observacao TEXT
);

-- === SCHEMA V4b (Intervalo) ===
CREATE TABLE FolhasRegistroIntervalo (
    folha_id SERIAL PRIMARY KEY,
    sessao_id INT NOT NULL REFERENCES Sessoes(sessao_id),
    comportamento_id INT NOT NULL REFERENCES Dicionario_Comportamentos(comportamento_id),
    total_intervalos INT NOT NULL,
    duracao_intervalo_seg INT NOT NULL,
    tipo_registro VARCHAR(50) NOT NULL
);

CREATE TABLE DadosIntervalo (
    dado_id SERIAL PRIMARY KEY,
    folha_id INT NOT NULL REFERENCES FolhasRegistroIntervalo(folha_id) ON DELETE CASCADE,
    numero_intervalo INT NOT NULL,
    ocorreu BOOLEAN NOT NULL,
    UNIQUE(folha_id, numero_intervalo)
);

-- === SCHEMA V5 (Metas) ===
CREATE TABLE Metas (
    meta_id SERIAL PRIMARY KEY,
    paciente_id INT NOT NULL REFERENCES Pacientes(paciente_id),
    comportamento_id INT NOT NULL REFERENCES Dicionario_Comportamentos(comportamento_id),
    descricao TEXT,
    tipo_meta VARCHAR(50) NOT NULL,
    tipo_dado_rastreio VARCHAR(50) NOT NULL,
    criterio_texto VARCHAR(255),
    criterio_valor_alvo DECIMAL,
    criterio_unidade VARCHAR(20),
    status_meta VARCHAR(20) DEFAULT 'Ativo'
);