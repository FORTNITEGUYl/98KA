local cloneref = cloneref or function(ref: any)
    return ref
end

if isfolder('98ka_folder') then
    delfolder('98ka_folder')
end

cloneref(game:GetService('StarterGui')):SetCore('SendNotification', {
    Title = '98KA',
    Text = 'Successfully reinstalled 98KA, Please rejoin the game to take effect',
    Duration = 20
})
