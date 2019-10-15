#Clock


#Touch Button

#required if touch button used as manual clock source

#CPLD

#Ext serial

#USB

#Ethernet

#Digital Video

#LEDS

#DPY0

#DPY1

#DIP_SW






set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]



set_property PACKAGE_PIN U20 [get_ports {rom_addrOUT[18]}]
set_property PACKAGE_PIN W23 [get_ports {rom_addrOUT[27]}]
set_property PACKAGE_PIN AA23 [get_ports {rom_addrOUT[31]}]
set_property PACKAGE_PIN U14 [get_ports {rom_addrOUT[3]}]
set_property PACKAGE_PIN V23 [get_ports {rom_addrOUT[28]}]
set_property PACKAGE_PIN V22 [get_ports {rom_addrOUT[24]}]
set_property PACKAGE_PIN U21 [get_ports {rom_addrOUT[23]}]
set_property PACKAGE_PIN Y21 [get_ports {rom_addrOUT[20]}]
set_property PACKAGE_PIN W20 [get_ports {rom_addrOUT[17]}]
set_property PACKAGE_PIN T15 [get_ports {rom_addrOUT[8]}]
set_property PACKAGE_PIN V16 [get_ports {rom_addrOUT[1]}]
set_property PACKAGE_PIN T14 [get_ports {rom_addrOUT[9]}]
set_property PACKAGE_PIN V19 [get_ports {rom_addrOUT[13]}]
set_property PACKAGE_PIN V18 [get_ports {rom_addrOUT[11]}]
set_property PACKAGE_PIN T18 [get_ports {rom_addrOUT[6]}]
set_property PACKAGE_PIN U16 [get_ports {rom_addrOUT[4]}]
set_property PACKAGE_PIN V14 [get_ports {rom_addrOUT[2]}]
set_property PACKAGE_PIN Y20 [get_ports {rom_addrOUT[16]}]
set_property PACKAGE_PIN AA22 [get_ports rom_ce]
set_property PACKAGE_PIN Y22 [get_ports clock_btn]
set_property PACKAGE_PIN U17 [get_ports reset_btn]
set_property PACKAGE_PIN V21 [get_ports {rom_addrOUT[22]}]
set_property PACKAGE_PIN AB24 [get_ports {rom_addrOUT[30]}]
set_property PACKAGE_PIN AC24 [get_ports {rom_addrOUT[29]}]
set_property PACKAGE_PIN Y23 [get_ports {rom_addrOUT[26]}]
set_property PACKAGE_PIN W18 [get_ports {rom_addrOUT[10]}]
set_property PACKAGE_PIN U15 [get_ports {rom_addrOUT[5]}]
set_property PACKAGE_PIN U22 [get_ports {rom_addrOUT[25]}]
set_property PACKAGE_PIN W21 [get_ports {rom_addrOUT[21]}]
set_property PACKAGE_PIN T20 [get_ports {rom_addrOUT[19]}]
set_property PACKAGE_PIN V17 [get_ports {rom_addrOUT[0]}]
set_property PACKAGE_PIN T19 [get_ports {rom_addrOUT[15]}]
set_property PACKAGE_PIN W19 [get_ports {rom_addrOUT[12]}]
set_property PACKAGE_PIN T17 [get_ports {rom_addrOUT[7]}]
set_property PACKAGE_PIN U19 [get_ports {rom_addrOUT[14]}]
