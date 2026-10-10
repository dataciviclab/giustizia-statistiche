#!/usr/bin/env python3
"""
Scarica il CSV Flussi della mediazione civile risolvendo l'URL dalla pagina.

Il nome del file ministeriale ruota a ogni aggiornamento semestrale
(es. Mediazione_semestrale_2024Primo_semestre_2026_Flussi.csv), quindi
l'URL non è stabile: questo script fa discovery dalla pagina ufficiale,
estrae il link corrente del CSV Flussi e lo copia in raw_input.csv.

Usage:
  python discover_flussi.py [--output OUTPUT]
"""

import argparse
import re
import sys
from pathlib import Path

from lab_connectors.http import download as http_download

PAGE_URL = (
    "https://datiestatistiche.giustizia.it/"
    "page/it/rilevazioni_civili?contentId=TGN15023"
)
BASE = "https://datiestatistiche.giustizia.it"
PATTERN = re.compile(
    r'href="(/cmsresources/cms/documents/Mediazione_semestrale_[^"]+_Flussi\.csv)"'
)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", default="raw_input.csv")
    args = parser.parse_args()
    output_path = Path(args.output)

    print(f"Discovery da {PAGE_URL} ...")
    html = http_download(PAGE_URL).decode("utf-8", errors="replace")
    matches = PATTERN.findall(html)
    if not matches:
        print("ERRORE: nessun link CSV Flussi trovato nella pagina", file=sys.stderr)
        sys.exit(1)
    rel = matches[0]
    url = BASE + rel
    print(f"  Trovato: {rel}")

    print(f"Download {url} ...")
    data = http_download(url)
    output_path.write_bytes(data)
    print(f"  OK ({len(data)} bytes) → {output_path}")


if __name__ == "__main__":
    main()
