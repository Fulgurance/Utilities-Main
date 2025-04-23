class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=/usr                      \
                                        --localstatedir=/var/lib/locate     \
                                        --host=#{Ism.settings.chrootTarget} \
                                        --build=#{Ism.settings.chrootTarget}",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr  \
                                        --localstatedir=/var/lib/locate",
                            path:       buildDirectoryPath)
        end
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
