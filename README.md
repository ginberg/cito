### Inhoud

Deze repository bevat openbare code voor CITO op het gebied van exploratieve en representatieve analyses.

### Voorbereiding

De rapportages kunnen in jouw eigen omgeving gedraaid worden of in een container omgeving. In het eerste geval zul je zelf de betreffende libraries moeten installeren. In het tweede geval wordt er een omgeving opgezet waar de juiste libraries worden geinstalleerd.

#### Opzetten omgeving

Om de rapportages te maken, moet eerst de omegeving opgezet worden. Dit betekend dat de juiste R versie en library versies geinstalleerd moeten worden.

- installeren [docker](https://docs.docker.com/get-docker/)
- docker build -t report-maker .
- docker run --rm -p 8787:8787 -e PASSWORD=cito -e ROOT=TRUE -v $PWD:/home/rstudio/cito report-maker
- open browser localhost:8787
- login rstudio/cito
- openen cito project
- eenmalig het script [installeren_libraries](installeren_libraries.R) uitvoeren

#### Rapportages genereren

Run het script [create_reports](create_reports.R). Dit script genereert 3 html bestanden:
* vestigingen_scores.html
* vestigingen_scores_vo.html
* exploratieve_analyse.html

Je kunt deze bestanden openen in je webbrowser.

### Exploratieve analyses

De [exploratieve analyse](exploratieve_analyse.Rmd) bevat exploratieve analyses op basis van gesimuleerde data. Deze gesimuleerde data bevat eigenschappen van leerlingen zoals geslacht alsmede scores voor bepaalde toetsen. Deze data wordt gebruikt om bepaalde statistieken te berekenen. Daarnaast worden er grafieken getoond die een completer beeld geven.  

### Representatieve analyses

De representatieve analyses zijn analyses waarbij een steekproef vergeleken wordt met de totale populatie. 
Er is een document voor het [basisonderwijs](vestigingen_scores.Rmd) en voor het [voortgezet onderwijs](vestigingen_scores_vo.Rmd)


### API URLs

Onderstaand een lijst van de csv/excel bestanden (links) en de bijbehorende API URL (rechts)

| File                                                                           | API URL                                                                                                     |
| -------------------------------------------------------------------------------| ----------------------------------------------------------------------------------------------------------- |
| achterstandsscores-scholen-2019.xlsx                                           | ?                                                                                                           |
| alle-vestigingen-bo.csv                                                        | https://onderwijsdata.duo.nl/api/3/action/datastore_search?resource_id=94f22ef5-cf37-4656-b834-51523e8f3bd1 |
| alle-vestigingen-vo.csv                                                        | https://onderwijsdata.duo.nl/api/3/action/datastore_search?resource_id=70c19ca0-b24b-4596-a077-79c75caab63a |
| gemiddelde-afstand-tussen-woonadres-leerling-en-schoolvestiging-2019-2020.csv  | ?                                                                                                           |
| gemiddelde-eindscores-bo-sbo-2018-2019.csv                                     | https://onderwijsdata.duo.nl/api/3/action/datastore_search?resource_id=9cda6dd5-1c5a-48b3-b190-207f0008ce66 |
| geslaagden-gezakten-en-cijfers-2018-2019.csv                                   | https://onderwijsdata.duo.nl/api/3/action/datastore_search?resource_id=7314e977-21f3-48bb-a9b4-91cc779f7b40 |


