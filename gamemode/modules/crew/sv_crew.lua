RegisterServerEvent("Additem")
AddEventHandler("Additem", function(item)
    MySQL.Async.execute('INSERT INTO items (identifier, item, count) VALUES (@identifier, @item, @count)', {
        ["@identifier"] = GetLicenseOfSource(),
        ["@item"] = item,
        ["@count"] = "1"
	})
end)