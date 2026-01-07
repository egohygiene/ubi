# lib/time.sh
#
# Time helpers.

time::epoch() {
  date -u +%s
}

time::timestamp() {
  date '+%Y-%m-%d %H:%M:%S'
}
