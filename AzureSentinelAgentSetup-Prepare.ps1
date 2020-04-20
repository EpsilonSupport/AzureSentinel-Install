#Get Variables --
$serverName=Read-Host -Prompt 'Name of server you are on'
$domain=Read-Host -Prompt 'NetBIOS'
$user=Read-Host -Prompt 'Domain Admin user name'
$pass=Read-Host -Prompt 'Domain Admin password'
$id=Read-Host -Prompt 'Azure Sentinel Workspace ID'
$key=Read-Host -Prompt 'Azure Sentinel Workspace ID Key'


#Enable TLS1.2 --
write-host "Enabling TLS 1.2 ..."
try {
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}
catch {
  Write-Warning $Error[0]
}

#create the directory --
write-host "Creating Software Distribution directory ..."
try {
  new-item -itemtype "directory" -path "C:\softwareDistribution\AzureSentinelAgent\Setup"
}
catch {
  Write-Warning $Error[0]
}

#share the directory --
write-host "Sharing Software Distribution directory ..."
try {
  New-SmbShare -Name "softwareDistribution" -Path "C:\softwareDistribution\" -FullAccess "everyone"
}
catch {
  Write-Warning $Error[0]
}

#Download batch file --
write-host "Downloading Azure Sentinel Agent Batch File ..."
try {
  Invoke-WebRequest -Uri "https://raw.githubusercontent.com/EpsilonSupport/SentinelTest/master/Install-AzureSentinel.bat" -outfile "C:\softwareDistribution\AzureSentinelAgent\Install-AzureSentinel.bat"
}
catch {
  Write-Warning $Error[0]
}

#Download zip file --
write-host "Downloading Azure Sentinel Agent Setup files ..."
try {
  Invoke-WebRequest -Uri "https://github.com/EpsilonSupport/SentinelTest/releases/download/v1.1/AzureSentinelAgentSetup.zip" -outfile "C:\softwareDistribution\AzureSentinelAgent\AzureSentinelAgentSetup.zip"
}
catch {
  Write-Warning $Error[0]
}

#EXTRACT AzureSentinelAgentSetup.zip -- 
write-host "Extracting ZIP to C:\softwareDistribution\AzureSentinelAgent\Setup ..."
try {
  Expand-Archive -LiteralPath "C:\softwareDistribution\AzureSentinelAgent\AzureSentinelAgentSetup.zip" -DestinationPath "C:\softwareDistribution\AzureSentinelAgent\Setup"
}
catch {
  Write-Warning $Error[0]
}

#Mounting Drive --
write-host "Mounting Drive ..."
try {
  net use X: \\$serverName\softwareDistribution\AzureSentinelAgent
}
catch {
  Write-Warning $Error[0]
}

#Installing Agent --
write-host "Installing Agent ..."
try {
  X:\Install-AzureSentinel.bat $id $key
}
catch {
  Write-Warning $Error[0]
}

#Unmounting Drive
write-host "Unmounting Drive ..."
try {
  net use x: /d
}
catch {
  Write-Warning $Error[0]
}
