class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        runMesonCommand([   "setup",
                            @buildDirectoryNames["MainBuild"],
                            "-Dadmin_group=wheel",
                            "-Dsystemdsystemunitdir=no",
                            "-Delogind=#{option("Elogind") ? "true" : "false"}",
                            "-Dvapi=false"],
                            path: mainWorkDirectoryPath)
    end

    def configure
        super

        runMesonCommand([   "configure",
                            @buildDirectoryNames["MainBuild"],
                            "--prefix=/usr",
                            "--buildtype=release",
                            "-Dadmin_group=wheel",
                            "-Dsystemdsystemunitdir=no",
                            "-Delogind=#{option("Elogind") ? "true" : "false"}",
                            "-Dvapi=false"],
                            path: mainWorkDirectoryPath)
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
