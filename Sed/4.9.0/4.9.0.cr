class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=/usr",
                                "--host=#{Ism.settings.chrootTarget}"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr"],
                                buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)

        if !option("Pass1")
            makeSource(["html"],buildDirectoryPath)
        end
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
        if !option("Pass1")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/sed-4.8")
            copyFile("#{buildDirectoryPath}/doc/sed.html","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/sed-4.8/sed.html")
            setPermissions("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/sed-4.8",755)
            setPermissions("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/sed-4.8/sed.html",644)
        end
    end

end
