class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=#{Ism.settings.rootPath}usr",
                                "--localstatedir=#{Ism.settings.rootPath}var/lib/locate",
                                "--host=#{Ism.settings.target}",
                                "--build=$(build-aux/config.guess)"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr",
                                "--localstatedir=/var/lib/locate"],
                                buildDirectoryPath)
        end
    end
    
    def build
        super
        makeSource([Ism.settings.makeOptions],buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        if option("Pass1")
            makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}","install"],buildDirectoryPath)
        else
            makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        end
    end

end
