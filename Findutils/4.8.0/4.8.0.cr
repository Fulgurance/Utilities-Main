class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--localstatedir=/var/lib/locate",
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

        makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
