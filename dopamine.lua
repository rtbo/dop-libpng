name = 'libpng'
version = '1.6.37'
description = 'The PNG reference library'
authors = {'The PNG Reference Library Authors'}
license = 'http://www.libpng.org/pub/png/src/libpng-LICENSE.txt'
copyright = 'Copyright (c) 1995-2019 The PNG Reference Library Authors'
langs = {'c'}

dependencies = {zlib = '>=1.2.5'}

function source()
    local folder = 'libpng-' .. version
    local archive = folder .. '.tar.xz'
    dop.download {
        'https://download.sourceforge.net/libpng/' .. archive,
        dest = archive,
    }
    dop.checksum {
        archive,
        sha256 = '505e70834d35383537b6491e7ae8641f1a4bed1876dbfe361201fc80868d88ca',
    }
    dop.extract_archive { archive, outdir = '.' }

    return folder
end

function build(dirs, config, dep_infos)

    local cmake = dop.CMake:new(config.profile)

    local defs = {
        ['PNG_TESTS'] = false,
    }
    -- if zlib is not in the system but in the dependency cache
    if dep_infos and dep_infos.zlib then
        local zlib = dep_infos.zlib.install_dir
        local libname = dop.windows and 'zlibstatic' or 'z'
        defs['ZLIB_INCLUDE_DIR'] = dop.path(zlib, 'include')
        defs['ZLIB_LIBRARY'] = dop.find_libfile(dop.path(zlib, 'lib'), libname, 'static')
    end

    cmake:configure({
        src_dir = dirs.src,
        install_dir = dirs.install,
        defs = defs,
    })
    cmake:build()
    cmake:install()
end
