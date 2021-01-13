# Zdravstveni-Sustav-DB

Naša baza podataka služi službenicima medicinskog sustava kako bi svi podaci bili
usklađeni u cjelokupnom zdravstvenom sustavu RH.

Ustanove koje su povezane u ovoj bazi su apoteke i bolnice.
Osobe koje će se služiti ovom bazom podataka su službenici ljekarne, doktori u
bolnicama, osobe koje uvode nove dijagnoze, osobe koje uvode nove specijalizacije,
nove liječnike, novorođenu djecu koja po rođenju ulaze u sustav i tablicu osoba sustava
HZZO, nove bolnice, nove apoteke, farmaceutske tvrtke koje uvode nove terapije.

Ova baza sadrži samo osobe koje su u sustavu HZZO-a, za strane državljane bi trebali
uvesti veliku količinu novih pravila koja bi značajno proširila bazu za naše ciljeve.
Pretpostavlja se da su sve osobe u sustavu HZZO-a nalaze u tablici osoba.
Količina podataka u svim tablicama je smanjene od one realne za potrebe našeg
projekta.

Sva imena, prezimena, mbo-ovi, datumi rođenja, id-evi, itd. su nasumično generirani na
smislen način.

Cilj ove baze podataka je primarno uspostaviti odnos između pacijenta, liječnika koji mu
je postavio dijagnozu, njegove dijagnoze i ljekarne koja sadrži odgovarajuću terapiju za
tog pacijenta kako bi svaki pacijent imao pristup odgovarajućoj zdravstvenoj skrbi i kako
nitko ne bi mogao zlouporabiti podizanje lijeka koji mu nije namijenjen koristeći sustav.
Baza ima i druge namjene, uključujući ali ne i ograničeno na:
* praćenje radnih mjesta liječnika, njihovih specijalizacija, pacijenata i terapija
* povezivanje liječnika u sustavu sa njihovim osobnim podacima koji ih
predstavljaju kao korisnike zdravstvenih usluga sustava
* povezivanje osoba, bolnica i apoteka sa gradovima u kojima borave / su
sagrađene
* praćenje raznih informacija vezanih uz smrti korisnika sustava
* praćenje rizičnih skupina poput umirovljenika ili osoba zaraženih visokorizičnim
bolestima
* praćenje različitih odnosa liječnika i njihovih pacijenata
* praćenje informacija vezanih uz bolnice poput potreba za više specijalističkog
osoblja ili potencijalnih lokacija za njihovu izgradnju
