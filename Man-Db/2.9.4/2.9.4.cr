class Target < ISM::Software

    def configure
        super
        configureSource([   "--prefix=/usr",
                            "--docdir=/usr/share/doc/man-db-2.9.4",
                            "--sysconfdir=/etc",
                            "--disable-setuid",
                            "--enable-cache-owner=bin",
                            "--with-browser=/usr/bin/lynx",
                            "--with-vgrind=/usr/bin/vgrind",
                            "--with-grap=/usr/bin/grap",
                            "--with-systemdtmpfilesdir=",
                            "--with-systemdsystemunitdir="],
                            buildDirectoryPath)
    end

    def build
        super
        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super
        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
