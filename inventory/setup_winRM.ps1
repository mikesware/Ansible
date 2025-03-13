IF (!(get-childitem Cert:\LocalMachine\My\)) {
New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "WinRMCertificate"
}
#get-childitem Cert:\LocalMachine\My\


Enable-PSRemoting -SkipNetworkProfileCheck -Force
($cert = gci Cert:\LocalMachine\My\) -and (NEW-WSManInstance winrm/config/Listener -SelectorSet @{Address='*';Transport='HTTPS'} -ValueSet @{CertificateThumbprint=$cert.Thumbprint})
#                                          Set-WSManInstance winrm/config/listener -SelectorSet @{Address="*";Transport="HTTP"} -ValueSet @{Enabled="false"}    
#                                           New-WSManInstance winrm/config/listener -SelectorSet @{Address="*";Transport="HTTPS"} -ValueSet @{Hostname="<your_hostname>";CertificateThumbprint="<your_certificate_thumbprint>"}  
#get-WSManInstance -Enumerate -ResourceURI winrm/config/Listener 


IF(!(get-netfirewallRule -DisplayName "Windows Remote Management
(HTTPS-In)")) {
New-NetFirewallRule -DisplayName "Windows Remote Management
(HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile
Any -LocalPort 5986 -Protocol TCP
}
