class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                          \
                                    --docdir=/usr/share/doc/man-db-2.11.1   \
                                    --sysconfdir=/etc                       \
                                    --disable-setuid                        \
                                    --enable-cache-owner=bin                \
                                    --with-browser=/usr/bin/lynx            \
                                    --with-vgrind=/usr/bin/vgrind           \
                                    --with-grap=/usr/bin/grap               \
                                    --with-systemdtmpfilesdir=              \
                                    --with-systemdsystemunitdir=",
                        path:       buildDirectoryPath)
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
