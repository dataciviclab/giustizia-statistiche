#!/usr/bin/env python3
"""
Unisce i file XLSX delle durate civili (SICID + SIECIC) in un unico CSV.

Scarica entrambi i file dal portale del Ministero della Giustizia usando
lab_connectors.http.download e produce un CSV con schema unificato e
colonna `registro` (SICID | SIECIC).

SICID  (foglio `data`):  Ripartizione, Distretto, Tipo ufficio, Sede,
                         Livello di aggregazione, Materia, Anno, Definiti,
                         Durata media in giorni, Durata media in anni
SIECIC (foglio `Data`):  Distretto, Tribunale→Sede, Livello di aggregazione,
                         Materia, Anno, Definiti, Durata media (giorni),
                         Durata media (anni)

Usage:
  python unite_durata_civile.py [--output OUTPUT]
"""

import argparse
import sys
from pathlib import Path

import pandas as pd
from lab_connectors.http import download as http_download

BASE = "https://datiestatistiche.giustizia.it/cmsresources/cms/documents/"
URL_SICID = BASE + "Durata_SICID_20142025.xlsx"
URL_SIECIC = BASE + "Durata_SIECIC_20142025.xlsx"

COLUMNS_OUT = [
    "registro",
    "ripartizione",
    "distretto",
    "tipo_ufficio",
    "sede",
    "livello_aggregazione",
    "materia",
    "anno",
    "definiti",
    "durata_media_gg",
]


def _fetch(url: str, dest: Path) -> None:
    print(f"Download {url} ...")
    data = http_download(url)
    dest.write_bytes(data)
    print(f"  OK ({len(data)} bytes)")


def _read_sicid(path: Path) -> pd.DataFrame:
    df = pd.read_excel(path, sheet_name="data")
    out = pd.DataFrame(
        {
            "registro": "SICID",
            "ripartizione": df["Ripartizione"],
            "distretto": df["Distretto"],
            "tipo_ufficio": df["Tipo ufficio"],
            "sede": df["Sede"],
            "livello_aggregazione": df["Livello di aggregazione"],
            "materia": df["Materia"],
            "anno": pd.to_numeric(df["Anno"], errors="coerce"),
            "definiti": pd.to_numeric(df["Definiti"], errors="coerce"),
            "durata_media_gg": pd.to_numeric(
                df["Durata media in giorni"], errors="coerce"
            ),
        }
    )
    return out


def _read_siecic(path: Path) -> pd.DataFrame:
    df = pd.read_excel(path, sheet_name="Data")
    out = pd.DataFrame(
        {
            "registro": "SIECIC",
            "ripartizione": None,
            "distretto": df["Distretto"],
            # SIECIC chiama la sede "Tribunale"
            "tipo_ufficio": "Tribunale",
            "sede": df["Tribunale"],
            "livello_aggregazione": df["Livello di aggregazione"],
            "materia": df["Materia"],
            "anno": pd.to_numeric(df["Anno"], errors="coerce"),
            "definiti": pd.to_numeric(df["Definiti"], errors="coerce"),
            "durata_media_gg": pd.to_numeric(
                df["Durata media (giorni)"], errors="coerce"
            ),
        }
    )
    return out


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", default="raw_input.csv")
    args = parser.parse_args()

    sicid_x = Path("raw_sicid.xlsx")
    siecic_x = Path("raw_siecic.xlsx")
    output_path = Path(args.output)

    _fetch(URL_SICID, sicid_x)
    _fetch(URL_SIECIC, siecic_x)

    frames = []
    for name, fn, p in [("SICID", _read_sicid, sicid_x), ("SIECIC", _read_siecic, siecic_x)]:
        try:
            df = fn(p)
            print(f"  OK  {name}: {len(df)} righe")
            frames.append(df)
        except Exception as e:
            print(f"  ERR {name}: {e}", file=sys.stderr)

    if not frames:
        print("ERRORE: nessun file letto", file=sys.stderr)
        sys.exit(1)

    united = pd.concat(frames, ignore_index=True)
    before = len(united)
    united = united.dropna(subset=["anno"])
    print(f"  Filtrate {before - len(united)} righe senza anno")

    united.to_csv(output_path, index=False)
    print(f"\nOutput: {output_path} ({len(united)} righe, {len(united.columns)} colonne)")
    print(f"Registri: {sorted(united['registro'].dropna().unique())}")
    print(f"Anni: {int(united['anno'].min())}-{int(united['anno'].max())}")

    sicid_x.unlink(missing_ok=True)
    siecic_x.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
