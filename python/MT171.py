#
# IskraEmeco MT171 IR Datalogger
# Release 0.20
# Author J. van der Linde
# Copyright (c) 2012 J. van der Linde
#
# Although there is a explicit copyright on this sourcecode, anyone may use it freely under a
# "Creative Commons Naamsvermelding-NietCommercieel-GeenAfgeleideWerken 3.0 Nederland" licentie.
# Please check http://creativecommons.org/licenses/by-nc-nd/3.0/nl/ for details
#
# This software is provided as is and comes with absolutely no warranty.
# The author is not responsible or liable (direct or indirect) to anyone for the use or misuse of this software.
# Any person using this software does so entirely at his/her own risk.
# That person bears sole responsibility and liability for any claims or actions, legal or civil, arising from such use.
# If you believe this software is in breach of anyone's copyright you will inform the author immediately so the offending material
# can be removed upon receipt of proof of copyright for that material.
#
# Dependend on Python 3.2+ and Python 3.2+ packages: PySerial 2.5
#
# If something fails in python: find /usr -name '*.pyc' -delete

version = "MT171 v0.20c"
import sys
import serial
import datetime
import csv
import os
import locale
import requests
# import mysql.connector

def scan_serial():
# scan for available ports. return a list of tuples (num, name)
    available = []
    for i in range(256):
        try:
            s = serial.Serial(i)
            if win_os:
# Windows style COM portname is returned from serial: COM1, COM2, etc...
                available.append( (i, s.portstr))
            else:
# Linux Style COM portname is not correctly returned, should be /dev/ttyUSB0, /dev/ttyUSB1, etc...
                available.append( (i, "/dev/ttyUSB"+str(i) ) )
            s.close()   # explicit close 'cause of delayed GC in java
        except serial.SerialException:
            pass
    return available

################
#Error display #
################
def show_error():
    ft = sys.exc_info()[0]
    fv = sys.exc_info()[1]
    print("Fout type: %s" % ft )
    print("Fout waarde: %s" % fv )
    return

################
#Scherm output #
################
def print_iskra_telegram():
    print ("---------------------------------------------------------------------------------------")
    print ("Iskra MT171 telegram ontvangen op: %s" % iskra_timestamp)
    print ("Meter fabrikant/type: %s" % iskra_metertype)
    print (" 0. 0. 0 - Meternummer: %s" % iskra_equipment_id )
    print (" 1. 8. 0 - Meterstand 1 Totaal: %0.3f %s" % (iskra_meterreading_1_tot, iskra_unitmeterreading_1_tot) )
    print (" 1. 8. 1 - Meterstand 1 Tarief 1: %0.3f %s" % (iskra_meterreading_1_1, iskra_unitmeterreading_1_1) )
    print (" 1. 8. 2 - Meterstand 1 Tarief 2: %0.3f %s" % (iskra_meterreading_1_2, iskra_unitmeterreading_1_2) )
    print (" 2. 8. 0 - Meterstand 2 Totaal: %0.3f %s" % (iskra_meterreading_2_tot, iskra_unitmeterreading_2_tot) )
    print (" 2. 8. 1 - Meterstand 2 Tarief 1: %0.3f %s" % (iskra_meterreading_2_1, iskra_unitmeterreading_2_1) )
    print (" 2. 8. 2 - Meterstand 2 Tarief 2: %0.3f %s" % (iskra_meterreading_2_2, iskra_unitmeterreading_2_2) )
    print ("Einde MT171 telegram" )
    return

###################
# Domoticz Output #
###################
def domoticz_iskra_telegram():
    idx=str(36)
    url="http://192.168.2.12:8080/json.htm?type=command&param=udevice&idx=" + idx + "&nvalue=0&svalue=" + str(int(iskra_meterreading_1_1) * 1000) + ";" + str(int(iskra_meterreading_1_2) * 1000) + ";" + str(int(iskra_meterreading_2_1) * 1000) + ";" + str(int(iskra_meterreading_2_2) * 1000) + ";0;0"
    print(url)
    requests.get(url)

################
#Csv output #
################
def csv_iskra_telegram():
#New filename every day
    csv_filename=datetime.datetime.strftime(datetime.datetime.today(), "iskra_"+"%Y-%m-%d"+".csv" )
    try:
#If csv_file exists: open it
        csv_file=open(csv_filename, 'rt')
        csv_file.close()
        csv_file=open(csv_filename, 'at', newline='', encoding="utf-8")
        writer = csv.writer(csv_file, dialect='excel', delimiter=';', quoting=csv.QUOTE_NONNUMERIC)
    except IOError:
#Otherwise: create it
        csv_file=open(csv_filename, 'wt', newline='', encoding="utf-8")
        writer = csv.writer(csv_file, dialect='excel', delimiter=';', quoting=csv.QUOTE_NONNUMERIC)
#Write csv-header
        writer.writerow([
         'iskra_timestamp',
         'iskra_metertype',
         'iskra_equipment_id',
         'iskra_meterreading_1_tot',
         'iskra_unitmeterreading_1_tot',
         'iskra_meterreading_1_1',
         'iskra_unitmeterreading_1_1',
         'iskra_meterreading_1_2',
         'iskra_unitmeterreading_1_2',
         'iskra_meterreading_1_tot',
         'iskra_unitmeterreading_2_tot',
         'iskra_meterreading_2_1',
         'iskra_unitmeterreading_2_1',
         'iskra_meterreading_2_2',
         'iskra_unitmeterreading_2_2'])
    print ("Iskra telegram in %s gelogd op: %s" % (csv_filename, iskra_timestamp) )
    writer.writerow([
         iskra_timestamp,
         iskra_metertype,
         iskra_equipment_id,
         iskra_meterreading_1_tot,
         iskra_unitmeterreading_1_tot,
         iskra_meterreading_1_1,
         iskra_unitmeterreading_1_1,
         iskra_meterreading_1_2,
         iskra_unitmeterreading_1_2,
         iskra_meterreading_2_tot,
         iskra_unitmeterreading_2_tot,
         iskra_meterreading_2_1,
         iskra_unitmeterreading_2_1,
         iskra_meterreading_2_2,
         iskra_unitmeterreading_2_2])
    csv_file.close()

    return


################################################################################################################################################
#Main program
################################################################################################################################################
print ("Iskra IR Datalogger %s" % version)
comport=0
output_mode="scherm"
win_os = (os.name == 'nt')
if win_os:
    print("Windows Mode")
else:
    print("Non-Windows Mode")
print("Python versie %s.%s.%s" % sys.version_info[:3])
print ("Control-C om af te breken")


#comport parameters
try:
    comport=int(sys.argv[1])
except:
    print ("Opstart syntaxis: 'mt171.py {COM poort-nummer} {uitvoer-modus} {db_host} {db_user} {db_password} {db_database}'")
    print ("Ontbrekende of verkeerde parameter: COM poort-nummer.")
    print ("Toegestane waarden:")
#scanserial returns win_os serial ports and non win_os USB serial ports
    for n,s in scan_serial():
        port=n+1
        print ("%d --> %s" % (port,s) )
    print ("Programma afgebroken.")
    sys.exit()

#output_mode parameters
try:
    output_mode=sys.argv[2]
except:
    print ("Opstart syntaxis: 'mt171.py {COM poort-nummer} {uitvoer-modus} {db_host} {db_user} {db_password} {db_database}'")
    print ("Ontbrekende of verkeerde parameters: ")
    print ("- Uitvoer-modus. Geldige waarden: 'scherm', 'csv', 'domoticz'. 'scherm' gebruikt")
    output_mode="scherm"
if output_mode not in ["scherm", "csv", "domoticz"]:
    print ("Opstart syntaxis: 'mt171.py {COM poort-nummer} {uitvoer-modus} {db_host} {db_user} {db_password} {db_database}'")
    print ("Ontbrekende of verkeerde parameters: ")
    print ("- Uitvoer-modus. Geldige waarden: 'scherm', 'csv', 'domoticz'. 'scherm' gebruikt")
    output_mode="scherm"


#Set COM port config
if comport != 0:
    ser = serial.Serial()
    ser.baudrate = 300
    ser.bytesize=serial.SEVENBITS
    ser.parity=serial.PARITY_EVEN
    ser.stopbits=serial.STOPBITS_TWO
    ser.xonxoff=0
    ser.rtscts=0
    ser.timeout=20
    if win_os:
        ser.port=comport-1
    else:
        ser.port="/dev/ttyUSB"+str(comport-1)

#Show startup arguments
print ("Opstart parameters:")
if comport != 0:
        if win_os:
            print ("COM poort-nummer: %d (%s)" % (comport, ser.name) )
        else:
# ser.name property is not available in Linux.
            port="/dev/ttyUSB"+str(comport-1)  # Linux Style for /dev/ttyUSB0, /dev/ttyUSB1, etc...
            print ("COM poort-nummer: %d (%s)" % (comport, port) )
else:
    print ("COM poort-nummer: NVT, Interne testdata wordt gebruikt")
print ("Uitvoer-modus: %s" % output_mode )
if output_mode == "db":
    print ("MySQL-verbinding: %s / %s" % (p1_mysql_host, p1_mysql_db) )

if comport == 0:
#################################################################
# Use test values instead of COM port reading                   #
#################################################################
    ir_buffer = "/ISk5MT171-0033\r\n"
    ir_lines = ir_buffer.strip().split('\r\n')
    ir_buffer = "C.1.0*255(40888053)\r\n1-0:0.0.0*255(40888053)\r\n1-0:0.2.0*255(V1.0)\r\n1-0:1.8.0*255(024562 kWh)\r\n1-0:1.8.1*255(000000 kWh)\r\n1-0:1.8.2*255(024562 kWh)\r\n1-0:2.8.0*255(000000 kWh)\r\n1-0:2.8.1*255(000000 kWh)\r\n1-0:2.8.2*255(000000 kWh)\r\nFF(00000000)\r\n!\r\n\x03\x10"
    ir_lines.extend(ir_buffer.strip().split('\r\n'))
#    ir_buffer = "0\r\n"
#    ir_lines.extend(ir_buffer.strip().split('\r\n'))
else:
#################################################################
# COM port reading                                              #
#################################################################
    #Open COM port
    try:
        ser.open()
    except:
        if win_os:
            sys.exit ("Fout bij het openen van %s. Programma afgebroken."  % ser.name)
        else:
            sys.exit ("Fout bij het openen van %s. Programma afgebroken."  %  port)
    #Initialize
    print ("Initialisatie op 300 baud")
    ir_command='/?!\x0D\x0A'
    ser.write(ir_command.encode('utf-8'))
    #ser.flush()
    #Wait for initialize confirmation
    ir_buffer = ''
#    while '/ISk5MT171-0133\r\n' not in ir_buffer:
    while '/ISk' not in ir_buffer:
        ir_buffer = str(ser.readline(), "utf-8")
        if '/?!\x0D\x0A' in ir_buffer:
            ir_buffer = str(ser.readline(), "utf-8")
    ir_lines = ir_buffer.strip().split('\r\n')
    print ("Gegevensuitwisseling op 300 baud")
    #Acknowledge to 300baud
    ir_command='\x06000\x0D\x0A'
    ser.write(ir_command.encode('utf-8'))
    #ser.flush()
    #Wait for data
    ir_buffer = ''
    ETX = False
    while not ETX:
        ir_buffer = str(ser.readline(), "utf-8")
        if '\x06000\x0D\x0A' in ir_buffer:
            ir_buffer = str(ser.readline(), "utf-8")
        if '\x03' in ir_buffer:
            ETX = True
    #Strip the STX character
        ir_buffer = ir_buffer.replace('\x02','')
    #Strip the ! character
        ir_buffer = ir_buffer.replace('!','')
    #Strip the ETX character
        ir_buffer = ir_buffer.replace('\x03','')
        ir_lines.extend(ir_buffer.strip().split('\r\n'))
    print ("Gegevensuitwisseling voltooid")
    #Close port and show status
    try:
        ser.close()
    except:
        if win_os:
            sys.exit ("Fout bij het sluiten van %s. Programma afgebroken."  % ser.name)
        else:
            sys.exit ("Fout bij het sluiten van %s. Programma afgebroken."  %  port)

#################################################################
# Process data                                                  #
#################################################################
print ("Number of received elements: %d" % len(ir_lines))
print ("Array of received elements: %s" % ir_lines)

iskra_timestamp=datetime.datetime.strftime(datetime.datetime.today(), "%Y-%m-%d %H:%M:%S" )
iskra_data = ir_lines

#iskra_metertype  <= iskra_data[0]
#iskra_data[0] /ISk5MT171-0133
iskra_metertype = iskra_data[0]

#iskra_equipment_id  <= iskra_data[2]
#iskra_data[1] 0-0:C.1.0*255(40888053)
#iskra_data[2] 1-0:0.0.0*255(40888053)
iskra_element = iskra_data[2]
iskra_num_start=iskra_element.find("0.0.0*255(")+10
iskra_num_end=iskra_element.find(")",iskra_num_start)
iskra_equipment_id = iskra_element[iskra_num_start:iskra_num_end]

iskra_element = iskra_data[4]
#iskra_data[4] 1-0:1.8.0*255(024562 kWh)
iskra_num_start = iskra_element.find("1.8.0*255(") +10
iskra_num_end=iskra_element.find(" ",iskra_num_start)
iskra_meterreading_1_tot = float(iskra_element[iskra_num_start:iskra_num_end])
iskra_num_start = iskra_num_end+1
iskra_num_end=iskra_element.find(")",iskra_num_start)
iskra_unitmeterreading_1_tot = iskra_element[iskra_num_start:iskra_num_end]

iskra_element = iskra_data[5]
#iskra_data[5] 1-0:1.8.1*255(000000 kWh)
iskra_num_start = iskra_element.find("1.8.1*255(") +10
iskra_num_end=iskra_element.find(" ",iskra_num_start)
iskra_meterreading_1_1 = float(iskra_element[iskra_num_start:iskra_num_end])
iskra_num_start = iskra_num_end+1
iskra_num_end=iskra_element.find(")",iskra_num_start)
iskra_unitmeterreading_1_1 = iskra_element[iskra_num_start:iskra_num_end]

iskra_element = iskra_data[6]
#iskra_data[6] 1-0:1.8.2*255(024562 kWh)
iskra_num_start = iskra_element.find("1.8.2*255(") +10
iskra_num_end=iskra_element.find(" ",iskra_num_start)
iskra_meterreading_1_2 = float(iskra_element[iskra_num_start:iskra_num_end])
iskra_num_start = iskra_num_end+1
iskra_num_end=iskra_element.find(")",iskra_num_start)
iskra_unitmeterreading_1_2 = iskra_element[iskra_num_start:iskra_num_end]

iskra_element = iskra_data[7]
#iskra_data[7] 1-0:2.8.0*255(000000 kWh)
iskra_num_start = iskra_element.find("2.8.0*255(") +10
iskra_num_end=iskra_element.find(" ",iskra_num_start)
iskra_meterreading_2_tot = float(iskra_element[iskra_num_start:iskra_num_end])
iskra_num_start = iskra_num_end+1
iskra_num_end=iskra_element.find(")",iskra_num_start)
iskra_unitmeterreading_2_tot = iskra_element[iskra_num_start:iskra_num_end]

iskra_element = iskra_data[8]
#iskra_data[8] 1-0:2.8.1*255(000000 kWh)
iskra_num_start = iskra_element.find("2.8.1*255(") +10
iskra_num_end=iskra_element.find(" ",iskra_num_start)
iskra_meterreading_2_1 = float(iskra_element[iskra_num_start:iskra_num_end])
iskra_num_start = iskra_num_end+1
iskra_num_end=iskra_element.find(")",iskra_num_start)
iskra_unitmeterreading_2_1 = iskra_element[iskra_num_start:iskra_num_end]

iskra_element = iskra_data[9]
#iskra_data[9] 1-0:2.8.2*255(000000 kWh)
iskra_num_start = iskra_element.find("2.8.2*255(") +10
iskra_num_end=iskra_element.find(" ",iskra_num_start)
iskra_meterreading_2_2 = float(iskra_element[iskra_num_start:iskra_num_end])
iskra_num_start = iskra_num_end+1
iskra_num_end=iskra_element.find(")",iskra_num_start)
iskra_unitmeterreading_2_2 = iskra_element[iskra_num_start:iskra_num_end]



#################################################################
# Output based on startup parameter 'output_mode'               #
#################################################################
#Output to scherm
if output_mode=="scherm": print_iskra_telegram()
#Output to csv_file
if output_mode=="csv": csv_iskra_telegram()
#Output to database
if output_mode=="domoticz": domoticz_iskra_telegram()




