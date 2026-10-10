"""Spese erario — composizione e costo per procedimento."""

import plotly.express as px
import plotly.graph_objects as go
import streamlit as st

from lab_connectors.formatters import fmt_eur
from sources import QUADRO_YEAR, load_quadro, load_spese_composizione

st.title("💰 Spese di giustizia")

comp = load_spese_composizione()
quadro = load_quadro(QUADRO_YEAR)

if comp.empty:
    st.warning("Nessun dato disponibile.")
    st.stop()

# -- Composizione nel tempo --------------------------------------------------
st.subheader("Composizione nazionale nel tempo")
tipo_order = sorted(comp["tipo_spesa"].unique())
fig = go.Figure()
colors = {"onorari": "#6366f1", "spese": "#f59e0b", "indennita": "#10b981", "altro": "#94a3b8"}
for t in tipo_order:
    df = comp[comp["tipo_spesa"] == t].sort_values("anno")
    fig.add_trace(go.Bar(
        x=df["anno"], y=df["importo_totale"] / 1e6,
        name=t,
        marker_color=colors.get(t),
    ))
fig.update_layout(barmode="stack", height=420, margin={"t": 20, "b": 40},
                  legend_orientation="h", yaxis_title="Milioni di €")
st.plotly_chart(fig, width="stretch")

st.caption(
    "Nota: per il 2025 la fonte è cambiata (Modello 1/A/SG → DATALAKE/SIAMM). "
    "Le righe NAZIONALE/INTERDISTRETTUALE sono voci reali compaiono solo dal 2025."
)

st.divider()

# -- Quota onorari -----------------------------------------------------------
st.subheader("Quota onorari sulla spesa totale")
onor = comp[comp["tipo_spesa"] == "onorari"].sort_values("anno")
tot = comp.groupby("anno", as_index=False)["importo_totale"].sum()
q = onor.merge(tot, on="anno", suffixes=("_onor", "_tot"))
q["quota"] = q["importo_totale_onor"] / q["importo_totale_tot"] * 100
fig_q = go.Figure(go.Scatter(
    x=q["anno"], y=q["quota"], mode="lines+markers",
    line=dict(color="#6366f1", width=3),
))
fig_q.update_layout(height=320, margin={"t": 20, "b": 40},
                    yaxis_title="% della spesa erario")
st.plotly_chart(fig_q, width="stretch")

st.divider()

# -- Euro per procedimento ---------------------------------------------------
st.subheader("Costo per procedimento civile definito (2025)")
fig_bar = px.bar(
    quadro.sort_values("euro_per_procedimento_civ", ascending=True),
    x="euro_per_procedimento_civ", y="distretto", orientation="h",
    labels={"euro_per_procedimento_civ": "€ / procedimento", "distretto": ""},
    color="euro_per_procedimento_civ",
    color_continuous_scale=["#10b981", "#f59e0b", "#ef4444"],
)
med = quadro["euro_per_procedimento_civ"].median()
fig_bar.add_vline(x=med, line_dash="dot", annotation_text=f"mediana {fmt_eur(med)}")
fig_bar.update_layout(height=700, margin={"t": 20, "b": 40}, coloraxis_showscale=False)
st.plotly_chart(fig_bar, width="stretch")

with st.expander("Dettaglio spesa per distretto"):
    show = quadro[["distretto", "spesa_totale", "civ_definiti", "euro_per_procedimento_civ"]].copy()
    show["spesa_totale_mln"] = (show["spesa_totale"] / 1e6).round(1)
    st.dataframe(
        show.sort_values("spesa_totale", ascending=False).drop(columns="spesa_totale"),
        width="stretch", hide_index=True,
    )
