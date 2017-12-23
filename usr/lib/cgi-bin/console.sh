#!/bin/sh
	echo "Content-type: text/html\n"
	 
	# read in our parameters
	CMD=`echo "$QUERY_STRING" | sed -n 's/^.*cmd=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"`
	FOLDER=`echo "$QUERY_STRING" | sed -n 's/^.*folder=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"| sed "s/%2F/\//g"`
	 FOLDER1=`echo "$QUERY_STRING" | sed -n 's/^.*folder1=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"| sed "s/%2F/\//g"`
         FOLDER2=`echo "$QUERY_STRING" | sed -n 's/^.*folder2=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"| sed "s/%2F/\//g"`
	 ufwinput=`echo "$QUERY_STRING" | sed -n 's/^.*ufwinput=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"| sed "s/%2F/\//g"`
	 guestwifi=`echo "$QUERY_STRING" | sed -n 's/^.*guestwifi=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"| sed "s/%2F/\//g"`
	 channel=`echo "$QUERY_STRING" | sed -n 's/^.*channel=\([^&]*\).*$/\1/p' | sed "s/%20/ /g"| sed "s/%2F/\//g"`


	# our html header
	echo "<html>"
	echo "<head><title>Raspberry Pi WebUI</title></head>"
	echo "<body>"

	 
	# print out the form
	 
	# page header
	echo "<p>"
	echo "<center><h3>"
	echo "Raspberry Pi WebUI "
	echo "</center></h3>"
	echo "<p>"
	echo "<h4>"
	echo "Pi Hostname:  "
	echo `hostname`
	echo "   |   "
        echo "Date: "
        echo `date`
	echo "<br />"
	echo "eth0 IP Address:  "
	echo `ip addr show eth0 | grep "inet " | awk '{ print $2 }'`
	echo "   |   "
	echo "wlan0 IP Address:  "
        echo `ip addr show wlan0 | grep "inet " | awk '{ print $2 }'`
	echo "<br />"
	echo "Snort Status:"
	echo `service snort status | grep "Active:" | awk '{ print $2 }'`
	echo "</h4>"
	echo "<p>"
	echo "<table>"
	echo "<colgroup><col style="background-color:F0F8FF"><col stype="background-color:white"><col style="background-color:F0F8FF"></colgroup>"
	echo "<tr>"
	echo "<th>Available Commands:</th><th>&nbsp;</th><th>Open Wi-Fi Networks:</th>"
	echo "<tr><td>"
	echo "<form method=get>"
	echo "<input type=radio name=cmd value=showUFW checked> Show Firewall Rules<br>"
	echo "<input type=radio name=cmd value=ufwReload> Reload UFW<br>"
	echo "<input type=radio name=cmd value=ufwStart> Start UFW<br>"
	echo "<input type=radio name=cmd value=ufwStop> Stop UFW<br>"
	echo "<input type=radio name=cmd value=tailSyslog> Show Syslog<br>"
	echo "<input type=radio name=cmd value=tailAuth> Show Auth Log<br>"
	echo "<input type=radio name=cmd value=updateRPZ> Update RPZ Blocklist<br>"
	echo "<input type=radio name=cmd value=tailUFW> Show UFW Log<br>"
	echo "<input type=radio name=cmd value=tailSnort> Show Snort Log<br>"
	echo "<input type=radio name=cmd value=Start-Snort> Start Snort<br>"
	echo "<input type=radio name=cmd value=Stop-Snort> Stop Snort<br>"
	echo "<input type=radio name=cmd value=updateSnort> Update Snort Configuration<br>"
	echo "<input type=radio name=cmd value=ifconfig> Show Network Configuration<br>"
	echo "<input type=radio name=cmd value=wifiScan> Scan For Open Wi-Fi Networks<br>"
	echo "<input type=submit name=Submit/Reload>"
	echo "<br />"
	echo "<br />"
	echo "Add or Remove Firewall Rules:"
	echo "<br />"
	echo "<input type=text name=ufwinput><br />"
	echo "<input type=submit name=cmd value=ufwAllow>  <input type=submit name=cmd value=ufwDeny>  <input type=submit name=cmd value=ufwReject>   <input type=submit name=cmd value=ufwDelete>"
	echo "</td>"
	echo "<td>""</td>"
	echo "<td>"
	echo "<pre>"
	#iwlist wlan0 scan | grep "Encryption key:off" -B 2 -A 1 | grep -v "Encryption key:off" | grep -v "Quality="
	iwlist wlan0 scan | grep -B 6 "Encryption key:off" | grep -E 'ESSID|Channel' | awk '{print $1, $2, $3, $4}' | awk ' {print;} NR % 2 == 0 { print ""; }'
	echo "</pre>"
	echo "Enter the ESSID and Channel of the network you would like to connect to:<br />"
	echo "<input type=text name=guestwifi value=guestwifi>   <input type=number name=channel value=channel><br />"
	echo "<input type=submit name=cmd value=joinWiFi>"
	echo "<br />"
	echo "</td></tr>"
	echo "</form>"
	echo "</table>"
	echo "</body>"
	echo "</html>"

	 
	# test if any parameters were passed
	if [ $CMD ]
	then
	  case "$CMD" in
	    ifconfig)
	      echo "<pre>"
	      /sbin/ifconfig
	      echo "</pre>"
	      ;;

	    showUFW)
	      echo "<pre>"
	      sudo ufw status numbered
	      echo "</pre>"
	      ;;

	   Start-Snort)
	      echo "<pre>"
	      sudo service snort start
              echo "</pre>"
	      ;;

           Stop-Snort)
              echo "<pre>"
              sudo service snort stop
              echo "</pre>"
              ;;

	   updateSnort)
	      echo "<pre>"
 	      sudo bash /root/configSnort.sh
	      echo "<pre>"
              ;;

	   tailSnort)
              echo "<pre>"
              tail /var/log/snort
              echo "</pre>"
              ;;

	   tailSyslog)
	      echo "<pre>"
	      tail /var/log/syslog
	      echo "</pre>"
	      ;;

	   tailAuth)
              echo "<pre>"
              tail /var/log/auth.log
              echo "</pre>"
              ;;

           updateRPZ)
              echo "<pre>"
              bash /root/malwaredomains.sh
              echo "</pre>"
              ;;

	   tailUFW)
              echo "<pre>"
              tail /var/log/ufw.log
              echo "</pre>"
              ;;

	   ufwAllow)
              echo "<pre>"
              sudo ufw allow "$ufwinput"
	      sudo ufw status numbered
              echo "</pre>"
              ;;

	   ufwDeny)
              echo "<pre>"
              sudo ufw deny "$ufwinput"
              sudo ufw status numbered
	      echo "</pre>"
              ;;

	   ufwReject)
             echo "<pre>"
             sudo ufw reject "$ufwinput"
             sudo ufw status numbered
	     echo "</pre>"
             ;;

	  ufwDelete)
	     echo "<pre>"
	     sudo ufw --force delete "$ufwinput"
	     sudo ufw status numbered
	     echo "</pre>"
	     ;;

	  ufwReload)
              echo "<pre>"
              sudo ufw reload
              echo "</pre>"
              ;;

	  ufwStart)
 	     echo "<pre>"
	     sudo ufw --force enable
 	     echo "</pre>"
             ;;

          ufwStop)
             echo "<pre>"
             sudo ufw disable
             echo "</pre>"
             ;;

	  wifiScan)
             sudo iwlist wlan0 scan > /dev/null
	     ;;

	  joinWiFi)
	      echo "<pre>"
	      #echo "sudo /sbin/iwconfig wlan0 essid \"$guestwifi\" channel $channel mode Managed ; sudo /sbin/dhclient wlan0"
	      #echo \"$guestwifi\" 
	      #echo $channel
	      # below only accepts ssid's that have no spaces 
	      sudo /sbin/iwconfig wlan0 essid $guestwifi channel $channel mode Managed ; sudo /sbin/dhclient wlan0
	      #sudo /sbin/iwconfig wlan0 essid "Duane" channel 1 mode Managed ; sudo /sbin/dhclient wlan0  #WORKS
	      echo "</pre>"
	      ;;

	     *)
	      echo "Invalid choice $CMD<br>"
	      ;;
	  esac
	fi
