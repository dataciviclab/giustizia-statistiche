"""Panoramica nazionale — KPI 2025 + quadro distretti."""

import plotly.graph_objects as go
import streamlit as st

from lab_connectors.formatters import fmt_eur, fmt_num, fmt_pct
from sources import QUADRO_YEAR, load_nazionale, load_quadro

st.title("📊 Panoramica nazionale")

naz_df = load_nazionale(QUADRO_YEAR)
if naz_df.empty:
    st.warning("Nessun dato disponibile.")
    st.stop()

n = naz_df.iloc[0]

k1, k2, k3, k4 = st.columns(4)
k1.metric(
    "Clearance civile",
    f"{n['civ_clearance']:.2f}",
    delta_color="inverse",
    help="Definiti / iscritti nei Tribunali civili. Valori < 1 = si accumula arretrato.",
)
k2.metric(
    "Disposition time civile",
    f"{fmt_num(n['civ_disposition_gg'])} gg",
    delta_color="inverse",
    help="Durata media di definizione, ponderata sui definiti.",
)
k3.metric(
    "Costo / procedimento civile",
    fmt_eur(n["euro_per_procedimento_civ"]),
    help="Spesa erario totale ÷ procedimenti civili definiti.",
)
k4.metric(
    "Penale oltre 2 anni",
    fmt_pct(n["quota_penale_oltre_2anni"] / 100),
    delta_color="inverse",
    help="Quota di procedimenti penali definiti oltre i 2 anni (Tribunali).",
)

k5, k6, k7, k8 = st.columns(4)
k5.metric(
    "Clearance penale",
    f"{n['pen_clearance']:.2f}",
    delta_color="inverse",
    help="Definiti / iscritti nei Tribunali penali.",
)
k6.metric(
    "Disposition time penale",
    f"{fmt_num(n['pen_disposition_gg'])} gg",
    delta_color="inverse",
)
k7.metric(
    "Pendenti civili (PNRR)",
    fmt_num(n["pnrr_pendenti"]),
    help="Pendenti finali Tribunali civili, ultimo anno intero disponibile.",
)
k8.metric(
    "Scarto vs target 2026",
    fmt_num(n["pnrr_scarto_vs_target"]),
    delta_color="inverse",
    help="Pendenti attuali − target PNRR 2026 (somma target sedi con target pubblicato).",
)

st.divider()

quadro = load_quadro(QUADRO_YEAR)
st.subheader("Quadro distretti")
st.caption(
    "Ordinabile per colonna. Indicatori sui soli Tribunali; "
    "spesa = erario totale del distretto."
)

show = quadro.copy()
show["euro_procedimento"] = show["euro_per_procedimento_civ"]
show["civ_disposition_gg"] = show["civ_disposition_gg"].round(0)
show["pen_disposition_gg"] = show["pen_disposition_gg"].round(0)
show["quota_penale_oltre_2anni"] = show["quota_penale_oltre_2anni"].round(1)
show["pnrr_pendenti"] = show["pnrr_pendenti"].round(0)
show["pnrr_target_2026"] = show["pnrr_target_2026"].round(0)
show["pnrr_pct_target"] = show["pnrr_pct_target"].round(0)
cols = [
    "distretto",
    "civ_clearance",
    "civ_disposition_gg",
    "pen_clearance",
    "pen_disposition_gg",
    "quota_penale_oltre_2anni",
    "euro_procedimento",
    "pnrr_pendenti",
    "pnrr_target_2026",
    "pnrr_pct_target",
]
st.dataframe(
    show[cols].sort_values("civ_clearance"),
    width="stretch",
    hide_index=True,
    column_config={
        "distretto": "Distretto",
        "civ_clearance": st.column_config.NumberColumn("Clear. civ", format="%.2f"),
        "civ_disposition_gg": st.column_config.NumberColumn("DT civ (gg)", format="localized"),
        "pen_clearance": st.column_config.NumberColumn("Clear. pen", format="%.2f"),
        "pen_disposition_gg": st.column_config.NumberColumn("DT pen (gg)", format="localized"),
        "quota_penale_oltre_2anni": st.column_config.NumberColumn(
            "Pen >2a (%)", format="%.1f"
        ),
        "euro_procedimento": st.column_config.NumberColumn(
            "€/procedimento", format="localized"
        ),
        "pnrr_pendenti": st.column_config.NumberColumn("PNRR pendenti", format="localized"),
        "pnrr_target_2026": st.column_config.NumberColumn("Target 2026", format="localized"),
        "pnrr_pct_target": st.column_config.NumberColumn(
            "% target", format="localized"
        ),
    },
)

st.divider()

fig = go.Figure()
fig.add_trace(
    go.Bar(
        x=quadro["distretto"],
        y=quadro["civ_clearance"],
        name="Clearance civile",
        marker_color="#6366f1",
    )
)
fig.add_hline(y=1.0, line_dash="dot", annotation_text="soglia 1.0")
fig.update_layout(
    height=380,
    margin={"t": 30, "b": 40},
    xaxis_title="",
    yaxis_title="Definiti / iscritti",
    legend_orientation="h",
)
st.plotly_chart(fig, width="stretch")
