# Configuration Optimization tool configuration parameters
# version of the Configuration Optimization tool to install
default["dice-h2020"]["conf-optim"]["co-version"] = "v0.1.1"
# install Configuration Optimization tool into this path
default["dice-h2020"]["conf-optim"]["co-installpath"] = "/opt/co"
# URL of the release containing the compiled binaries for MCR
default["dice-h2020"]["conf-optim"]["release-url"] =
	"https://github.com/dice-project/DICE-Configuration-BO4CO/releases/download/" # v0.1.1/bin.zip
# URL of the whole BO4CO code
default["dice-h2020"]["conf-optim"]["src-release-url"] =
	"https://github.com/dice-project/DICE-Configuration-BO4CO/archive/master.zip"
# deployment services container UUID reserved for the CO
default["dice-h2020"]["conf-optim"]["ds-container"] = "7b5750a7-914e-4e83-ab40-b04fd1975542"

# MATLAB parameters
default["dice-h2020"]["conf-optim"]["matlab-url"] =
	"http://uk.mathworks.com/supportfiles/downloads/R2015a/deployment_files/R2015a/installers/glnxa64/MCR_R2015a_glnxa64_installer.zip"
# install MATLAB into this path
default["dice-h2020"]["conf-optim"]["matlab-installpath"] = "/opt/matlab"

# DICE deployment service parameters
# url of the DICE deployment release package
default["dice-h2020"]["deployment-service"]["release-url"] =
	"https://github.com/dice-project/DICE-Deployment-Service/archive/0.3.1.zip"
# url of the DICE deployment service's instance
default["dice-h2020"]["deployment-service"]["url"] = "http://deployer.example.lan:8000"
# TODO: move into an encrypted vault
# deployment services credentials - username
default["dice-h2020"]["deployment-service"]["username"] = "user"
# TODO: move into an encrypted vault
# deployment services credentials - password
default["dice-h2020"]["deployment-service"]["password"] = "password"
# install DICE deployment service CLI tools into this path
default["dice-h2020"]["deployment-service"]["tools-install-path"] = "/opt/deployment-service/"

# DICE monitoring service configuration parameters
# url of the DICE monitoring service
default["dice-h2020"]["d-mon"]["url"] = "http://dmon.example.lan:5001"
