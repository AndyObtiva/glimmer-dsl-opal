# Copyright (c) 2020-2021 Andy Maleh
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class HelloCanvas
  include Glimmer::UI::CustomShell
  
  body {
    shell {
      text 'Hello, Canvas!'
      minimum_size 320, 400
    
      @canvas = canvas {
        background :yellow
        
        rectangle(0, 0, 220, 400) {
          background rgb(255, 0, 0)
        }
        rectangle(50, 20, 300, 150, 30, 50) {
          background :magenta
        }
        rectangle(50, 20, 300, 150, 30, 50) {
          foreground :yellow
        }
        rectangle(205, 50, 86, 97) {
          foreground :yellow
        }
        rectangle(67, 75, 128, 38) {
          background :yellow
        }
        rectangle(150, 200, 100, 70) {
          background :dark_magenta
        }
        rectangle(50, 200, 30, 70) {
          background :magenta
        }
        oval(110, 310, 100, 100) {
          background :yellow
        }
        text('Picasso', 67, 103) {
          foreground :dark_magenta
          font name: 'Courier', height: 30
        }
        polygon(250, 210, 260, 170, 270, 210, 290, 230) {
          background :dark_yellow
        }
        polyline(250, 110, 260, 70, 270, 110, 290, 130, 250, 110) {
          foreground :black
        }
      }
    }
  }
end

HelloCanvas.launch
        
