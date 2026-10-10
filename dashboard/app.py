#!/usr/bin/env python3
"""
Cruscotto Giustizia · Dashboard Streamlit
Come funziona il sistema giudiziario italiano: volumi, efficienza, costo, PNRR.
"""

import streamlit as st
from lab_connectors.branding import apply_branding

st.set_page_config(
    page_title="Cruscotto Giustizia",
    page_icon="⚖️",
    layout="wide",
    initial_sidebar_state="expanded",
)

apply_branding()

pages = {
    "": [
        st.Page("pages/01_Panoramica.py", title="Panoramica", icon="📊", default=True),
        st.Page("pages/02_Distretti.py", title="Distretti", icon="📍"),
    ],
    "Temi": [
        st.Page("pages/03_PNRR.py", title="PNRR pendenti", icon="🎯"),
        st.Page("pages/04_Spese.py", title="Spese erario", icon="💰"),
    ],
    "Strumenti": [
        st.Page("pages/05_SQL.py", title="Query SQL", icon="🧪"),
    ],
}

pg = st.navigation(pages, position="sidebar")

st.sidebar.markdown("---")
st.sidebar.caption(
    "Dati: Ministero della Giustizia — DG Statistica "
    "([fonte](https://datiestatistiche.giustizia.it/))"
)
st.sidebar.caption(
    "Codice: [dataciviclab/giustizia-statistiche]"
    "(https://github.com/dataciviclab/giustizia-statistiche)"
)
st.sidebar.caption("[DataCivicLab](https://dataciviclab.org/)")

pg.run()
