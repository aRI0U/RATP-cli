# Command-line interface for RATP schedules retrieval

Ce script bash permet d'afficher dans le terminal les horaires d'un moyen de transport (RER, métro, bus, tramway, noctillien) géré par la [RATP](https://www.ratp.fr/).

Ce script envoie une requête à [cette API](https://api-ratp.pierre-grimaud.fr/v4/) pour récupérer les horaires et affiche ensuite les résultats dans le terminal.

This bash script enables a user to get on his terminal the schedules of any [RATP](https://www.ratp.fr/) transportation (metro, bus, RER, tramway, "noctilien") by typing a simple command.

The script sends a request to [this API](https://api-ratp.pierre-grimaud.fr/v4/) to retrieve the schedules and then displays it on the terminal.

## Prerequisities

- Linux (might work on MacOS inch'Allah)



## Preparation

- First download the script and make it executable:

  ```sh
  sudo wget -nc https://raw.githubusercontent.com/aRI0U/RATP-cli/master/ratp.sh -O /usr/local/bin/ratp
  sudo chmod a+rx /usr/local/bin/ratp
  ```

- I used [curl](https://curl.haxx.se) to retrieve schedules from the API and [jq](https://stedolan.github.io/jq/) to handle the JSON files. You need to install them to be able to run the script. On Ubuntu:

  ```sh
  sudo apt-get install curl
  sudo apt-get install jq
  ```

- Add the following lines to your `.bashrc`:

  ```sh
  alias ratp='/usr/local/bin/ratp'
  ```

  and run `source .bashrc`.

After these steps, you should be able to run the script by typing `ratp` on your terminal.

## Usage

This script aims at being as simple as possible to use. To get the schedule of a specific transportation, the syntax is the following:

```sh
$ ratp <line> <station>
```

Line can be the number of any bus, RER, metro, noctilien or tramway belonging to the RATP network.

### Examples

Schedule of the RER B at Bagneux:

```sh
$ ratp b bagneux
       Train à quai	Aeroport Charles de Gaulle 2 TGV
   Train sans arrêt	Aeroport Charles de Gaulle 2 TGV
               16:43	Mitry-Claye
               16:52	Aeroport Charles de Gaulle 2 TGV
   Train sans arrêt	Aeroport Charles de Gaulle 2 TGV
               17:13	Mitry-Claye
               16:31	Robinson
   Train sans arrêt	Saint-Remy-les-Chevreuse
               16:49	Massy-Palaiseau
               16:58	Robinson
   Train sans arrêt	Saint-Remy-les-Chevreuse
               17:19	Massy-Palaiseau
```

Name of stations parsing seems to be case-insensitive, and seems not to care about whether you use dashes instead of escapes.

```sh
$ ratp A nanterre-ville
               16:48	Saint-Germain-en-Laye
   Train sans arrêt	St-Germain-en-Laye. Poissy. Cergy.
               17:18	Saint-Germain-en-Laye
               17:48	Saint-Germain-en-Laye
               18:18	Saint-Germain-en-Laye
               18:48	Saint-Germain-en-Laye
               16:37	Boissy-Saint-Leger
               17:07	Boissy-Saint-Leger
               17:37	Boissy-Saint-Leger
               18:07	Boissy-Saint-Leger
               18:37	Boissy-Saint-Leger
               19:07	Boissy-Saint-Leger
$ ratp a Nanterre Ville
               16:48	Saint-Germain-en-Laye
   Train sans arrêt	St-Germain-en-Laye. Poissy. Cergy.
               17:18	Saint-Germain-en-Laye
               17:48	Saint-Germain-en-Laye
               18:18	Saint-Germain-en-Laye
               18:48	Saint-Germain-en-Laye
               16:37	Boissy-Saint-Leger
               17:07	Boissy-Saint-Leger
               17:37	Boissy-Saint-Leger
               18:07	Boissy-Saint-Leger
               18:37	Boissy-Saint-Leger
               19:07	Boissy-Saint-Leger
```

For name of stations, some abbreviations are available and some aren't. This seems to rely on the API or on the RATP website itself, and no recurrent behaviour seems to appear.

```sh	
$ ratp 187 div leclerc camille desmoulins
                6 mn	Fresnes Charcot Zola
       TRAFIC REDUIT	Fresnes Charcot Zola
               11 mn	Porte d'Orleans
       TRAFIC REDUIT	Porte D Orleans
$ ratp 187 division leclerc camille desmoulins
                5 mn	Fresnes Charcot Zola
       TRAFIC REDUIT	Fresnes Charcot Zola
               11 mn	Porte d'Orleans
$ ratp 187 division leclerc
Schedules unavailable	Destination unavailable

$ ratp b chatelet
               16:41	Aeroport Charles de Gaulle 2 TGV
               16:48	Aeroport Charles de Gaulle 2 TGV
               17:01	Mitry-Claye
               17:10	Aeroport Charles de Gaulle 2 TGV
               17:18	Aeroport Charles de Gaulle 2 TGV
               17:31	Mitry-Claye
               16:43	Robinson
               16:50	Saint-Remy-les-Chevreuse
               16:56	Massy-Palaiseau
               17:13	Robinson
               17:22	Saint-Remy-les-Chevreuse
               17:31	Massy-Palaiseau
$ ratp b chatelet les halles
               16:41	Aeroport Charles de Gaulle 2 TGV
               16:48	Aeroport Charles de Gaulle 2 TGV
               17:01	Mitry-Claye
               17:10	Aeroport Charles de Gaulle 2 TGV
               17:18	Aeroport Charles de Gaulle 2 TGV
               17:31	Mitry-Claye
               16:43	Robinson
               16:50	Saint-Remy-les-Chevreuse
               16:56	Massy-Palaiseau
               17:13	Robinson
               17:22	Saint-Remy-les-Chevreuse
               17:31	Massy-Palaiseau
$ ratp a chatelet
Schedules unavailable	Destination unavailable
$ ratp a chatelet les halles
   Train sans arrêt		St-Germain-en-Laye. Poissy. Cergy.
               16:45	La Defense (Grande Arche)
               17:01	Saint-Germain-en-Laye
               17:16	La Defense (Grande Arche)
               17:31	Saint-Germain-en-Laye
               17:46	La Defense (Grande Arche)
       Train à quai	Marne-la-Vallee Chessy
               16:53	Boissy-Saint-Leger
               17:08	Marne-la-Vallee Chessy
               17:23	Boissy-Saint-Leger
               17:38	Marne-la-Vallee Chessy
               17:53	Boissy-Saint-Leger
```

Finally, remind that the name of some stations can be different of the usual one, and that they might not match.

```sh
$ ratp a la defense
Schedules unavailable	Destination unavailable
$ ratp a grande arche de la defense
    A l'approche V.2	Saint-Germain-en-Laye
     Sans arrêt V.2	St-Germain-en-Laye. Poissy. Cergy.
  Train terminus V.B	La Defense (Grande Arche)
  Sans voyageurs V.B	St-Germain-en-Laye. Poissy. Cergy.
        17:12 Voie 2	Saint-Germain-en-Laye
  Train terminus V.B	La Defense (Grande Arche)
        16:43 Voie 1	Boissy-Saint-Leger
        16:58 Voie 1	Marne-la-Vallee Chessy
        17:13 Voie 1	Boissy-Saint-Leger
        17:28 Voie 1	Marne-la-Vallee Chessy
        17:43 Voie 1	Boissy-Saint-Leger
        17:58 Voie 1	Marne-la-Vallee Chessy
```
