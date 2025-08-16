<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Copying And Pasting In Ubuntu Bash](#copying-and-pasting-in-ubuntu-bash)
  - [Copying and Pasting in the Terminal](#copying-and-pasting-in-the-terminal)
    - [Using Mouse](#using-mouse)
    - [Using Keyboard Shortcuts](#using-keyboard-shortcuts)
  - [Alternative Method](#alternative-method)
- [Terminal Only](#terminal-only)
  - [Copying and Pasting in the Terminal without a GUI](#copying-and-pasting-in-the-terminal-without-a-gui)
    - [Using screen or tmux](#using-screen-or-tmux)
      - [Using tmux](#using-tmux)
      - [Using screen](#using-screen)
  - [Copying and Pasting Between Local Machine and Server](#copying-and-pasting-between-local-machine-and-server)
    - [Using SSH](#using-ssh)
  - [Using Terminal Multiplexers for Advanced Management](#using-terminal-multiplexers-for-advanced-management)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Copying And Pasting In Ubuntu Bash

Yes, Ubuntu Bash allows copying and pasting. Here are the methods to do it:

## Copying and Pasting in the Terminal

### Using Mouse

1. **Copying:**
    - Highlight the text you want to copy by clicking and dragging your mouse over it.
    - Right-click on the highlighted text and select "Copy" from the context menu.
2. **Pasting:**
    - Right-click in the terminal where you want to paste the copied text.
    - Select "Paste" from the context menu.

### Using Keyboard Shortcuts

1. **Copying:**
    - Highlight the text you want to copy by clicking and dragging your mouse over it.
    - Press Ctrl + Shift + C to copy the highlighted text.
2. **Pasting:**
    - Click where you want to paste the text in the terminal.
    - Press Ctrl + Shift + V to paste the copied text.

## Alternative Method

- **Middle Mouse Button:**
  - Highlight the text you want to copy.
  - Click the middle mouse button (scroll wheel) where you want to paste the text. This works by using the primary selection clipboard, which is independent of the clipboard used by Ctrl + C and Ctrl + V.

These methods work in the default GNOME Terminal and other terminal emulators commonly used in Ubuntu.

# Terminal Only
In Ubuntu Server Edition, which typically lacks a graphical user interface (GUI), you can still copy and paste text within the terminal or between your local machine and the server using several methods.

## Copying and Pasting in the Terminal without a GUI

### Using screen or tmux

Both screen and tmux are terminal multiplexer programs that allow you to manage multiple terminal sessions from a single window. They also support copy and paste operations.

#### Using tmux

1. **Copying:**
    - Enter copy mode by pressing Ctrl + B followed by \[.
    - Move the cursor to the beginning of the text you want to copy using arrow keys.
    - Press Space to start the selection and move the cursor to the end of the text.
    - Press Enter to copy the selected text.
2. **Pasting:**
    - Press Ctrl + B followed by \] to paste the copied text.

#### Using screen

1. **Copying:**
    - Enter copy mode by pressing Ctrl + A followed by Escape.
    - Use the arrow keys to move the cursor to the beginning of the text you want to copy.
    - Press Space to start the selection and move the cursor to the end of the text.
    - Press Space again to copy the selected text.
2. **Pasting:**
    - Press Ctrl + A followed by \] to paste the copied text.

## Copying and Pasting Between Local Machine and Server

### Using SSH

When connected to a server via SSH from a local machine with a GUI, you can use your local machine’s copy and paste functionality.

1. **Copying from Local Machine:**
    - Highlight the text on your local machine.
    - Press Ctrl + C (or right-click and select "Copy").
2. **Pasting into SSH Session:**
    - Click into the terminal window where your SSH session is active.
    - Press Ctrl + Shift + V (or right-click and select "Paste").
3. **Copying from SSH Session:**
    - Highlight the text in the SSH terminal.
    - Press Ctrl + Shift + C (or right-click and select "Copy").
4. **Pasting into Local Machine:**
    - Click into the desired location on your local machine.
    - Press Ctrl + V (or right-click and select "Paste").

## Using Terminal Multiplexers for Advanced Management

Using terminal multiplexers like tmux and screen not only allows you to copy and paste but also offers advanced session management, which is very helpful when working on a server without a GUI.