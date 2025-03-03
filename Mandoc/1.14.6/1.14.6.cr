class Target < ISM::Software

    def configure
        super

        configureSource(path: buildDirectoryPath)
    end

    def build
        super

        makeSource( arguments:   "mandoc",
                    path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/man/man1")

        copyFile(   "#{buildDirectoryPath}/mandoc",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/mandoc")

        copyFile(   "#{buildDirectoryPath}/mandoc.1",
                    "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/share/man/man1/mandoc.1")
    end

end
