"""Distretto singolo — serie storiche civile e penale."""

import plotly.graph_objects as go
import streamlit as st
from plotly.subplots import make_subplots

from lab_connectors.formatters import fmt_eur, fmt_num, fmt_pct
from sources import (
    QUADRO_YEAR,
    load_clearance_trend,
    load_flussi_trend,
    load_quadro,
)

st.title("📍 Distretto per distretto")

quadro = load_quadro(QUADRO_YEAR)
if quadro.empty:
    st.warning("Nessun dato disponibile.")
    st.stop()

distretti = sorted(quadro["distretto"].unique())
distretto = st.selectbox("Distretto", distretti, index=distretti.index("Roma") if "Roma" in distretti else 0)

row = quadro[quadro["distretto"] == distretto].iloc[0]

k1, k2, k3, k4, k5 = st.columns(5)
k1.metric("Clearance civile", f"{row['civ_clearance']:.2f}", delta_color="inverse")
k2.metric("DT civile", f"{fmt_num(row['civ_disposition_gg'])} gg", delta_color="inverse")
k3.metric("Penale > 2 anni", fmt_pct(row["quota_penale_oltre_2anni"] / 100), delta_color="inverse")
k4.metric("€ / procedimento civile", fmt_eur(row["euro_per_procedimento_civ"]))
pnrr_delta = None if row["pnrr_pct_target"] is None else f"{row['pnrr_pct_target']:.0f}% del target"
k5.metric("PNRR pendenti", fmt_num(row["pnrr_pendenti"]), delta=pnrr_delta, delta_color="inverse")

st.divider()

# -- Flussi trend ------------------------------------------------------------
fc = load_flussi_trend("civile_flussi", distretto)
fp = load_flussi_trend("penale_flussi", distretto)

fig = make_subplots(rows=1, cols=2, subplot_titles=("Civile", "Penale"))
for col, df, color in ((1, fc, "#6366f1"), (2, fp, "#f59e0b")):
    fig.add_trace(
        go.Scatter(x=df["anno"], y=df["sopravvenuti"], name="Iscritti", legendgroup=f"g{col}",
                   line=dict(color=color, dash="dot"), showlegend=col == 1),
        row=1, col=col,
    )
    fig.add_trace(
        go.Scatter(x=df["anno"], y=df["definiti"], name="Definiti", legendgroup=f"g{col}",
                   line=dict(color=color), showlegend=col == 1),
        row=1, col=col,
    )
    fig.add_trace(
        go.Scatter(x=df["anno"], y=df["pendenti"], name="Pendenti", legendgroup=f"g{col}",
                   line=dict(color=color, dash="dash"), showlegend=col == 1),
        row=1, col=col,
    )
fig.update_layout(height=400, margin={"t": 40, "b": 40}, legend_orientation="h")
st.plotly_chart(fig, width="stretch")

# -- Clearance trend ---------------------------------------------------------
trend = load_clearance_trend(distretto)
if not trend.empty:
    st.subheader("Andamento clearance (2014 → 2025)")
    t = trend.iloc[0]
    fig2 = go.Figure()
    fig2.add_trace(go.Bar(
        x=["2014", "2025"],
        y=[t["first_cr_civ"], t["last_cr_civ"]],
        name="Civile",
        marker_color="#6366f1",
    ))
    fig2.add_trace(go.Bar(
        x=["2014", "2025"],
        y=[t["first_cr_pen"], t["last_cr_pen"]],
        name="Penale",
        marker_color="#f59e0b",
    ))
    fig2.add_hline(y=1.0, line_dash="dot")
    fig2.update_layout(barmode="group", height=350, margin={"t": 20, "b": 40},
                       legend_orientation="h", yaxis_title="Definiti / iscritti")
    st.plotly_chart(fig2, width="stretch")

    with st.expander("Dettaglio variazioni"):
        st.dataframe(
            trend[["distretto", "first_cr_civ", "last_cr_civ", "delta_cr_abs_civ",
                   "first_cr_pen", "last_cr_pen", "delta_cr_abs_pen"]]
            .rename(columns={
                "first_cr_civ": "CR civ 2014", "last_cr_civ": "CR civ 2025",
                "delta_cr_abs_civ": "Δ CR civ",
                "first_cr_pen": "CR pen 2014", "last_cr_pen": "CR pen 2025",
                "delta_cr_abs_pen": "Δ CR pen",
            }),
            width="stretch", hide_index=True,
        )
