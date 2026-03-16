#!/bin/bash                                                                                                                                       
# Shabang mit dem Verweis auf die Bash-Shell

sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1) -y        # Entfernt alle altlasten von Docker, sofernvorhanden

sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y                     # Docker deinstalieren

sudo rm -rf /var/lib/docker                                                                                                                      # Docker lib löschen
sudo rm -rf /var/lib/containerd                                                                                                                  # Container lib löschen

sudo rm /etc/apt/sources.list.d/docker.sources                                                                                                   # Quelle löschen                                                                                                 
sudo rm /etc/apt/keyrings/docker.asc                                                                                                             # Docker Schlüssel löschen

# Alles neu

# Add Docker's official GPG key:
sudo apt update                                                                                                                                  # Update
sudo apt install ca-certificates curl                                                                                                            # vertrauenswürdiges Root-Zertifikat
sudo install -m 0755 -d /etc/apt/keyrings                                                                                                        # Neue Diractory erstelle, falls noch nicht vorhanden und Rechte vergeben
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc                                                     # GPG-Schlüssek runterladen und bei docker.asc speichern           
sudo chmod a+r /etc/apt/keyrings/docker.asc                                                                                                      # Leserecht für alle User für docker.asc hinzufügen

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF                                                                                            # Bis EOF wir folgendes in die Datei docker.sources geschrieben
Types: deb                                                                                                                                       # Typ: Debian 
URIs: https://download.docker.com/linux/ubuntu                                                                                                   # Downloadpfad
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")                                                                     # Ubuntu-Verion wird automatisch erkannt
Components: stable                                                                                                                               # Stabiles Datenpaket
Signed-By: /etc/apt/keyrings/docker.asc                                                                                                          # Lässt nur Dateien zu, die mit GPG-Schlüssel signiert sind
EOF                                                                                                                                              # End of File (EOF)

sudo apt update                                                                                                                                  # Update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y                                             # Docker + Docker-Compose instalieren


sudo systemctl enable docker.service                                                                                                             # Docker Dienst starten
sudo systemctl enable containerd.service                                                                                                         # Container Dienst starten


print("Das hat geklapp")                                                                                                                          # Ausgabe um zu überprüfen, ob installation durchgelaufen ist
