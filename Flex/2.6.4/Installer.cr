class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                      \
                                    --docdir=/usr/share/doc/flex-2.6.4  \
                                    --disable-static",
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

        makeLink(   target: "flex",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lex",
                    type:   :symbolicLink)
    end

end
