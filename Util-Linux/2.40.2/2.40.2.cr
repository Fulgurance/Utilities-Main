class Target < ISM::Software

    def prepare
        super

        if option("Pass1")
            makeDirectory("#{buildDirectoryPath}/var/lib/hwclock")
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource(arguments:      "ADJTIME_PATH=/var/lib/hwclock/adjtime      \
                                            --libdir=/usr/lib                           \
                                            --docdir=/usr/share/doc/#{versionName}      \
                                            --disable-makeinstall-chown                 \
                                            --disable-chfn-chsh                         \
                                            --disable-login                             \
                                            --disable-nologin                           \
                                            --disable-su                                \
                                            --disable-setpriv                           \
                                            --disable-runuser                           \
                                            --disable-pylibmount                        \
                                            --disable-static                            \
                                            --disable-liblastlog2                       \
                                            --without-python                            \
                                            --runstatedir=/run",
                            path:           buildDirectoryPath)
        else
            configureSource(arguments:      "ADJTIME_PATH=/var/lib/hwclock/adjtime      \
                                            --bindir=/usr/bin                           \
                                            --libdir=/usr/lib                           \
                                            --docdir=/usr/share/doc/#{versionName}      \
                                            --runstatedir=/run                          \
                                            --sbindir=/usr/sbin                         \
                                            --host=#{Ism.settings.systemTarget}         \
                                            --build=#{Ism.settings.systemTarget}        \
                                            --target=#{Ism.settings.systemTarget}       \
                                            --disable-makeinstall-chown                 \
                                            --disable-chfn-chsh                         \
                                            --disable-login                             \
                                            --disable-nologin                           \
                                            --disable-su                                \
                                            --disable-setpriv                           \
                                            --disable-runuser                           \
                                            --disable-pylibmount                        \
                                            --disable-liblastlog2                       \
                                            --disable-static                            \
                                            --without-python                            \
                                            --without-systemd                           \
                                            --without-systemdsystemunitdir",
                            path:           buildDirectoryPath)
        end
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
