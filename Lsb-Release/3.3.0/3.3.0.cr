class Target < ISM::Software

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "INSTALL_ROOT=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr install",
                    path:       buildDirectoryPath)
    end

end
