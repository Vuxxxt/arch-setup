#!/usr/bin/env bash

set -e

echo "Installing base package set..."

sudo pacman -Syu --needed - < packages/pacman.txt
