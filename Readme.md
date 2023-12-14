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


### Guide

Execute all scripts (in order), change interfaces if required.