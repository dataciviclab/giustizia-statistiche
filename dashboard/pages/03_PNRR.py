"""PNRR — cohort arretrato civile vs target 2026 (-90%).

Il target PNRR non riguarda la pendenza totale ma il cohort dei vecchi
arretrati: cause pendenti al 31/12/2022 e iscritte dal 2017 (Tribunali).
Obiettivo: residuo ≤ 10% della baseline entro giugno 2026.
"""

import plotly.express as px
import plotly.graph_objects as go
import streamlit as st

from lab_connectors.formatters import fmt_num
from sources import load_pnrr_nazionale, load_pnrr_sedi

st.title("🎯 PNRR — arretrato civile vs target 2026")

st.caption(
    "Il target PNRR (M1C1-47/48) non è sulla pendenza totale: riguarda il "
    "**cohort** dei procedimenti civili pendenti al 31/12/2022 e iscritti dal "
    "2017 (Tribunali). Obiettivo: -90% entro giugno 2026, cioè residuo ≤ 10% "
    "della baseline. Il grafico confronta il cohort ancora vivo (2025) con il "
    "residuo ammesso."
)

sedi = load_pnrr_sedi(2025)
naz = load_pnrr_nazionale()

if sedi.empty:
    st.warning("Nessun dato PNRR disponibile.")
    st.stop()

con_cohort = sedi[sedi["pendenti_obiettivo_2026"].notna()].copy()
con_cohort["allowed"] = con_cohort["baseline_obiettivo_2026"] * 0.10
con_cohort["pct_residuo"] = (
    con_cohort["pendenti_obiettivo_2026"] / con_cohort["baseline_obiettivo_2026"] * 100
)
con_cohort["sotto"] = con_cohort["pendenti_obiettivo_2026"] <= con_cohort["allowed"]

k1, k2, k3 = st.columns(3)
k1.metric("Pendenti totali 2025", fmt_num(con_cohort["pendenti_fine_periodo"].sum()))
k2.metric(
    "Cohort 2017-22 ancora vivo",
    fmt_num(con_cohort["pendenti_obiettivo_2026"].sum()),
    help="Di una baseline di " + fmt_num(con_cohort["baseline_obiettivo_2026"].sum()),
)
k3.metric(
    "Sedi sotto target (≤10%)",
    f"{con_cohort['sotto'].sum()} / {len(con_cohort)}",
)

st.divider()

# -- Evoluzione nazionale ----------------------------------------------------
st.subheader("Evoluzione nazionale")
fig_naz = go.Figure()
xlab = naz["anno"].astype(str) + " " + naz["periodo"].str.replace("Semestre ", "S", regex=False)
fig_naz.add_trace(go.Bar(x=xlab, y=naz["pendenti_fine_periodo"], name="Pendenti totali",
                         marker_color="#6366f1"))
fig_naz.add_trace(go.Scatter(x=xlab, y=naz["definiti"], name="Definiti",
                             line=dict(color="#10b981")))
fig_naz.update_layout(height=360, margin={"t": 20, "b": 40}, legend_orientation="h")
st.plotly_chart(fig_naz, width="stretch")
st.caption(
    "Le barre sono la pendenza TOTALE (contesto). Il 2026 è solo Primo "
    "semestre — non confrontabile 1:1 con gli anni interi. Il target PNRR "
    "opera sul cohort qui sotto, non su queste barre."
)

# -- Cohort: scatter vs residuo ammesso --------------------------------------
st.subheader("Cohort arretrato 2017-22: ancora vivo vs residuo ammesso (10%)")

fig = go.Figure()
fig.add_trace(go.Scatter(
    x=con_cohort["allowed"],
    y=con_cohort["pendenti_obiettivo_2026"],
    mode="markers",
    text=con_cohort["sede"],
    marker=dict(
        size=9,
        color=con_cohort["sotto"].map({True: "#10b981", False: "#ef4444"}),
    ),
    hovertemplate="%{text}<br>cohort vivo %{y}<br>ammesso %{x}<extra></extra>",
))
max_v = max(con_cohort["allowed"].max(), con_cohort["pendenti_obiettivo_2026"].max())
fig.add_trace(go.Scatter(
    x=[0, max_v], y=[0, max_v], mode="lines", name="target",
    line=dict(dash="dot", color="gray"),
))
fig.update_layout(
    height=480, margin={"t": 20, "b": 40},
    xaxis_title="Residuo ammesso (10% della baseline 2022)",
    yaxis_title="Cohort ancora pendente (2025)",
    legend_orientation="h",
)
st.plotly_chart(fig, width="stretch")

# -- Classifica residuo ------------------------------------------------------
st.subheader("Classifica: % del cohort residua (peggiori)")
fig_bar = px.bar(
    con_cohort.sort_values("pct_residuo", ascending=False).head(15),
    x="pct_residuo", y="sede", orientation="h",
    labels={"pct_residuo": "% della baseline ancora pendente", "sede": ""},
    color="pct_residuo", color_continuous_scale=["#10b981", "#f59e0b", "#ef4444"],
)
fig_bar.add_vline(x=10, line_dash="dot", annotation_text="target 10%")
fig_bar.update_layout(height=480, margin={"t": 20, "b": 40}, coloraxis_showscale=False)
st.plotly_chart(fig_bar, width="stretch")

with st.expander("Tabella cohort per sede"):
    st.dataframe(
        con_cohort[["sede", "distretto", "baseline_obiettivo_2026",
                    "pendenti_obiettivo_2026", "allowed", "pct_residuo", "sotto"]]
        .rename(columns={
            "baseline_obiettivo_2026": "Baseline (2022)",
            "pendenti_obiettivo_2026": "Ancora vivo (2025)",
            "allowed": "Ammesso (10%)",
            "pct_residuo": "% residua",
            "sotto": "Sotto target",
        })
        .sort_values("% residua", ascending=False),
        width="stretch", hide_index=True,
    )
