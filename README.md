## About

A plugin for VLC to create the .csv project files for use in [Lossless Cut](https://github.com/mifi/lossless-cut). This allows for easier lossless cutting of h265 files.

## Installation

Place cutter-plugin.lua in the \lua\extensions\ directory.

* Windows (all users): %ProgramFiles%\VideoLAN\VLC\lua\extensions\
* Windows (current user): %APPDATA%\VLC\lua\extensions\
* Linux (all users): /usr/share/vlc/lua/extensions/
* Linux (current user): ~/.local/share/vlc/lua/extensions/
* Mac OS X (all users): /Applications/VLC.app/Contents/MacOS/share/lua/extensions/

- Restart VLC.

## Usage

Once installed, click View -> Lossless Cutter to open the GUI.

To add a new cut, click Add Cut. This sets a new cut starting at the current position. Scrub to the end position and click Set End.

Click Save to save the .csv in the same directory with the file name + '.csv'.

Open the video file in Lossless Cut and drag the created .csv into the window and the cuts will appear ready for processing.