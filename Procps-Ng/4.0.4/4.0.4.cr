class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                          \
                                    --docdir=/usr/share/doc/procps-ng-4.0.4 \
                                    --disable-static                        \
                                    --disable-modern-top                    \
                                    --disable-kill",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
