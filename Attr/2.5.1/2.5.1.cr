class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr      \
                                    --disable-static    \
                                    --sysconfdir=/etc   \
                                    --docdir=/usr/share/doc/attr-2.5.1",
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
