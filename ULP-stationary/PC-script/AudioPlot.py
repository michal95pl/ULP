import customtkinter
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import threading
import Audio
from time import sleep
import numpy
from matplotlib.figure import Figure

class AudioPlot(threading.Thread):

    __window = None
    __audio : Audio = None

    def __init__(self, window, audio):
        super().__init__()
        self.__window = window
        self.__audio = audio

    def run(self):
        print("INFO: running plot thread")
        print('\033[93m' + "WARNING: check if signal is 0 on the plot" + '\033[0m')

        audioVolume = customtkinter.CTkProgressBar(master=self.__window)
        audioVolume.pack()

        #fig, ax = plt.subplots()
        #ax.set_xlim(0, 400) # 0,1024 0-7
        #ax.set_ylim(0, 0.02)
        #line, = ax.semilogx(self.__audio.getFftDate())
        #line, = ax.plot(self.__audio.getFftDate())
        #canvas = FigureCanvasTkAgg(fig, master=self.__window)  # A tk.DrawingArea.
        #canvas.draw()
        #canvas.get_tk_widget().pack()

        while True:
            data = self.__audio.getAudioData()
            #ax.plot(self.__audio.getFftDate())
            #line.set_ydata(self.__audio.getFftDate())
            #canvas.draw()
            #canvas.flush_events()
            #self.__window.update()
            audioVolume.set(data/ 60)
            #print(self.__audio.getAudioData())
            sleep(0.0001)