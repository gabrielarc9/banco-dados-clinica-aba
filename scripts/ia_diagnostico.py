# Arquivo: ia.py

import os
import psycopg2
import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.preprocessing import LabelEncoder

# 1. conexão
DB_CONNECTION_STRING = os.environ.get('SUPABASE_DB_URL')
if not DB_CONNECTION_STRING:
    print("Erro: Defina a variável SUPABASE_DB_URL.")
    exit()

try:
    print("1. Conectando ao cérebro (Banco de Dados)...")
    conn = psycopg2.connect(DB_CONNECTION_STRING)

    # 2. BUSCAR DADOS
    query = """
    SELECT
        A.descricao AS antecedente,
        C.nome_comportamento AS comportamento,
        CQ.categoria AS consequencia_real
    FROM RegistrosABC AS R
    JOIN Dicionario_Antecedentes AS A ON R.antecedente_id = A.antecedente_id
    JOIN Dicionario_Comportamentos AS C ON R.comportamento_id = C.comportamento_id
    JOIN Dicionario_Consequencias AS CQ ON R.consequencia_id = CQ.consequencia_id;
    """
    df = pd.read_sql_query(query, conn)
    conn.close()

    if df.empty:
        print("Sem dados para treinar!")
        exit()

    print(f"2. Dados carregados: {len(df)} registros encontrados.")

    # 3. Tradução
    le_antecedente = LabelEncoder()
    le_comportamento =  LabelEncoder ()

    df ['ant_code'] = le_antecedente.fit_transform(df['antecedente'])
    df ['comp_code'] = le_comportamento.fit_transform(df['comportamento'])

    X = df[['ant_code', 'comp_code']]
    y = df['consequencia_real']

    # 4.TREINAMENTO
    print ("3. Treinando o modelo de IA...")
    modelo = DecisionTreeClassifier()
    modelo.fit(X, y)
    print(" -> Modelo treinado com sucesso!")

    # 5. TESTE DE PREVISÃO
    print("\n--- TESTE DE IA ---")

    # TRUQUE: Em vez de digitar, pegamos o texto direto da memória da IA
    # O índice [1] deve ser "Terapeuta apresentou instrução..."
    # O índice [0] deve ser "Gritar"
    try:
        texto_antecedente = le_antecedente.classes_[1]
        texto_comportamento = le_comportamento.classes_[0]
    except:
        texto_antecedente = le_antecedente.classes_[0]
        texto_comportamento = le_comportamento.classes_[0]

    # Tranforma o texto em números
    val_ant = le_antecedente.transform([texto_antecedente])[0]
    val_comp = le_comportamento.transform([texto_comportamento])[0]

    # A Mágica
    previsao = modelo.predict([[val_ant, val_comp]])

    print(f"Cenário Analisado:")
    print(f" Antecedente: {texto_antecedente}")
    print(f" Comportamento: {texto_comportamento}")
    print("-" * 30)
    print(f"-> A IA diagnostica a função como: {previsao[0]}")
    print("-" * 30)

except Exception as e:
    print(f"Erro geral: {e}")