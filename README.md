# rofi-audio-selector

A set of scripts for selecting PulseAudio audio source and sink with [hyprdots](https://github.com/prasanthrangan/hyprdots) (the popular dot file collection for hyprland)


## Introduction

This repository contains the scripts to create a rofi dmenu for selecting the audio input and output.

It is assumed that you have installed hyprdots and the dependencies.

## Demo

![Demo image](asset/rofi-audio-selector-demo.png)

## Installation

These scripts is primary for the Arch Linux with the installed hyprdot files, but others distro should be fine as long as these commands are available:

1. hyprctl
2. rofi
3. notify-send

### Run the installation script

### Add right click action to waybar

## Dependencies

### Arch packages
- aur/rofi-lbonn-wayland-git
- extra/waybar
- extra/hyprland
- extra/libnotify

## TODO
- [ ] Write the installation and uninstallation script
- [ ] Document how to integrate with waybar (under hyprdot)
- [ ] Add source and sink option to the script
- [ ] Clean up the script

## References
1. [prasanthrangan/hyprdots](https://github.com/prasanthrangan/hyprdots)
2. [Bash script to change default audio sink using rofi](https://www.reddit.com/r/archlinux/comments/14idhhk/bash_script_to_change_default_audio_sink_using/)
3. [zbaylin/rofi-wifi-menu/rofi-wifi-menu.sh](https://github.com/zbaylin/rofi-wifi-menu/blob/master/rofi-wifi-menu.sh)
4. [kellya/rofi-sound](https://github.com/kellya/rofi-sound)
