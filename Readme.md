# LabV7

![topology](/assets/topology.png)

#### install
`bash -c "$(curl -sL https://get.containerlab.dev)"`
#### deploy
```bash
cd src
docker build -t rn-lab-sess-7 .
sudo containerlab deploy
```

#### remove
```bash
sudo containerlab destroy
```

#### connect
```bash
ssh root@<Student Node Ip> #password=password
```

## Aufgaben
Betrachten Sie die Netzwerktopologie in Abb. 31 mit den dazugehöriegen
IP-Adressen aus Tabelle 3. Schreiben Sie den Befehl auf, den Sie benötigen
um auf RouterB eine Route zum Netz 192.168.1.0/24 über Interface if2 von
RouterC zu setzen.*
```bash
ip route add 192.168.1.0./24 via 192.168.30.2 dev if2
```
<br/>
<br/>

*Schreiben Sie den Befehl auf um sich die Routing-Tabellen anzeigen zu
lassen und die Ausgabe in eine Datei umzuleiten.*
```bash
route -n > routingtable.txt
```

<br />
<br />

*Geben Sie die jeweilige Gateway IP-Adresse in Tabelle 4 in Bezug zu
Abbildung 31 an.*
