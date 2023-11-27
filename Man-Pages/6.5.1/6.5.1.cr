class Target < ISM::Software

    def prepare
        super

        deleteFile("#{mainWorkDirectoryPath(false)}/man3/crypt.3")
        deleteFile("#{mainWorkDirectoryPath(false)}/man3/crypt_r.3")
    end
    
    def prepareInstallation
        super

        makeSource(["prefix=/usr","DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
