class Target < ISM::Software

    def prepareInstallation
        super

        runPythonCommand(["setup.py","install","bdist"],buildDirectoryPath)

        extractArchive("#{buildDirectoryPath}/dist/Asciidoc-10.2.0.linux-x86_64.tar.gz")

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr")

        copyDirectory("#{workDirectoryPath}/usr","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr")

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d")

        if File.exists?("#{Ism.settings.rootPath}etc/profile.d/python.sh")
            copyFile("#{Ism.settings.rootPath}etc/profile.d/python.sh","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh")
        else
            generateEmptyFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh")
        end

        pythonData = <<-CODE
        pathappend /usr/lib/python3.11/site-packages/Asciidoc-10.2.0-py3.11.egg PYTHONPATH
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/python.sh",pythonData)
    end

end

