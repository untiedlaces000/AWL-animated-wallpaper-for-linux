a wallpaper lite is a animated wallpaper script that is made to work with gnome x11 and works with other de's that doesn’t leak ram or crash your system

<img width="198" height="70" alt="ascii-art-text" src="https://github.com/user-attachments/assets/54b742f3-a1ee-4c03-bdd9-0a242c526a57" />


cinnamon (x11, wayland does not work),
gnome (x11, wayland does not work),
kde plasma (x11 and wayland with bugs),
labwc (awl wayland version)

<img width="1168" height="241" alt="ascii-art-text" src="https://github.com/user-attachments/assets/010e8a66-523a-459e-981c-c0d0e636c6c0" />
   

<img width="1607" height="142" alt="ascii-art-text(1)" src="https://github.com/user-attachments/assets/f1f3b7b6-d119-4e96-ac82-83a1f0a37890" />

There are two ways to install awl there is the auto install(only for version 2 and up) and there is the manual install route if you cant use the auto install
 
<img width="182" height="72" alt="ascii-art-text(1)12" src="https://github.com/user-attachments/assets/a25077d0-9f6d-4684-80cb-edf2bccc32a0" />

ONLY FOR VERSION 3 AND UP IF YOU GOT A OLDER VERSION THEN USE THE MANUAL INSTALL INSTRUCTIONS 
 these are terminal commands

no.1 download awl from the releases page 

no.2 extract the folder 

no.3 move the a-wallpaper-lite folder in a-wallpaper-lite-*.zip in your home folder

no.4
 ```shell
cd ~/a-wallpaper-lite/x11/
 ```

OR (if your using wayland)

 ```shell
cd ~/a-wallpaper-lite/wayland/
 ```

this command puts you into the install folder

no.5

  ```shell
chmod +x autoinstall.sh
 ```

no.6
 
 ```shell
sudo sh ./autoinstall.sh
 ``` 
 this runs the install script
 
 
 <img width="484" height="128" alt="ascii-art-text" src="https://github.com/user-attachments/assets/79765005-a4cd-43d8-9ee2-5c416c03c449" />

 
 no.1 download the awlscreen folder from this github repo 
 
 no.2 put awlscreen folder in home folder
 
 no.3 run cd ~/awlscreen/    in terminal
 
 no.4 run chmod +x awl*.desktop in terminal
 
 no.5 run chmod +x awlscreen.sh in terminal
 
 no.6 put awlarestart in /.config/autostart/  (may be different based on distro and DE)
 
 no.7 put awlautostart in /.config/autostart/  (may be different based on distro and DE)
 
 no.8 put awlc in /.local/share/applications  (may be different based on distro and DE)

 no.9 put awlc in /.local/share/applications  (may be different based on distro and DE)
 
 no.10 make a-wallpaper-lite folder in Pictures

 no.11 install all of the dependencies 

<img width="707" height="170" alt="ascii-art-text(2)" src="https://github.com/user-attachments/assets/414e37c6-6dd1-42dd-85b1-56740f05a8e0" />

                                                                                                
log in to your linux distro  and it should auto start the wallpaper if it doesnt then open a wallpaper lite config to select your video file and it should do the rest

if your app shortcut isn’t working then you can go to where your awlscreen folder is located in the terminal then run ./awlscreen.sh --gui to bring up the selection window

                                                                                                
