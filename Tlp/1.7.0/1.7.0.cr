class Target < ISM::Software

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Tlp-Init.d",
                                                name:   "tlp")
        end
    end

    def deploy
        super

        if Ism.settings.autoDeployServices
            runRcUpdateCommand("add tlp default")
        end
    end

end
