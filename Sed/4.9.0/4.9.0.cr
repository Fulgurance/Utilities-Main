class Target < ISM::Software
    
    def configure
        super

        if option("Pass1")
            configureSource(arguments:  "--prefix=/usr  \
                                        --host=#{Ism.settings.chrootTarget}",
                            path:       buildDirectoryPath)
        else
            configureSource(arguments:  "--prefix=/usr",
                            path:       buildDirectoryPath)
        end
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)

        if !option("Pass1")
            makeSource( arguments:  "html",
                        path:       buildDirectoryPath)
        end
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        if !option("Pass1")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/#{versionName}")

            copyFile(   "#{buildDirectoryPath}/doc/sed.html",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/doc/#{versionName}/sed.html")
        end
    end

    def install
        super

        if !option("Pass1")
            runChmodCommand("0755 /usr/share/doc/#{versionName}")
            runChmodCommand("0644 /usr/share/doc/#{versionName}/sed.html")
        end
    end

end
