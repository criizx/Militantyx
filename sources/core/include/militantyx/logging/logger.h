#pragma once

#include <string>
#include <string_view>
#include <utility>

#include <spdlog/spdlog.h>

namespace Militantyx::Logging
{
enum class LogLevel
{
    Trace,
    Debug,
    Info,
    Warning,
    Error,
    Critical
};

struct LoggerOptions
{
    LogLevel level{LogLevel::Info};
    std::string pattern{"[%Y-%m-%d %H:%M:%S.%e] [%^%l%$] %v"};
};

void Initialize(const LoggerOptions &options = {});
void SetLevel(LogLevel level);
void Flush();
void Log(LogLevel level, std::string_view message);

[[nodiscard]] spdlog::level::level_enum ToSpdlogLevel(LogLevel level) noexcept;

template <typename... Args> void Log(LogLevel level, spdlog::format_string_t<Args...> format, Args &&...args)
{
    spdlog::log(ToSpdlogLevel(level), format, std::forward<Args>(args)...);
}
} // namespace Militantyx::Logging
