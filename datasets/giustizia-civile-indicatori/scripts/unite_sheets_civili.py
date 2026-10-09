#!/usr/bin/env python3
"""
Unisce i 3 sheet del file Indicatori_Civili.xlsx in un unico CSV.

Scarica il file XLSX dal portale del Ministero della Giustizia usando
lab_connectors.http.download (retry, SSL fallback, circuit breaker),
legge i 3 sheet dati e produce un CSV con schema unificato.

Sheet:
  - "Tribunali e Corti d'Appello" (2014-2025): Fonte SICID|SIECIC, Tipo ufficio
  - "Giudici di Pace" (2023-2025): senza Fonte/Tipo ufficio
  - "Tribunali per i Minorenni" (2023-2025): senza Distretto/Fonte/Tipo ufficio

Note:
  - Header sheet1/2 usa "Clearance  rate" (doppio spazio) → normalizzato
  - Anno: intero nel sheet1, stringa negli altri → coerce numerico

Usage:
  python unite_sheets_civili.py [--url URL] [--output OUTPUT]
"""

import argparse
import sys
from pathlib import Path

import pandas as pd
from lab_connectors.http import download as http_download

SHEET_MAIN = "Tribunali e Corti d'Appello"
SHEET_GIP = "Giudici di Pace"
SHEET_MINORI = "Tribunali per i Minorenni"

COLUMNS_OUT = [
    "Fonte",
    "Anno",
    "Tipo ufficio",
    "Distretto",
    "Sede",
    "Macromateria",
    "Materia",
    "Clearance rate",
    "Disposition time",
]

DEFAULT_URL = (
    "https://datiestatistiche.giustizia.it/"
    "cmsresources/cms/documents/Indicatori_Civili.xlsx"
)


def _normalize_columns(df: pd.DataFrame) -> pd.DataFrame:
    """Normalizza gli header: doppio spazio in 'Clearance  rate' → singolo."""
    df = df.rename(columns=lambda c: " ".join(str(c).split()))
    return df


def _read_sheet(xlsx_path: Path, sheet: str, tipo_ufficio: str | None) -> pd.DataFrame | None:
    try:
        df = pd.read_excel(xlsx_path, sheet_name=sheet)
        df = _normalize_columns(df)
        print(
            f"  LETTO {sheet}: {len(df)} righe × {len(df.columns)} "
            f"colonne → {list(df.columns)}"
        )
        if tipo_ufficio is not None and (
            "Tipo ufficio" not in df.columns or df["Tipo ufficio"].isna().all()
        ):
            df["Tipo ufficio"] = tipo_ufficio
        for col in COLUMNS_OUT:
            if col not in df.columns:
                df[col] = None
        df = df[COLUMNS_OUT]
        if "Anno" in df.columns:
            df["Anno"] = pd.to_numeric(df["Anno"], errors="coerce")
        return df
    except Exception as e:
        print(f"  ERR {sheet}: {e}", file=sys.stderr)
        return None


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", default=DEFAULT_URL)
    parser.add_argument("--output", default="raw_input.csv")
    args = parser.parse_args()

    xlsx_path = Path("raw_input.xlsx")
    output_path = Path(args.output)

    print(f"Download {args.url} ...")
    data = http_download(args.url)
    xlsx_path.write_bytes(data)
    print(f"  OK ({len(data)} bytes)")

    frames = []
    for sheet, tipo in [
        (SHEET_MAIN, None),  # Tipo ufficio già presente nel foglio
        (SHEET_GIP, "Giudici di Pace"),
        (SHEET_MINORI, "Tribunale per i Minorenni"),
    ]:
        df = _read_sheet(xlsx_path, sheet, tipo)
        if df is not None:
            frames.append(df)
            print(f"  OK  {sheet}: {len(df)} righe")

    if not frames:
        print("ERRORE: nessuno sheet letto", file=sys.stderr)
        sys.exit(1)

    united = pd.concat(frames, ignore_index=True)
    before = len(united)
    united = united.dropna(subset=["Anno"])
    print(f"  Filtrate {before - len(united)} righe senza Anno")

    united.to_csv(output_path, index=False)
    print(f"\nOutput: {output_path} ({len(united)} righe, {len(united.columns)} colonne)")
    print(f"Colonne: {list(united.columns)}")
    print(f"Tipo ufficio distinti: {sorted(united['Tipo ufficio'].dropna().unique())}")
    print(f"Fonte distinte: {sorted(united['Fonte'].dropna().unique())}")

    xlsx_path.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
