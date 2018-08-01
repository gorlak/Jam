newoption
{
    trigger = "architecture",
    description = "Specify architecture (see premake 'architecture' action for choices)",
    default = "x86", -- (function() if os.is64bit() then return 'x86_64' else return 'x86' end end)()
}

workspace "jam"

-- global options

architecture( _OPTIONS[ "architecture" ] )

floatingpoint "Fast"

flags
{
    "NoMinimalRebuild",
}

defines
{
    "WIN32",
    "_WIN32",
    "_CRT_SECURE_NO_DEPRECATE",
    "_CRT_NON_CONFORMING_SWPRINTFS",
    "_WINSOCK_DEPRECATED_NO_WARNINGS"
}

buildoptions
{
    "/MP",
    "/Zm256",
    "/d2Zi+", -- http://randomascii.wordpress.com/2013/09/11/debugging-optimized-codenew-in-visual-studio-2012/
}

linkoptions
{
    "/ignore:4221", -- disable warning about linking .obj files with not symbols defined (conditionally compiled away)
}

configurations
{
    "Debug",
    "Release",
}

location "Build"
objdir "Build"

-- global configurations

configuration "Debug"
    targetdir( "Bin/Debug/" )
    libdirs { "Bin/Debug/" }

configuration "Release"
    targetdir( "Bin/Release/" )
    libdirs { "Bin/Release/" }

configuration "Debug"
    defines
    {
        "_DEBUG",
    }
    symbols "On"
    buildoptions
    {
        "/Ob0",
    }

configuration "Release"
    defines
    {
        "NDEBUG",
    }
    symbols "On"
    optimize "Speed"
    editandcontinue "Off"
    --omitframepointer "On"
    buildoptions
    {
        "/Ob2",
        "/Oi",
    }

configuration {}

-- projects

project "jam"

    kind "ConsoleApp"
    language "C++"
    characterset "MBCS"
    -- staticruntime "On"

    disablewarnings
    {
        "4091", -- dbghelp.dll antics
        "4996", -- deprecation
    }

    defines
    {
        "NT",
    }

    includedirs
    {
    }

    local platform = "x64"
    if _OPTIONS[ "architecture" ] == "x86" then
        platform = "Win32"
    end

    files
    {
        "Source/*.c",
    }

    excludes
    {
        "Source/mkjambase.c"
    }
