class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super

        runMesonCommand(["setup",@buildDirectoryName],mainWorkDirectoryPath)
    end

    def configure
        super

        runMesonCommand([   "configure",
                            @buildDirectoryName,
                            "--prefix=/usr",
                            "--buildtype=release",
                            "-Dman=auto",
                            "-Ddocdir=/usr/share/doc/elogind-252.9",
                            "-Dcgroup-controller=elogind",
                            "-Ddbuspolicydir=/etc/dbus-1/system.d"],
                            mainWorkDirectoryPath)
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        runNinjaCommand(["install"],buildDirectoryPath,{"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        fileReplaceTextAtLineNumber("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/elogind/logind.conf","#KillUserProcesses=yes","KillUserProcesses=no",15)

        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/pam.d")
        makeDirectory("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/conf.d")

        if File.exists?("#{Ism.settings.rootPath}etc/pam.d/system-session")
            copyFile("#{Ism.settings.rootPath}etc/pam.d/system-session","#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/pam.d/system-session")
        else
            generateEmptyFile("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/pam.d/system-session")
        end

        systemSessionData = <<-CODE
        session  required    pam_loginuid.so
        session  optional    pam_elogind.so
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/pam.d/system-session",systemSessionData)

        elogindUserData = <<-CODE
        account  required    pam_access.so
        account  include     system-account

        session  required    pam_env.so
        session  required    pam_limits.so
        session  required    pam_unix.so
        session  required    pam_loginuid.so
        session  optional    pam_keyinit.so force revoke
        session  optional    pam_elogind.so

        auth     required    pam_deny.so
        password required    pam_deny.so
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/pam.d/elogind-user",elogindUserData)

        elogindConfData = <<-CODE
        ELOGIND_EXEC=/usr/lib/elogind/elogind
        ELOGIND_PIDFILE=/var/run/elogind.pid
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath(false)}#{Ism.settings.rootPath}etc/conf.d/elogind",elogindConfData)

        if option("Openrc")
            prepareOpenrcServiceInstallation("#{workDirectoryPath(false)}/Elogind-Init.d","elogind")
        end
    end

    def install
        super

        makeLink("libelogind.pc","#{Ism.settings.rootPath}usr/lib/pkgconfig/libsystemd.pc",:symbolicLinkByOverwrite)
        makeLink("elogind","#{Ism.settings.rootPath}usr/include/systemd",:symbolicLinkByOverwrite)
    end

end
