--!nocheck
script_key = script_key
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file) writefile(file, '') end

local downloader = Instance.new('TextLabel')
downloader.Size = UDim2.new(1, 0, 0, 40)
downloader.BackgroundTransparency = 1
downloader.TextStrokeTransparency = 0
downloader.TextSize = 20
downloader.TextColor3 = Color3.new(1, 1, 1)
downloader.Font = Enum.Font.Arial
downloader.Text = ''
downloader.Parent = Instance.new('ScreenGui', gethui and gethui() or game:GetService('CoreGui'))

local function downloadFile(path, func)
	if not isfile(path) then
		downloader.Text = 'Downloading '.. path
		local suc, res = pcall(function()
			-- Changed URL to your repository
			return game:HttpGet('https://raw.githubusercontent.com/FORTNITEGUYl/98KA/main/'..select(1, path:gsub('98ka_folder/', '')), true)
		end)
		if not suc or res == '404: Not Found' then error(res) end
		if path:find('.lua') then
			res = '--Customized for 98KA\n'..res
		end
		writefile(path, res)
		downloader.Text = ''
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('init') then continue end
		if file:find('profile') then continue end
		if isfile(file) then delfile(file) elseif isfolder(file) then wipeFolder(file) end
	end
end

-- Changed folder structure
for _, folder in {'98ka_folder', '98ka_folder/games', '98ka_folder/profiles', '98ka_folder/assets', '98ka_folder/libraries', '98ka_folder/guis'} do
	if not isfolder(folder) then
		downloader.Text = 'Downloading '.. folder
		makefolder(folder)
	end
end

if not shared.VapeDeveloper then
	local _, subbed = pcall(function() return game:HttpGet('https://github.com/FORTNITEGUYl/98KA') end)
	-- Logic maintains file integrity for your repo
	writefile('98ka_folder/profiles/commit.txt', 'main')
end

-- Load all libraries before executing main.lua
if not shared.vape then shared.vape = {} end
if not shared.vape.Libraries then shared.vape.Libraries = {} end

local Libraries = shared.vape.Libraries
local libraryFiles = {'base64', 'drawing', 'entity', 'hash', 'prediction', 'string', 'vm'}
for _, libFile in pairs(libraryFiles) do
	downloader.Text = 'Loading library: '.. libFile
	local libCode = downloadFile('98ka_folder/libraries/'..libFile..'.lua')
	Libraries[libFile] = loadstring(libCode)()
end

downloader.Text = ''
return loadstring(downloadFile('98ka_folder/main.lua'), 'main')(...)
