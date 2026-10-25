### Connecter Klipper/Moonraker, OctoPrint ou Home Assistant

Ces outils dialoguent avec l'API de Spoolman (`__PATH__/api/`) et ne peuvent pas s'authentifier via le portail YunoHost. L'API dispose de sa propre permission, distincte de l'interface web : vous pouvez donc l'ouvrir sans exposer l'interface.

```bash
sudo yunohost user permission update __APP__.api --add visitors
```

Ou dans la webadmin : *Groupes et permissions* → *__APP__.api* → ajouter *Visiteurs*.

⚠️ Spoolman n'a pas d'authentification : une fois l'API ouverte aux visiteurs, quiconque connaît son URL peut lire **et modifier** votre inventaire depuis Internet. Si possible, restreignez plutôt l'accès au réseau de votre imprimante au niveau de votre box ou pare-feu.

Puis, dans `moonraker.conf` :

```ini
[spoolman]
server: https://__DOMAIN____PATH__
```

### Fichiers et sauvegardes

- Base de données (SQLite) : `__DATA_DIR__/spoolman.db`
- Instantanés nocturnes de la base (5 conservés) : `__DATA_DIR__/backups/`
- Logs : `/var/log/__APP__/spoolman.log` (rotation quotidienne par Spoolman, 5 jours conservés)
- Réglages : `__INSTALL_DIR__/.env` (régénéré à chaque mise à jour)

Les sauvegardes YunoHost incluent la base de données. Un instantané cohérent est pris avant chaque sauvegarde et avant chaque mise à jour.
