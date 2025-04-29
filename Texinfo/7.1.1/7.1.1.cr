class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:      "--prefix=/usr                          \
                                        --host=#{Ism.settings.systemTarget}     \
                                        --build=#{Ism.settings.systemTarget}    \
                                        --target=#{Ism.settings.systemTarget}   ",
                        path:           buildDirectoryPath,
                        environment:    {"FORCE_UNSAFE_CONFIGURE" => "1"})
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
