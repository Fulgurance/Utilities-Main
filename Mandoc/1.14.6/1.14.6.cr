class Target < ISM::Software

    def configure
        super

        configureSource(path: buildDirectoryPath)
    end

    def build
        super

        makeSource(["mandoc"],path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/bin")
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/share/man/man1")

        copyFile("#{buildDirectoryPath(false)}/mandoc","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/bin/mandoc")
        copyFile("#{buildDirectoryPath(false)}/mandoc.1","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}/usr/share/man/man1/mandoc.1")
    end

    def install
        super

        setPermissions("#{Ism.settings.rootPath}/usr/bin/mandoc",0o755)
        setPermissions("#{Ism.settings.rootPath}/usr/share/man/man1/mandoc.1",0o644)
    end

end
