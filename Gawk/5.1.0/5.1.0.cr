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
                                "--host=#{Ism.settings.target}",
                                "--build=#{Ism.settings.chrootTarget}"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr"],
                                buildDirectoryPath)
        end
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
