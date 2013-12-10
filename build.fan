using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afEfanXtra"
		summary = "A library for creating reusable Embedded Fantom (efan) components"
		version = Version("1.0.0")

		meta	= [ "org.name"		: "Alien-Factory",
					"org.uri"		: "http://www.alienfactory.co.uk/",
					"vcs.uri"		: "https://bitbucket.org/AlienFactory/afefanxtra",
					"proj.name"		: "Efan Xtra",
					"license.name"	: "BSD 2-Clause License",
					"repo.private"	: "false"

					,"afIoc.module" : "afEfanXtra::EfanXtraModule"
				]

		index = [ "afIoc.module"	: "afEfanXtra::EfanXtraModule"
				]

		depends = [	"sys 1.0", 
					"concurrent 1.0",
					"afIoc 1.4.10+", 
					"afIocConfig 0+", 
					"afEfan 1.3.4+", 
					"afPlastic 1.0.8+"
				]

		srcDirs = [`test/unit-tests/`, `test/unit-tests/internal/`, `test/unit-tests/internal/utils/`, `test/unit-tests/components/`, `test/example/`, `fan/`, `fan/public/`, `fan/internal/`, `fan/internal/utils/`]
		resDirs = [`doc/`, `res/`, `test/example/`, `test/unit-tests/components/`]

		docApi = true
		docSrc = true

		// exclude test code when building the pod
		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }
		resDirs = resDirs.exclude { it.toStr.startsWith("test/") }
	}
}