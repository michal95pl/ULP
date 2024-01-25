import customtkinter
import USB
import Audio
import AudioPlot

class GUI:

    __window = customtkinter.CTk()
    __device = None

    def __init__(self):
        self.__window.title("ULP - made by M.L")
        self.__window.geometry("1280x720")
        self.__window.minsize(1280, 720)
        self.__window.maxsize(1280, 720)


    def startPage(self, usb : USB, audio : Audio):

        comboxUsb = customtkinter.CTkComboBox(master=self.__window, state=  "readonly", values=usb.getdevices())
        comboxAudio = customtkinter.CTkComboBox(master=self.__window, state="readonly", values=audio.getDevicesName(), width=200)

        def startSend(): # run send thread
            audioDevice = audio.indexToDevice(audio.nameToDevice(comboxAudio.get()))
            if comboxUsb.get() != "" and usb.checkConnection(comboxUsb.get()) and comboxAudio.get() != "" and audio.checkDevice(audioDevice): # check devices if ready
                usb.setDevice(comboxUsb.get())
                audio.setDevice(audioDevice)
                audio.setUsbDevice(usb)

                audio.start()
                AudioPlot.AudioPlot(self.__window, audio).start()

                comboxUsb.destroy()
                comboxAudio.destroy()
                buttonUsb.destroy()

        buttonUsb = customtkinter.CTkButton(master=self.__window, text="Set", command=startSend)

        comboxUsb.pack()
        comboxAudio.pack()
        buttonUsb.pack()
        self.__window.mainloop()

    def setSelectedDevice(self, dev):
        print(dev)
        self.__device = dev

    def getSelectedDevice(self):
        return self.__device