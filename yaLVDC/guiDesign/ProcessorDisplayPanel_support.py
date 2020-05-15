#! /usr/bin/env python
#  -*- coding: utf-8 -*-
#
# Support module generated by PAGE version 5.2
#  in conjunction with Tcl version 8.6
#    May 15, 2020 03:33:26 PM CDT  platform: Linux

import sys

try:
  import Tkinter as tk
except ImportError:
  import tkinter as tk

try:
  import ttk
  py3 = False
except ImportError:
  import tkinter.ttk as ttk
  py3 = True

def set_Tk_var():
  global bPRA1
  bPRA1 = tk.IntVar()
  global bPRA2
  bPRA2 = tk.IntVar()
  global bPRA3
  bPRA3 = tk.IntVar()
  global bPRA12
  bPRA12 = tk.IntVar()
  global bPRA4
  bPRA4 = tk.IntVar()
  global bPRA5
  bPRA5 = tk.IntVar()
  global bPRA6
  bPRA6 = tk.IntVar()
  global bPRA11
  bPRA11 = tk.IntVar()
  global bPRA7
  bPRA7 = tk.IntVar()
  global bPRA8
  bPRA8 = tk.IntVar()
  global bPRA9
  bPRA9 = tk.IntVar()
  global bPRA10
  bPRA10 = tk.IntVar()
  global bPRA14
  bPRA14 = tk.IntVar()
  global bPRA15
  bPRA15 = tk.IntVar()
  global bPRA16
  bPRA16 = tk.IntVar()
  global bPRA17
  bPRA17 = tk.IntVar()
  global bPRA18
  bPRA18 = tk.IntVar()
  global bPRA19
  bPRA19 = tk.IntVar()
  global bPRA20
  bPRA20 = tk.IntVar()
  global bPRA21
  bPRA21 = tk.IntVar()
  global bPRA22
  bPRA22 = tk.IntVar()
  global bPRA23
  bPRA23 = tk.IntVar()
  global bPRA24
  bPRA24 = tk.IntVar()
  global bPRA25
  bPRA25 = tk.IntVar()
  global bPRAS
  bPRAS = tk.IntVar()
  global bPRA13
  bPRA13 = tk.IntVar()
  global bPRBS
  bPRBS = tk.IntVar()
  global bPRB13
  bPRB13 = tk.IntVar()
  global bPRB1
  bPRB1 = tk.IntVar()
  global bPRB2
  bPRB2 = tk.IntVar()
  global bPRB3
  bPRB3 = tk.IntVar()
  global bPRB4
  bPRB4 = tk.IntVar()
  global bPRB5
  bPRB5 = tk.IntVar()
  global bPRB6
  bPRB6 = tk.IntVar()
  global bPRB7
  bPRB7 = tk.IntVar()
  global bPRB8
  bPRB8 = tk.IntVar()
  global bPRB9
  bPRB9 = tk.IntVar()
  global bPRB10
  bPRB10 = tk.IntVar()
  global bPRB11
  bPRB11 = tk.IntVar()
  global bPRB12
  bPRB12 = tk.IntVar()
  global bPRB14
  bPRB14 = tk.IntVar()
  global bPRB15
  bPRB15 = tk.IntVar()
  global bPRB16
  bPRB16 = tk.IntVar()
  global bPRB17
  bPRB17 = tk.IntVar()
  global bPRB18
  bPRB18 = tk.IntVar()
  global bPRB19
  bPRB19 = tk.IntVar()
  global bPRB20
  bPRB20 = tk.IntVar()
  global bPRB21
  bPRB21 = tk.IntVar()
  global bPRB22
  bPRB22 = tk.IntVar()
  global bPRB23
  bPRB23 = tk.IntVar()
  global bPRB24
  bPRB24 = tk.IntVar()
  global bPRB25
  bPRB25 = tk.IntVar()
  global displaySelect
  displaySelect = tk.IntVar()
  global modeControl
  modeControl = tk.IntVar()

def init(top, gui, *args, **kwargs):
  global w, top_level, root
  w = gui
  top_level = top
  root = top

def cPRA():
  print('ProcessorDisplayPanel_support.cPRA')
  sys.stdout.flush()

def cPRB():
  print('ProcessorDisplayPanel_support.cPRB')
  sys.stdout.flush()

def destroy_window():
  # Function which closes the window.
  global top_level
  top_level.destroy()
  top_level = None

if __name__ == '__main__':
  import ProcessorDisplayPanel
  ProcessorDisplayPanel.vp_start_gui()




