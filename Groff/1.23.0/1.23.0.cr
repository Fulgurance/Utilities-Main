class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:      "--prefix=/usr",
                        path:           buildDirectoryPath,
                        environment:    {"PAGE" => "A4"})
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
