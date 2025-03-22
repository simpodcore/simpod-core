import streamlit as st
import json
from datetime import datetime

# Título
st.title("SIMPOD – Execution Monitoring Panel")

# Carregar os dados simulados
with open("examples/simulation_data.json") as f:
    data = json.load(f)

executions = data.get("executions", [])

# Mostrar informações gerais
st.subheader("Executions Summary")
st.write(f"Total Executions: {len(executions)}")

# Mostrar detalhes das execuções
st.subheader("Execution Details")
for i, exec in enumerate(executions):
    st.markdown(f"### Execution #{i + 1}")
    st.write({
        "Bot": exec["bot"],
        "ROI (%)": exec["roiBasisPoints"] / 100,
        "Network": exec["network"],
        "Timestamp": datetime.fromisoformat(exec["timestamp"].replace("Z", "+00:00")).strftime("%Y-%m-%d %H:%M:%S"),
        "Tx Hash": exec["txHash"]
    })
    st.markdown("---")

# Rodapé
st.markdown("**Powered by SIMPOD + GPT**")