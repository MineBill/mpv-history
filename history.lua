sqlite3 = require('lsqlite3')
msg = require('mp.msg')

local history_db_path = ''
do
    local cfg = mp.find_config_file('.')
    history_db_path = cfg:sub(1, #cfg - 1) .. 'history.db'
end

last_insert_id = nil
db = nil

function get_property(property)
    res = mp.get_property(property, "N/A")
    return res
end

-- Check if table exist or create it otherwise
function start_file()
    msg.info("Opening database..")
    db, errcode, errmsg = sqlite3.open(history_db_path)
    if db == nil then
        error(string.format("DB Failed to open: %d %s", errcode, errmsg))
    end

    check_table=[=[
        SELECT * FROM history_item;
    ]=]
    result = db:exec(check_table)
    if result ~= sqlite3.OK then
        create_tables=[=[
            CREATE TABLE history_item(
                id          INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                path        TEXT    NOT NULL,
                filename    TEXT    NOT NULL,
                title       TEXT    NOT NULL,
                time_pos    INTEGER,
                date        DATE    NOT NULL
            );
        ]=]

        res = db:exec(create_tables)
        if res ~= sqlite3.OK then error(db:errmsg()) end
    end
end

function file_loaded()
    video_query=string.format([=[
        INSERT INTO history_item (path, filename, title, date)
        VALUES(
            "%s",
            "%s",
            "%s",
            "%s"
        );
        SELECT LAST_INSERT_ROWID();
    ]=], 
        mp.get_property("path"),
        mp.get_property("filename"),
        mp.get_property("media-title"),
        os.date("%Y-%m-%d %H:%M")
    )
    -- function callback should return 0 to indicate everything is ok
    res = db:exec(video_query, function(udata, cols, values, names)
        last_insert_id = values[1]
        print(string.format("last_insert_id=%d", last_insert_id))
        return 0
    end, nil)
    if res ~= sqlite3.OK then error(db:errmsg()) end
end

function shutdown()
    msg.info("Closing database..")
    db:close()
end

mp.add_hook("on_unload", 50, function(hook)
    time = mp.get_property("percent-pos")
    query = string.format([=[
        UPDATE history_item
        SET time_pos = %d
        WHERE id = %d;
    ]=],
        time,
        last_insert_id
    )

    res = db:exec(query)
    if res ~= sqlite3.OK then error(db:errmsg()) end
end)

mp.register_event("start-file", start_file)
mp.register_event("file-loaded", file_loaded)
mp.register_event("shutdown", shutdown)
