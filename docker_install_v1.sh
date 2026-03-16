#!/bin/bash                                                                                                                                       
# Shabang mit dem Verweis auf die Bash-Shell
# Wir beginnen, indem wir alle alten Dockerfiles und Docker selbst löschen

sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1) -y        # Entfernt alle altlasten von Docker, sofernvorhanden

sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras -y                     # Docker deinstalieren

sudo rm -rf /var/lib/docker                                                                                                                      # Docker lib löschen
sudo rm -rf /var/lib/containerd                                                                                                                  # Container lib löschen

sudo rm /etc/apt/sources.list.d/docker.sources                                                                                                   # Quelle löschen                                                                                                 
sudo rm /etc/apt/keyrings/docker.asc                                                                                                             # Docker Schlüssel löschen

# Jetzt installieren wir Docker von Grund auf neu

# Füge Docker seine offiziellen GPG Schlüssel hinzu:
sudo apt update                                                                                                                                  # Update
sudo apt install ca-certificates curl                                                                                                            # vertrauenswürdiges Root-Zertifikat
sudo install -m 0755 -d /etc/apt/keyrings                                                                                                        # Neue Diractory erstelle, falls noch nicht vorhanden und Rechte vergeben
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc                                                     # GPG-Schlüssek runterladen und bei docker.asc speichern           
sudo chmod a+r /etc/apt/keyrings/docker.asc                                                                                                      # Leserecht für alle User für docker.asc hinzufügen

# #Das Repository dem Apt Quellenverzeichnis hinzufügen: Bis EOF wir folgendes in die Datei docker.sources geschrieben, Typ: Debian,Downloadpfad, Ubuntu-Verion wird automatisch erkannt, Stabiles Datenpaket, Lässt nur Dateien zu, die mit GPG-Schlüssel signiert sind, End of File (EOF)
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF                                                                                           
Types: deb                                                                                                                                       
URIs: https://download.docker.com/linux/ubuntu                                                                                                   
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")                                                                    
Components: stable                                                                                                                              
Signed-By: /etc/apt/keyrings/docker.asc                                                                                                          
EOF                                                                                                                                             

sudo apt update                                                                                                                                  

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y                                             


sudo systemctl enable docker.service                                                                                                            
sudo systemctl enable containerd.service                                                                                                         

                                                                                                                  
