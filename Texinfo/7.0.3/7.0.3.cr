class Target < ISM::Software
    
    def configure
        super

        configureSource([   "--prefix=/usr"],
                            path: buildDirectoryPath,
                            environment: {"FORCE_UNSAFE_CONFIGURE" => "1"})
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource(["DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}","install"],buildDirectoryPath)
    end

end
