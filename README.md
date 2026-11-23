# Лабораторная работа №1
## Скрипт сбора диагностики для технической поддержки

**Файл скрипта:** `collect-info.sh`

### Цель работы

Разработать Bash-скрипт, который собирает сведения о системе, нагрузке, процессах и дисках в один текстовый файл. Скрипт должен работать без root-прав и не прекращать сбор при отсутствии отдельных утилит или ошибках команд.

### Что собирает скрипт

| Раздел | Команды | Назначение |
|---|---|---|
| Система | `uname -a`, `uptime`, `cat /etc/os-release`, `lscpu` | Версия ядра, дистрибутив, время работы и характеристики CPU |
| Нагрузка | `vmstat 1 5` | Динамика нагрузки за пять секунд, включая ожидание ввода-вывода (`wa`) |
| Процессы | `ps` и `head` | Десять процессов с наибольшей загрузкой CPU и памяти |
| Диски | `df -h`, `df -i` | Свободное место и использование inode |

### Реализация

Полный исходный код находится в файле `collect-info.sh` в этом комплекте.

### Проверка требований

- Каждая собирающая команда запускается через `timeout`.
- Перед запуском проверяется наличие основной утилиты через `command -v`.
- Отсутствующая команда отмечается в отчёте отдельной строкой.
- Код возврата `124` трактуется как таймаут; остальные ненулевые коды — как ошибка команды.
- Скрипт не требует root-прав. Если обычному пользователю недоступны отдельные сведения, ошибка попадёт в файл, а сбор продолжится.
- Прогресс выводится в `stderr`, диагностические данные — в файл, путь к файлу — единственная строка в `stdout`.

### Запуск

```bash
chmod +x collect-info.sh
./collect-info.sh
```

Чтобы проверить, что в стандартный вывод попадает только путь к файлу:

```bash
./collect-info.sh 2>/dev/null
```

Для проверки статическим анализатором (если ShellCheck установлен):

```bash
shellcheck collect-info.sh
```

### Пример результата выполнения

Ниже приведён пример отчёта, полученный при запуске скрипта в Linux-среде подготовки. При защите необходимо запустить скрипт на своём компьютере и приложить созданный им файл `sysinfo-...txt`: значения зависят от конкретной машины.

```text

===== Система =====
Linux 12dcaa703d38 6.18.57 #1 SMP Tue Oct 20 21:56:04 UTC 2026 x86_64 GNU/Linux

===== Время работы и средняя нагрузка =====
 10:13:21 up 1 min,  0 users,  load average: 0.06, 0.03, 0.01

===== Информация о дистрибутиве =====
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
NAME="Debian GNU/Linux"
VERSION_ID="13"
VERSION="13 (trixie)"
VERSION_CODENAME=trixie
DEBIAN_VERSION_FULL=13.3
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"

===== Процессор =====
Architecture:                            x86_64
CPU op-mode(s):                          32-bit, 64-bit
Address sizes:                           46 bits physical, 48 bits virtual
Byte Order:                              Little Endian
CPU(s):                                  3
On-line CPU(s) list:                     0-2
Vendor ID:                               AuthenticAMD
Model name:                              AMD EPYC 9V74 80-Core Processor
CPU family:                              25
Model:                                   17
Thread(s) per core:                      1
Core(s) per socket:                      3
Socket(s):                               1
Stepping:                                1
BogoMIPS:                                5192.28
Flags:                                   fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid extd_apicid tsc_known_freq pni pclmulqdq ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand hypervisor lahf_lm cmp_legacy cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw topoext cpuid_fault vmmcall fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid avx512f avx512dq rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni avx512bw avx512vl xsaveopt xsavec xgetbv1 xsaves avx512_bf16 clzero xsaveerptr arat npt nrip_save tsc_scale vmcb_clean flushbyasid pausefilter pfthreshold v_vmsave_vmload avx512vbmi umip avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg avx512_vpopcntdq rdpid fsrm arch_capabilities
Hypervisor vendor:                       KVM
Virtualization type:                     full
L1d cache:                               64 KiB (2 instances)
L1i cache:                               64 KiB (2 instances)
L2 cache:                                2 MiB (2 instances)
L3 cache:                                32 MiB (1 instance)
NUMA node(s):                            1
NUMA node0 CPU(s):                       0-2
Vulnerability Gather data sampling:      Not affected
Vulnerability Ghostwrite:                Not affected
Vulnerability Indirect target selection: Not affected
Vulnerability Itlb multihit:             Not affected
Vulnerability L1tf:                      Not affected
Vulnerability Mds:                       Not affected
Vulnerability Meltdown:                  Not affected
Vulnerability Mmio stale data:           Not affected
Vulnerability Old microcode:             Not affected
Vulnerability Reg file data sampling:    Not affected
Vulnerability Retbleed:                  Not affected
Vulnerability Spec rstack overflow:      Vulnerable
Vulnerability Spec store bypass:         Vulnerable
Vulnerability Spectre v1:                Vulnerable: __user pointer sanitization and usercopy barriers only; no swapgs barriers
Vulnerability Spectre v2:                Vulnerable; STIBP: disabled; PBRSB-eIBRS: Not affected; BHI: Not affected
Vulnerability Srbds:                     Not affected
Vulnerability Tsa:                       Vulnerable
Vulnerability Tsx async abort:           Not affected
Vulnerability Vmscape:                   Not affected

===== Нагрузка за 5 секунд =====
procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st gu
 0  0      0 5036232   4700  67076    0    0    64    18  456    2  4  3 92  0  1  0
 0  0      0 5036960   4700  67172    0    0     0     0  546 1155  0  1 99  0  0  0
 0  0      0 5036960   4700  67172    0    0     0     0  106  100  0  0 100  0  0  0
 0  0      0 5036960   4700  67172    0    0     0     0   91   86  0  0 100  0  0  0
 0  0      0 5036960   4700  67172    0    0     0     0   92   85  0  0 99  0  0  0

===== Топ-10 процессов по CPU =====
    PID USER     %CPU %MEM COMMAND
    268 oai       8.1  4.3 artifact_tool_r
    255 oai       2.9  2.3 python
    206 oai       2.0  1.2 python
    227 oai       0.9  0.6 python
      1 root      0.6  0.4 supervisord
    311 oai       0.2  0.0 bash
    178 oai       0.0  0.0 tini
      6 root      0.0  0.0 log_forwarder
     21 root      0.0  0.0 bash
     37 root      0.0  0.0 sleep

===== Топ-10 процессов по памяти =====
    PID USER     %MEM %CPU COMMAND
    268 oai       4.3  8.1 artifact_tool_r
    255 oai       2.3  2.9 python
    206 oai       1.2  2.0 python
    227 oai       0.6  0.9 python
      1 root      0.4  0.6 supervisord
    347 root      0.0  0.0 curl
    360 oai       0.0  0.0 ps
    311 oai       0.0  0.2 bash
    358 oai       0.0  0.0 bash
    356 oai       0.0  0.0 timeout

===== Свободное место на файловых системах =====
Filesystem      Size  Used Avail Use% Mounted on
overlay          32G  5.4M   30G   1% /
tmpfs            64M     0   64M   0% /dev
shm             3.0G     0  3.0G   0% /dev/shm

===== Использование inode =====
Filesystem      Inodes IUsed   IFree IUse% Mounted on
overlay        2097152   154 2096998    1% /
tmpfs           761375    15  761360    1% /dev
shm             761375     1  761374    1% /dev/shm
```

### Вывод

В ходе работы создан Bash-скрипт для автоматизированного сбора базовой диагностики Linux-системы. Он записывает сведения о системе, загрузке процессора, активных процессах и файловых системах в единый текстовый файл. Таймауты ограничивают время выполнения команд, а проверка наличия утилит и обработка кодов возврата позволяют продолжать сбор даже при частичных ошибках.
# Lab1OS
