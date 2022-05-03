#!/bin/bash
(crontab -l 2>/dev/null || true; echo "15 6 * * 3     /usr/sbin/fstrim -v /") | crontab -
