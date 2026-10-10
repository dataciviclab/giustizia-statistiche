#!/usr/bin/env python3
"""
Prepara il CSV Dettaglio UCP: sanifica header e tipi.

Il file ministeriale è cp1252, con header lunghi, spazi, trattini e
virgolette tipografiche (U+2019). Lo script:
  1. scarica il CSV (lab_connectors, retry + SSL fallback)
  2. decodifica cp1252
  3. converte gli header in snake_case (US-/SPM-/SAS-/SAP- restano prefissi)
  4. converte in numerico le colonne di conteggio (1 / vuoto → Int64 nullable)
  5. scrive UTF-8 in raw_input.csv

Usage:
  python prepare_dettaglio.py [--url URL] [--output OUTPUT]
"""

import argparse
import re
import sys
from pathlib import Path

import pandas as pd
from lab_connectors.http import download as http_download

DEFAULT_URL = (
    "https://datiestatistiche.giustizia.it/"
    "cmsresources/cms/documents/UCP_2021_2025_Dettaglio_UCP.csv"
)

# Colonne che restano testuali
TEXT_COLS = {"corte_appello", "descrizione", "sede", "anno", "supporto"}


def snake(col: str) -> str:
    c = col.lower()
    c = re.sub(r"[^a-z0-9]+", "_", c)
    return c.strip("_")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", default=DEFAULT_URL)
    parser.add_argument("--output", default="raw_input.csv")
    args = parser.parse_args()

    print(f"Download {args.url} ...")
    data = http_download(args.url)
    tmp = Path("raw_dettaglio_cp1252.csv")
    tmp.write_bytes(data)
    print(f"  OK ({len(data)} bytes)")

    df = pd.read_csv(tmp, sep=";", encoding="cp1252", dtype=str)
    df.columns = [snake(c) for c in df.columns]
    print(f"  {len(df)} righe × {len(df.columns)} colonne snake_case")

    for col in df.columns:
        if col in TEXT_COLS:
            continue
        coerced = pd.to_numeric(df[col].str.replace("\xa0", "", regex=False), errors="coerce")
        # Se la maggioranza è numerica → tipizza; altrimenti lascia testo
        if coerced.notna().mean() > 0.5:
            df[col] = coerced.astype("Int64")

    df.to_csv(args.output, index=False)
    print(f"Output: {args.output} ({len(df)} righe)")
    tmp.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
