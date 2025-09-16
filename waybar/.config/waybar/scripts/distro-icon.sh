#!/bin/bash

# Detectar a distribuição e retornar o ícone apropriado
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case $ID in
        fedora)
            echo ""  # Ícone do Fedora
            ;;
        arch|endeavouros|manjaro)
            echo ""  # Ícone do Arch Linux
            ;;
        ubuntu|debian|pop|linuxmint)
            echo ""  # Ícone do Debian/Ubuntu
            ;;
        opensuse*|suse*)
            echo ""  # Ícone do openSUSE
            ;;
        *)
            echo ""  # Ícone genérico do Linux
            ;;
    esac
else
    echo ""  # Fallback para ícone genérico
fi
