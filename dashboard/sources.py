"""Fonti dati per il Cruscotto Giustizia.

Wrappa lab_connectors.duckdb.queries con @st.cache_data.
Anni derivati dal registry del repo; dati letti da GCS
(bucket clean/mart, prefix `giustizia-statistiche/`).
"""

from __future__ import annotations

import json
from pathlib import Path

import pandas as pd
import streamlit as st

from lab_connectors.duckdb.queries import (
    detect_local_root,
    load_mart_all_years as _load_mart_all_years,
    load_mart_table as _load_mart_table,
    query_clean as _query_clean,
)
from lab_connectors.formatters import fmt_eur, fmt_num, fmt_pct  # noqa: F401  (re-export)

ROOT = Path(__file__).parent.parent
PREFIX = "giustizia-statistiche/"
LOCAL_ROOT = detect_local_root(repo_root=ROOT)

# Anno dello snapshot quadro (compose) — le serie complete vivono nella partizione
QUADRO_YEAR = 2025
PNRR_YEAR = 2026


def _registry() -> dict:
    return json.loads((ROOT / "registry" / "registry.json").read_text(encoding="utf-8"))


@st.cache_data(ttl=3600, show_spinner=False)
def years_from_registry() -> dict[str, tuple[int, int]]:
    """Slug → (start, end) dal registry del repo."""
    out: dict[str, tuple[int, int]] = {}
    for d in _registry().get("datasets", []):
        period = d.get("period") or {}
        if "start" in period and "end" in period:
            out[d["slug"]] = (int(period["start"]), int(period["end"]))
    return out


@st.cache_data(ttl=3600, show_spinner=False)
def slugs_from_registry() -> list[str]:
    return [d["slug"] for d in _registry().get("datasets", [])]


def load_mart(slug: str, table: str, year: int):
    """Carica una tabella mart da GCS (cached 1h)."""
    return _load_mart_table(slug, table, year, prefix=PREFIX, local_root=LOCAL_ROOT)


def load_mart_years(slug: str, table: str, years: list[int]):
    """Carica un mart su più partizioni anni (union by name)."""
    return _load_mart_all_years(slug, table, years, prefix=PREFIX, local_root=LOCAL_ROOT)


def query_on(slug: str, sql: str, years: list[int]):
    """SQL sul clean layer di un dataset (cached via load, qui no-cache wrapper)."""
    return _cached_query(slug, sql, tuple(years))


@st.cache_data(ttl=3600, show_spinner=False)
def _cached_query(slug: str, sql: str, years: tuple[int, ...]):
    return _query_clean(slug, sql, list(years), prefix=PREFIX, local_root=LOCAL_ROOT)


# -- Loader tematici ---------------------------------------------------------


@st.cache_data(ttl=3600, show_spinner=False)
def load_quadro(year: int = QUADRO_YEAR) -> pd.DataFrame:
    return load_mart("quadro_distretto", "mart_quadro", year)


@st.cache_data(ttl=3600, show_spinner=False)
def load_nazionale(year: int = QUADRO_YEAR) -> pd.DataFrame:
    return load_mart("quadro_distretto", "mart_nazionale", year)


@st.cache_data(ttl=3600, show_spinner=False)
def load_flussi_trend(slug: str, distretto: str | None = None) -> pd.DataFrame:
    """Serie storica iscritti/definiti/pendenti dal clean (snapshot partition)."""
    year = PNRR_YEAR if slug == "monitoraggio_pnrr_giustizia" else QUADRO_YEAR
    where = f"WHERE distretto = '{distretto}'" if distretto else ""
    sql = f"""
        SELECT anno,
               SUM(sopravvenuti) AS sopravvenuti,
               SUM(definiti_totale) AS definiti,
               SUM(pendenti_finali) AS pendenti
        FROM clean_input
        {where}
        GROUP BY anno
        ORDER BY anno
    """
    if slug == "penale_flussi":
        sql = sql.replace("definiti_totale", "definiti_totale")
    return query_on(slug, sql, [year])


@st.cache_data(ttl=3600, show_spinner=False)
def load_clearance_trend(distretto: str | None = None) -> pd.DataFrame:
    """Clearance trend civile + penale (Tribunali) da entrambi i marts."""
    civ = load_mart("giustizia_civile_indicatori", "mart_civile_trend", QUADRO_YEAR)
    pen = load_mart("giustizia_penale_indicatori", "mart_penale_trend", QUADRO_YEAR)
    civ = civ[civ["tipo_ufficio"] == "Tribunale"]
    pen = pen[pen["tipo_ufficio"] == "Tribunale"]
    if distretto:
        civ = civ[civ["distretto"] == distretto]
        pen = pen[pen["distretto"] == distretto]
    merged = civ.merge(
        pen[["distretto", "first_year", "last_year", "first_cr", "last_cr", "delta_cr_abs"]],
        on="distretto",
        how="left",
        suffixes=("_civ", "_pen"),
    )
    return merged


@st.cache_data(ttl=3600, show_spinner=False)
def load_spese_composizione() -> pd.DataFrame:
    return load_mart("spese_giustizia", "mart_nazionale_trend", QUADRO_YEAR)


@st.cache_data(ttl=3600, show_spinner=False)
def load_pnrr_sedi(anno: int = 2025) -> pd.DataFrame:
    """Pendenti vs target per sede (Civile, Tribunale, Intero anno)."""
    df = load_mart(
        "monitoraggio_pnrr_giustizia", "monitoraggio_pnrr_giustizia", PNRR_YEAR
    )
    mask = (
        (df["materia"] == "Civile")
        & (df["tipo_ufficio"] == "Tribunale")
        & (df["periodo"] == "Intero anno")
        & (df["anno"] == anno)
    )
    return df[mask].copy()


@st.cache_data(ttl=3600, show_spinner=False)
def load_pnrr_nazionale() -> pd.DataFrame:
    df = load_mart("monitoraggio_pnrr_giustizia", "mart_nazionale_trend", PNRR_YEAR)
    return df[(df["materia"] == "Civile") & (df["tipo_ufficio"] == "Tribunale")].copy()
