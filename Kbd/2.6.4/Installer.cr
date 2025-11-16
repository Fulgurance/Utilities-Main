class Target < ISM::Software

    def prepare
        super

        fileReplaceText(path:       "#{buildDirectoryPath}/configure",
                        text:       "RESIZECONS_PROGS=yes",
                        newText:    "RESIZECONS_PROGS=no")

        fileReplaceText(path:       "#{buildDirectoryPath}/docs/man/man8/Makefile.in",
                        text:       "resizecons.8 ",
                        newText:    "")
    end

    def configure
        super

        configureSource(arguments:  "--prefix=/usr  \
                                    --disable-vlock",
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
