<#	
	===========================================================================
	 Created on:   	3/18/2017
	 Created by:   	Shon Thomas - "pixelstroke"
	 Filename:     	Open-Website.psm1
	-------------------------------------------------------------------------
	 Module Name: Open-Website
	===========================================================================
#>
<#
	.SYNOPSIS
		Open URL in a specified browser
	
	.DESCRIPTION
		Launch a web browser and navigate to the specified URL
	
	.PARAMETER Browser
		Select Internet Explorer, Edge, Chrome or FireFox
	
	.PARAMETER URL
		Specify the URL to navigate to
	
	.PARAMETER Focus
		Attempt to focus meta-tag
		(e.g http://www.linkedurl.com/page#content)
	
	.EXAMPLE
		PS C:\> Open-Website -Browser 'Internet Explorer' -URL 'http://www.pixelstroke.net'
	
	.NOTES
		This module is meant for the Windows OS and only the following web browsers:
			Internet Explorer, Edge, Chrome and FireFox

			Edge will crash Powershell or any caller so be careful when using it.
	.TODO
		Edge 
		Build -Query Parameter (?)
			link.com/json?<query>=<value%20entered>
		Refine -Focus Parameter (#)
			link.com/page#focus
		
#>
function Open-Website
{
	param
	(
		[Parameter(Mandatory = $true,
				   HelpMessage = 'Enter a supported browser name')]
		[ValidateSet('Internet Explorer', 'IE', 'Edge', 'Chrome', 'FireFox', IgnoreCase = $true)]
		[Alias('B')]
		[string]$Browser = 'Internet Explorer',
		[Parameter(Mandatory = $true,
				   HelpMessage = 'Enter a URL to navigate to')]
		[ValidateNotNullOrEmpty()]
		[Alias('Link')]
		[string]$URL = 'http://github.com/pixelstroke',
		[Alias('F')]
		[string]$Focus
	)
	
	$script:os = (Get-WmiObject -Class Win32_OperatingSystem).OSArchitecture
	$script:exe = $null
	
	if ($os -eq '64-bit')
	{
		$exe = "${env:ProgramFiles(x86)}"
	}
	else
	{
		$exe = "${env:ProgramFiles}"
	}	
	
	try
	{
		switch ($Browser)
		{
			{ ($_ -match 'Internet Explorer') -or ($_ -match 'IE') }
			{
				
				$exe = "$exe\Internet Explorer\iexplore.exe"
				
				if ($Focus)
				{
					Start-Process -FilePath $exe -ArgumentList @("$URL#$Focus") -Wait
				}
				else
				{
					Start-Process -FilePath $exe -ArgumentList @($URL) -Wait
				}
				
				break
			} # Internet Explorer
			
			({ $_ -match 'Edge' })
			{
				$confirm = ''
				while ($confirm -notmatch "y|n")
				{
					Write-Warning "Edge may crash powershell. Do you still want to launch the browser?"
					$confirm = Read-Host "(Y/N)"
				}
				
				if ($confirm.ToLower() -eq 'y')
				{
					if ($URL -notcontains "http://" -or $URL -notcontains "https://")
					{
						Start-Process -FilePath "microsoft-edge:http://$URL" -Wait
					}
					else
					{
						Start-Process -FilePath "microsoft-edge:$URL" -Wait
					}
				}
				break
			} # Edge
			
			({ $_ -match 'Chrome' })
			{
				$exe = "$exe\Google\Chrome\Application\chrome"				

				if ($Focus)
				{
					Start-Process $exe -ArgumentList @('--new-window', "$URL#$Focus")
				}
				else
				{
					Start-Process $exe -ArgumentList @('--new-window', $URL)
				}
				break
			} # Chrome
			
			({ $_ -match 'FireFox' })
			{
				$exe = "$exe\Mozilla Firefox\firefox.exe"				
				
				if ($Focus)
				{
					Start-Process $exe -ArgumentList @("-url $URL#$Focus")
				}
				else
				{
					Start-Process $exe -ArgumentList @("-url $URL")
				}
				break
			} # Firefox
			
			'Default'
			{
				Write-Error "No browser specified"
				break
			} # Default
		} # switch
	} # try
	catch [System.Exception]
	{
		Write-Error "$($_.Exception.Message)"
		exit
	}	
}

Export-ModuleMember -Function Open-Website




# SIG # Begin signature block
# MIITpgYJKoZIhvcNAQcCoIITlzCCE5MCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUtRBQUPk0llsM175u1jZZrwwE
# hz2ggg2tMIIEFDCCAvygAwIBAgILBAAAAAABL07hUtcwDQYJKoZIhvcNAQEFBQAw
# VzELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExEDAOBgNV
# BAsTB1Jvb3QgQ0ExGzAZBgNVBAMTEkdsb2JhbFNpZ24gUm9vdCBDQTAeFw0xMTA0
# MTMxMDAwMDBaFw0yODAxMjgxMjAwMDBaMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
# ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIFRpbWVzdGFt
# cGluZyBDQSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAlO9l
# +LVXn6BTDTQG6wkft0cYasvwW+T/J6U00feJGr+esc0SQW5m1IGghYtkWkYvmaCN
# d7HivFzdItdqZ9C76Mp03otPDbBS5ZBb60cO8eefnAuQZT4XljBFcm05oRc2yrmg
# jBtPCBn2gTGtYRakYua0QJ7D/PuV9vu1LpWBmODvxevYAll4d/eq41JrUJEpxfz3
# zZNl0mBhIvIG+zLdFlH6Dv2KMPAXCae78wSuq5DnbN96qfTvxGInX2+ZbTh0qhGL
# 2t/HFEzphbLswn1KJo/nVrqm4M+SU4B09APsaLJgvIQgAIMboe60dAXBKY5i0Eex
# +vBTzBj5Ljv5cH60JQIDAQABo4HlMIHiMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMB
# Af8ECDAGAQH/AgEAMB0GA1UdDgQWBBRG2D7/3OO+/4Pm9IWbsN1q1hSpwTBHBgNV
# HSAEQDA+MDwGBFUdIAAwNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFs
# c2lnbi5jb20vcmVwb3NpdG9yeS8wMwYDVR0fBCwwKjAooCagJIYiaHR0cDovL2Ny
# bC5nbG9iYWxzaWduLm5ldC9yb290LmNybDAfBgNVHSMEGDAWgBRge2YaRQ2XyolQ
# L30EzTSo//z9SzANBgkqhkiG9w0BAQUFAAOCAQEATl5WkB5GtNlJMfO7FzkoG8IW
# 3f1B3AkFBJtvsqKa1pkuQJkAVbXqP6UgdtOGNNQXzFU6x4Lu76i6vNgGnxVQ380W
# e1I6AtcZGv2v8Hhc4EvFGN86JB7arLipWAQCBzDbsBJe/jG+8ARI9PBw+DpeVoPP
# PfsNvPTF7ZedudTbpSeE4zibi6c1hkQgpDttpGoLoYP9KOva7yj2zIhd+wo7AKvg
# IeviLzVsD440RZfroveZMzV+y5qKu0VN5z+fwtmK+mWybsd+Zf/okuEsMaL3sCc2
# SI8mbzvuTXYfecPlf5Y1vC0OzAGwjn//UYCAp5LUs0RGZIyHTxZjBzFLY7Df8zCC
# BJ8wggOHoAMCAQICEhEh1pmnZJc+8fhCfukZzFNBFDANBgkqhkiG9w0BAQUFADBS
# MQswCQYDVQQGEwJCRTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEoMCYGA1UE
# AxMfR2xvYmFsU2lnbiBUaW1lc3RhbXBpbmcgQ0EgLSBHMjAeFw0xNjA1MjQwMDAw
# MDBaFw0yNzA2MjQwMDAwMDBaMGAxCzAJBgNVBAYTAlNHMR8wHQYDVQQKExZHTU8g
# R2xvYmFsU2lnbiBQdGUgTHRkMTAwLgYDVQQDEydHbG9iYWxTaWduIFRTQSBmb3Ig
# TVMgQXV0aGVudGljb2RlIC0gRzIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQCwF66i07YEMFYeWA+x7VWk1lTL2PZzOuxdXqsl/Tal+oTDYUDFRrVZUjtC
# oi5fE2IQqVvmc9aSJbF9I+MGs4c6DkPw1wCJU6IRMVIobl1AcjzyCXenSZKX1GyQ
# oHan/bjcs53yB2AsT1iYAGvTFVTg+t3/gCxfGKaY/9Sr7KFFWbIub2Jd4NkZrItX
# nKgmK9kXpRDSRwgacCwzi39ogCq1oV1r3Y0CAikDqnw3u7spTj1Tk7Om+o/SWJMV
# TLktq4CjoyX7r/cIZLB6RA9cENdfYTeqTmvT0lMlnYJz+iz5crCpGTkqUPqp0Dw6
# yuhb7/VfUfT5CtmXNd5qheYjBEKvAgMBAAGjggFfMIIBWzAOBgNVHQ8BAf8EBAMC
# B4AwTAYDVR0gBEUwQzBBBgkrBgEEAaAyAR4wNDAyBggrBgEFBQcCARYmaHR0cHM6
# Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADAWBgNV
# HSUBAf8EDDAKBggrBgEFBQcDCDBCBgNVHR8EOzA5MDegNaAzhjFodHRwOi8vY3Js
# Lmdsb2JhbHNpZ24uY29tL2dzL2dzdGltZXN0YW1waW5nZzIuY3JsMFQGCCsGAQUF
# BwEBBEgwRjBEBggrBgEFBQcwAoY4aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNv
# bS9jYWNlcnQvZ3N0aW1lc3RhbXBpbmdnMi5jcnQwHQYDVR0OBBYEFNSihEo4Whh/
# uk8wUL2d1XqH1gn3MB8GA1UdIwQYMBaAFEbYPv/c477/g+b0hZuw3WrWFKnBMA0G
# CSqGSIb3DQEBBQUAA4IBAQCPqRqRbQSmNyAOg5beI9Nrbh9u3WQ9aCEitfhHNmmO
# 4aVFxySiIrcpCcxUWq7GvM1jjrM9UEjltMyuzZKNniiLE0oRqr2j79OyNvy0oXK/
# bZdjeYxEvHAvfvO83YJTqxr26/ocl7y2N5ykHDC8q7wtRzbfkiAD6HHGWPZ1BZo0
# 8AtZWoJENKqA5C+E9kddlsm2ysqdt6a65FDT1De4uiAO0NOSKlvEWbuhbds8zkSd
# wTgqreONvc0JdxoQvmcKAjZkiLmzGybu555gxEaovGEzbM9OuZy5avCfN/61PU+a
# 003/3iCOTpem/Z8JvE3KGHbJsE2FUPKA0h0G9VgEB7EYMIIE7jCCAtYCAQEwDQYJ
# KoZIhvcNAQELBQAwPTELMAkGA1UEBhMCVVMxFDASBgNVBAoMC1BpeGVsU3Ryb2tl
# MRgwFgYDVQQDDA9waXhlbHN0cm9rZS5uZXQwHhcNMTcwMzE5MTgxMDU0WhcNMjAw
# MzE4MTgxMDU0WjA9MQswCQYDVQQGEwJVUzEUMBIGA1UECgwLUGl4ZWxTdHJva2Ux
# GDAWBgNVBAMMD3BpeGVsc3Ryb2tlLm5ldDCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBALz8JNEwnjN3v8TpK41lbBIy6oXaB0b18Vs+Drx4zeIRja45jLdJ
# OipSrds7802sQDh8P9vKTaPJJAgkyTZL9smWJXULd+6u4eEX1SUgQCH4wakwv/eP
# J3sdi+fMC8LKLzd7fgM26+iZt6cpJo2nAJqdpTQ2mneuREtbIfKPUUGRbJlprQ3X
# L4F+m62dc4PDjngp+TGk8NPqW19CosJgnvntEwNntOMY0sFNXPOYeq9SV6A4Wid8
# BDMY1Yt+64NQiZH7P3yNyP5f6Qvq0XN6vt/g2nFH6t4rYSlMcezmgmDdb7oOkt83
# 1NTPEn9rQPPjpmQrCkw1DUWrU3Ap45NUeFUJbaos1YpleentwKne4bPzHIvUb6y8
# hOS59/xEP5ba2MHMhgATdCnY1SqqEpHjf36Rn3mZV5VuQTCE/UnnA7/yB6Aq3xF/
# hhuJ0tKMDbjgi31XLEupl1zfN3JI1ZUcLIPinyVJFC+W6zTbdJuPYbBqbXztz7xZ
# 91QWoK2NFOTrtIu4AYwdRKN/wn/ldpGaNyD/zh5ffrqwynk67jlOpZoQRL0Ku3zE
# F9zO0BPyLOew8MB9ZUvwgWl+mZYpFgrIHWcmIdfTyIgDCCUflJU7mWeWSDyST58p
# nI2VlSzmzrSLKXR4pkzaA6BNOVGixq0Cv61CpwrnqU+uNt6jGOfa3RrfAgMBAAEw
# DQYJKoZIhvcNAQELBQADggIBAG2ZzMiiLWbHU/hZecaKjYww9bgNqaG2ZWHLIUYm
# Tv6bgJDv01MnZaESK6DFMUkniszMpsARfmByXclsTUtYbfzwsOkvbAT0Ks00OolL
# t1XlwPp8T2P1Gd7qG8rvies5xlELKDi6McFP6+V3ai91YPfBfwLoPHiAjn108b8o
# FXn1valL24dAj7BMAGmYehqgiCEomjbuA9WO5Pf9A4wqHHAKY6JBCvvm5La21pPH
# 6ImX7RetpD98XcOrv/jOzI2zLA294jaB8aqccNBXIzo3C95Aj4HPjpB6/ogCIB9D
# 5Y6c9tay7JKQ3tsdzzclP0N7KTAvAdMSshALyOzcIECfi3+vuYPT9v0qnUBnp0O/
# ZBR4kowpc1PQLEpG4vfL9OWpwWJF4f/F++j0sETb3S/51SIBtRc4WLt43fgVzG1m
# BilQ8Z/FgHfBW8vOFk1vkcb/PnpzBlLKCZAwocE/jBCpyCof0Bu17AR/mETie4Ft
# uKH11KpWYgfOiD1J2oZT55+2qQWVsS5FJ0+FQATCZRl2MuZXEZV/HqkWF8LEwlvp
# mIPfL7GFIeDrH1/pTn2Lnrnzw3ZX3CJlGoUxa5ZT5dm4nugCYv8LqCm/rkChZY3a
# kU+vkdB7hlC5pE7c4COLoHAiwKsHCe+ZwZqshv0kPbbyW2SYLdy8TP0fafKGninL
# eXRxMYIFYzCCBV8CAQEwQjA9MQswCQYDVQQGEwJVUzEUMBIGA1UECgwLUGl4ZWxT
# dHJva2UxGDAWBgNVBAMMD3BpeGVsc3Ryb2tlLm5ldAIBATAJBgUrDgMCGgUAoFIw
# EAYKKwYBBAGCNwIBDDECMAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwIwYJ
# KoZIhvcNAQkEMRYEFLhDfnkfSB9D97Tbef/TMoyfjPFWMA0GCSqGSIb3DQEBAQUA
# BIICAG3I32wKStZQagFWzmMirmzxsAxS3EAWWcbifocgNEnAdsFUuwFCnkme0JIk
# svzdF8qTSszbDZIf4O27O1pHS10whRVGin6UU1lviXxFYdlUy/lspTEreP41WYCr
# vWUd5H4YtOwPz2LArN+Vvk/qsmzIHgi+Kn8OT3C8X60M0pcmVQt5TDmwQtmrDHrJ
# exWfcCcpQZFJopkxcQ0JK6/2IjXVkggwthz8XOXB4T1it3Ba7UDWvLhogAIBh/LW
# imLiPqO6EUoEMaJBOVDz+jEHnTP0R7Yu/i2U1eETTnOA5ktt48FJzj18X1wkJC9m
# sVwV7QSyOsLxXJ9pXNfenf46v2tqLquxtLRwXp0sOPPQmb9u9ZXBsWywhy/4avpF
# Zns6ilGDXgTacBp6l8xJRQRjBGeUgVpfctEPCP8UIkiEdtqCK7QOvfyiHKVxL44e
# kldttzWIrW+YorOqxsLCueydQ+XOZr1I72WOdcsKRKiNwANpVobcIrZWqMJqSgCG
# cp7W3bne0E987jfaXpk23T3SCjb5EcwdlZDcDhCshqBpvAEqK8ZzF66hEUaJ465Z
# tTLuMcR99jHfz5tsZ6WwAc7eSlN4+aLH+R5OuK+jfaGNPXypQSmEiv/hcg53WIAW
# yivYP0LJpS836a8oxzZuxUypTIqYPpG1+EIsK7DY5dR0LUCkoYICojCCAp4GCSqG
# SIb3DQEJBjGCAo8wggKLAgEBMGgwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEds
# b2JhbFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gVGltZXN0YW1waW5n
# IENBIC0gRzICEhEh1pmnZJc+8fhCfukZzFNBFDAJBgUrDgMCGgUAoIH9MBgGCSqG
# SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE3MDMxOTE4MzAz
# NVowIwYJKoZIhvcNAQkEMRYEFLM0daxC3MZxTut7wKyPbozN47uYMIGdBgsqhkiG
# 9w0BCRACDDGBjTCBijCBhzCBhAQUY7gvq2H1g5CWlQULACScUCkz7HkwbDBWpFQw
# UjELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYtc2ExKDAmBgNV
# BAMTH0dsb2JhbFNpZ24gVGltZXN0YW1waW5nIENBIC0gRzICEhEh1pmnZJc+8fhC
# fukZzFNBFDANBgkqhkiG9w0BAQEFAASCAQBangySfqcZc1JCjnwrYV21GXiuw3ky
# op1DvNGKyNvjKr5ikoEoer4T3/aSxCQB1BQnLbhCqTVYAAW1DAfd4WxXndtYT4ka
# 5QoYYAmaAsaavDym5tE/gsHbGPT+qfLEDGJaBD11aNWuIqurZjlnbOkNmqhh7+5y
# vluZjl3Gy9+0lKFpLsWprX95NPjr4A/qk3YqTLLfKmm9//KvYfAo1Fqd+3vfAVCo
# 6NDdJPWdq+n7+1XW2vc5A6Kn1/a0fIvOVE700DEOHGqElHT97NdlwLSQX5CRfuLW
# YI9SsfETwYdsSi5+PtYIwwB6WvHmj7GkrTfsPJYrHrP0GVdhYRyyF74h
# SIG # End signature block
