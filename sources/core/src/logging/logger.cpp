#include <logger.h>

#include <memory>
#include <mutex>

#include <spdlog/sinks/stdout_color_sinks.h>

namespace Militantyx::Logging
{
namespace
{
std::mutex initializationMutex;
}

void Initialize(const LoggerOptions &options)
{
    const std::scoped_lock lock{initializationMutex};

    auto sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
    auto logger = std::make_shared<spdlog::logger>("militantyx", std::move(sink));

    logger->set_pattern(options.pattern);
    logger->set_level(ToSpdlogLevel(options.level));
    logger->flush_on(spdlog::level::warn);

    spdlog::set_default_logger(std::move(logger));
}

void SetLevel(const LogLevel level)
{
    spdlog::set_level(ToSpdlogLevel(level));
}

void Flush()
{
    spdlog::default_logger()->flush();
}

void Log(const LogLevel level, const std::string_view message)
{
    spdlog::log(ToSpdlogLevel(level), "{}", message);
}

spdlog::level::level_enum ToSpdlogLevel(const LogLevel level) noexcept
{
    switch (level)
    {
    case LogLevel::Trace:
        return spdlog::level::trace;
    case LogLevel::Debug:
        return spdlog::level::debug;
    case LogLevel::Info:
        return spdlog::level::info;
    case LogLevel::Warning:
        return spdlog::level::warn;
    case LogLevel::Error:
        return spdlog::level::err;
    case LogLevel::Critical:
        return spdlog::level::critical;
    }

    return spdlog::level::off;
}
} // namespace Militantyx::Logging
