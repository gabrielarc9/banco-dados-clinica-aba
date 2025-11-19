# Arquivo: main.py (VERSÃO FINAL - CORREÇÃO DE COLUNAS MINÚSCULAS)

import os
import psycopg2
import pandas as pd
import matplotlib.pyplot as plt

# --- 1. CONEXÃO SEGURA ---
DB_CONNECTION_STRING = os.environ.get('SUPABASE_DB_URL') 

if not DB_CONNECTION_STRING:
    print("Erro: A variável de ambiente SUPABASE_DB_URL não foi definida.")
    exit()

# --- 2. A CONSULTA ---
query = """
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
    DR.data_hora_sessao AS Data_Sessao
FROM Metas AS M
JOIN Pacientes AS P ON M.paciente_id = P.paciente_id
JOIN Dicionario_Comportamentos AS C ON M.comportamento_id = C.comportamento_id
JOIN DadosReais AS DR ON M.paciente_id = DR.paciente_id AND M.comportamento_id = DR.comportamento_id
WHERE M.status_meta = 'Ativo';
"""

# --- 3. EXECUTANDO A ANÁLISE ---
try:
    print("Conectando ao banco de dados...")
    conn = psycopg2.connect(DB_CONNECTION_STRING) 
    
    print("Buscando dados de progresso...")
    # Aviso: O Pandas pode dar um Warning sobre SQLAlchemy aqui. Pode ignorar por enquanto.
    df = pd.read_sql_query(query, conn)
    
    conn.close()

    # --- 4. GERANDO O GRÁFICO ---
    if df.empty:
        print("A consulta não retornou dados. Verifique seu banco.")
    else:
        print("Dados encontrados. Gerando gráfico...")

        # CORREÇÃO CRUCIAL: Nomes das colunas em minúsculas
        paciente_nome = df['paciente'].iloc[0]
        comportamentos = df['comportamento_alvo'].iloc[0] 
        meta = df['meta_porcentagem'].iloc[0]
        real = df['real_porcentagem'].iloc[0]

        labels = ['Meta Definida', 'Desempenho Real']
        valores = [meta, real]

        plt.figure(figsize=(10, 6))
        # Define as cores: Azul para meta, Vermelho para real (alerta) ou Verde se estiver bom
        bars = plt.bar(labels, valores, color=['blue', 'orange'])

        plt.title(f"Progresso do Paciente: {paciente_nome}\nComportamento: {comportamentos}")
        plt.ylabel("Porcentagem de Ocorrência (%)")
        
        # Define o limite do gráfico um pouco acima do maior valor
        plt.ylim(0, max(meta, real) + 20)

        # Escreve os números em cima das barras
        for bar in bars:
            yval = bar.get_height()
            plt.text(bar.get_x() + bar.get_width()/2.0, yval + 1, f'{yval:.1f}%', ha='center', va='bottom')

        nome_arquivo = "relatorio_progresso.png"
        plt.savefig(nome_arquivo)

        print(f"\nSucesso! Gráfico salvo como: {nome_arquivo}")

except Exception as e:
    print(f"Ocorreu um erro: {e}")