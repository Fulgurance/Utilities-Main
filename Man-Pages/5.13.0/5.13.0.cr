class Target < ISM::Software
    
    def prepareInstallation
        super

        makeSource(["prefix=/usr","DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
