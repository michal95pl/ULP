import USB
import GUI
import Audio

if __name__ == "__main__":

    usb = USB.USB()
    audio = Audio.Audio()

    audio.getDevicesName()

    appGui = GUI.GUI()
    appGui.startPage(usb, audio)





