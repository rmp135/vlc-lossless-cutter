function descriptor()
    return {
        title = "Lossless Cutter",
        version = "1.0",
        author = "Ryan Poole",
        url = '',
        shortdesc = "Lossless Cutter",
        description = "",
        capabilities = {
            "input-listener",
            "meta-listener",
            "playing-listener"
        }
    }
end

-------------- Global variables -------------
cuts = {}
-----------------------------------------------

function format_time(s)
    s = s / 1000000
    local hours = s / (60 * 60)
    s = s % (60 * 60)
    local minutes = s / 60
    local seconds = s % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

function activate()
    createGUI()
end

function createGUI()
    main_layout = vlc.dialog("Lossless Cutter")
    main_layout:add_label("<b>Cuts:</b>", 1, 1, 4, 1)

    cuts_list = main_layout:add_list(1, 2, 4, 1)

    main_layout:add_button("Set Start", set_start, 1, 3, 2, 1)
    main_layout:add_button("Set End", set_end, 3, 3, 2, 1)

    main_layout:add_button("Add Cut", add_cut, 1, 4, 1, 1)
    main_layout:add_button("Remove Cut", remove_cut, 2, 4, 1, 1)
    main_layout:add_button("GoTo", go_to_cut, 3, 4, 1, 1)
    main_layout:add_button("Save", save, 4, 4, 1, 1)
end

function set_start()
    selection = cuts_list:get_selection()
    if (not selection) then
        return
    end
    for idx, _ in pairs(selection) do
        sel = idx
        break
    end
    time = vlc.var.get(input, "time")
    cuts[sel].starttime = time
    refresh_cuts()
end

function set_end()
    selection = cuts_list:get_selection()
    if (not selection) then
        return
    end
    for idx, _ in pairs(selection) do
        sel = idx
        break
    end
    input = vlc.object.input()
    time = vlc.var.get(input, "time")
    cuts[sel].endtime = time
    refresh_cuts()

end

function save()
    uri = vlc.input.item():uri()
    filepath = vlc.strings.decode_uri(uri)
    filepath = string.sub(filepath,9)
    filepath = filepath .. ".csv"
    vlc.msg.dbg(filepath)
    file = io.open(filepath, "w")
    for _, value in pairs(cuts) do
        file:write(string.format(value.starttime / 10^6, '%4f') .. ","..  string.format(value.endtime / 10^6, '%6.4f') ..",".."\n")
    end
    file:close()
end

function add_cut()
    input = vlc.object.input()
    time = vlc.var.get(input, "time")
    cut = {
        starttime = time,
        endtime = time
    }
    table.insert(cuts, cut)
    refresh_cuts()
end

function refresh_cuts()
    cuts_list.clear(cuts_list)
    for i, cut in pairs(cuts) do
        cuts_list:add_value(format_time(cut.starttime) .. " - " .. format_time(cut.endtime), i)
    end
end

function go_to_cut()
    selection = cuts_list:get_selection()
    if (not selection) then
        return 1
    end
    local sel = nil
    for id, _ in pairs(selection) do
        sel = id
        break
    end
    input = vlc.object.input()
    vlc.var.set(input, "time", cuts[sel].starttime)
end

function remove_cut()
    selection = cuts_list:get_selection()
    if (not selection) then
        return 1
    end
    local sel = nil
    for id, _ in pairs(selection) do
        sel = id
        break
    end
    cuts[sel] = nil
    refresh_cuts()
end

