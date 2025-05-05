class Target < ISM::Software
    
    def prepare
        super

        if !option("Pass1")
            fileReplaceText(path:       "#{buildDirectoryPath}/Makefile.in",
                            text:       "extras",
                            newText:    "")
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=/usr                      \
                                        --host=#{Ism.settings.chrootTarget} \
                                        --build=#{Ism.settings.systemTarget(relatedToChroot: false)}",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr                          \
                                        --docdir=/usr/share/doc/#{versionName}  \
                                        --disable-static",
                            path:       buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeLink(   target: "flex",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/lex",
                    type:   :symbolicLink)

        makeLink(   target: "flex.1",
                    path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/man/man1/lex.1",
                    type:   :symbolicLink)
    end

end
