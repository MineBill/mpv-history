# mpv-history

A simple lua plugin for the mpv player to keep track of your viewing history in slqite3 database

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
