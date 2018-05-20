#!/usr/bin/python
#
#-Metadata----------------------------------------------------------------
# Filename: add-to-panel.py
# Date: 2016-01-27
#-Notes-------------------------------------------------------------------
# Just adds a list of apps to the Kali MATE top panel
# 
# just check /usr/share/applications and add your favorite
# apps from there into the apps list and away you go. 
#

import subprocess

apps = [ 'mate-terminal', 'iceweasel', 'kali-wireshark','kali-msfconsole',
	 'kali-zaproxy', 'kali-burpsuite', 'kali-zenmap', 'sublime_text' ]

print "[*] Fetching current panel objects..."
gsettings = subprocess.check_output(['gsettings','get','org.mate.panel','object-id-list']).strip()
objlist = eval(gsettings)

for app in apps:
	print "[+] Adding " + app
	subprocess.call(['gsettings','set','org.mate.panel.object:/org/mate/panel/objects/' + app + '/', 'launcher-location','\'/usr/share/applications/' + app + '.desktop\'']) 
	subprocess.call(['gsettings','set','org.mate.panel.object:/org/mate/panel/objects/' + app + '/', 'position','-1']) 
	subprocess.call(['gsettings','set','org.mate.panel.object:/org/mate/panel/objects/' + app + '/', 'toplevel-id','\'top\'']) 

	if app not in objlist:
		objlist.append(app)
	
objstr = repr(objlist)

subprocess.call(['gsettings','set','org.mate.panel','object-id-list',objstr])
print "[*] Done"
