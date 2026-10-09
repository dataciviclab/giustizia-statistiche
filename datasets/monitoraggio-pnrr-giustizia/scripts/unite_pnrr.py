#!/usr/bin/env python3
"""
Unisce i due CSV del Monitoraggio PNRR giustizia (civili + penali).

Stesso grano nei due file (anno × periodo × tipo_ufficio × distretto × sede);
i soli civili hanno le colonne arretrato e target PNRR. Lo script produce un
unico CSV con tutte le colonne, riempite di vuoto per il penale.

Usage:
  python unite_pnrr.py [--output OUTPUT]
"""

import argparse
import sys
from pathlib import Path

import pandas as pd
from lab_connectors.http import download as http_download

BASE = "https://datiestatistiche.giustizia.it/cmsresources/cms/documents/"
URL_CIVILI = BASE + "Monitoraggio_PNRR_Dati_civili.csv"
URL_PENALI = BASE + "Monitoraggio_PNRR_Dati_penali.csv"

COLUMNS_OUT = [
    "materia",
    "anno",
    "periodo",
    "tipo_ufficio",
    "ripartizione",
    "distretto",
    "sede",
    "definiti",
    "pendenti_fine_periodo",
    "pendenti_20191231",
    "arretrato",
    "baseline_obiettivo_2024",
    "pendenti_obiettivo_2024",
    "baseline_obiettivo_2026",
    "pendenti_obiettivo_2026",
]


def _fetch(url: str, dest: Path) -> None:
    print(f"Download {url} ...")
    data = http_download(url)
    dest.write_bytes(data)
    print(f"  OK ({len(data)} bytes)")


def _read(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path, sep=";", encoding="utf-8-sig", dtype=str)
    # normalizza header: spazi multipli ecc.
    df.columns = [" ".join(str(c).split()) for c in df.columns]
    rename = {
        "Materia": "materia",
        "Anno": "anno",
        "Periodo": "periodo",
        "Tipo ufficio": "tipo_ufficio",
        "Ripartizione": "ripartizione",
        "Distretto": "distretto",
        "Sede": "sede",
        "Definiti": "definiti",
        "Pendenti a fine periodo": "pendenti_fine_periodo",
        "Pendenti al 31/12/2019": "pendenti_20191231",
        "Arretrato": "arretrato",
        "Baseline obiettivo 2024": "baseline_obiettivo_2024",
        "Pendenti per obiettivo 2024": "pendenti_obiettivo_2024",
        "Baseline obiettivo 2026": "baseline_obiettivo_2026",
        "Pendenti per obiettivo 2026": "pendenti_obiettivo_2026",
    }
    df = df.rename(columns=rename)
    for col in COLUMNS_OUT:
        if col not in df.columns:
            df[col] = None
    df = df[COLUMNS_OUT]
    df["anno"] = pd.to_numeric(df["anno"], errors="coerce")
    return df


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", default="raw_input.csv")
    args = parser.parse_args()

    civili_p = Path("raw_pnrr_civili.csv")
    penali_p = Path("raw_pnrr_penali.csv")
    output_path = Path(args.output)

    _fetch(URL_CIVILI, civili_p)
    _fetch(URL_PENALI, penali_p)

    frames = []
    for name, p in [("civili", civili_p), ("penali", penali_p)]:
        try:
            df = _read(p)
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
    print(f"Materie: {sorted(united['materia'].dropna().unique())}")
    print(f"Anni: {int(united['anno'].min())}-{int(united['anno'].max())}")

    civili_p.unlink(missing_ok=True)
    penali_p.unlink(missing_ok=True)


if __name__ == "__main__":
    main()
