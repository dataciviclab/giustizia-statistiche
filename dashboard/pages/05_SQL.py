"""Query SQL libera sui dataset del repo."""

from pathlib import Path

from lab_connectors.duckdb.sql_page import render_sql_query
from lab_connectors.registry import load_registry

from sources import PREFIX

registry = load_registry(Path(__file__).resolve().parent.parent.parent / "registry" / "registry.json")

render_sql_query(
    registry=registry,
    prefix=PREFIX,
    default_slug="quadro_distretto",
    title="🧪 Query SQL",
    description=(
        "Scrivi query SQL sui dataset di giustizia-statistiche. "
        "Usa ``clean_input`` come tabella virtuale — viene risolta sui Parquet GCS. "
        "Per i mart usa la pagina Panoramica o apri un file parquet dal path nel registry."
    ),
)
