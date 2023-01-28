### Rotterdam F5 VPN Docker published tunnel

De Docker container die je opstart gebruikt de F5 CLI om een VPN met Rotterdam te maken.
De pubished port van de container biedt de mogelijkheid de ontwikkel-VPN te verbinden.
(Ergo, de published port is een tunnel ... naar de ontwikkel-VPN)

#### Voor tekst en uitleg over de F5 CLI:

[F5 BigIP CLI](https://support.f5.com/kb/en-us/products/big-ip_apm/manuals/product/apm-client-configuration-11-4-0/4.html "F5 BigIP CLI")

#### Bouw het image

```bash
docker build -t rdam-f5 .
```

#### Start een container

Om de container "zinvol" te starten, moet deze privileged worden opgestart. De F5 knoeit namelijk met de route-tabel, wat voorbehouden is aan elevated users (oftewel root).

Verder heb je natuurlijk credentials nodig:

variabele          | waarde
---                | ---
USERNAME           | rotterdam id, zoals bijv. 925133
TOKEN_AND_PASSWORD | concatenatie van het gegenereerde token (, bijv 123456) en het wachtwoord horend bij het rotterdam id

```bash
docker run --rm --publish 127.0.0.1:49443:443 --privileged --env "USERNAME=925133" --env "TOKEN_AND_PASSWORD=123456mvSctnw8r" rdam-f5
```

Zodra de login geslaagd is verschijnt de melding, tenzij je de container detached hebt gestart

```
Operation in progress


Please check back the status with /usr/local/bin/f5fpc --info


The session is established.
```

#### Ontwikkel VPN

De tunnel naar de ontwikkel VPN is op port 49443 door de container aan de host gekoppeld. OpenVPN (of Tunnelblick) starten werkt met nagenoeg dezelfde configuratie. Het enige verschil is dat de \<connection> is aangepast.

```
<connection>
remote 127.0.0.1 49443 tcp
</connection>
```
**de volledig ovpn configuratie file is bijgevoegd.** (Je hoeft dus niet zelf te typen)
