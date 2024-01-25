import serial.tools.list_ports
import serial

class USB:
    __devicelist = [] # all avilable devices
    __device = None

    def __init__(self):
        comlist = serial.tools.list_ports.comports()

        for element in comlist:
            self.__devicelist.append(element.device)

    def checkConnection(self, device):
        try:
            device = serial.Serial(device, 115200)
            device.close()
            print("INFO: USB checked")
            return True
        except:
            print("\033[91m" + "ERROR: script can't connect to USB device, check usb connection" + '\033[0m')
            return False


    def getdevices(self):
        return self.__devicelist

    def setDevice(self, device):
        self.__device = serial.Serial(device, 115200)

    def getDevice(self):
        return self.__device

    def sendData(self, ev, eq):
        if (self.__device != None):
            try:
                self.__device.write((chr(ev) + chr(eq[0]) + chr(eq[1]) + chr(eq[2]) + chr(eq[3]) + chr(eq[4]) + chr(eq[5]) + chr(eq[6])).encode())
            except:
                print("\033[91m" + "ERROR: script can't send Vu data to USB device, check usb connection and reset app" + '\033[0m')