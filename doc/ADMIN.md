### Connecting Klipper/Moonraker, OctoPrint or Home Assistant

These tools talk to Spoolman's API (`__PATH__/api/`) and cannot log in through the YunoHost portal. The API has its own permission, separate from the web interface, so you can open it without exposing the UI:

```bash
sudo yunohost user permission update __APP__.api --add visitors
```

Or in the webadmin: *Groups and permissions* → *__APP__.api* → add *Visitors*.

⚠️ Spoolman has no authentication: once the API is open to visitors, anyone on the Internet who knows its URL can read **and modify** your inventory. Prefer restricting access at your router or firewall to your printer's network when you can.

Then, in `moonraker.conf`:

```ini
[spoolman]
server: https://__DOMAIN____PATH__
```

### Files and backups

- Database (SQLite): `__DATA_DIR__/spoolman.db`
- Nightly database snapshots (5 kept): `__DATA_DIR__/backups/`
- Logs: `/var/log/__APP__/spoolman.log` (rotated daily by Spoolman, 5 days kept)
- Settings: `__INSTALL_DIR__/.env` (regenerated on upgrades)

YunoHost backups include the database. A consistent snapshot is taken before each backup and before each upgrade.
