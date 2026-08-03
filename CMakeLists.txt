cmake_minimum_required(VERSION 3.25)

project(Militantyx VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

find_package(spdlog CONFIG REQUIRED)

add_library(militantyx_logger
    sources/core/src/logging/logger.cpp
)
add_library(Militantyx::Logger ALIAS militantyx_logger)

target_include_directories(militantyx_logger
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/sources/core/include/militantyx/logging
)

target_link_libraries(militantyx_logger
    PUBLIC
        spdlog::spdlog
)

if(MSVC)
    target_compile_options(militantyx_logger PRIVATE /W4 /permissive-)
else()
    target_compile_options(militantyx_logger PRIVATE -Wall -Wextra -Wpedantic)
endif()

include(CTest)

if(BUILD_TESTING)
    add_executable(logger_smoke_test
        sources/core/tests/logging/logger_smoke_test.cpp
    )
    target_link_libraries(logger_smoke_test PRIVATE Militantyx::Logger)
    add_test(NAME logger_smoke_test COMMAND logger_smoke_test)
endif()
