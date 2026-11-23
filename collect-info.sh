#!/usr/bin/env bash

set -uo pipefail

OUT="sysinfo-$(hostname)-$(date +%F-%H%M).txt"
: >"$OUT"

say() {
    printf '%s\n' "$*" >&2
}

run() {
    local title=$1
    local tmo=$2
    local cmd=$3
    local rc

    printf '\n===== %s =====\n' "$title" >>"$OUT"

    if ! command -v "${cmd%% *}" >/dev/null 2>&1; then
        printf '(команда %s недоступна)\n' "${cmd%% *}" >>"$OUT"
        return 0
    fi

    timeout "$tmo" bash -c "$cmd" >>"$OUT" 2>&1
    rc=$?

    if [ "$rc" -eq 124 ]; then
        printf '(команда не уложилась в %s с — таймаут)\n' "$tmo" >>"$OUT"
    elif [ "$rc" -ne 0 ]; then
        printf '(команда завершилась с кодом %s)\n' "$rc" >>"$OUT"
    fi

    return 0
}

main() {
    say "Собираю общие сведения..."
    run "Система" 5 'uname -a'
    run "Время работы и средняя нагрузка" 5 'uptime'
    run "Информация о дистрибутиве" 5 'cat /etc/os-release'
    run "Процессор" 5 'lscpu'

    say "Снимаю замеры нагрузки..."
    run "Нагрузка за 5 секунд" 10 'vmstat 1 5'
    run "Топ-10 процессов по CPU" 5 'ps -eo pid,user,%cpu,%mem,comm --sort=-%cpu | head -11'
    run "Топ-10 процессов по памяти" 5 'ps -eo pid,user,%mem,%cpu,comm --sort=-%mem | head -11'

    say "Собираю сведения о дисках..."
    run "Свободное место на файловых системах" 5 'df -h'
    run "Использование inode" 5 'df -i'

    printf '%s\n' "$PWD/$OUT"
}

main "$@"
