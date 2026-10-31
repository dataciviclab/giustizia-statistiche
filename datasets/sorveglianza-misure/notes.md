# Note — sorveglianza-misure

## Fonte

- Pagina: https://datiestatistiche.giustizia.it/it/sorveglianza.page
- File: `Sorveglianza_misure_dati.csv` (5,9 MB, delimitatore `;`, UTF-8 con BOM)
- Cadenza semestrale; dati comunicati dagli uffici alla DGStat entro 45 giorni dalla fine del semestre

## Trappole verificate

1. **`Semestre` include il valore `Anno`** (totale annuale duplicato). Verificato su tutte le 15.137 combinazioni: `Anno = Primo semestre + Secondo semestre`. Gestito con `periodo_tipo`.
2. **BOM UTF-8 in testa al file.** Il reader DuckDB non accetta `encoding: utf-8-sig`: va usato `utf-8` (il BOM viene rimosso automaticamente nell'header).
3. **`Bolzano/Bozen`** normalizzato in `Bolzano`, canone con `penale_flussi` e `civile_flussi`.
4. **`Oggetto` ha 71 valori distinti** e le etichette non sono allineate con il file esecuzione ("Affidamento al Servizio Sociale" vs "Affidamento in Prova al Servizio Sociale"): la mappa `natura_misura` usa pattern `LIKE`, non uguaglianze.
5. **`lavoro esterno` (art. 21 O.P.) è classificato come `alternativa`**: è un provvedimento di competenza della sorveglianza e la fonte lo espone tra le "misure concesse". Va tenuto presente che il file esecuzione **non** traccia il lavoro esterno nello stock: il confronto flusso/stok su questa voce non è possibile.

## Copertura

- 58 sedi, 26 distretti, 2 tipi di ufficio
- Ogni anno ha lo stesso numero di righe (7.569), tranne il 2025 (7.566)

## Numeri di controllo (2025, `periodo_tipo='anno'`)

| Misura | Provvedimenti |
|---|---:|
| Concesse | 38.871 |
| Revocate | 4.431 |
| Cessate per altri motivi | 22 |
| Cessate per sopravvenienza nuovi titoli | 2 |
| Dichiarate inefficaci | 227 |
