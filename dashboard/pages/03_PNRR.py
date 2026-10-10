"""PNRR — pendenti civili vs target 2026."""

import plotly.express as px
import plotly.graph_objects as go
import streamlit as st

from lab_connectors.formatters import fmt_num
from sources import load_pnrr_nazionale, load_pnrr_sedi

st.title("🎯 PNRR — pendenti civili vs target 2026")

sedi = load_pnrr_sedi(2025)
naz = load_pnrr_nazionale()

if sedi.empty:
    st.warning("Nessun dato PNRR disponibile.")
    st.stop()

k1, k2, k3 = st.columns(3)
k1.metric("Pendenti 2025 (Tribunali civili)", fmt_num(sedi["pendenti_fine_periodo"].sum()))
k2.metric("Target 2026 (sedi con target)", fmt_num(sedi["pendenti_obiettivo_2026"].sum()))
con_target = sedi[sedi["pendenti_obiettivo_2026"].notna()]
sotto = (con_target["pendenti_fine_periodo"] <= con_target["pendenti_obiettivo_2026"]).sum()
k3.metric(
    "Sedi già sotto target",
    f"{sotto} / {len(con_target)}",
    delta_color="inverse",
)

st.divider()

# -- Evoluzione nazionale ----------------------------------------------------
st.subheader("Evoluzione nazionale")
fig_naz = go.Figure()
fig_naz.add_trace(go.Bar(
    x=naz["anno"].astype(str) + " " + naz["periodo"].str.replace("Semestre ", "S", regex=False),
    y=naz["pendenti_fine_periodo"],
    name="Pendenti",
    marker_color="#6366f1",
))
fig_naz.add_trace(go.Scatter(
    x=naz["anno"].astype(str) + " " + naz["periodo"].str.replace("Semestre ", "S", regex=False),
    y=naz["definiti"],
    name="Definiti",
    line=dict(color="#10b981"),
))
fig_naz.update_layout(height=360, margin={"t": 20, "b": 40}, legend_orientation="h")
st.plotly_chart(fig_naz, width="stretch")
st.caption(
    "Attenzione: il 2026 è solo Primo semestre — non confrontabile 1:1 "
    "con gli anni interi precedenti."
)

# -- Sedi: pendenti vs target ------------------------------------------------
st.subheader("Sedi: pendenti 2025 vs target 2026")

plot_df = sedi[sedi["pendenti_obiettivo_2026"].notna()].copy()
plot_df["oltre_target"] = plot_df["pendenti_fine_periodo"] > plot_df["pendenti_obiettivo_2026"]

fig = go.Figure()
fig.add_trace(go.Scatter(
    x=plot_df["pendenti_obiettivo_2026"],
    y=plot_df["pendenti_fine_periodo"],
    mode="markers",
    text=plot_df["sede"],
    marker=dict(
        size=9,
        color=plot_df["oltre_target"].map({True: "#ef4444", False: "#10b981"}),
    ),
    hovertemplate="%{text}<br>target %{x}<br>pendenti %{y}<extra></extra>",
))
max_v = max(plot_df["pendenti_obiettivo_2026"].max(), plot_df["pendenti_fine_periodo"].max())
fig.add_trace(go.Scatter(
    x=[0, max_v], y=[0, max_v], mode="lines", name="target = pendenti",
    line=dict(dash="dot", color="gray"),
))
fig.update_layout(
    height=480, margin={"t": 20, "b": 40},
    xaxis_title="Target 2026", yaxis_title="Pendenti 2025",
    legend_orientation="h",
)
st.plotly_chart(fig, width="stretch")

# -- Classifica ritardo ------------------------------------------------------
st.subheader("Classifica ritardo (% del target)")
rit = plot_df.copy()
rit["pct"] = rit["pendenti_fine_periodo"] * 100 / rit["pendenti_obiettivo_2026"]
fig_bar = px.bar(
    rit.sort_values("pct", ascending=False).head(15),
    x="pct", y="sede", orientation="h",
    labels={"pct": "% del target 2026", "sede": ""},
    color="pct", color_continuous_scale=["#10b981", "#f59e0b", "#ef4444"],
)
fig_bar.update_layout(height=480, margin={"t": 20, "b": 40}, coloraxis_showscale=False)
st.plotly_chart(fig_bar, width="stretch")

with st.expander("Tabella sedi completa"):
    st.dataframe(
        plot_df[["sede", "distretto", "pendenti_fine_periodo", "pendenti_obiettivo_2026", "definiti"]]
        .sort_values("pendenti_fine_periodo", ascending=False),
        width="stretch", hide_index=True,
    )
