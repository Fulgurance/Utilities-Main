class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource([   "--prefix=#{Ism.settings.rootPath}usr",
                                "--host=#{Ism.settings.target}"],
                                buildDirectoryPath)
        else
            configureSource([   "--prefix=/usr"],
                                buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource([Ism.settings.makeOptions],buildDirectoryPath)

        if option("Pass2")
            makeSource([Ism.settings.makeOptions,"html"],buildDirectoryPath)
        end
    end
    
    def prepareInstallation
        super

        if option("Pass1")
            makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}","install"],buildDirectoryPath)
        else
            makeSource([Ism.settings.makeOptions,"DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
            makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/sed-4.8")
            copyFile("#{buildDirectoryPath(false)}/doc/sed.html","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/sed-4.8/sed.html")
            setPermissions("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/sed-4.8",755)
            setPermissions("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}usr/share/doc/sed-4.8/sed.html",644)
        end
    end

end
