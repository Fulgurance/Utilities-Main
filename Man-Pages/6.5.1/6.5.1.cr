class Target < ISM::Software

    def prepare
        super

        deleteFile("#{mainWorkDirectoryPath}/man3/crypt.3")
        deleteFile("#{mainWorkDirectoryPath}/man3/crypt_r.3")
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "prefix=/usr DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
