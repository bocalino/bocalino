
📦 Ghost City - Sistem Pachete VIP

1. Importă baza de date:
   - Execută `ghst_vip.sql` în phpMyAdmin sau prin consola MySQL.

2. Adaugă scriptul în server:
   - Pune `ghst_vip.lua` în folderul unui resource, ex: `resources/[local]/ghst_vip`.
   - În `fxmanifest.lua`, adaugă:
        server_script 'ghst_vip.lua'

3. Comandă pentru oferit pachet:
   /giveghstvip [id] [tip]
   Exemplu: /giveghstvip 3 platinum

4. Pachetele disponibile:
   - bronze, silver, gold, platinum

5. Funcționalitate:
   - Oferă bani, mașini temporare (pe 30 zile), și Fantome Coins
   - La expirare: mașinile sunt retrase, dar casa rămâne.
