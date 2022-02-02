# Configuración de estaciones de trabajo - "dotfiles"

## Instalar chezmoi

```
curl -sfL https://git.io/chezmoi | sh
chezmoi init [--apply] git@github.com:carlosm3011/carlos-dotfiles.git
```

El "apply" es opcional, lo que hace es aplicar junto con el checkout todos los cambios pendientes.

## Instanciar un nuevo puesto de trabajo

### Instalar paquetes

Modificar los scripts "run_once_xx-install.sh.tmpl".

### Dotfiles

TBW*

## Gestión de dotfiles

- Inicialización del repositorio

- Aplicar los cambios
   - ```chezmoi update```
   - ```chezmoi apply``` 

## Referencias:

1. https://github.com/jmc265/dotfiles
2. https://chezmoi.io
