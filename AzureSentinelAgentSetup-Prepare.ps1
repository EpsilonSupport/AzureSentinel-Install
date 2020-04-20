#create the directory --
write-host "Creating Software Distribution directory ..."
new-item -itemtype "directory" -path "C:\softwareDistribution\AzureSentinelAgent\Setup"

#share the directory --
write-host "Sharing Software Distribution directory ..."
New-SmbShare -Name "softwareDistribution" -Path "C:\softwareDistribution\" -FullAccess "everyone"

#Download batch file --
write-host "Downloading Azure Sentinel Agent Batch File ..."
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/EpsilonSupport/SentinelTest/master/Install-AzureSentinel.bat" -outfile "C:\softwareDistribution\AzureSentinelAgent\Install-AzureSentinel.bat"

#Download zip file --
write-host "Downloading Azure Sentinel Agent Setup files ..."
Invoke-WebRequest -Uri "https://github.com/EpsilonSupport/SentinelTest/releases/download/v1.0/AzureSentinelAgentSetup.zip" -outfile "C:\softwareDistribution\AzureSentinelAgent\AzureSentinelAgentSetup.zip"

#EXTRACT AzureSentinelAgentSetup.zip -- 
write-host "Extracting ZIP to C:\softwareDistribution\AzureSentinelAgent\Setup ..."
Expand-Archive -LiteralPath "C:\softwareDistribution\AzureSentinelAgent\AzureSentinelAgentSetup.zip" -DestinationPath "C:\softwareDistribution\AzureSentinelAgent\Setup"
