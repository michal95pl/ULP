import audioop
import time
from time import sleep
import pyaudio
import numpy
import threading
import USB

class Audio(threading.Thread):

    __audio = pyaudio.PyAudio()
    __devices = [] # all devices
    __selectedDevice = None # choosed device
    __audioData = 0 # captured audio data
    __fftData = [0] * 1024*2
    __USBDevice : USB= None

    def __init__(self):
        super().__init__()
        for i in range(self.__audio.get_device_count()):
                if self.__audio.get_device_info_by_index(i)["maxInputChannels"] > 0:
                    self.__devices.append(self.__audio.get_device_info_by_index(i))

    def nameToDevice(self, name):
        indx = -1
        for i in range(len(self.__devices)):
            if (str(self.__devices[i]["index"]) + " " + self.__devices[i]["name"]) == name:
                indx = i
                break
        return indx

    def setUsbDevice(self, device : USB):
        self.__USBDevice = device

    def indexToDevice(self, indx):
        return self.__devices[indx]

    def checkDevice(self, device):

        try:
            stream = self.__audio.open(
                            input_device_index = device["index"],
                            format=pyaudio.paInt16,
                            channels=1,
                            rate=int(device["defaultSampleRate"]),
                            input=True,
                            frames_per_buffer=1024
            )
            stream.close()
            print("INFO: audio device checked")
            return True
        except:
            print("\033[91m" + "ERROR: audio device not found or audio device is no set as default" + '\033[0m')
            return False

    # thread function
    def run(self):
        print("INFO: running audio thread")

        stream = self.__audio.open(
            input_device_index=self.__selectedDevice["index"],
            format=pyaudio.paInt16,
            channels=1,
            rate=int(self.__selectedDevice["defaultSampleRate"]),
            input=True,
            frames_per_buffer=1024*2
        )

        while True:
            data = stream.read(1024*2)
            data = numpy.frombuffer(data, dtype=numpy.int16)

            ff = numpy.fft.fft(data)
            ff = numpy.abs(ff[0:1024*2]) * 2 / (256 * 1024*2)
            self.__fftData = ff


            rms = audioop.rms(data, 2)
            if rms == 0:
                volume = 0
            else:
                volume = 20 * numpy.log10(rms)

            ffdatasend = []
            for i in range(7):
                val = int(ff[i]*300)
                if (val > 255):
                    val = 255
                if (val < 0):
                    val = 0
                ffdatasend.append(val)

            ev_data = volume*2.3
            if (ev_data > 150):
                ev_data = 150
                print('\033[93m' + "WARNING: ev value out of range of led (turn down the music for better effect)" + '\033[0m')

            self.__USBDevice.sendData(int(ev_data), ffdatasend)

            self.__audioData = volume

    def setDevice(self, device):
        self.__selectedDevice = device

    def getDevicesName(self):
        temp = []
        for item in self.__devices:
            temp.append(str(item["index"]) + " " + item["name"])
        return temp

    def getAudioData(self):
        return self.__audioData

    def getFftDate(self):
        return self.__fftData