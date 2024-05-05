class Target < ISM::Software
    
    def prepare
        super

        if !option("Pass1")
            fileReplaceText("#{buildDirectoryPath(false)}/Makefile.in","extras","")
        end
    end

    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.chrootTarget}",
                                "--build=$(./config.guess)"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--docdir=/usr/share/doc/flex-2.6.4",
                                "--disable-static"],
                                buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)

        makeLink("flex","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/bin/lex",:symbolicLink)
        makeLink("flex.1","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/share/man/man1/lex.1",:symbolicLink)
    end

end
