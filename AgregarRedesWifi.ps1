# AgregarRedesWiFi.ps1

$nuevasRedes = @(
    @{ Nombre = "NuevaRed1"; Contraseña = "Contraseña1" },
    @{ Nombre = "NuevaRed2"; Contraseña = "Contraseña2" },
    @{ Nombre = "NuevaRed3"; Contraseña = "Contraseña3" }
)

$rutaArchivos = "C:\Users\TuUsuario\Documentos\PerfilesWiFi"

if (-not (Test-Path $rutaArchivos)) {
    New-Item -ItemType Directory -Path $rutaArchivos
}

$nuevasRedes | ForEach-Object {
    $nombreRed = $_.Nombre
    $contraseña = $_.Contraseña
    $rutaArchivoPerfil = Join-Path -Path $rutaArchivos -ChildPath "$nombreRed.xml"
    
    @"
<?xml version="1.0"?>
<WLANProfile xmlns="http://www.microsoft.com/networking/WLAN/profile/v1">
    <name>$nombreRed</name>
    <SSIDConfig>
        <SSID>
            <name>$nombreRed</name>
        </SSID>
    </SSIDConfig>
    <connectionType>ESS</connectionType>
    <connectionMode>auto</connectionMode>
    <MSM>
        <security>
            <authEncryption>
                <authentication>WPA2PSK</authentication>
                <encryption>AES</encryption>
                <useOneX>false</useOneX>
            </authEncryption>
            <sharedKey>
                <keyType>passPhrase</keyType>
                <protected>false</protected>
                <keyMaterial>$contraseña</keyMaterial>
            </sharedKey>
        </security>
    </MSM>
</WLANProfile>
"@ | Set-Content -Path $rutaArchivoPerfil

    netsh wlan add profile filename="$rutaArchivoPerfil"
    Write-Host "Perfil de red WiFi agregado exitosamente: $nombreRed"
}
