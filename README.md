# mpv-history

A simple lua plugin for the mpv player to keep track of your viewing history in slqite3 database

## Installation
This script requires lsqlite3 to be installed on your system. To do so, you must first install [Luarocks](https://github.com/luarocks/luarocks/wiki/Download)
Once that is done you must then download the library itself:
### Linux:
```bash
sudo luarocks --lua-version 5.2 lsqlite3 # mpv uses Lua 5.2, so we must specify that
```
We must use `sudo` to install it system-wide because that's how the lua vm mpv uses can find it.
### Windows:
I have no idea. You need to install `sqlite3` and make it visible while installing `lsqlite3` with luarocks. If you manage to do
this please let me know so i can update the REAMDE.

## DB Table
The pluing will try to load check if the table `history_item` exists and if not it will create one.
The column names are as follows:
| id | path | filename | title | time_pos | date |
|----|------|----------|-------|----------|------|

- `id`: An auto-incremented id
- `path`: The path of the current playing file. This is either a file in your filesystem, a youtube or a twitch url.
- `filename`: Just the name of the file. When viewing a youtube video this will be the video id. When viewing a twitch steam this will be the channel name.
- `title`: For youtube video this will be the title.
- `time_pos`: How much of the video in % you have watched. Note that if mpv closes without giving the script a chance to shutdown first this entry won't be inserted. Thus, it is possible for it to be NULL.
- `date`: Date in `YY-MM-DD HH:MM` format.

## Viewing your history
This script will only record your history and can't display it inside mpv. To view it you should use:
- [SQlite Browser](https://sqlitebrowser.org/)
- [Sqliteman](http://sqliteman.yarpen.cz/)
- Other software of your choice
- A simple sql query (SELECT * FROM history_item;)

# [License](./LICENSE)
GPL v3
