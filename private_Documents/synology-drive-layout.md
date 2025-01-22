# Layout para la instalacion de Synology Drive

## Previo: instalar el cliente de Synology Drive

1. Instalar el cliente Synology Drive
2. Configurar los jobs de sincronizacion
  - Uno es el home
  - Los otros estan en el Team Folder

## Links en el home de la mac

Crear carpetas para alojar los acceos:

```
mkdir -p ~/SD/home
mkdir -p ~/SD/Fotos-LyM
mkdir -p ~/SD/Sync
```

Luego crear los symlinks:

```
ln -sf ~/Library/CloudStorage/SynologyDrive-home ~/SD/home
ln -sf ~/Library/CloudStorage/SynologyDrive-Sync ~/SD/Sync
ln -sf ~/Library/CloudStorage/SynologyDrive-Fotos-LyM ~/SD/Fotos-LyM
```


