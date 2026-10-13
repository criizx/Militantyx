# Militantyx

Militantyx - прототип для исследования обнаружения ранее неизвестной
вредоносной активности по структуре сетевых взаимодействий рабочих станций.
Сенсор будет анализировать метаданные потоков без расшифровки содержимого.
C2 входит в набор экспериментальных сценариев.

## Тема и цель ВКР

Рабочая формулировка темы: «Исследование и разработка метода обнаружения
ранее неизвестной вредоносной активности на основе графа сетевых взаимодействий».

Цель - разработать метод и экспериментально проверить, помогают ли связи
между потоками выявлять сценарии, не использованные при обучении и настройке
детектора. Необычный сетевой обмен сам по себе не доказывает заражение:
в предупреждении нужны признаки, по которым можно проверить срабатывание.

## Что реализовано

- C++23-проект с CMake и адаптером журналирования на spdlog;
- smoke-тест логирования, подключение Catch2 3 и CTest;
- скрипты форматирования, сборки, статического анализа и Git-хуки;
- workflow GitHub Actions для проверки существующего C++-кода.

PCAP-заголовки и исходник пока пустые; тест чтения PCAP содержит `REQUIRE(true)`.
Построение потоков, графовый детектор, обучение модели и интерфейс ещё не
реализованы. Dockerfile запускает smoke-тест, Compose описывает каркас
инфраструктуры с ClickHouse. Успешная сборка не подтверждает работу детектора.

## Планируемая обработка

```text
PCAP → двунаправленные потоки → граф за временное окно
     → признаки структуры и обмена → оценка аномальности
     → предупреждение со ссылками на исходные потоки
```

Первая версия будет работать офлайн. Потоковый baseline и графовый вариант
сравниваются на одной выборке. Отдельно проверяется влияние шума разметки,
задержек и размеров пакетов. Параметры и порог фиксируются
до оценки на тестовой выборке. Выбранные сценарии целиком исключаются
из обучения и настройки.

## Структура

- `sources/core/` - C++: журналирование; далее PCAP, потоки и граф;
- `sources/ml/` - место для Python-модуля обучения и оценки;
- `sources/dashboard/` - место для интерфейса анализа;
- `docs/` - границы работы, архитектура и план экспериментов;
- `scripts/` - локальные проверки; `.github/workflows/` - GitHub CI.

В каталогах ML и интерфейса пока есть только README.

## Сборка и проверки

Нужны CMake 3.25+, компилятор C++23, spdlog, Catch2 3, clang-format,
clang-tidy и ShellCheck. На Ubuntu 24.04:

```bash
sudo apt-get update
sudo apt-get install build-essential cmake ninja-build libspdlog-dev catch2 clang-format clang-tidy shellcheck
cmake -S . -B .build/checks -G Ninja -DCMAKE_BUILD_TYPE=Debug -DBUILD_TESTING=ON
cmake --build .build/checks --parallel
ctest --test-dir .build/checks --output-on-failure
scripts/verify.sh
```

На macOS зависимости C++ устанавливаются отдельно; скрипты учитывают LLVM
из Homebrew. `scripts/install-hooks.sh` включает локальные Git-хуки.
`docker compose up --build` запускает ClickHouse и smoke-тест логирования.
Программы анализа PCAP и обученной модели в проекте пока нет.

## Документация и источники

- [Объём ВКР и критерии готовности](docs/MVP.md)
- [Архитектура](docs/ARCHITECTURE_AND_DECISIONS.md)
- [Данные и протокол экспериментов](docs/RESEARCH_PROTOCOL.md)
- [План реализации](docs/TASK_BREAKDOWN.md)
- [Стек](docs/STACK_DECISIONS.md), [среда](docs/ENVIRONMENT.md)
- [Порядок разработки](docs/CONTRIBUTING.md)

Основа направления - [HyperVision](https://github.com/fuchuanpu/HyperVision)
и [статья о графе взаимодействий потоков](https://www.ndss-symposium.org/ndss-paper/detecting-unknown-encrypted-malicious-traffic-in-real-time-via-flow-interaction-graph-analysis/).
[FlowPrint](https://github.com/Thijsvanede/FlowPrint) используется как источник
идей о временных связях обращений; перенос его подхода с мобильных приложений
на рабочие станции требует проверки.
[RAPIER](https://www.ndss-symposium.org/ndss-paper/low-quality-training-data-only-a-robust-framework-for-detecting-encrypted-malicious-network-traffic/)
посвящён качеству обучающих данных,
[NetMasquerade](https://github.com/09nat/NetMasquerade) - устойчивости
детекторов к изменениям трафика. Эти проекты не интегрированы в Militantyx.

## Лицензия

[Apache License 2.0](LICENSE).
