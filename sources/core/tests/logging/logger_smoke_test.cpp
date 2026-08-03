#include <logger.h>

int main()
{
    using Militantyx::Logging::Flush;
    using Militantyx::Logging::Initialize;
    using Militantyx::Logging::Log;
    using Militantyx::Logging::LoggerOptions;
    using Militantyx::Logging::LogLevel;
    using Militantyx::Logging::SetLevel;

    Initialize(LoggerOptions{.level = LogLevel::Trace});
    Log(LogLevel::Info, "Militantyx logger initialized");
    Log(LogLevel::Debug, "Formatted value: {}", 42);
    SetLevel(LogLevel::Info);
    Flush();

    return 0;
}
