class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

    end

    def configure
        super

        runMesonCommand([   "--prefix=/usr",
                            "--buildtype=release",
                            "-Dadmin_group=wheel",
                            "-Dsystemd=false",
                            "-Dsystemdsystemunitdir=no",
                            "-Delogind=#{option("Elogind") ? "true" : "false"}",
                            ".."],
                            buildDirectoryPath)
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(["install"],buildDirectoryPath,{"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})
    end

end
