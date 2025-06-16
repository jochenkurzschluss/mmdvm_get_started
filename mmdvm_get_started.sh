#!/bin/bash
#
# Script Name:      mmdvm_get_started
# Beschreibung:     installationshilfe des MMDVMHost, DMRgateway und DAPNETGateway
# Aufruf:           ./mmdvm_get_started.sh
#               
#               
# Autor:            Michael Herholt DO2ITH https://www.ithnet.de
# Version:          v 1.1
# Datum:            17:00 MESZ 16.06.2025
# Dokumentation:    README.txt oder https://www.ithnet.de/mmdvm_get_started.html

# Quellen festlegen
current_user=$(whoami)
current_directory=$(pwd)
hotdat='/opt/hotspot/hotspot.sh'

# Log anlegen
touch instLog.log
echo -e "\n\nLog beginn\n\n\n" >> $current_directory/instLog.log
# Log Zeitsptempel 
date >> instLog.log
# Log welche Variabeln sind vorhanden
echo -e "\n\nGesetzte Variabeln:\n-aktueller Benutzer= "$current_user"\n-aktuelles Verzeichniss= "$current_directory"\n-hotdat= "$hotdat"\n" >> instLog.log

# Eigentliches Script starten
echo "#   Willkommen zur installationshilfe zum MMDVM Hotspot " 
echo "#   Orientierung war heirbei die Anleitung von hamspirit.de "
echo "#   Dieses script ist nur zur unterstützung keine volle Installation"
echo "#   scriptversion v 1.1 von DO2ITH"
echo "#   "
echo "#   Dieses Script installiert den MMDVM Hotspot mit der software von G4KLX"
echo "#   im Detail ist das MMDVMHOST, DMRGateway und DAPNetGateway"

# Benutzer nach der Konfiguration fragen
read -r -p "#   Konfiguration des Hotspots Starten ? [y/N] " konfchk
if [[ "$konfchk" =~ ^([yY][eE][sS]|[yY])$ ]]
then # Konfiguration der Gateways und des MMDVM host 
    echo -e $(date '+%H:%M:%S')"- Kofiguration der .ini Dateien wurde gestartet" >> $current_directory/instLog.log
    echo "#   MMDVM.ini konfiguration starten..."
    read -t 30
    nano $current_directory"/config/MMDVM.ini"
    echo "#   DMRGateway.ini konfiguration starten..."
    read -t 30
    nano $current_directory"/config/DMRGateway.ini"
    echo "#   DAPNETGateway.ini konfiguration starten..."
    read -t 30
    nano $current_directory"/config/DAPNETGateway.ini"
else
    echo "#   Konfiguration wird Übersprungen ! ! !"
    echo -e $(date '+%H:%M:%S')" - Benutzer hat vorhergehende Konfiguration übersprungen" >> $current_directory/instLog.log
fi

# Warnung ausgeben Kanfig Nötig! Weitere infos unter https://github.com/g4klx/ 
# Weitere informationen zur Konfiguration unter https://www.hamspirit.de/10874/mmdvmhost-und-dmrgateway-einrichten-ohne-fertige-images/
echo -e "\n\n --- ACHTUNG ! ! ! --- \n\n Datein im Verzeichniss conf/ sollten fertig konfiguriert sein ! \n\n"

# Eigentliches Installations-Script Starten
read -r -p "#   Installationshilfe starten ? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo -e $(date '+%H:%M:%S')"- Benutzer Antwort auf die frage Installationshilfe starten war: JA\n\n\n\n\n" >> $current_directory/instLog.log
    echo "#   Wir brauchen Sudo! Es wird auch geprüft ob die abhängigkeiten erfüllt sind!"
    echo "#   "
    echo "#   "
    echo "#   "
    echo "#   "
    echo -e $(date '+%H:%M:%S')"- Installationsquellen Aktualisieren" >> $current_directory/instLog.log
    echo "#   Aktualisiere die Installationsquellen"
    sudo apt-get update | tee  &>> $current_directory/instLog.log
    echo -e $(date '+%H:%M:%S')"- Aktualisieren des Systems" >> $current_directory/instLog.log
    echo "#   Aktualisiere das System"
    sudo apt-get upgrade -y | tee &>> $current_directory/instLog.log
    echo "#   "
    echo "#   "
    echo "#   "
    echo "#   "
    echo "#   Prüfe Abhängigkeiten..."
    echo -e $(date '+%H:%M:%S')"- Installation fehlender Pakete" >> $current_directory/instLog.log
    sudo apt-get install git vim gcc cpp build-essential cmake automake nano screen -y  | tee &>> $current_directory/instLog.log
    echo "#   "
    echo "#   "
    echo "#   "
    echo "#   "

# Benutzer abfrage
    read -r -p "#   Ist der User \""$current_user"\" korrekt ? [y/N] " responseii
    if [[ "$responseii" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        echo -e $(date '+%H:%M:%S')"\n\n- Hotspot wird auf folgenden Benutzer Installiert: \n- \""$current_user"\" \n\n\n -Angelegte verzeichnisse\n - /opt/hotspot/MMDVMHost \n - /opt/hotspot/DMRGateway\n - /opt/hotspot/DAPNETGateway \n" >> $current_directory/instLog.log
        echo "#   ... erstelle verzeichnisse und setze Rechte"
        sudo mkdir /opt/hotspot
        sudo mkdir /var/log/hotspot
        sudo chown "$current_user":"$current_user" /var/log/hotspot
        sudo chown "$current_user":"$current_user" /opt/hotspot
        echo "#   "
        echo "#   Wechsle Verzeichniss!"
        cd /opt/hotspot
        echo $(date '+%H:%M:%S')" - Verzeichniss wechsel zu /opt/hotspot" >> $current_directory/instLog.log
        echo "#   Lade Daten herrunter"

# Quelldaten Herunterladen
        git clone https://github.com/g4klx/MMDVMHost.git 
        git clone https://github.com/g4klx/DMRGateway 
        git clone https://github.com/g4klx/DAPNETGateway.git 

# MMDVMHost mit make kompelieren
        echo "#   Kompieliere... MMDVMHost"
        echo $(date '+%H:%M:%S')" - wechsle in verzeichniss /opt/hotspot/MMDVMHost" >> $current_directory/git_mmdvm.log
        cd /opt/hotspot/MMDVMHost
        make | tee &>> instLog.log

# DMRGateway mit make kompelieren
        echo "#   Kompieliere... DMRGateway"
        echo $(date '+%H:%M:%S')" - wechsle in verzeichniss /opt/hotspot/DMRGateway" >> $current_directory/git_dmr.log
        cd /opt/hotspot/DMRGateway
        make | tee &>> instLog.log

# DAPNETGateway mit make kompelieren
        echo "#   Kompieliere... DAPNETGateway"
        echo $(date '+%H:%M:%S')" - wechsle in verzeichniss /opt/hotspot/DAPNETGateway" >> $current_directory/git_dapnet.log
        cd /opt/hotspot/DAPNETGateway
        make | tee &>> instLog.log

# Benutzer informieren
        echo -e "#   make ist fertig.\n\n#   Kopieren der Konfiguration wird vorbereitet!"
        echo $(date '+%H:%M:%S')" - Kopiere Konfiguration" >> $current_directory/instLog.log
        cp -f "$current_directory"/config/MMDVM.ini /opt/hotspot/MMDVMHost/MMDVM.ini
        cp -f "$current_directory"/config/DMRGateway.ini /opt/hotspot/MMDVMHost/DMRGateway.ini
        cp -f "$current_directory"/config/DAPNETGateway.ini /opt/hotspot/MMDVMHost/DAPNETGateway.ini

# Anlegen der Startdatei
        echo $(date '+%H:%M:%S')" - lege hotspot.sh an" >> $current_directory/instLog.log
        touch /opt/hotspot/hotspot.sh
        

# hotspotsh vorbereiten und schreiben
        echo $(date '+%H:%M:%S')" - schreibe hotspot.sh in /opt/hotspot" >> $current_directory/instLog.log
        echo "#! /bin/bash " >> $hotdat
        echo " " >> $hotdat
        echo "### BEGIN INIT INFO " >> $hotdat
        echo "# Provides:          MMDVM Hotspot " >> $hotdat
        echo "# Required-Start:    \$local_fs \$network " >> $hotdat
        echo "# Required-Stop:     \$local_fs " >> $hotdat
        echo "# Default-Start:     2 3 4 5 " >> $hotdat
        echo "# Default-Stop:      0 1 6 " >> $hotdat
        echo "# Short-Description: MMDVM Hotspot service " >> $hotdat
        echo "# Description:       MMDVM Hotspot service " >> $hotdat
        echo "### END INIT INFO " >> $hotdat
        echo " " >> $hotdat
        echo "case \"\$1\" in " >> $hotdat
        echo "  start) " >> $hotdat
        echo "    echo \"Starting Hotspot...\" " >> $hotdat
        echo "    sudo -u "$current_user" bash -c '/opt/hotspot/MMDVMHost/MMDVMHost /opt/hotspot/MMDVMHost/MMDVM.ini' & " >> $hotdat
        echo "    sudo -u "$current_user" bash -c '/opt/hotspot/DMRGateway/DMRGateway /opt/hotspot/DMRGateway/DMRGateway.ini' &  " >> $hotdat
        echo "    sudo -u "$current_user" bash -c '/opt/hotspot/DAPNETGateway/DAPNETGateway /opt/hotspot/DAPNETGateway/DAPNETGateway.ini' & " >> $hotdat
        echo " " >> $hotdat
        echo "    ;; " >> $hotdat
        echo "  stop) " >> $hotdat
        echo "    echo \"Stopping Hotspot...\" " >> $hotdat
        echo " " >> $hotdat
        echo "    sudo -u root bash -c 'killall MMDVMHost' " >> $hotdat
        echo "    sudo -u root bash -c 'killall DMRGateway' " >> $hotdat
        echo "    sudo -u root bash -c 'killall DAPNETGateway' " >> $hotdat
        echo " " >> $hotdat
        echo "    sleep 2 " >> $hotdat
        echo "    ;; " >> $hotdat
        echo "  *) " >> $hotdat
        echo "    echo \"Usage: /etc/init.d/hotspot {start|stop}\" " >> $hotdat
        echo "    exit 1 " >> $hotdat
        echo "    ;; " >> $hotdat
        echo "esac " >> $hotdat
        echo " " >> $hotdat
        echo "exit 0 " >> $hotdat
        echo -e $(date '+%H:%M:%S')" - hotspot.sh ist geschrieben !" >> $current_directory/instLog.log

# Installationshilfe abschließen
        echo -e "#   Die Installationshilfe ist abgeschlossen ! \n#   Bemerkungen in bezug des Erfolgs siehe Logdatei"
        echo -e $(date '+%H:%M:%S')" -   Installationshilfe ist abgeschlossen\nSchluss ! ! !" >> $current_directory/instLog.log
        read -t 30
        cat $current_directory"/instLog.log"

    else

#Falscher User ?
        echo -e $(date '+%H:%M:%S')" -   Falscher User\n- Bitte als Benutzer des Hotspots anmelden! Abbruch ! \n" >> $current_directory/instLog.log
        echo "#   Bitte als Benutzer des Hotspots anmelden! Abbruch !" 
    fi
else

# Benutzer bricht Script ab!
    echo -e $(date '+%H:%M:%S')" - Script durch Benutzer Abgebrochen!" >> $current_directory/instLog.log
    echo "#   "
    echo "#   "
    echo "#   "
    echo "#   "
    echo "#   Abbruch !"
fi
