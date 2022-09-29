#!/usr/bin/env bash

info() {
  echo "$(date --utc -Iseconds) INFO $1"
}

error() {
  echo "$(date --utc -Iseconds) ERROR $1"
}

warn() {
  echo "$(date --utc -Iseconds) WARN $1"
}
