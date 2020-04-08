function Script(msg)
if TypeForChat == ("ForUser") then
if text == '/start' then  
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
if Dev_Raider(msg) then
local Text_keyboard = '〽┇اهلا بك في اوامر الكيبورد الجاهزه'
local List_keyboard = {
{'تفعيل تواصل البوت 🔔','تعطيل تواصل البوت 🔕'},
{'اذاعه خاص 👤','اذاعه للمجموعات 👥'},
{'اذاعه خاص بالتوجيه 👤','اذاعه بالتوجيه 👥'},
{'اذاعه بالتثبيت 📌'},
{'احصائيات البوت 📑'},
{'تفعيل مغادرة البوت ✔','تعطيل مغادرة البوت ❌'},
{'تفعيل اذاعه المطورين 🔓','تعطيل اذاعه المطورين 🔏'},
{'تفعيل الوضع الخدمي 🔖','تعطيل الوضع الخدمي 〽'},
{'تنظيف المجموعات 🔄','تنظيف المشتركين 🚯'},
{'مسح قائمه العام 💯','مسح قائمه المطورين 🚫'},
{'ازالة كليشه ستارت 🔗','تغير كليشه ستارت 🆕'},
{'قائمه العام 📝','قائمه المطورين 📝'},
{'تغير اسم البوت 🔄'},
{'تغير كليشة المطور 🆕','ازالة كليشة المطور 🆗'},
{'تحديث الملفات 🔁','تحديث السورس 🔂'},
{'جلب نسخة خزن الكروبات 📦'},
{'الغاء ✖'}
}
send_inline_keyboard(msg.chat_id_,Text_keyboard,List_keyboard)
else
if not redis:get(bot_id..'Ban:Cmd:Start'..msg.sender_user_id_) then
local GetCmdStart = redis:get(bot_id.."Set:Cmd:Start:Bot")  
if not GetCmdStart then 
CmdStart = '\n🙋┇أهلآ بك في بوت '..Name_Bot..''..
'\n〽┇اختصاص البوت حماية المجموعات'..
'\n☑┇لتفعيل البوت عليك اتباع مايلي ...'..
'\n👥┇اضف البوت الى مجموعتك'..
'\n⚡┇ارفعه ادمن {مشرف}'..
'\n⛔┇ارسل كلمة { تفعيل } ليتم تفعيل المجموعه'..
'\n📛┇سيتم ترقيتك منشئ اساسي في البوت'..
'\n🚸┇مطور البوت ← {['..UserName_Dev..']}'
send(msg.chat_id_, msg.id_,CmdStart) 
else
send(msg.chat_id_, msg.id_,GetCmdStart) 
end 
end
end
redis:setex(bot_id..'Ban:Cmd:Start'..msg.sender_user_id_,60,true)
return false
end
if not Dev_Raider(msg) and not redis:sismember(bot_id..'User:Ban:Pv',msg.sender_user_id_) and not redis:get(bot_id..'Status:Lock:Twasl') then
send(msg.sender_user_id_,msg.id_,'📨┇تم ارسال رسالتك الى المطور ← { [saiedj20] }')    
local List_id = {Id_Dev,msg.sender_user_id_}
for k,v in pairs(List_id) do   
tdcli_function({ID="GetChat",chat_id_=v},function(arg,chat) end,nil)
end
tdcli_function({ID="ForwardMessages",chat_id_=Id_Dev,from_chat_id_= msg.sender_user_id_,message_ids_={[0]=msg.id_},disable_notification_=1,from_background_=1},function(arg,data) 
if data and data.messages_ and data.messages_[0] ~= false and data.ID ~= "Error" then
if data and data.messages_ and data.messages_[0].content_.sticker_ then
Send_Optionspv(Id_Dev,0,msg.sender_user_id_,"reply_Pv","〽┇قام بارسال الملصق")  
return false
end
end
end,nil)
end
if Dev_Raider(msg) then
if msg.reply_to_message_id_ ~= 0  then    
tdcli_function({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)},function(extra, result, success) 
if result.forward_info_.sender_user_id_ then     
UserForward = result.forward_info_.sender_user_id_    
end     
if text == 'حظر' then
Send_Optionspv(Id_Dev,msg.id_,UserForward,"reply_Pv","〽┇تم حظره من تواصل البوت")  
redis:sadd(bot_id..'User:Ban:Pv',data.id_)  
return false  
elseif text =='الغاء الحظر' then
Send_Optionspv(Id_Dev,msg.id_,UserForward,"reply_Pv","〽┇تم الغاء حظره من تواصل البوت")  
redis:srem(bot_id..'User:Ban:Pv',data.id_)  
return false  
end 
tdcli_function({ID='GetChat',chat_id_=UserForward},function(a,s) end,nil)
tdcli_function({ID="SendChatAction",chat_id_=UserForward,action_={ID="SendMessageTypingAction",progress_=100}},function(arg,Get_Status) 
if (Get_Status.code_) == (400) or (Get_Status.code_) == (5) then
Send_Optionspv(Id_Dev,msg.id_,UserForward,"reply_Pv","⚠┇قام بحظر البوت لا تستطيع ارسال له رسائل")  
return false  
end 
if text then    
send(UserForward,msg.id_,text)    
elseif msg.content_.ID == 'MessageSticker' then    
sendSticker(UserForward, msg.id_, msg.content_.sticker_.sticker_.persistent_id_)   
elseif msg.content_.ID == 'MessagePhoto' then    
sendPhoto(UserForward, msg.id_,msg.content_.photo_.sizes_[0].photo_.persistent_id_,(msg.content_.caption_ or ''))    
elseif msg.content_.ID == 'MessageAnimation' then    
sendDocument(UserForward, msg.id_, msg.content_.animation_.animation_.persistent_id_)    
elseif msg.content_.ID == 'MessageVoice' then    
sendVoice(UserForward, msg.id_, msg.content_.voice_.voice_.persistent_id_)    
end     
Send_Optionspv(Id_Dev,msg.id_,UserForward,"reply_Pv","☑┇تم ارسال رسالتك اليه بنجاح")  
end,nil)end,nil)
end
if text == 'تغير كليشه ستارت 🆕' then
redis:set(bot_id..'Set:Cmd:Start:Bots',true) 
send(msg.chat_id_, msg.id_,'〽┇ارسل الان الكليشه ليتم وضعها') 
elseif text == 'ازالة كليشه ستارت 🔗' then
redis:del(bot_id..'Set:Cmd:Start:Bot') 
send(msg.chat_id_, msg.id_,'☑┇تم حذف كليشه ستارت') 
elseif text == "تفعيل مغادرة البوت ✔" then   
redis:del(bot_id.."Status:Lock:Left"..msg.chat_id_)  
send(msg.chat_id_, msg.id_,"☑┇تم تفعيل مغادرة البوت") 
elseif text == "تعطيل مغادرة البوت ❌" then  
redis:set(bot_id.."Status:Lock:Left"..msg.chat_id_,true)   
send(msg.chat_id_, msg.id_, "☑┇تم تعطيل مغادرة البوت") 
elseif text == "تفعيل اذاعه المطورين 🔓" then  
redis:del(bot_id.."Status:Broadcasting:Bot") 
send(msg.chat_id_, msg.id_,"☑┇تم تفعيل الاذاعه \n〽┇الان يمكن للمطورين الاذاعه" ) 
elseif text == "تعطيل اذاعه المطورين 🔏" then  
redis:set(bot_id.."Status:Broadcasting:Bot",true) 
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل الاذاعه") 
elseif text == 'تفعيل الوضع الخدمي 🔖' then  
redis:del(bot_id..'Free:Bot') 
send(msg.chat_id_, msg.id_,'☑┇تم تفعيل البوت الخدمي \n⚡┇الان يمكن الجميع تفعيله') 
elseif text == 'تعطيل الوضع الخدمي 〽' then  
redis:set(bot_id..'Free:Bot',true) 
send(msg.chat_id_, msg.id_,'☑┇تم تعطيل البوت الخدمي') 
elseif text == 'تغير كليشة المطور 🆕' then
redis:set(bot_id..'GetTexting:DevRaider'..msg.chat_id_..':'..msg.sender_user_id_,true)
send(msg.chat_id_,msg.id_,'📮┇ ارسل لي الكليشه الان')
elseif text=="اذاعه خاص 👤" then 
redis:setex(bot_id.."Broadcasting:Users" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
send(msg.chat_id_, msg.id_,"🔘┇ارسل لي المنشور الان\n〽┇يمكنك ارسال -{ صوره - ملصق - متحركه - رساله }\n⚠┇لالغاء الاذاعه ارسل : الغاء") 
return false
elseif text=="اذاعه للمجموعات 👥" then 
redis:setex(bot_id.."Broadcasting:Groups" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
send(msg.chat_id_, msg.id_,"🔘┇ارسل لي المنشور الان\n〽┇يمكنك ارسال -{ صوره - ملصق - متحركه - رساله }\n⚠┇لالغاء الاذاعه ارسل : الغاء") 
return false
elseif text=="اذاعه بالتثبيت 📌" and DeveloperBot(msg) then 
redis:setex(bot_id.."Broadcasting:Groups:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
send(msg.chat_id_, msg.id_,"🔘┇ارسل لي المنشور الان\n〽┇يمكنك ارسال -{ صوره - ملصق - متحركه - رساله }\n⚠┇لالغاء الاذاعه ارسل : الغاء") 
return false
elseif text=="اذاعه بالتوجيه 👥" and DeveloperBot(msg) then 
redis:setex(bot_id.."Broadcasting:Groups:Fwd" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
send(msg.chat_id_, msg.id_,"〽┇ارسل لي التوجيه الان\n☑┇ليتم نشره في المجموعات") 
return false
elseif text=="اذاعه خاص بالتوجيه 👤" and DeveloperBot(msg) then 
redis:setex(bot_id.."Broadcasting:Users:Fwd" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
send(msg.chat_id_, msg.id_,"〽┇ارسل لي التوجيه الان\n☑┇ليتم نشره الى المشتركين") 
return false
elseif text == 'ازالة كليشة المطور 🆗' then
redis:del(bot_id..'Texting:DevRaider')
send(msg.chat_id_, msg.id_,'☑┇ تم حذف كليشه المطور')
elseif text == "تغير اسم البوت 🔄" then 
redis:setex(bot_id.."Change:Name:Bot"..msg.sender_user_id_,300,true) 
send(msg.chat_id_, msg.id_,"📫┇ ارسل لي الاسم الان ")  
return false
elseif text == ("مسح قائمه العام 💯") or text == ("مسح المحظورين عام") then
redis:del(bot_id.."Removal:User:Groups")
send(msg.chat_id_, msg.id_, "🗑┇تم مسح المحظورين عام من البوت")
elseif text == ("مسح قائمه المطورين 🚫") then
redis:del(bot_id.."Developer:Bot")
send(msg.chat_id_, msg.id_, "🗑┇ تم مسح المطورين من البوت  ")
elseif text == ("قائمه العام 📝") or text == ("المحظورين عام") then
local list = redis:smembers(bot_id.."Removal:User:Groups")
Gban = "\n📄┇قائمة المحظورين عام في البوت\n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Gban = Gban..""..k.."~ : [@"..username.."]\n"
else
Gban = Gban..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Gban = "⚠┇لا يوجد محظورين عام"
end
send(msg.chat_id_, msg.id_, Gban)
elseif text == ("قائمه المطورين 📝") then
local list = redis:smembers(bot_id.."Developer:Bot")
Sudos = "\n📄┇قائمة مطورين في البوت \n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Sudos = Sudos..""..k.."~ : [@"..username.."]\n"
else
Sudos = Sudos..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Sudos = "⚠┇لا يوجد مطورين"
end
send(msg.chat_id_, msg.id_, Sudos)
elseif text and text:match("^حظر عام @(.*)$") then
function FunctionStatus(arg, result)
if (result.id_) then
if result and result.type_ and result.type_.ID == ("ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
if tonumber(result.id_) == tonumber(bot_id) then  
send(msg.chat_id_, msg.id_, "⚠┇لا تسطيع حظر البوت عام")
return false 
end
if Dev_Raider_User(result.id_) == true then
send(msg.chat_id_, msg.id_, "⚠┇لا تستطيع حظر المطور الاساسي عام")
return false 
end
redis:sadd(bot_id.."Removal:User:Groups", result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم حظره عام من المجموعات")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^حظر عام @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^الغاء العام @(.*)$") then
function FunctionStatus(arg, result)
if (result.id_) then
Send_Options(msg,result.id_,"reply","☑┇تم الغاء حظره عام من المجموعات")  
redis:srem(bot_id.."Removal:User:Groups", result.id_)
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^الغاء العام @(.*)$") }, FunctionStatus, nil)
elseif text and text:match("^اضف مطور @(.*)$") then
function FunctionStatus(arg, result)
if (result.id_) then
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
redis:sadd(bot_id.."Developer:Bot", result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم ترقيته مطور في البوت")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^اضف مطور @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^حذف مطور @(.*)$") then
function FunctionStatus(arg, result)
if (result.id_) then
redis:srem(bot_id.."Developer:Bot", result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم تنزيله من المطورين")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^حذف مطور @(.*)$")}, FunctionStatus, nil)
elseif text =='احصائيات البوت 📑' then 
send(msg.chat_id_, msg.id_,'*📋┇عدد احصائيات البوت الكامله \n━━━━━━━━━━━━━\n📮┇عدد المجموعات : '..(redis:scard(bot_id..'ChekBotAdd') or 0)..'\n👤┇عدد المشتركين : '..(redis:scard(bot_id..'Num:User:Pv') or 0)..'*')
elseif text and text:match("^تعين عدد الاعضاء (%d+)$") then
redis:set(bot_id..'Num:Add:Bot',text:match("تعين عدد الاعضاء (%d+)$") ) 
send(msg.chat_id_, msg.id_,'*☑┇ تم تعيين عدد اعضاء تفعيل البوت اكثر من : '..text:match("تعين عدد الاعضاء (%d+)$")..' عضو *')
elseif text == 'حذف كليشه المطور' then
redis:del(bot_id..'Texting:DevRaider')
send(msg.chat_id_, msg.id_,'☑┇ تم حذف كليشه المطور')
elseif text == "تنظيف المشتركين 🚯" then
local pv = redis:smembers(bot_id..'Num:User:Pv')  
local sendok = 0
for i = 1, #pv do
tdcli_function({ID='GetChat',chat_id_ = pv[i]},function(arg,dataq)
tdcli_function ({ ID = "SendChatAction",chat_id_ = pv[i], action_ = {  ID = "SendMessageTypingAction", progress_ = 100} },function(arg,data) 
if data.ID and data.ID == "Ok"  then
else
redis:srem(bot_id..'Num:User:Pv',pv[i])  
sendok = sendok + 1
end
if #pv == i then 
if sendok == 0 then
send(msg.chat_id_, msg.id_,'👤┇لا يوجد مشتركين وهميين')   
else
local ok = #pv - sendok
send(msg.chat_id_, msg.id_,'*👥┇عدد المشتركين الان ←{ '..#pv..' }\n⚠┇تم العثور على ←{ '..sendok..' } مشترك قام بحظر البوت\n☑┇اصبح عدد المشتركين الان ←{ '..ok..' } مشترك *')   
end
end
end,nil)
end,nil)
end
return false
elseif text == "تنظيف المجموعات 🔄" then
local group = redis:smembers(bot_id..'ChekBotAdd')  
local w = 0
local q = 0
for i = 1, #group do
tdcli_function({ID='GetChat',chat_id_ = group[i]
},function(arg,data)
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusMember" then
redis:srem(bot_id..'ChekBotAdd',group[i])  
w = w + 1
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusLeft" then
redis:srem(bot_id..'ChekBotAdd',group[i])  
q = q + 1
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusKicked" then
redis:srem(bot_id..'ChekBotAdd',group[i])  
q = q + 1
end
if data and data.code_ and data.code_ == 400 then
redis:srem(bot_id..'ChekBotAdd',group[i])  
w = w + 1
end
if #group == i then 
if (w + q) == 0 then
send(msg.chat_id_, msg.id_,'👥┇لا توجد مجموعات وهميه ')   
else
local saied = (w + q)
local sendok = #group - saied
if q == 0 then
saied = ''
else
saied = '\n🚯┇ تم ازالة ~ '..q..' مجموعات من البوت'
end
if w == 0 then
raider = ''
else
raider = '\n🚯┇ تم ازالة ~'..w..' مجموعه لان البوت عضو'
end
send(msg.chat_id_, msg.id_,'*👥┇ عدد المجموعات الان ← { '..#group..' } مجموعه '..raider..''..saied..'\n🔘┇اصبح عدد المجموعات الان ← { '..sendok..' } مجموعات*\n')   
end
end
end,nil)
end
return false
elseif text == 'جلب نسخة خزن الكروبات 📦' then
local Groups = redis:smembers(bot_id..'ChekBotAdd')  
local Get_Json = '{"IdBot": '..bot_id..',"Groups":{'  
for k,v in pairs(Groups) do   
local President = redis:smembers(bot_id.."President:Group"..v)
local Constructor = redis:smembers(bot_id.."Constructor:Group"..v)
local Manager = redis:smembers(bot_id.."Manager:Group"..v)
local Admin = redis:smembers(bot_id.."Admin:Group"..v)
local Vips = redis:smembers(bot_id.."Vip:Group"..v)
local LinkGroup = redis:get(bot_id.."Status:link:set:Group"..v) 
local WelcomeGroup = redis:get(bot_id.."Get:Welcome:Group"..v) or ''
local Status_Dev = redis:get(bot_id.."Developer:Bot:Reply"..v) 
local Status_Prt = redis:get(bot_id.."President:Group:Reply"..v) 
local Status_Cto = redis:get(bot_id.."Constructor:Group:Reply"..v) 
local Status_Own = redis:get(bot_id.."Manager:Group:Reply"..v) 
local Status_Md = redis:get(bot_id.."Admin:Group:Reply"..v) 
local Status_Vip = redis:get(bot_id.."Vip:Group:Reply"..v) 
local Status_Mem = redis:get(bot_id.."Mempar:Group:Reply"..v) 
if k == 1 then
Get_Json = Get_Json..'"'..v..'":{'
else
Get_Json = Get_Json..',"'..v..'":{'
end
if #President ~= 0 then 
Get_Json = Get_Json..'"President":['
for k,v in pairs(President) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..'],'
end
if #Constructor ~= 0 then
Get_Json = Get_Json..'"Constructor":['
for k,v in pairs(Constructor) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..'],'
end
if #Manager ~= 0 then
Get_Json = Get_Json..'"Manager":['
for k,v in pairs(Manager) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..'],'
end
if #Admin ~= 0 then
Get_Json = Get_Json..'"Admin":['
for k,v in pairs(Admin) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..'],'
end
if #Vips ~= 0 then
t = t..'"Vips":['
for k,v in pairs(Vips) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..'],'
end
if Status_Dev then
Get_Json = Get_Json..'"Status_Dev":"'..Status_Dev..'",'
end
if Status_Prt then
Get_Json = Get_Json..'"Status_Prt":"'..Status_Prt..'",'
end
if Status_Cto then
Get_Json = Get_Json..'"Status_Cto":"'..Status_Cto..'",'
end
if Status_Own then
Get_Json = Get_Json..'"Status_Own":"'..Status_Own..'",'
end
if Status_Md then
Get_Json = Get_Json..'"Status_Md":"'..Status_Md..'",'
end
if Status_Vip then
Get_Json = Get_Json..'"Status_Vip":"'..Status_Vip..'",'
end
if Status_Mem then
Get_Json = Get_Json..'"Status_Mem":"'..Status_Mem..'",'
end
if LinkGroup then
Get_Json = Get_Json..'"LinkGroup":"'..LinkGroup..'",'
end
Get_Json = Get_Json..'"WelcomeGroup":"'..WelcomeGroup..'"}'
end
Get_Json = Get_Json..'}}'
local File = io.open('./lib/'..bot_id..'.json', "w")
File:write(Get_Json)
File:close()
sendDocument(msg.chat_id_, msg.id_,'./lib/'..bot_id..'.json', '\n☑┇تم جلب نسخه خاصه بالكروبات\n〽┇يحتوي الملف على {'..#Groups..'} مجموعه')
elseif text == 'تفعيل تواصل البوت 🔔' then  
redis:del(bot_id..'Status:Lock:Twasl') 
send(msg.chat_id_, msg.id_,'🔘┇ تم تفعيل التواصل ') 
elseif text == 'تعطيل تواصل البوت 🔕' then  
redis:set(bot_id..'Status:Lock:Twasl',true) 
send(msg.chat_id_, msg.id_,'🔘┇ تم تعطيل التواصل ') 
end
end 
end
if TypeForChat == ("ForSuppur") then
if text and text:match('^'..Name_Bot..' ') then
data.message_.content_.text_ = data.message_.content_.text_:gsub('^'..Name_Bot..' ','')
end
if text then
local NewCmmd = redis:get(bot_id.."Get:Reides:Commands:Group"..msg.chat_id_..":"..text)
if NewCmmd then
text = (NewCmmd or text)
end;end
if text ==  ""..Name_Bot..' شنو رئيك بهاذا' and tonumber(msg.reply_to_message_id_) > 0 and not redis:get(bot_id.."Status:Fun:Bots"..msg.chat_id_) then     
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, function(Arg,Data) 
local Text_Fun = {'لوكي وزاحف من ساع زحفلي وحضرته 😒','خوش ولد و ورده مال الله 🙄','يلعب ع البنات 🙄', 'ولد زايعته الكاع 😶🙊','صاك يخبل ومعضل ','محلو وشواربه جنها مكناسه 😂🤷🏼‍♀️','اموت عليه 🌝','هوه غير الحب مال اني ❤️','مو خوش ولد صراحه ☹️','ادبسز وميحترم البنات  ', 'فد واحد قذر 🙄😒','ماطيقه كل ما اكمشه ريحته جنها بخاخ بف باف مال حشرات 😂🤷‍♀️','مو خوش ولد 🤓' } 
send(msg.chat_id_, Data.id_,''..Text_Fun[math.random(#Text_Fun)]..'')   
end,nil)
return false
elseif text == ""..Name_Bot..' شنو رئيك بهاي' and tonumber(msg.reply_to_message_id_) > 0 and not redis:get(bot_id.."Status:Fun:Bots"..msg.chat_id_) then    
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)},function(Arg, Data) 
local Text_Fun = {'الكبد مال اني هيه ','ختولي ماحبها ','خانتني ويه صديقي 😔','بس لو الكفها اله اعضها 💔','خوش بنيه بس عده مكسرات زايده وناقصه منا ومنا وهيه تدري بنفسها 😒','جذابه ومنافقه سوتلي مشكله ويه الحب مالتي ','ئووووووووف اموت ع ربها ','ديرو بالكم منها تلعب ع الولد 😶 ضحكت ع واحد قطته ايفون 7 ','صديقتي وختي وروحي وحياتي ','فد وحده منحرفه 😥','ساكنه بالعلاوي ونته حدد بعد لسانها لسان دلاله 🙄🤐','ام سحوره سحرت اخويا وعلكته 6 سنوات 🤕','ماحبها 🙁','بله هاي جهره تسئل عليها ؟ ','بربك ئنته والله فارغ وبطران وماعدك شي تسوي جاي تسئل ع بنات العالم ولي يله 🏼','ياخي بنيه حبوبه بس لبعرك معمي عليها تشرب هواي 😹' } 
send(msg.chat_id_,Data.id_,''..Text_Fun[math.random(#Text_Fun)]..'') 
end,nil)
return false
end    
if text == 'رفع النسخه الاحتياطيه' and tonumber(msg.reply_to_message_id_) > 0 and Dev_Raider(msg) then   
tdcli_function({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},function(Arg, Data)   
if Data.content_.document_ then 
SetFile_Groups(msg,msg.chat_id_,Data.content_.document_.document_.persistent_id_ ,Data.content_.document_.file_name_)
end;end,nil)
end

if text == 'جلب نسخه احتياطيه' and Dev_Raider(msg) or text == 'جلب نسخه الكروبات' and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
local Groups = redis:smembers(bot_id..'ChekBotAdd')  
local Get_Json = '{"IdBot": '..bot_id..',"Groups":{'  
for k,v in pairs(Groups) do   
local President = redis:smembers(bot_id.."President:Group"..v)
local Constructor = redis:smembers(bot_id.."Constructor:Group"..v)
local Manager = redis:smembers(bot_id.."Manager:Group"..v)
local Admin = redis:smembers(bot_id.."Admin:Group"..v)
local Vips = redis:smembers(bot_id.."Vip:Group"..v)
local LinkGroup = redis:get(bot_id.."Status:link:set:Group"..v) 
local WelcomeGroup = redis:get(bot_id.."Get:Welcome:Group"..v) or ''
local Status_Dev = redis:get(bot_id.."Developer:Bot:Reply"..v) 
local Status_Prt = redis:get(bot_id.."President:Group:Reply"..v) 
local Status_Cto = redis:get(bot_id.."Constructor:Group:Reply"..v) 
local Status_Own = redis:get(bot_id.."Manager:Group:Reply"..v) 
local Status_Md = redis:get(bot_id.."Admin:Group:Reply"..v) 
local Status_Vip = redis:get(bot_id.."Vip:Group:Reply"..v) 
local Status_Mem = redis:get(bot_id.."Mempar:Group:Reply"..v) 
if k == 1 then
Get_Json = Get_Json..'"'..v..'":{'
else
Get_Json = Get_Json..',"'..v..'":{'
end
if #President ~= 0 then 
Get_Json = Get_Json..'"President":['
for k,v in pairs(President) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..'],'
end
if #Constructor ~= 0 then
Get_Json = Get_Json..'"Constructor":['
for k,v in pairs(Constructor) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..'],'
end
if #Manager ~= 0 then
Get_Json = Get_Json..'"Manager":['
for k,v in pairs(Manager) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..'],'
end
if #Admin ~= 0 then
Get_Json = Get_Json..'"Admin":['
for k,v in pairs(Admin) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..'],'
end
if #Vips ~= 0 then
t = t..'"Vips":['
for k,v in pairs(Vips) do
if k == 1 then
Get_Json = Get_Json..'"'..v..'"'
else
Get_Json = Get_Json..',"'..v..'"'
end
end   
Get_Json = Get_Json..'],'
end
if Status_Dev then
Get_Json = Get_Json..'"Status_Dev":"'..Status_Dev..'",'
end
if Status_Prt then
Get_Json = Get_Json..'"Status_Prt":"'..Status_Prt..'",'
end
if Status_Cto then
Get_Json = Get_Json..'"Status_Cto":"'..Status_Cto..'",'
end
if Status_Own then
Get_Json = Get_Json..'"Status_Own":"'..Status_Own..'",'
end
if Status_Md then
Get_Json = Get_Json..'"Status_Md":"'..Status_Md..'",'
end
if Status_Vip then
Get_Json = Get_Json..'"Status_Vip":"'..Status_Vip..'",'
end
if Status_Mem then
Get_Json = Get_Json..'"Status_Mem":"'..Status_Mem..'",'
end
if LinkGroup then
Get_Json = Get_Json..'"LinkGroup":"'..LinkGroup..'",'
end
Get_Json = Get_Json..'"WelcomeGroup":"'..WelcomeGroup..'"}'
end
Get_Json = Get_Json..'}}'
local File = io.open('./lib/'..bot_id..'.json', "w")
File:write(Get_Json)
File:close()
sendDocument(msg.chat_id_, msg.id_,'./lib/'..bot_id..'.json', '\n☑┇تم جلب نسخه خاصه بالكروبات\n〽┇يحتوي الملف على {'..#Groups..'} مجموعه')
end
if text == ("مسح قائمه العام") and Dev_Raider(msg) or text == ("مسح المحظورين عام") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:del(bot_id.."Removal:User:Groups")
send(msg.chat_id_, msg.id_, "🗑┇تم مسح المحظورين عام من البوت")
elseif text == ("مسح المطورين") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:del(bot_id.."Developer:Bot")
send(msg.chat_id_, msg.id_, "🗑┇ تم مسح المطورين من البوت  ")
elseif text == ("مسح المنشئين الاساسين") and DeveloperBot(msg) or text == "مسح الاساسين" and DeveloperBot(msg)  then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n??┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:del(bot_id.."President:Group"..msg.chat_id_)
send(msg.chat_id_, msg.id_, "🗑┇ تم مسح المنشئين الاساسيين في المجموعه")
elseif text == ("مسح المنشئين الاساسين") or text == "مسح الاساسين" then
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,da) 
if da.status_.ID == "ChatMemberStatusCreator" then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:del(bot_id.."President:Group"..msg.chat_id_)
send(msg.chat_id_, msg.id_, "🗑┇ تم مسح المنشئين الاساسيين في المجموعه")
end
end,nil)
elseif text == ("مسح المنشئين") and PresidentGroup(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:del(bot_id.."Constructor:Group"..msg.chat_id_)
send(msg.chat_id_, msg.id_, "🗑┇ تم مسح المنشئين في المجموعه")
elseif text == ("مسح المدراء") and Constructor(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:del(bot_id.."Manager:Group"..msg.chat_id_)
send(msg.chat_id_, msg.id_, "🗑┇ تم مسح المدراء في المجموعه")
elseif text == ("مسح الادمنيه") and Owner(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:del(bot_id.."Admin:Group"..msg.chat_id_)
send(msg.chat_id_, msg.id_, "🗑┇ تم مسح الادمنيه في المجموعه")
elseif text == ("مسح المميزين") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:del(bot_id.."Vip:Group"..msg.chat_id_)
send(msg.chat_id_, msg.id_, "🗑┇ تم مسح المميزين في المجموعه")
elseif text == ("مسح المكتومين") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:del(bot_id.."Silence:User:Group"..msg.chat_id_)
send(msg.chat_id_, msg.id_, "🗑┇ تم مسح المكتومين في المجموعه")
elseif text == ("مسح المحظورين") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:del(bot_id.."Removal:User:Group"..msg.chat_id_)
send(msg.chat_id_, msg.id_, "🗑┇تم مسح المحظورين في المجموعه")
elseif text == "حذف الاوامر المضافه" and Constructor(msg) or text == "مسح الاوامر المضافه" and Constructor(msg) then 
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
local list = redis:smembers(bot_id.."Command:List:Group"..msg.chat_id_)
for k,v in pairs(list) do
redis:del(bot_id.."Get:Reides:Commands:Group"..msg.chat_id_..":"..v)
redis:del(bot_id.."Command:List:Group"..msg.chat_id_)
end
send(msg.chat_id_, msg.id_,"☑┇تم مسح جميع الاوامر التي تم اضافتها")  
elseif text == "مسح الصلاحيات" and Constructor(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
local list = redis:smembers(bot_id.."Validitys:Group"..msg.chat_id_)
for k,v in pairs(list) do;redis:del(bot_id.."Add:Validity:Group:Rt"..v..msg.chat_id_);redis:del(bot_id.."Validitys:Group"..msg.chat_id_);end
send(msg.chat_id_, msg.id_,"☑┇تم مسح صلاحيات المجموعه")
elseif text == ("قائمه العام") and Dev_Raider(msg) or text == ("المحظورين عام") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
local list = redis:smembers(bot_id.."Removal:User:Groups")
Gban = "\n📄┇قائمة المحظورين عام في البوت\n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Gban = Gban..""..k.."~ : [@"..username.."]\n"
else
Gban = Gban..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Gban = "⚠┇لا يوجد محظورين عام"
end
send(msg.chat_id_, msg.id_, Gban)
elseif text == ("المطورين") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
local list = redis:smembers(bot_id.."Developer:Bot")
Sudos = "\n📄┇قائمة مطورين في البوت \n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Sudos = Sudos..""..k.."~ : [@"..username.."]\n"
else
Sudos = Sudos..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Sudos = "⚠┇لا يوجد مطورين"
end
send(msg.chat_id_, msg.id_, Sudos)
elseif text == "المنشئين الاساسين" and DeveloperBot(msg) or text == "الاساسين" and DeveloperBot(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
local list = redis:smembers(bot_id.."President:Group"..msg.chat_id_)
Asase = "\n📄┇قائمة المنشئين الاساسين في المجموعه\n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Asase = Asase..""..k.."~ : [@"..username.."]\n"
else
Asase = Asase..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Asase = "⚠┇لا يوجد منشئين اساسيين"
end
send(msg.chat_id_, msg.id_, Asase)
elseif text == "المنشئين الاساسين" or text == "الاساسين" then
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,da) 
if da.status_.ID == "ChatMemberStatusCreator" then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
local list = redis:smembers(bot_id.."President:Group"..msg.chat_id_)
Asase = "\n📄┇قائمة المنشئين الاساسين في المجموعه\n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Asase = Asase..""..k.."~ : [@"..username.."]\n"
else
Asase = Asase..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Asase = "⚠┇لا يوجد منشئين اساسيين"
end
send(msg.chat_id_, msg.id_, Asase)
end
end,nil)
elseif text == ("المنشئين") and PresidentGroup(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
local list = redis:smembers(bot_id.."Constructor:Group"..msg.chat_id_)
Monsh = "\n📄┇قائمة منشئين المجموعه \n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Monsh = Monsh..""..k.."~ : [@"..username.."]\n"
else
Monsh = Monsh..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Monsh = "⚠┇لا يوجد منشئين"
end
send(msg.chat_id_, msg.id_, Monsh)
elseif text == ("المدراء") and Constructor(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
local list = redis:smembers(bot_id.."Manager:Group"..msg.chat_id_)
Moder = "\n📄┇قائمة المدراء في المجموعه \n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Moder = Moder..""..k.."~ : [@"..username.."]\n"
else
Moder = Moder..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Moder = "⚠┇لا يوجد مدراء"
end
send(msg.chat_id_, msg.id_, Moder)
elseif text == ("الادمنيه") and Owner(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
local list = redis:smembers(bot_id.."Admin:Group"..msg.chat_id_)
Admin = "\n📄┇قائمة الادمنيه في المجموعه\n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Admin = Admin..""..k.."~ : [@"..username.."]\n"
else
Admin = Admin..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Admin = "⚠┇لا يوجد ادمنيه"
end
send(msg.chat_id_, msg.id_, Admin)
elseif text == ("المميزين") and Admin(msg) then
local list = redis:smembers(bot_id.."Vip:Group"..msg.chat_id_)
Vips = "\n📄┇قائمة المميزين في المجموعه \n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Vips = Vips..""..k.."~ : [@"..username.."]\n"
else
Vips = Vips..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Vips = "⚠┇لا يوجد مميزين"
end
send(msg.chat_id_, msg.id_, Vips)
elseif text == ("المكتومين") and Admin(msg) then
local list = redis:smembers(bot_id.."Silence:User:Group"..msg.chat_id_)
Muted = "\n📄┇قائمة المكتومين في المجموعه\n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Muted = Muted..""..k.."~ : [@"..username.."]\n"
else
Muted = Muted..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Muted = "⚠┇لا يوجد مكتومين"
end
send(msg.chat_id_, msg.id_, Muted)
elseif text == ("المحظورين") and Admin(msg) then
local list = redis:smembers(bot_id.."Removal:User:Group"..msg.chat_id_)
Bans = "\n📄┇قائمة المحظورين في المجموعه \n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
local username = redis:get(bot_id.."Save:Username" .. v)
if username then
Bans = Bans..""..k.."~ : [@"..username.."]\n"
else
Bans = Bans..""..k.."~ : `"..v.."`\n"
end
end
if #list == 0 then
Bans = "⚠┇لا يوجد محظورين"
end
send(msg.chat_id_, msg.id_, Bans)
elseif text == "الصلاحيات" and Admin(msg) then 
local list = redis:smembers(bot_id.."Validitys:Group"..msg.chat_id_)
if #list == 0 then
send(msg.chat_id_, msg.id_,"⚠┇لا توجد صلاحيات مضافه هنا")
return false
end
Validity = "\n⛔┇قائمة الصلاحيات المضافه \n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
var = redis:get(bot_id.."Add:Validity:Group:Rt"..v..msg.chat_id_)
if var then
Validity = Validity..""..k.."- "..v.." ~ ("..var..")\n"
else
Validity = Validity..""..k.."- "..v.."\n"
end
end
send(msg.chat_id_, msg.id_,Validity)
elseif text == "الاوامر المضافه" and Constructor(msg) then
local list = redis:smembers(bot_id.."Command:List:Group"..msg.chat_id_.."")
Command = "🔰┇قائمه الاوامر المضافه  \n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
Commands = redis:get(bot_id.."Get:Reides:Commands:Group"..msg.chat_id_..":"..v)
if Commands then 
Command = Command..""..k..": ("..v..") ← {"..Commands.."}\n"
else
Command = Command..""..k..": ("..v..") \n"
end
end
if #list == 0 then
Command = "🔰┇لا توجد اوامر اضافيه"
end
send(msg.chat_id_, msg.id_,"["..Command.."]")
elseif text == "تاك للكل" and Admin(msg) then
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""), offset_ = 0,limit_ = 200},function(ta,saied)
local t = "\n⛔┇ قائمة الاعضاء \n━━━━━━━━━━━━━\n"
x = 0
local list = saied.members_
for k, v in pairs(list) do
x = x + 1
if redis:get(bot_id.."Save:Username"..v.user_id_) then
t = t..""..x.." : [@"..redis:get(bot_id.."Save:Username"..v.user_id_).."]\n"
else
t = t..""..x.." : "..v.user_id_.."\n"
end
end
send(msg.chat_id_,msg.id_,t)
end,nil)
elseif text == ("حظر عام") and tonumber(msg.reply_to_message_id_) ~= 0 and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if tonumber(result.sender_user_id_) == tonumber(bot_id) then  
send(msg.chat_id_, msg.id_, "⚠┇لا تسطيع حظر البوت عام")
return false 
end
if Dev_Raider_User(result.sender_user_id_) == true then
send(msg.chat_id_, msg.id_, "⚠┇لا تستطيع حظر المطور الاساسي عام")
return false 
end
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم حظره عام من المجموعات")  
redis:sadd(bot_id.."Removal:User:Groups", result.sender_user_id_)
Kick_Group(result.chat_id_, result.sender_user_id_)
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("الغاء العام") and tonumber(msg.reply_to_message_id_) ~= 0 and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
redis:srem(bot_id.."Removal:User:Groups", result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم الغاء حظره عام من المجموعات")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("اضف مطور") and tonumber(msg.reply_to_message_id_) ~= 0 and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
redis:sadd(bot_id.."Developer:Bot", result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم ترقيته مطور في البوت")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("حذف مطور") and tonumber(msg.reply_to_message_id_) ~= 0 and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
redis:srem(bot_id.."Developer:Bot", result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم تنزيله من المطورين")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("رفع منشئ اساسي") and tonumber(msg.reply_to_message_id_) ~= 0 and DeveloperBot(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
redis:sadd(bot_id.."President:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم ترقيته منشئ اساسي")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("تنزيل منشئ اساسي") and tonumber(msg.reply_to_message_id_) ~= 0 and DeveloperBot(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
redis:srem(bot_id.."President:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم تنزيله من المنشئين")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("رفع منشئ اساسي") and tonumber(msg.reply_to_message_id_) ~= 0 then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,da) 
if da.status_.ID == "ChatMemberStatusCreator" then
function FunctionStatus(arg, result)
redis:sadd(bot_id.."President:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم ترقيته منشئ اساسي")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
end
end,nil)
elseif text == ("تنزيل منشئ اساسي") and tonumber(msg.reply_to_message_id_) ~= 0 then 
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,da) 
if da.status_.ID == "ChatMemberStatusCreator" then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
redis:srem(bot_id.."President:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم تنزيله من المنشئين")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
end
end,nil)
elseif text == "رفع منشئ" and tonumber(msg.reply_to_message_id_) ~= 0 and PresidentGroup(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
redis:sadd(bot_id.."Constructor:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم ترقيته منشئ في المجموعه")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text and text:match("^تنزيل منشئ$") and tonumber(msg.reply_to_message_id_) ~= 0 and PresidentGroup(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
redis:srem(bot_id.."Constructor:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم تنزيله من المنشئين")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("رفع مدير") and tonumber(msg.reply_to_message_id_) ~= 0 and Constructor(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
redis:sadd(bot_id.."Manager:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم ترقيته مدير المجموعه")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("تنزيل مدير") and tonumber(msg.reply_to_message_id_) ~= 0 and Constructor(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
redis:srem(bot_id.."Manager:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم تنزيله من المدراء")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("رفع ادمن") and tonumber(msg.reply_to_message_id_) ~= 0 and Owner(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
if not Constructor(msg) and redis:get(bot_id.."Status:Cheking:Seted"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✖┇لا تستطيع رفع احد وذالك لان تم تعطيل الرفع من قبل المنشئين')
return false
end
function FunctionStatus(arg, result)
redis:sadd(bot_id.."Admin:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم ترقيته ادمن للمجموعه")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("تنزيل ادمن") and tonumber(msg.reply_to_message_id_) ~= 0 and Owner(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
redis:srem(bot_id.."Admin:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم تنزيله من ادمنيه المجموعه")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("رفع مميز") and tonumber(msg.reply_to_message_id_) ~= 0 and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
if not Constructor(msg) and redis:get(bot_id.."Status:Cheking:Seted"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✖┇لا تستطيع رفع احد وذالك لان تم تعطيل الرفع من قبل المنشئين')
return false
end
function FunctionStatus(arg, result)
redis:sadd(bot_id.."Vip:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم ترقيته مميز للمجموعه")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("تنزيل مميز") and tonumber(msg.reply_to_message_id_) ~= 0 and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
redis:srem(bot_id.."Vip:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم تنزيله من المميزين")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("حظر") and msg.reply_to_message_id_ ~= 0 and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
if not Constructor(msg) and redis:get(bot_id.."Status:Lock:Ban:Group"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'☑┇لقد تم تعطيل الحظر و الطرد من قبل المنشئين')
return false
end
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
function FunctionStatus(arg, result)
if Rank_Checking(result.sender_user_id_, msg.chat_id_) == true then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(result.sender_user_id_,msg.chat_id_).." ")
else
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.sender_user_id_, status_ = { ID = "ChatMemberStatusKicked" },},function(arg,data) 
if (data and data.code_ and data.code_ == 400 and data.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_, msg.id_,"⚠┇لا توجد لدي صلاحية حظر المستخدمين") 
return false  
end
redis:sadd(bot_id.."Removal:User:Group"..msg.chat_id_, result.sender_user_id_)
Kick_Group(result.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم حظره من المجموعه")  
end,nil)   
end
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("الغاء حظر") and tonumber(msg.reply_to_message_id_) ~= 0 and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if tonumber(result.sender_user_id_) == tonumber(bot_id) then
send(msg.chat_id_, msg.id_, "☑️┇لا يمكنك عمل هاذا الامر على البوت") 
return false 
end
redis:srem(bot_id.."Removal:User:Group"..msg.chat_id_, result.sender_user_id_)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.sender_user_id_, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم الغاء حظره من هنا")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("كتم") and msg.reply_to_message_id_ ~= 0 and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
function FunctionStatus(arg, result)
if Rank_Checking(result.sender_user_id_, msg.chat_id_) == true then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(result.sender_user_id_,msg.chat_id_).."")
return false 
end     
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم كتمه من هنا")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("الغاء كتم") and tonumber(msg.reply_to_message_id_) ~= 0 and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
redis:srem(bot_id.."Silence:User:Group"..msg.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم الغاء كتمه من هنا")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text == ("الغاء تقيد") and tonumber(msg.reply_to_message_id_) ~= 0 and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
https.request("https://api.telegram.org/bot" .. token .. "/restrictChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" .. result.sender_user_id_ .. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم الغاء تقييده")  
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text and text:match("^حظر عام @(.*)$") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if (result.id_) then
if result and result.type_ and result.type_.ID == ("ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
if tonumber(result.id_) == tonumber(bot_id) then  
send(msg.chat_id_, msg.id_, "⚠┇لا تسطيع حظر البوت عام")
return false 
end
if Dev_Raider_User(result.id_) == true then
send(msg.chat_id_, msg.id_, "⚠┇لا تستطيع حظر المطور الاساسي عام")
return false 
end
redis:sadd(bot_id.."Removal:User:Groups", result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم حظره عام من المجموعات")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^حظر عام @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^الغاء العام @(.*)$") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if (result.id_) then
Send_Options(msg,result.id_,"reply","☑┇تم الغاء حظره عام من المجموعات")  
redis:srem(bot_id.."Removal:User:Groups", result.id_)
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^الغاء العام @(.*)$") }, FunctionStatus, nil)
elseif text and text:match("^اضف مطور @(.*)$") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if (result.id_) then
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
redis:sadd(bot_id.."Developer:Bot", result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم ترقيته مطور في البوت")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^اضف مطور @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^حذف مطور @(.*)$") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if (result.id_) then
redis:srem(bot_id.."Developer:Bot", result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم تنزيله من المطورين")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^حذف مطور @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^رفع منشئ اساسي @(.*)$") and DeveloperBot(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
if (result.id_) then
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
redis:sadd(bot_id.."President:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم ترقيته منشئ اساسي")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^رفع منشئ اساسي @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^تنزيل منشئ اساسي @(.*)$") and DeveloperBot(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
if (result.id_) then
redis:srem(bot_id.."President:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم تنزيله من المنشئين")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^تنزيل منشئ اساسي @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^رفع منشئ اساسي @(.*)$") then 
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,da) 
if da.status_.ID == "ChatMemberStatusCreator" then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if (result.id_) then
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
redis:sadd(bot_id.."President:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم ترقيته منشئ اساسي")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^رفع منشئ اساسي @(.*)$")}, FunctionStatus, nil)
return false
end
end,nil)
elseif text and text:match("^تنزيل منشئ اساسي @(.*)$") then 
tdcli_function ({ID = "GetChatMember",chat_id_ = msg.chat_id_,user_id_ = msg.sender_user_id_},function(arg,da) 
if da.status_.ID == "ChatMemberStatusCreator" then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if (result.id_) then
redis:srem(bot_id.."President:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم تنزيله من المنشئين")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^تنزيل منشئ اساسي @(.*)$")}, FunctionStatus, nil)
return false
end
end,nil)
elseif text and text:match("^رفع منشئ @(.*)$") and PresidentGroup(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
if (result.id_) then
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
redis:sadd(bot_id.."Constructor:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم ترقيته منشئ في المجموعه")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^رفع منشئ @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^تنزيل منشئ @(.*)$") and PresidentGroup(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
if (result.id_) then
redis:srem(bot_id.."Constructor:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم تنزيله من المنشئين")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^تنزيل منشئ @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^رفع مدير @(.*)$") and Constructor(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
if (result.id_) then
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
redis:sadd(bot_id.."Manager:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم ترقيته مدير المجموعه")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^رفع مدير @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^تنزيل مدير @(.*)$") and Constructor(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
if (result.id_) then
redis:srem(bot_id.."Manager:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم تنزيله من المدراء")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^تنزيل مدير @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^رفع ادمن @(.*)$") and Owner(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
if not Constructor(msg) and redis:get(bot_id.."Status:Cheking:Seted"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✖┇لا تستطيع رفع احد وذالك لان تم تعطيل الرفع من قبل المنشئين')
return false
end
function FunctionStatus(arg, result)
if (result.id_) then
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
redis:sadd(bot_id.."Admin:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم ترقيته ادمن للمجموعه")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^رفع ادمن @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^تنزيل ادمن @(.*)$") and Owner(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
if (result.id_) then
redis:srem(bot_id.."Admin:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم تنزيله من ادمنيه المجموعه")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^تنزيل ادمن @(.*)$") }, FunctionStatus, nil)
elseif text and text:match("^رفع مميز @(.*)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
if not Constructor(msg) and redis:get(bot_id.."Status:Cheking:Seted"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✖┇لا تستطيع رفع احد وذالك لان تم تعطيل الرفع من قبل المنشئين')
return false
end
function FunctionStatus(arg, result)
if (result.id_) then
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
redis:sadd(bot_id.."Vip:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم ترقيته مميز للمجموعه")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^رفع مميز @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^تنزيل مميز @(.*)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
function FunctionStatus(arg, result)
if (result.id_) then
redis:srem(bot_id.."Vip:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم تنزيله من المميزين")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^تنزيل مميز @(.*)$") }, FunctionStatus, nil)
elseif text and text:match("رفع (.*)") and tonumber(msg.reply_to_message_id_) > 0 and Admin(msg) then 
if redis:sismember(bot_id.."Validitys:Group"..msg.chat_id_,text:match("رفع (.*)")) then
function Status_reply(extra, result, success)   
local statusrt = redis:get(bot_id.."Add:Validity:Group:Rt"..text:match("رفع (.*)")..msg.chat_id_)
if statusrt == "مميز" and Admin(msg) then
redis:set(bot_id.."Add:Validity:Users"..msg.chat_id_..result.sender_user_id_,RTPA) 
redis:sadd(bot_id.."Vip:Group"..msg.chat_id_,result.sender_user_id_)  
elseif statusrt == "ادمن" and Owner(msg) then 
redis:set(bot_id.."Add:Validity:Users"..msg.chat_id_..result.sender_user_id_,RTPA)
redis:sadd(bot_id.."Admin:Group"..msg.chat_id_,result.sender_user_id_)  
elseif statusrt == "مدير" and Constructor(msg) then
redis:set(bot_id.."Add:Validity:Users"..msg.chat_id_..result.sender_user_id_,RTPA)  
redis:sadd(bot_id.."Manager:Group"..msg.chat_id_,result.sender_user_id_)  
elseif statusrt == "عضو" and Admin(msg) then
end
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم ترقيته : "..text:match("رفع (.*)").."")  
end   
tdcli_function ({ ID = "GetMessage", chat_id_ = msg.chat_id_, message_id_ = tonumber(msg.reply_to_message_id_) }, Status_reply, nil)
end
elseif text and text:match("تنزيل (.*)") and tonumber(msg.reply_to_message_id_) > 0 and Admin(msg) then 
if redis:sismember(bot_id.."Validitys:Group"..msg.chat_id_,text:match("تنزيل (.*)")) then
function Status_reply(extra, result, success)   
local statusrt = redis:get(bot_id.."Add:Validity:Group:Rt"..text:match("تنزيل (.*)")..msg.chat_id_)
if statusrt == "مميز" and Admin(msg) then
redis:srem(bot_id.."Vip:Group"..msg.chat_id_,result.sender_user_id_)  
redis:del(bot_id.."Add:Validity:Users"..msg.chat_id_..result.sender_user_id_)
elseif statusrt == "ادمن" and Owner(msg) then 
redis:srem(bot_id.."Admin:Group"..msg.chat_id_,result.sender_user_id_) 
redis:del(bot_id.."Add:Validity:Users"..msg.chat_id_..result.sender_user_id_)
elseif statusrt == "مدير" and Constructor(msg) then
redis:srem(bot_id.."Manager:Group"..msg.chat_id_,result.sender_user_id_)  
redis:del(bot_id.."Add:Validity:Users"..msg.chat_id_..result.sender_user_id_)
elseif statusrt == "عضو" and Admin(msg) then
end
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم تنزيله : "..text:match("تنزيل (.*)").."")  
end   
tdcli_function ({ ID = "GetMessage", chat_id_ = msg.chat_id_, message_id_ = tonumber(msg.reply_to_message_id_) }, Status_reply, nil)
end
elseif text and text:match("^رفع (.*) @(.*)") and Admin(msg) then 
local text1 = {string.match(text, "^(رفع) (.*) @(.*)$")}
if redis:sismember(bot_id.."Validitys:Group"..msg.chat_id_,text1[2]) then
function status_username(extra, result, success)   
if (result.id_) then
local statusrt = redis:get(bot_id.."Add:Validity:Group:Rt"..text1[2]..msg.chat_id_)
if statusrt == "مميز" and Admin(msg) then
redis:sadd(bot_id.."Vip:Group"..msg.chat_id_,result.id_)  
redis:set(bot_id.."Add:Validity:Users"..msg.chat_id_..result.id_,text1[2])
elseif statusrt == "ادمن" and Owner(msg) then 
redis:sadd(bot_id.."Admin:Group"..msg.chat_id_,result.id_)  
redis:set(bot_id.."Add:Validity:Users"..msg.chat_id_..result.id_,text1[2])
elseif statusrt == "مدير" and Constructor(msg) then
redis:sadd(bot_id.."Manager:Group"..msg.chat_id_,result.id_)  
redis:set(bot_id.."Add:Validity:Users"..msg.chat_id_..result.id_,text1[2])
elseif statusrt == "عضو" and Admin(msg) then
end
Send_Options(msg,result.id_,"reply","☑┇تم رفعه : "..text1[2].."")
else
send(msg.chat_id_, msg.id_,"📌┇المعرف غلط")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text1[3]},status_username,nil) 
end 
elseif text and text:match("^تنزيل (.*) @(.*)") and Admin(msg) then 
local text1 = {string.match(text, "^(تنزيل) (.*) @(.*)$")}
if redis:sismember(bot_id.."Validitys:Group"..msg.chat_id_,text1[2]) then
function status_username(extra, result, success)   
if (result.id_) then
local statusrt = redis:get(bot_id.."Add:Validity:Group:Rt"..text1[2]..msg.chat_id_)
if statusrt == "مميز" and Admin(msg) then
redis:srem(bot_id.."Vip:Group"..msg.chat_id_,result.id_)  
redis:del(bot_id.."Add:Validity:Users"..msg.chat_id_..result.id_)
elseif statusrt == "ادمن" and Owner(msg) then 
redis:srem(bot_id.."Admin:Group"..msg.chat_id_,result.id_)  
redis:del(bot_id.."Add:Validity:Users"..msg.chat_id_..result.id_)
elseif statusrt == "مدير" and Constructor(msg) then 
redis:srem(bot_id.."Manager:Group"..msg.chat_id_,result.id_)  
redis:del(bot_id.."Add:Validity:Users"..msg.chat_id_..result.id_)
elseif statusrt == "عضو" and Admin(msg) then
end
Send_Options(msg,result.id_,"reply","☑┇تم تنزيله : "..text1[2].."")
else
send(msg.chat_id_, msg.id_,"📌┇المعرف غلط")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text1[3]},status_username,nil) 
end  
elseif text and text:match("^حظر @(.*)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
if not Constructor(msg) and redis:get(bot_id.."Status:Lock:Ban:Group"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'☑┇لقد تم تعطيل الحظر و الطرد من قبل المنشئين')
return false
end
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
function FunctionStatus(arg, result)
if (result.id_) then
if Rank_Checking(result.id_, msg.chat_id_) == true then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(result.id_,msg.chat_id_).."")
else
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.id_, status_ = { ID = "ChatMemberStatusKicked" },},function(arg,data) 
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
if (data and data.code_ and data.code_ == 400 and data.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_, msg.id_,"⚠┇لا توجد لدي صلاحية حظر المستخدمين") 
return false  
end
redis:sadd(bot_id.."Removal:User:Group"..msg.chat_id_, result.id_)
Kick_Group(msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم حظره من المجموعه")  
end,nil)   
end
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^حظر @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^الغاء حظر @(.*)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if (result.id_) then
if tonumber(result.id_) == tonumber(bot_id) then
send(msg.chat_id_, msg.id_, "☑️┇لا يمكنك عمل هاذا الامر على البوت") 
return false 
end
redis:srem(bot_id.."Removal:User:Group"..msg.chat_id_, result.id_)
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.id_, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
Send_Options(msg,result.id_,"reply","☑┇تم الغاء حظره من هنا")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^الغاء حظر @(.*)$") }, FunctionStatus, nil)
elseif text and text:match("^كتم @(.*)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
function FunctionStatus(arg, result)
if (result.id_) then
if Rank_Checking(result.id_, msg.chat_id_) == true then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(result.id_,msg.chat_id_).." ")
return false 
end     
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم كتمه من هنا")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^كتم @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^الغاء كتم @(.*)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if (result.id_) then
redis:srem(bot_id.."Silence:User:Group"..msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم الغاء كتمه من هنا")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^الغاء كتم @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^تقيد @(.*)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
if (result.id_) then
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
if Rank_Checking(result.id_, msg.chat_id_) then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(result.id_,msg.chat_id_).."")
return false 
end      
https.request("https://api.telegram.org/bot"..token.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم تقييده في المجموعه")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^تقيد @(.*)$")}, FunctionStatus, nil)
elseif text and text:match('^تقيد (%d+) (.*) @(.*)$') and Admin(msg) then
local TextEnd = {string.match(text, "^(تقيد) (%d+) (.*) @(.*)$")}
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
function FunctionStatus(arg, result)
if (result.id_) then
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
if TextEnd[3] == 'يوم' then
Time_Restrict = TextEnd[2]:match('(%d+)')
Time = Time_Restrict * 86400
end
if TextEnd[3] == 'ساعه' then
Time_Restrict = TextEnd[2]:match('(%d+)')
Time = Time_Restrict * 3600
end
if TextEnd[3] == 'دقيقه' then
Time_Restrict = TextEnd[2]:match('(%d+)')
Time = Time_Restrict * 60
end
TextEnd[3] = TextEnd[3]:gsub('دقيقه',"دقايق") 
TextEnd[3] = TextEnd[3]:gsub('ساعه',"ساعات") 
TextEnd[3] = TextEnd[3]:gsub("يوم","ايام") 
if Rank_Checking(result.id_, msg.chat_id_) then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(result.id_,msg.chat_id_).."")
else
Send_Options(msg,result.id_,"reply", "☑┇تم تقيده لمدة ~ { "..TextEnd[2]..' '..TextEnd[3]..'}')
https.request("https://api.telegram.org/bot"..token.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.id_..'&until_date='..tonumber(msg.date_+Time))
end
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = TextEnd[4]}, FunctionStatus, nil)
elseif text and text:match("^الغاء تقيد @(.*)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
function FunctionStatus(arg, result)
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
if (result.id_) then
https.request("https://api.telegram.org/bot" .. token .. "/restrictChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" .. result.id_ .. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
Send_Options(msg,result.id_,"reply","☑┇تم الغاء تقييده")  
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^الغاء تقيد @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^طرد @(.*)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
if not Constructor(msg) and redis:get(bot_id.."Status:Lock:Ban:Group"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'☑┇لقد تم تعطيل الحظر و الطرد من قبل المنشئين')
return false
end
function FunctionStatus(arg, result)
if (result.id_) then
if Rank_Checking(result.id_, msg.chat_id_) == true then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(result.id_,msg.chat_id_).."")
else
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.id_, status_ = { ID = "ChatMemberStatusKicked" },},function(arg,data) 
if (result and result.type_ and result.type_.ID == "ChannelChatInfo") then
send(msg.chat_id_,msg.id_,"⚠┇عذرا هاذا معرف قناة")   
return false 
end      
if (data and data.code_ and data.code_ == 400 and data.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_, msg.id_,"⚠┇لا توجد لدي صلاحية حظر المستخدمين") 
return false  
end
Kick_Group(msg.chat_id_, result.id_)
Send_Options(msg,result.id_,"reply","☑┇تم طرده من هنا")  
end,nil)   
end
else
send(msg.chat_id_, msg.id_,"❌┇المعرف غلط ")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^طرد @(.*)$")}, FunctionStatus, nil)
elseif text and text:match("^حظر عام (%d+)$") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
if Dev_Raider_User(text:match("^حظر عام (%d+)$")) == true then
send(msg.chat_id_, msg.id_, "⚠┇لا تستطيع حظر المطور الاساسي عام")
return false 
end
if tonumber(text:match("^حظر عام (%d+)$")) == tonumber(bot_id) then  
send(msg.chat_id_, msg.id_, "⚠┇لا تسطيع حظر البوت عام")
return false 
end
redis:sadd(bot_id.."Removal:User:Groups", text:match("^حظر عام (%d+)$"))
Send_Options(msg,text:match("^حظر عام (%d+)$"),"reply","☑┇تم حظره عام من المجموعات")  
elseif text and text:match("^الغاء العام (%d+)$") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:srem(bot_id.."Removal:User:Groups", text:match("^الغاء العام (%d+)$"))
Send_Options(msg,text:match("^الغاء العام (%d+)$"),"reply","☑┇تم الغاء حظره عام من المجموعات")  
return false
end
if text and text:match("^اضف مطور (%d+)$") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:sadd(bot_id.."Developer:Bot", text:match("^اضف مطور (%d+)$"))
Send_Options(msg,text:match("^اضف مطور (%d+)$"),"reply","☑┇تم ترقيته مطور في البوت")  
elseif text and text:match("^حذف مطور (%d+)$") and Dev_Raider(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:srem(bot_id.."Developer:Bot", text:match("^حذف مطور (%d+)$"))
Send_Options(msg,text:match("^حذف مطور (%d+)$"),"reply","☑┇تم تنزيله من المطورين")  
elseif text and text:match("^رفع منشئ اساسي (%d+)$") and DeveloperBot(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
redis:sadd(bot_id.."President:Group"..msg.chat_id_, text:match("^رفع منشئ اساسي (%d+)$") )
Send_Options(msg,text:match("^رفع منشئ اساسي (%d+)$") ,"reply","☑┇تم ترقيته منشئ اساسي")  
elseif text and text:match("^تنزيل منشئ اساسي (%d+)$") and DeveloperBot(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
redis:srem(bot_id.."President:Group"..msg.chat_id_, text:match("^تنزيل منشئ اساسي (%d+)$") )
Send_Options(msg,text:match("^تنزيل منشئ اساسي (%d+)$") ,"reply","☑┇تم تنزيله من المنشئين")  
elseif text and text:match("^رفع منشئ (%d+)$") and PresidentGroup(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
redis:sadd(bot_id.."Constructor:Group"..msg.chat_id_, text:match("^رفع منشئ (%d+)$"))
Send_Options(msg,text:match("^رفع منشئ (%d+)$"),"reply","☑┇تم ترقيته منشئ في المجموعه")  
elseif text and text:match("^تنزيل منشئ (%d+)$") and PresidentGroup(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
redis:srem(bot_id.."Constructor:Group"..msg.chat_id_, text:match("^تنزيل منشئ (%d+)$"))
Send_Options(msg,text:match("^تنزيل منشئ (%d+)$"),"reply","☑┇تم تنزيله من المنشئين")  
elseif text and text:match("^رفع مدير (%d+)$") and Constructor(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
redis:sadd(bot_id.."Manager:Group"..msg.chat_id_, text:match("^رفع مدير (%d+)$") )
Send_Options(msg,text:match("^رفع مدير (%d+)$") ,"reply","☑┇تم ترقيته مدير المجموعه")  
elseif text and text:match("^تنزيل مدير (%d+)$") and Constructor(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
redis:srem(bot_id.."Manager:Group"..msg.chat_id_, text:match("^تنزيل مدير (%d+)$") )
Send_Options(msg,text:match("^تنزيل مدير (%d+)$") ,"reply","☑┇تم تنزيله من المدراء")  
elseif text and text:match("^رفع ادمن (%d+)$") and Owner(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
if not Constructor(msg) and redis:get(bot_id.."Status:Cheking:Seted"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✖┇لا تستطيع رفع احد وذالك لان تم تعطيل الرفع من قبل المنشئين')
return false
end
redis:sadd(bot_id.."Admin:Group"..msg.chat_id_, text:match("^رفع ادمن (%d+)$"))
Send_Options(msg,text:match("^رفع ادمن (%d+)$"),"reply","☑┇تم ترقيته ادمن للمجموعه")  
elseif text and text:match("^تنزيل ادمن (%d+)$") and Owner(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
redis:srem(bot_id.."Admin:Group"..msg.chat_id_, text:match("^تنزيل ادمن (%d+)$"))
Send_Options(msg,text:match("^تنزيل ادمن (%d+)$"),"reply","☑┇تم تنزيله من ادمنيه المجموعه")  
elseif text and text:match("^رفع مميز (%d+)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
if not Constructor(msg) and redis:get(bot_id.."Status:Cheking:Seted"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'✖┇لا تستطيع رفع احد وذالك لان تم تعطيل الرفع من قبل المنشئين')
return false
end
redis:sadd(bot_id.."Vip:Group"..msg.chat_id_, text:match("^رفع مميز (%d+)$"))
Send_Options(msg,text:match("^رفع مميز (%d+)$"),"reply","☑┇تم ترقيته مميز للمجموعه")  
elseif text and text:match("^تنزيل مميز (%d+)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end 
redis:srem(bot_id.."Vip:Group"..msg.chat_id_, text:match("^تنزيل مميز (%d+)$") )
Send_Options(msg,text:match("^تنزيل مميز (%d+)$") ,"reply","☑┇تم تنزيله من المميزين")  
elseif text and text:match("^حظر (%d+)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
if not Constructor(msg) and redis:get(bot_id.."Status:Lock:Ban:Group"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'☑┇لقد تم تعطيل الحظر و الطرد من قبل المنشئين')
return false
end
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
if Rank_Checking(text:match("^حظر (%d+)$") , msg.chat_id_) == true then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(userid,msg.chat_id_).."")
else
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = text:match("^حظر (%d+)$") , status_ = { ID = "ChatMemberStatusKicked" },},function(arg,data) 
if (data and data.code_ and data.code_ == 400 and data.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_, msg.id_,"⚠┇لا توجد لدي صلاحية حظر المستخدمين") 
return false  
end
redis:sadd(bot_id.."Removal:User:Group"..msg.chat_id_, text:match("^حظر (%d+)$") )
Kick_Group(msg.chat_id_, text:match("^حظر (%d+)$") )  
Send_Options(msg,text:match("^حظر (%d+)$") ,"reply","☑┇تم حظره من المجموعه")  
end,nil)   
end
elseif text and text:match("^الغاء حظر (%d+)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
if tonumber(text:match("^الغاء حظر (%d+)$") ) == tonumber(bot_id) then
send(msg.chat_id_, msg.id_, "☑️┇لا يمكنك عمل هاذا الامر على البوت") 
return false 
end
redis:srem(bot_id.."Removal:User:Group"..msg.chat_id_, text:match("^الغاء حظر (%d+)$") )
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = text:match("^الغاء حظر (%d+)$") , status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
Send_Options(msg,text:match("^الغاء حظر (%d+)$") ,"reply","☑┇تم الغاء حظره من هنا")  
elseif text and text:match("^كتم (%d+)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
if Rank_Checking(text:match("^كتم (%d+)$"), msg.chat_id_) == true then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(userid,msg.chat_id_).."")
else
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
redis:sadd(bot_id.."Silence:User:Group"..msg.chat_id_, text:match("^كتم (%d+)$"))
Send_Options(msg,text:match("^كتم (%d+)$"),"reply","☑┇تم كتمه من هنا")  
end
elseif text and text:match("^الغاء كتم (%d+)$") and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end
redis:srem(bot_id.."Silence:User:Group"..msg.chat_id_,text:match("^الغاء كتم (%d+)$") )
Send_Options(msg,text:match("^الغاء كتم (%d+)$") ,"reply","☑┇تم الغاء كتمه من هنا")  
elseif text and text:match("^تقيد (%d+)$") and Admin(msg) then
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
if Rank_Checking(text:match("^تقيد (%d+)$"), msg.chat_id_) then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(userid,msg.chat_id_).."")
else
https.request("https://api.telegram.org/bot" .. token .. "/restrictChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..text:match("^تقيد (%d+)$"))
Send_Options(msg,userid,"reply","☑┇تم تقييده في المجموعه")  
end
elseif text and text:match('^تقيد (%d+) (.*)$') and tonumber(msg.reply_to_message_id_) ~= 0 and Admin(msg) then
local TextEnd = {string.match(text, "^(تقيد) (%d+) (.*)$")}
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
function FunctionStatus(arg, result)
if TextEnd[3] == 'يوم' then
Time_Restrict = TextEnd[2]:match('(%d+)')
Time = Time_Restrict * 86400
end
if TextEnd[3] == 'ساعه' then
Time_Restrict = TextEnd[2]:match('(%d+)')
Time = Time_Restrict * 3600
end
if TextEnd[3] == 'دقيقه' then
Time_Restrict = TextEnd[2]:match('(%d+)')
Time = Time_Restrict * 60
end
TextEnd[3] = TextEnd[3]:gsub('دقيقه',"دقايق") 
TextEnd[3] = TextEnd[3]:gsub('ساعه',"ساعات") 
TextEnd[3] = TextEnd[3]:gsub("يوم","ايام") 
if Rank_Checking(result.sender_user_id_, msg.chat_id_) then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(result.sender_user_id_,msg.chat_id_).."")
else
Send_Options(msg,result.sender_user_id_,"reply", "☑┇تم تقيده لمدة ~ { "..TextEnd[2]..' '..TextEnd[3]..'}')
https.request("https://api.telegram.org/bot"..token.."/restrictChatMember?chat_id="..msg.chat_id_.."&user_id="..result.sender_user_id_..'&until_date='..tonumber(msg.date_+Time))
end
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text and text:match("^الغاء تقيد (%d+)$") and Admin(msg) then
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
https.request("https://api.telegram.org/bot" .. token .. "/restrictChatMember?chat_id=" .. msg.chat_id_ .. "&user_id=" ..text:match("^الغاء تقيد (%d+)$").. "&can_send_messages=True&can_send_media_messages=True&can_send_other_messages=True&can_add_web_page_previews=True")
Send_Options(msg,text:match("^الغاء تقيد (%d+)$"),"reply","☑┇تم الغاء تقييده")  
elseif text == ("طرد") and msg.reply_to_message_id_ ~=0 and Admin(msg) then
if not Constructor(msg) and redis:get(bot_id.."Status:Lock:Ban:Group"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'☑┇لقد تم تعطيل الحظر و الطرد من قبل المنشئين')
return false
end
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
function FunctionStatus(arg, result)
if Rank_Checking(result.sender_user_id_, msg.chat_id_) == true then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(result.sender_user_id_,msg.chat_id_).."")
else
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = result.id_, status_ = { ID = "ChatMemberStatusKicked" },},function(arg,data) 
if (data and data.code_ and data.code_ == 400 and data.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_, msg.id_,"⚠┇لا توجد لدي صلاحية حظر المستخدمين") 
return false  
end
Kick_Group(result.chat_id_, result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","☑┇تم طرده من هنا")  
end,nil)
end
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, FunctionStatus, nil)
elseif text and text:match("^طرد (%d+)$") and Admin(msg) then 
if not Constructor(msg) and redis:get(bot_id.."Status:Lock:Ban:Group"..msg.chat_id_) then 
send(msg.chat_id_, msg.id_,'☑┇لقد تم تعطيل الحظر و الطرد من قبل المنشئين')
return false
end
if msg.can_be_deleted_ == false then 
send(msg.chat_id_, msg.id_,"⚠┇عذرآ البوت ليس ادمن") 
return false  
end
if Rank_Checking(text:match("^طرد (%d+)$") , msg.chat_id_) == true then
send(msg.chat_id_, msg.id_, "\n⚠┇لا تستطيع -( حظر , طرد , كتم , تقيد ) : "..Get_Rank(userid,msg.chat_id_).."")
else
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = text:match("^طرد (%d+)$") , status_ = { ID = "ChatMemberStatusKicked" },},function(arg,data) 
if (data and data.code_ and data.code_ == 400 and data.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_, msg.id_,"⚠┇لا توجد لدي صلاحية حظر المستخدمين") 
return false  
end
Kick_Group(msg.chat_id_, text:match("^طرد (%d+)$") )
Send_Options(msg,text:match("^طرد (%d+)$") ,"reply","☑┇تم طرده من هنا")  
end,nil)   
end
elseif text == "قفل الدردشه" and msg.reply_to_message_id_ == 0 and Owner(msg) then 
redis:set(bot_id.."Status:Lock:text"..msg.chat_id_,true) 
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الدردشه")  
elseif text == "قفل الاضافه" and msg.reply_to_message_id_ == 0 and Admin(msg) then 
redis:set(bot_id.."Status:Lock:AddMempar"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل اضافة الاعضاء")  
elseif text == "قفل الدخول" and msg.reply_to_message_id_ == 0 and Admin(msg) then 
redis:set(bot_id.."Status:Lock:Join"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل دخول الاعضاء")  
elseif text == "قفل البوتات" and msg.reply_to_message_id_ == 0 and Admin(msg) then 
redis:set(bot_id.."Status:Lock:Bot:kick"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل البوتات")  
elseif text == "قفل البوتات بالطرد" and msg.reply_to_message_id_ == 0 and Admin(msg) then 
redis:set(bot_id.."Status:Lock:Bot:kick"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل البوتات")  
elseif text == "قفل الاشعارات" and msg.reply_to_message_id_ == 0 and Admin(msg) then  
redis:set(bot_id.."Status:Lock:tagservr"..msg.chat_id_,true)  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الاشعارات")  
elseif text == "قفل التثبيت" and msg.reply_to_message_id_ == 0 and Constructor(msg) then 
redis:set(bot_id.."Status:lockpin"..msg.chat_id_, true) 
redis:sadd(bot_id.."Status:Lock:pin",msg.chat_id_) 
tdcli_function ({ ID = "GetChannelFull",  channel_id_ = msg.chat_id_:gsub("-100","") }, function(arg,data)  redis:set(bot_id.."Get:Id:Msg:Pin"..msg.chat_id_,data.pinned_message_id_)  end,nil)
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل التثبيت هنا")  
elseif text == "قفل التعديل" and msg.reply_to_message_id_ == 0 and Constructor(msg) then 
redis:set(bot_id.."Status:Lock:edit"..msg.chat_id_,true) 
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل تعديل")  
elseif text == "قفل تعديل الميديا" and msg.reply_to_message_id_ == 0 and Constructor(msg) then 
redis:set(bot_id.."Status:Lock:edit"..msg.chat_id_,true) 
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل تعديل")  
elseif text == "قفل الكل" and msg.reply_to_message_id_ == 0 and Constructor(msg) then  
redis:set(bot_id.."Status:Lock:tagservrbot"..msg.chat_id_,true)   
list ={"Status:Lock:Bot:kick","Status:Lock:User:Name","Status:Lock:hashtak","Status:Lock:Cmd","Status:Lock:Link","Status:Lock:forward","Status:Lock:Keyboard","Status:Lock:geam","Status:Lock:Photo","Status:Lock:Animation","Status:Lock:Video","Status:Lock:Audio","Status:Lock:vico","Status:Lock:Sticker","Status:Lock:Document","Status:Lock:Unsupported","Status:Lock:Markdaun","Status:Lock:Contact","Status:Status:Lock:Spam"}
for i,lock in pairs(list) do;redis:set(bot_id..lock..msg.chat_id_,"del");end
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل جميع الاوامر")  
elseif text == "فتح الاضافه" and msg.reply_to_message_id_ == 0 and Admin(msg) then 
redis:del(bot_id.."Status:Lock:AddMempar"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح اضافة الاعضاء")  
elseif text == "فتح الدردشه" and msg.reply_to_message_id_ == 0 and Owner(msg) then 
redis:del(bot_id.."Status:Lock:text"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الدردشه")  
elseif text == "فتح الدخول" and msg.reply_to_message_id_ == 0 and Admin(msg) then 
redis:del(bot_id.."Status:Lock:Join"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح دخول الاعضاء")  
elseif text == "فتح البوتات" and msg.reply_to_message_id_ == 0 and Admin(msg) then 
redis:del(bot_id.."Status:Lock:Bot:kick"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فـتح البوتات")  
elseif text == "فتح البوتات " and msg.reply_to_message_id_ == 0 and Admin(msg) then 
redis:del(bot_id.."Status:Lock:Bot:kick"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","🍃\n☑┇تم فـتح البوتات")  
elseif text == "فتح الاشعارات" and msg.reply_to_message_id_ == 0 and Admin(msg) then  
redis:del(bot_id.."Status:Lock:tagservr"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فـتح الاشعارات")  
elseif text == "فتح التثبيت" and msg.reply_to_message_id_ == 0 and Constructor(msg) then 
redis:del(bot_id.."Status:lockpin"..msg.chat_id_)  
redis:srem(bot_id.."Status:Lock:pin",msg.chat_id_)
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فـتح التثبيت هنا")  
elseif text == "فتح التعديل" and msg.reply_to_message_id_ == 0 and Constructor(msg) then 
redis:del(bot_id.."Status:Lock:edit"..msg.chat_id_) 
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فـتح تعديل")  
elseif text == "فتح التعديل الميديا" and msg.reply_to_message_id_ == 0 and Constructor(msg) then 
redis:del(bot_id.."Status:Lock:edit"..msg.chat_id_) 
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فـتح تعديل")  
elseif text == "فتح الكل" and msg.reply_to_message_id_ == 0 and Admin(msg) then 
redis:del(bot_id.."Status:Lock:tagservrbot"..msg.chat_id_)   
list ={"Status:Lock:Bot:kick","Status:Lock:User:Name","Status:Lock:hashtak","Status:Lock:Cmd","Status:Lock:Link","Status:Lock:forward","Status:Lock:Keyboard","Status:Lock:geam","Status:Lock:Photo","Status:Lock:Animation","Status:Lock:Video","Status:Lock:Audio","Status:Lock:vico","Status:Lock:Sticker","Status:Lock:Document","Status:Lock:Unsupported","Status:Lock:Markdaun","Status:Lock:Contact","Status:Status:Lock:Spam"}
for i,lock in pairs(list) do;redis:del(bot_id..lock..msg.chat_id_);end
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فـتح جميع الاوامر")  
elseif text == "قفل الروابط" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Link"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الروابط")  
elseif text == "قفل الروابط بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Link"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الروابط")  
elseif text == "قفل الروابط بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Link"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الروابط")  
elseif text == "قفل الروابط بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Link"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الروابط")  
elseif text == "فتح الروابط" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Link"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الروابط")  
elseif text == "قفل المعرفات" and Admin(msg) then
redis:set(bot_id.."Status:Lock:User:Name"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل المعرفات")  
elseif text == "قفل المعرفات بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:User:Name"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل المعرفات")  
elseif text == "قفل المعرفات بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:User:Name"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل المعرفات")  
elseif text == "قفل المعرفات بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:User:Name"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل المعرفات")  
elseif text == "فتح المعرفات" and Admin(msg) then
redis:del(bot_id.."Status:Lock:User:Name"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح المعرفات")  
elseif text == "قفل التاك" and Admin(msg) then
redis:set(bot_id.."Status:Lock:hashtak"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل التاك")  
elseif text == "قفل التاك بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:hashtak"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل التاك")  
elseif text == "قفل التاك بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:hashtak"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل التاك")  
elseif text == "قفل التاك بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:hashtak"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل التاك")  
elseif text == "فتح التاك" and Admin(msg) then
redis:del(bot_id.."Status:Lock:hashtak"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح التاك")  
elseif text == "قفل الشارحه" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Cmd"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الشارحه")  
elseif text == "قفل الشارحه بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Cmd"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الشارحه")  
elseif text == "قفل الشارحه بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Cmd"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الشارحه")  
elseif text == "قفل الشارحه بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Cmd"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الشارحه")  
elseif text == "فتح الشارحه" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Cmd"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الشارحه")  
elseif text == "قفل الصور"and Admin(msg) then
redis:set(bot_id.."Status:Lock:Photo"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الصور")  
elseif text == "قفل الصور بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Photo"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الصور")  
elseif text == "قفل الصور بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Photo"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الصور")  
elseif text == "قفل الصور بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Photo"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الصور")  
elseif text == "فتح الصور" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Photo"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الصور")  
elseif text == "قفل الفيديو" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Video"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الفيديو")  
elseif text == "قفل الفيديو بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Video"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الفيديو")  
elseif text == "قفل الفيديو بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Video"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الفيديو")  
elseif text == "قفل الفيديو بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Video"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الفيديو")  
elseif text == "فتح الفيديو" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Video"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الفيديو")  
elseif text == "قفل المتحركه" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Animation"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل المتحركه")  
elseif text == "قفل المتحركه بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Animation"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل المتحركه")  
elseif text == "قفل المتحركه بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Animation"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل المتحركه")  
elseif text == "قفل المتحركه بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Animation"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل المتحركه")  
elseif text == "فتح المتحركه" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Animation"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح المتحركه")  
elseif text == "قفل الالعاب" and Admin(msg) then
redis:set(bot_id.."Status:Lock:geam"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الالعاب")  
elseif text == "قفل الالعاب بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:geam"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الالعاب")  
elseif text == "قفل الالعاب بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:geam"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الالعاب")  
elseif text == "قفل الالعاب بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:geam"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الالعاب")  
elseif text == "فتح الالعاب" and Admin(msg) then
redis:del(bot_id.."Status:Lock:geam"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الالعاب")  
elseif text == "قفل الاغاني" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Audio"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الاغاني")  
elseif text == "قفل الاغاني بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Audio"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الاغاني")  
elseif text == "قفل الاغاني بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Audio"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الاغاني")  
elseif text == "قفل الاغاني بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Audio"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الاغاني")  
elseif text == "فتح الاغاني" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Audio"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الاغاني")  
elseif text == "قفل الصوت" and Admin(msg) then
redis:set(bot_id.."Status:Lock:vico"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الصوت")  
elseif text == "قفل الصوت بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:vico"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الصوت")  
elseif text == "قفل الصوت بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:vico"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الصوت")  
elseif text == "قفل الصوت بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:vico"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الصوت")  
elseif text == "فتح الصوت" and Admin(msg) then
redis:del(bot_id.."Status:Lock:vico"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الصوت")  
elseif text == "قفل الكيبورد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Keyboard"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الكيبورد")  
elseif text == "قفل الكيبورد بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Keyboard"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الكيبورد")  
elseif text == "قفل الكيبورد بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Keyboard"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الكيبورد")  
elseif text == "قفل الكيبورد بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Keyboard"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الكيبورد")  
elseif text == "فتح الكيبورد" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Keyboard"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الكيبورد")  
elseif text == "قفل الملصقات" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Sticker"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الملصقات")  
elseif text == "قفل الملصقات بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Sticker"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الملصقات")  
elseif text == "قفل الملصقات بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Sticker"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الملصقات")  
elseif text == "قفل الملصقات بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Sticker"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الملصقات")  
elseif text == "فتح الملصقات" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Sticker"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الملصقات")  
elseif text == "قفل التوجيه" and Admin(msg) then
redis:set(bot_id.."Status:Lock:forward"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل التوجيه")  
elseif text == "قفل التوجيه بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:forward"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل التوجيه")  
elseif text == "قفل التوجيه بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:forward"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل التوجيه")  
elseif text == "قفل التوجيه بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:forward"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل التوجيه")  
elseif text == "فتح التوجيه" and Admin(msg) then
redis:del(bot_id.."Status:Lock:forward"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح التوجيه")  
elseif text == "قفل الملفات" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Document"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الملفات")  
elseif text == "قفل الملفات بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Document"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الملفات")  
elseif text == "قفل الملفات بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Document"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الملفات")  
elseif text == "قفل الملفات بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Document"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الملفات")  
elseif text == "فتح الملفات" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Document"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الملفات")  
elseif text == "قفل السيلفي" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Unsupported"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل السيلفي")  
elseif text == "قفل السيلفي بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Unsupported"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل السيلفي")  
elseif text == "قفل السيلفي بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Unsupported"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل السيلفي")  
elseif text == "قفل السيلفي بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Unsupported"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل السيلفي")  
elseif text == "فتح السيلفي" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Unsupported"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح السيلفي")  
elseif text == "قفل الماركداون" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Markdaun"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الماركداون")  
elseif text == "قفل الماركداون بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Markdaun"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الماركداون")  
elseif text == "قفل الماركداون بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Markdaun"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الماركداون")  
elseif text == "قفل الماركداون بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Markdaun"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الماركداون")  
elseif text == "فتح الماركداون" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Markdaun"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الماركداون")  
elseif text == "قفل الجهات" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Contact"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الجهات")  
elseif text == "قفل الجهات بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Contact"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الجهات")  
elseif text == "قفل الجهات بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Contact"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الجهات")  
elseif text == "قفل الجهات بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Contact"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الجهات")  
elseif text == "فتح الجهات" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Contact"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الجهات")  
elseif text == "قفل الكلايش" and Admin(msg) then
redis:set(bot_id.."Status:Status:Lock:Spam"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الكلايش")  
elseif text == "قفل الكلايش بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Status:Lock:Spam"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الكلايش")  
elseif text == "قفل الكلايش بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Status:Lock:Spam"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الكلايش")  
elseif text == "قفل الكلايش بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Status:Lock:Spam"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الكلايش")  
elseif text == "فتح الكلايش" and Admin(msg) then
redis:del(bot_id.."Status:Status:Lock:Spam"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الكلايش")  
elseif text == "قفل الانلاين" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Inlen"..msg.chat_id_,"del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفـل الانلاين")  
elseif text == "قفل الانلاين بالتقيد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Inlen"..msg.chat_id_,"ked")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفـل الانلاين")  
elseif text == "قفل الانلاين بالكتم" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Inlen"..msg.chat_id_,"ktm")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفـل الانلاين")  
elseif text == "قفل الانلاين بالطرد" and Admin(msg) then
redis:set(bot_id.."Status:Lock:Inlen"..msg.chat_id_,"kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفـل الانلاين")  
elseif text == "فتح الانلاين" and Admin(msg) then
redis:del(bot_id.."Status:Lock:Inlen"..msg.chat_id_)  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح الانلاين")  
elseif text == "قفل التكرار بالطرد" and Admin(msg) then 
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id_ ,"Spam:User","kick")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kick","☑┇تم قفل التكرار")
elseif text == "قفل التكرار" and Admin(msg) then 
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id_ ,"Spam:User","del")  
Send_Options(msg,msg.sender_user_id_,"Close_Status","☑┇تم قفل التكرار بالحذف")
elseif text == "قفل التكرار بالتقيد" and Admin(msg) then 
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id_ ,"Spam:User","keed")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Kid","☑┇تم قفل التكرار")
elseif text == "قفل التكرار بالكتم" and Admin(msg) then 
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id_ ,"Spam:User","mute")  
Send_Options(msg,msg.sender_user_id_,"Close_Status_Ktm","☑┇تم قفل التكرار")
elseif text == "فتح التكرار" and Admin(msg) then 
redis:hdel(bot_id.."Spam:Group:User"..msg.chat_id_ ,"Spam:User")  
Send_Options(msg,msg.sender_user_id_,"Open_Status","☑┇تم فتح التكرار")
elseif text == "تفعيل جلب الرابط" and Admin(msg) or text == 'تفعيل الرابط' and Admin(msg) then  
redis:set(bot_id.."Link_Group"..msg.chat_id_,true) 
send(msg.chat_id_, msg.id_,"☑┇تم تفعيل جلب الرابط المجموعه") 
elseif text == "تعطيل جلب الرابط" and Admin(msg) or text == 'تعطيل الرابط' and Admin(msg) then
redis:del(bot_id.."Link_Group"..msg.chat_id_) 
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل جلب رابط المجموعه") 
elseif text == "تفعيل الترحيب" and Admin(msg) then  
redis:set(bot_id.."Chek:Welcome"..msg.chat_id_,true) 
send(msg.chat_id_, msg.id_,"☑┇تم تفعيل ترحيب المجموعه") 
elseif text == "تعطيل الترحيب" and Admin(msg) then  
redis:del(bot_id.."Chek:Welcome"..msg.chat_id_) 
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل ترحيب المجموعه") 
elseif text == "تفعيل ردود المدير" and Owner(msg) then   
redis:del(bot_id.."Status:Reply:Manager"..msg.chat_id_)  
send(msg.chat_id_, msg.id_,"☑┇تم تفعيل ردود المدير") 
elseif text == "تعطيل ردود المدير" and Owner(msg) then  
redis:set(bot_id.."Status:Reply:Manager"..msg.chat_id_,true)  
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل ردود المدير" ) 
elseif text == "تفعيل ردود المطور" and Owner(msg) then   
redis:del(bot_id.."Status:Reply:Sudo"..msg.chat_id_)  
send(msg.chat_id_, msg.id_,"☑┇تم تفعيل ردود المطور" ) 
elseif text == "تعطيل ردود المطور" and Owner(msg) then  
redis:set(bot_id.."Status:Reply:Sudo"..msg.chat_id_,true)   
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل ردود المطور" ) 
elseif text == "تفعيل اطردني" and Owner(msg) then   
redis:del(bot_id.."Status:Cheking:Kick:Me:Group"..msg.chat_id_)  
send(msg.chat_id_, msg.id_,Text) 
elseif text == "تعطيل اطردني" and Owner(msg) then  
redis:set(bot_id.."Status:Cheking:Kick:Me:Group"..msg.chat_id_,true)  
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل امر اطردني") 
elseif text == "تفعيل المغادره" and Dev_Raider(msg) then   
redis:del(bot_id.."Status:Lock:Left"..msg.chat_id_)  
send(msg.chat_id_, msg.id_,"☑┇تم تفعيل مغادرة البوت") 
elseif text == "تعطيل المغادره" and Dev_Raider(msg) then  
redis:set(bot_id.."Status:Lock:Left"..msg.chat_id_,true)   
send(msg.chat_id_, msg.id_, "☑┇تم تعطيل مغادرة البوت") 
elseif text == "تفعيل الاذاعه" and Dev_Raider(msg) then  
redis:del(bot_id.."Status:Broadcasting:Bot") 
send(msg.chat_id_, msg.id_,"☑┇تم تفعيل الاذاعه \n〽┇الان يمكن للمطورين الاذاعه" ) 
elseif text == "تعطيل الاذاعه" and Dev_Raider(msg) then  
redis:set(bot_id.."Status:Broadcasting:Bot",true) 
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل الاذاعه") 
elseif text == "تعطيل اوامر التحشيش" and Owner(msg) then    
send(msg.chat_id_, msg.id_, '☑┇تم تعطيل اوامر التحشيش')
redis:set(bot_id.."Status:Fun:Group"..msg.chat_id_,"true")
elseif text == "تفعيل اوامر التحشيش" and Owner(msg) then    
send(msg.chat_id_, msg.id_,'☑┇تم تفعيل اوامر التحشيش')
redis:del(bot_id.."Status:Fun:Group"..msg.chat_id_)
elseif text == 'تفعيل الايدي' and Owner(msg) then   
redis:del(bot_id..'Status:Lock:Id:Photo'..msg.chat_id_) 
send(msg.chat_id_, msg.id_,'☑┇تم تفعيل الايدي') 
elseif text == 'تعطيل الايدي' and Owner(msg) then  
redis:set(bot_id..'Status:Lock:Id:Photo'..msg.chat_id_,true) 
send(msg.chat_id_, msg.id_,'☑┇تم تعطيل الايدي') 
elseif text == 'تفعيل الايدي بالصوره' and Owner(msg) then   
redis:del(bot_id..'Status:Lock:Id:Py:Photo'..msg.chat_id_) 
send(msg.chat_id_, msg.id_,'☑┇تم تفعيل الايدي بالصوره') 
elseif text == 'تعطيل الايدي بالصوره' and Owner(msg) then  
redis:set(bot_id..'Status:Lock:Id:Py:Photo'..msg.chat_id_,true) 
send(msg.chat_id_, msg.id_,'☑┇تم تعطيل الايدي بالصوره') 
elseif text == "تعطيل الالعاب" and Owner(msg) then   
redis:del(bot_id.."Status:Lock:Game:Group"..msg.chat_id_) 
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل الالعاب") 
elseif text == "تفعيل الالعاب" and Owner(msg) then  
redis:set(bot_id.."Status:Lock:Game:Group"..msg.chat_id_,true) 
send(msg.chat_id_, msg.id_,"☑┇تم تفعيل الالعاب") 
elseif text == 'تفعيل البوت الخدمي' and Dev_Raider(msg) then  
redis:del(bot_id..'Free:Bot') 
send(msg.chat_id_, msg.id_,'☑┇تم تفعيل البوت الخدمي \n⚡┇الان يمكن الجميع تفعيله') 
elseif text == 'تعطيل البوت الخدمي' and Dev_Raider(msg) then  
redis:set(bot_id..'Free:Bot',true) 
send(msg.chat_id_, msg.id_,'☑┇تم تعطيل البوت الخدمي') 
elseif text == "تعطيل الطرد" and Constructor(msg) or text == "تعطيل الحظر" and Constructor(msg) then
redis:set(bot_id.."Status:Lock:Ban:Group"..msg.chat_id_,"true")
send(msg.chat_id_, msg.id_, '☑┇تم تعطيل - ( الحظر - الطرد ) ')
elseif text == "تفعيل الطرد" and Constructor(msg) or text == "تفعيل الحظر" and Constructor(msg) then
redis:del(bot_id.."Status:Lock:Ban:Group"..msg.chat_id_)
send(msg.chat_id_, msg.id_, '☑┇تم تفعيل - ( الحظر - الطرد ) ')
elseif text == "تعطيل الرفع" and Constructor(msg) or text == "تعطيل الترقيه" and Constructor(msg) then
redis:set(bot_id.."Status:Cheking:Seted"..msg.chat_id_,"true")
send(msg.chat_id_, msg.id_, '☑┇تم تعطيل رفع - ( الادمن - المميز ) ')
elseif text == "تفعيل الرفع" and Constructor(msg) or text == "تفعيل الترقيه" and Constructor(msg) then
redis:del(bot_id.."Status:Cheking:Seted"..msg.chat_id_)
send(msg.chat_id_, msg.id_, '☑┇تم تفعيل رفع - ( الادمن - المميز ) ')
elseif text ==("تثبيت") and msg.reply_to_message_id_ ~= 0 and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end  
if redis:sismember(bot_id.."Status:Lock:pin",msg.chat_id_) and not Constructor(msg) then
send(msg.chat_id_,msg.id_,"⚠┇التثبيت مقفل من قبل المنشئين")  
return false end
tdcli_function ({ID = "PinChannelMessage",channel_id_ = msg.chat_id_:gsub("-100",""),message_id_ = msg.reply_to_message_id_,disable_notification_ = 1},function(arg,data) 
if data.ID == "Ok" then
send(msg.chat_id_, msg.id_,"☑┇تم تثبيت الرساله بنجاح")   
redis:set(bot_id.."Get:Id:Msg:Pin"..msg.chat_id_,msg.reply_to_message_id_)
elseif data.code_ == 6 then
send(msg.chat_id_,msg.id_,"⚠┇البوت ليس ادمن هنا")  
elseif data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"⚠┇ليست لدي صلاحية التثبيت .")  
end;end,nil) 
elseif text == "الغاء التثبيت" and Admin(msg) then
local url,res = http.request('http://raider.gamemodsm.xyz/ch/?id='..msg.sender_user_id_)
data = JSON.decode(url)
if data.Ch_Raider.Info_Raider ~= true then
send(msg.chat_id_,msg.id_,'\n📌┇عليك الاشتراك في قناة البوت \n💢┇قناة البوت ← { @RaiderCli }')   
return false 
end  
if redis:sismember(bot_id.."Status:Lock:pin",msg.chat_id_) and not Constructor(msg) then
send(msg.chat_id_,msg.id_,"⚠┇التثبيت مقفل من قبل المنشئين")  
return false end
tdcli_function({ID="UnpinChannelMessage",channel_id_ = msg.chat_id_:gsub("-100","")},function(arg,data) 
if data.ID == "Ok" then
send(msg.chat_id_, msg.id_,"☑┇تم الغاء تثبيت الرساله بنجاح")   
redis:del(bot_id.."Get:Id:Msg:Pin"..msg.chat_id_)
elseif data.code_ == 6 then
send(msg.chat_id_,msg.id_,"⚠┇البوت ليس ادمن هنا")  
elseif data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"⚠┇ليست لدي صلاحية التثبيت .")
end;end,nil)
elseif text == 'طرد المحذوفين' or text == 'مسح المحذوفين' then  
if Admin(msg) then    
tdcli_function({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),offset_ = 0,limit_ = 1000}, function(arg,del)
for k, v in pairs(del.members_) do
tdcli_function({ID = "GetUser",user_id_ = v.user_id_},function(b,data) 
if data.first_name_ == false then
KickGroup(msg.chat_id_, data.id_)
end;end,nil);end
send(msg.chat_id_, msg.id_,'☑┇تم طرد الحسابات المحذوفه')
end,nil)
end
elseif text ==("مسح المطرودين") and Admin(msg) then    
local function delbans(extra, result)  
if not msg.can_be_deleted_ == true then  
send(msg.chat_id_, msg.id_, "⚠┇ يرجى ترقيتي ادمن هنا") 
return false
end  
local num = 0 
for k,y in pairs(result.members_) do 
num = num + 1  
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = y.user_id_, status_ = { ID = "ChatMemberStatusLeft"}, }, dl_cb, nil)  
end  
send(msg.chat_id_, msg.id_,"☑┇ تم الغاء الحظر عن *: "..num.." * شخص") 
end    
elseif text == "مسح البوتات" and Admin(msg) then 
tdcli_function ({ ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(arg,tah)  
local admins = tah.members_  
local x = 0
local c = 0
for i=0 , #admins do 
if tah.members_[i].status_.ID == "ChatMemberStatusEditor" then  
x = x + 1 
end
if tonumber(admins[i].user_id_) ~= tonumber(bot_id) then
KickGroup(msg.chat_id_,admins[i].user_id_)
end
c = c + 1
end     
if (c - x) == 0 then
send(msg.chat_id_, msg.id_, "⚠┇لا توجد بوتات في المجموعه")
else
send(msg.chat_id_, msg.id_,"\n⛔┇عدد البوتات هنا : "..c.."\n👮┇عدد البوتات التي هي ادمن : "..x.."\n🚷┇تم طرد - "..(c - x).." - بوتات ") 
end 
end,nil)  
elseif text == "مسح الرابط" and Admin(msg) or text == "حذف الرابط" and Admin(msg) then
send(msg.chat_id_,msg.id_,"☑┇تم ازالة رابط المجموعه")           
redis:del(bot_id.."Status:link:set:Group"..msg.chat_id_) 
elseif text == "حذف الصوره" and Admin(msg) or text == "مسح الصوره" and Admin(msg) then 
https.request("https://api.telegram.org/bot"..token.."/deleteChatPhoto?chat_id="..msg.chat_id_) 
send(msg.chat_id_, msg.id_,"☑┇تم ازالة صورة المجموعه") 
elseif text == "مسح الترحيب" and Admin(msg) or text == "حذف الترحيب" and Admin(msg) then 
redis:del(bot_id.."Get:Welcome:Group"..msg.chat_id_) 
send(msg.chat_id_, msg.id_,"☑┇تم ازالة ترحيب المجموعه") 
elseif text == "مسح القوانين" and Admin(msg) or text == "حذف القوانين" and Admin(msg) then  
send(msg.chat_id_, msg.id_,"〽┇تم ازالة قوانين المجموعه")  
redis:del(bot_id..":Rules:Group"..msg.chat_id_) 
elseif text == 'حذف الايدي' and Owner(msg) or text == 'مسح الايدي' and Owner(msg) then
redis:del(bot_id.."Set:Id:Group"..msg.chat_id_)
send(msg.chat_id_, msg.id_, '⚡┇تم ازالة كليشة الايدي ')
elseif text == 'مسح رسائلي' then
redis:del(bot_id..'Num:Message:User'..msg.chat_id_..':'..msg.sender_user_id_)
send(msg.chat_id_, msg.id_,'☑┇تم مسح جميع رسائلك ') 
elseif text == 'مسح سحكاتي' or text == 'مسح تعديلاتي' then
redis:del(bot_id..'Num:Message:Edit'..msg.chat_id_..':'..msg.sender_user_id_)
send(msg.chat_id_, msg.id_,'☑┇تم مسح جميع تعديلاتك ') 
elseif text == 'مسح جهاتي' then
redis:del(bot_id..'Num:Add:Memp'..msg.chat_id_..':'..msg.sender_user_id_)
send(msg.chat_id_, msg.id_,'☑┇تم مسح جميع جهاتك المضافه ') 
elseif text ==("مسح") and Admin(msg) and tonumber(msg.reply_to_message_id_) > 0 then
Delete_Message(msg.chat_id_,{[0] = tonumber(msg.reply_to_message_id_),msg.id_})   
tdcli_function({ID="GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersKicked"},offset_ = 0,limit_ = 200}, delbans, {chat_id_ = msg.chat_id_, msg_id_ = msg.id_})    
elseif text and text:match("^وضع تكرار (%d+)$") and Admin(msg) then   
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id_ ,"Num:Spam" ,text:match("^وضع تكرار (%d+)$")) 
send(msg.chat_id_, msg.id_,"📮┇تم وضع عدد التكرار : "..text:match("^وضع تكرار (%d+)$").."")  
elseif text and text:match("^وضع زمن التكرار (%d+)$") and Admin(msg) then   
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id_ ,"Num:Spam:Time" ,text:match("^وضع زمن التكرار (%d+)$")) 
send(msg.chat_id_, msg.id_,"📮┇تم وضع زمن التكرار : "..text:match("^وضع زمن التكرار (%d+)$").."") 
elseif text == "ضع رابط" and Admin(msg) or text == "وضع رابط" and Admin(msg) then
send(msg.chat_id_,msg.id_,"📮┇ارسل رابط المجموعه او رابط قناة المجموعه")
redis:setex(bot_id.."Status:link:set"..msg.chat_id_..""..msg.sender_user_id_,120,true) 
elseif text and text:match("^ضع صوره") and Admin(msg) and msg.reply_to_message_id_ == 0 or text and text:match("^وضع صوره") and Admin(msg) and msg.reply_to_message_id_ == 0 then  
redis:set(bot_id.."Set:Chat:Photo"..msg.chat_id_..":"..msg.sender_user_id_,true) 
send(msg.chat_id_,msg.id_,"🌄┇ارسل الصوره لوضعها") 
elseif text == "ضع وصف" and Admin(msg) or text == "وضع وصف" and Admin(msg) then  
redis:setex(bot_id.."Change:Description" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 120, true)  
send(msg.chat_id_,msg.id_,"📮┇ارسل الان الوصف")
elseif text == "ضع ترحيب" and Admin(msg) or text == "وضع ترحيب" and Admin(msg) then  
redis:setex(bot_id.."Welcome:Group" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 120, true)  
send(msg.chat_id_,msg.id_,"📮┇ارسل لي الترحيب الان".."\n📫┇تستطيع اضافة مايلي !\n👤┇دالة عرض الاسم »{`name`}\n📌┇دالة عرض المعرف »{`user`}") 
elseif text == "ضع قوانين" and Admin(msg) or text == "وضع قوانين" and Admin(msg) then 
redis:setex(bot_id.."Redis:Rules:" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
send(msg.chat_id_,msg.id_,"📮┇ارسل لي القوانين الان")  
elseif text == 'وضع كليشه المطور' and Dev_Raider(msg) then
redis:set(bot_id..'GetTexting:DevRaider'..msg.chat_id_..':'..msg.sender_user_id_,true)
send(msg.chat_id_,msg.id_,'📮┇ ارسل لي الكليشه الان')
elseif text and text:match("^ضع اسم (.*)") and Owner(msg) or text and text:match("^وضع اسم (.*)") and Owner(msg) then 
local Name = text:match("^ضع اسم (.*)") or text:match("^وضع اسم (.*)") 
tdcli_function ({ ID = "ChangeChatTitle",chat_id_ = msg.chat_id_,title_ = Name },function(arg,data) 
if data.message_ == "Channel chat title can be changed by administrators only" then
send(msg.chat_id_,msg.id_,"⚠┇ البوت ليس ادمن يرجى ترقيتي !")  
return false  
end 
if data.message_ == "CHAT_ADMIN_REQUIRED" then
send(msg.chat_id_,msg.id_,"⚠┇ ليست لدي صلاحية تغير اسم المجموعه")  
else
send(msg.chat_id_,msg.id_,"🔘┇ تم تغيير اسم المجموعه الى {["..Name.."]}")  
end
end,nil) 
elseif text == "الرابط" then 
local status_Link = redis:get(bot_id.."Link_Group"..msg.chat_id_)
if not status_Link then
send(msg.chat_id_, msg.id_,"☑┇جلب الرابط معطل") 
return false  
end
local link = redis:get(bot_id.."Status:link:set:Group"..msg.chat_id_)            
if link then                              
send(msg.chat_id_,msg.id_,"📮┇ Link Chat :\n ["..link.."]")                          
else                
local linkgpp = json:decode(https.request('https://api.telegram.org/bot'..token..'/exportChatInviteLink?chat_id='..msg.chat_id_))
if linkgpp.ok == true then 
send(msg.chat_id_,msg.id_,"📮┇ Link Chat :\n ["..linkgpp.result.."]")                          
else
send(msg.chat_id_, msg.id_,"⚠┇لا يوجد رابط للمجموعه")              
end            
end
elseif text == "الترحيب" and Admin(msg) then 
if redis:get(bot_id.."Get:Welcome:Group"..msg.chat_id_)   then 
Welcome = redis:get(bot_id.."Get:Welcome:Group"..msg.chat_id_)  
else 
Welcome = "⛔┇لم يتم تعيين ترحيب للمجموعه"
end 
send(msg.chat_id_, msg.id_,"["..Welcome.."]") 
elseif text == "مسح قائمه المنع" and Admin(msg) then   
local list = redis:smembers(bot_id.."List:Filter"..msg.chat_id_)  
for k,v in pairs(list) do  
redis:del(bot_id.."Filter:Reply1"..msg.sender_user_id_..msg.chat_id_)  
redis:del(bot_id.."Filter:Reply2"..v..msg.chat_id_)  
redis:srem(bot_id.."List:Filter"..msg.chat_id_,v)  
end  
send(msg.chat_id_, msg.id_,"☑┇تم مسح قائمه المنع")  
elseif text == "قائمه المنع" and Admin(msg) then   
local list = redis:smembers(bot_id.."List:Filter"..msg.chat_id_)  
t = "\n⛔┇قائمة المنع \n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do  
local FilterMsg = redis:get(bot_id.."Filter:Reply2"..v..msg.chat_id_)   
t = t..""..k.."- "..v.." » {"..FilterMsg.."}\n"    
end  
if #list == 0 then  
t = "📬┇لا يوجد كلمات ممنوعه"  
end  
send(msg.chat_id_, msg.id_,t)  
elseif text and text == "منع" and msg.reply_to_message_id_ == 0 and Admin(msg) then       
send(msg.chat_id_, msg.id_,"📛┇ارسل الكلمه لمنعها")  
redis:set(bot_id.."Filter:Reply1"..msg.sender_user_id_..msg.chat_id_,"SetFilter")  
return false  
elseif text == "الغاء منع" and msg.reply_to_message_id_ == 0 and Admin(msg) then    
send(msg.chat_id_, msg.id_,"🔖┇ارسل الكلمه الان")  
redis:set(bot_id.."Filter:Reply1"..msg.sender_user_id_..msg.chat_id_,"DelFilter")  
return false  
elseif text == ("كشف البوتات") and Admin(msg) then  
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersBots"},offset_ = 0,limit_ = 100 },function(extra,result,success)
local admins = result.members_  
text = "\n⛔┇قائمة البوتات \n━━━━━━━━━━━━━\n"
local n = 0
local t = 0
for i=0 , #admins do 
n = (n + 1)
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_
},function(arg,ta) 
if result.members_[i].status_.ID == "ChatMemberStatusMember" then  
tr = ""
elseif result.members_[i].status_.ID == "ChatMemberStatusEditor" then  
t = t + 1
tr = " {★}"
end
text = text..": [@"..ta.username_.."]"..tr.."\n"
if #admins == 0 then
send(msg.chat_id_, msg.id_, "⚠┇لا توجد بوتات في المجموعه")
return false 
end
if #admins == i then 
local a = "\n━━━━━━━━━━━━━\n🔖┇عدد البوتات التي هنا : "..n.." بوت"
local f = "\n👮┇عدد البوتات التي هي ادمن : "..t.."\n⚠┇ملاحضه علامة النجمه يعني البوت ادمن - ★ \n"
send(msg.chat_id_, msg.id_, text..a..f)
end
end,nil)
end
end,nil)
elseif text == "القوانين" then 
local Set_Rules = redis:get(bot_id..":Rules:Group" .. msg.chat_id_)   
if Set_Rules then     
send(msg.chat_id_,msg.id_, Set_Rules)   
else      
send(msg.chat_id_, msg.id_,"⚠┇لا توجد قوانين هنا")   
end    
elseif text == "اضف امر" and Constructor(msg) then
redis:set(bot_id.."Command:Reids:Group"..msg.chat_id_..":"..msg.sender_user_id_,"true") 
send(msg.chat_id_, msg.id_,"⚡┇الان ارسل لي الامر القديم ...")  
elseif text == "حذف امر" and Constructor(msg) or text == "مسح امر" and Constructor(msg) then 
redis:set(bot_id.."Command:Reids:Group:Del"..msg.chat_id_..":"..msg.sender_user_id_,"true") 
send(msg.chat_id_, msg.id_,"⤵┇ارسل الان الامر الذي قمت بوضعه مكان الامر القديم")  
elseif text and text:match("^مسح صلاحيه (.*)$") and Admin(msg) or text and text:match("^حذف صلاحيه (.*)$") and Admin(msg) then 
local ComdNew = text:match("^مسح صلاحيه (.*)$") or text:match("^حذف صلاحيه (.*)$")
redis:del(bot_id.."Add:Validity:Group:Rt"..ComdNew..msg.chat_id_)
redis:srem(bot_id.."Validitys:Group"..msg.chat_id_,ComdNew)  
send(msg.chat_id_, msg.id_, "\n☑┇تم مسح ← { "..ComdNew..' } من الصلاحيات') 
elseif text and text:match("^اضف صلاحيه (.*)$") and Admin(msg) then 
local ComdNew = text:match("^اضف صلاحيه (.*)$")
redis:set(bot_id.."Add:Validity:Group:Rt:New"..msg.chat_id_..msg.sender_user_id_,ComdNew)  
redis:sadd(bot_id.."Validitys:Group"..msg.chat_id_,ComdNew)  
redis:setex(bot_id.."Redis:Validity:Group"..msg.chat_id_..""..msg.sender_user_id_,200,true)  
send(msg.chat_id_, msg.id_, "\n〽┇ارسل نوع الصلاحيه كما مطلوب منك :\n💢┇انواع الصلاحيات المطلوبه ← { عضو ، مميز  ، ادمن  ، مدير }") 
elseif text and text:match("^تغير رد المطور (.*)$") and Owner(msg) then
local Teext = text:match("^تغير رد المطور (.*)$") 
redis:set(bot_id.."Developer:Bot:Reply"..msg.chat_id_,Teext)
send(msg.chat_id_, msg.id_,"〽┇ تم تغير رد المطور الى :"..Teext)
elseif text and text:match("^تغير رد المنشئ الاساسي (.*)$") and Owner(msg) then
local Teext = text:match("^تغير رد المنشئ الاساسي (.*)$") 
redis:set(bot_id.."President:Group:Reply"..msg.chat_id_,Teext)
send(msg.chat_id_, msg.id_,"〽┇ تم تغير رد المنشئ الاساسي الى :"..Teext)
elseif text and text:match("^تغير رد المنشئ (.*)$") and Owner(msg) then
local Teext = text:match("^تغير رد المنشئ (.*)$") 
redis:set(bot_id.."Constructor:Group:Reply"..msg.chat_id_,Teext)
send(msg.chat_id_, msg.id_,"〽┇ تم تغير رد المنشئ الى :"..Teext)
elseif text and text:match("^تغير رد المدير (.*)$") and Owner(msg) then
local Teext = text:match("^تغير رد المدير (.*)$") 
redis:set(bot_id.."Manager:Group:Reply"..msg.chat_id_,Teext) 
send(msg.chat_id_, msg.id_,"〽┇ تم تغير رد المدير الى :"..Teext)
elseif text and text:match("^تغير رد الادمن (.*)$") and Owner(msg) then
local Teext = text:match("^تغير رد الادمن (.*)$") 
redis:set(bot_id.."Admin:Group:Reply"..msg.chat_id_,Teext)
send(msg.chat_id_, msg.id_,"〽┇ تم تغير رد الادمن الى :"..Teext)
elseif text and text:match("^تغير رد المميز (.*)$") and Owner(msg) then
local Teext = text:match("^تغير رد المميز (.*)$") 
redis:set(bot_id.."Vip:Group:Reply"..msg.chat_id_,Teext)
send(msg.chat_id_, msg.id_,"〽┇ تم تغير رد المميز الى :"..Teext)
elseif text and text:match("^تغير رد العضو (.*)$") and Owner(msg) then
local Teext = text:match("^تغير رد العضو (.*)$") 
redis:set(bot_id.."Mempar:Group:Reply"..msg.chat_id_,Teext)
send(msg.chat_id_, msg.id_,"〽┇ تم تغير رد العضو الى :"..Teext)
elseif text == 'حذف رد المطور' and Owner(msg) then
redis:del(bot_id.."Developer:Bot:Reply"..msg.chat_id_)
send(msg.chat_id_, msg.id_,"☑┇تم حدف رد المطور")
elseif text == 'حذف رد المنشئ الاساسي' and Owner(msg) then
redis:del(bot_id.."President:Group:Reply"..msg.chat_id_)
send(msg.chat_id_, msg.id_,"☑┇تم حذف رد المنشئ الاساسي ")
elseif text == 'حذف رد المنشئ' and Owner(msg) then
redis:del(bot_id.."Constructor:Group:Reply"..msg.chat_id_)
send(msg.chat_id_, msg.id_,"☑┇تم حذف رد المنشئ ")
elseif text == 'حذف رد المدير' and Owner(msg) then
redis:del(bot_id.."Manager:Group:Reply"..msg.chat_id_) 
send(msg.chat_id_, msg.id_,"☑┇تم حذف رد المدير ")
elseif text == 'حذف رد الادمن' and Owner(msg) then
redis:del(bot_id.."Admin:Group:Reply"..msg.chat_id_)
send(msg.chat_id_, msg.id_,"☑┇تم حذف رد الادمن ")
elseif text == 'حذف رد المميز' and Owner(msg) then
redis:del(bot_id.."Vip:Group:Reply"..msg.chat_id_)
send(msg.chat_id_, msg.id_,"☑┇تم حذف رد المميز")
elseif text == 'حذف رد العضو' and Owner(msg) then
redis:del(bot_id.."Mempar:Group:Reply"..msg.chat_id_)
send(msg.chat_id_, msg.id_,"☑┇تم حذف رد العضو")
elseif text == ("مسح ردود المدير") and Owner(msg) then
local list = redis:smembers(bot_id.."List:Manager"..msg.chat_id_.."")
for k,v in pairs(list) do
redis:del(bot_id.."Add:Rd:Manager:Gif"..v..msg.chat_id_)   
redis:del(bot_id.."Add:Rd:Manager:Vico"..v..msg.chat_id_)   
redis:del(bot_id.."Add:Rd:Manager:Stekrs"..v..msg.chat_id_)     
redis:del(bot_id.."Add:Rd:Manager:Text"..v..msg.chat_id_)   
redis:del(bot_id.."Add:Rd:Manager:Photo"..v..msg.chat_id_)
redis:del(bot_id.."Add:Rd:Manager:Video"..v..msg.chat_id_)
redis:del(bot_id.."Add:Rd:Manager:File"..v..msg.chat_id_)
redis:del(bot_id.."Add:Rd:Manager:Audio"..v..msg.chat_id_)
redis:del(bot_id.."List:Manager"..msg.chat_id_)
end
send(msg.chat_id_, msg.id_,"☑┇تم مسح قائمه ردود المدير")
elseif text == ("ردود المدير") and Owner(msg) then
local list = redis:smembers(bot_id.."List:Manager"..msg.chat_id_.."")
text = "📑┇قائمه ردود المدير \n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
if redis:get(bot_id.."Add:Rd:Manager:Gif"..v..msg.chat_id_) then
db = "متحركه 🎭"
elseif redis:get(bot_id.."Add:Rd:Manager:Vico"..v..msg.chat_id_) then
db = "بصمه 📢"
elseif redis:get(bot_id.."Add:Rd:Manager:Stekrs"..v..msg.chat_id_) then
db = "ملصق 🃏"
elseif redis:get(bot_id.."Add:Rd:Manager:Text"..v..msg.chat_id_) then
db = "رساله ✉"
elseif redis:get(bot_id.."Add:Rd:Manager:Photo"..v..msg.chat_id_) then
db = "صوره 🎇"
elseif redis:get(bot_id.."Add:Rd:Manager:Video"..v..msg.chat_id_) then
db = "فيديو 📹"
elseif redis:get(bot_id.."Add:Rd:Manager:File"..v..msg.chat_id_) then
db = "ملف 📁"
elseif redis:get(bot_id.."Add:Rd:Manager:Audio"..v..msg.chat_id_) then
db = "اغنيه 🎵"
end
text = text..""..k.." » {"..v.."} » {"..db.."}\n"
end
if #list == 0 then
text = "⚠┇عذرا لا يوجد ردود للمدير في المجموعه"
end
send(msg.chat_id_, msg.id_,"["..text.."]")
elseif text == "اضف رد" and Owner(msg) then
send(msg.chat_id_, msg.id_,"📮┇ارسل الان الكلمه لاضافتها في ردود المدير ")
redis:set(bot_id.."Set:Manager:rd"..msg.sender_user_id_..":"..msg.chat_id_,true)
elseif text == "حذف رد" and Owner(msg) then
send(msg.chat_id_, msg.id_,"📮┇ارسل الان الكلمه لحذفها من ردود المدير")
redis:set(bot_id.."Set:Manager:rd"..msg.sender_user_id_..":"..msg.chat_id_,"true2")
elseif text == ("مسح ردود المطور") and Dev_Raider(msg) then 
local list = redis:smembers(bot_id.."List:Rd:Sudo")
for k,v in pairs(list) do
redis:del(bot_id.."Add:Rd:Sudo:Gif"..v)   
redis:del(bot_id.."Add:Rd:Sudo:vico"..v)   
redis:del(bot_id.."Add:Rd:Sudo:stekr"..v)     
redis:del(bot_id.."Add:Rd:Sudo:Text"..v)   
redis:del(bot_id.."Add:Rd:Sudo:Photo"..v)
redis:del(bot_id.."Add:Rd:Sudo:Video"..v)
redis:del(bot_id.."Add:Rd:Sudo:File"..v)
redis:del(bot_id.."Add:Rd:Sudo:Audio"..v)
redis:del(bot_id.."List:Rd:Sudo")
end
send(msg.chat_id_, msg.id_,"☑┇تم حذف ردود المطور")
elseif text == ("ردود المطور") and Dev_Raider(msg) then 
local list = redis:smembers(bot_id.."List:Rd:Sudo")
text = "\n📝┇قائمة ردود المطور \n━━━━━━━━━━━━━\n"
for k,v in pairs(list) do
if redis:get(bot_id.."Add:Rd:Sudo:Gif"..v) then
db = "متحركه 🎭"
elseif redis:get(bot_id.."Add:Rd:Sudo:vico"..v) then
db = "بصمه 📢"
elseif redis:get(bot_id.."Add:Rd:Sudo:stekr"..v) then
db = "ملصق 🃏"
elseif redis:get(bot_id.."Add:Rd:Sudo:Text"..v) then
db = "رساله ✉"
elseif redis:get(bot_id.."Add:Rd:Sudo:Photo"..v) then
db = "صوره 🎇"
elseif redis:get(bot_id.."Add:Rd:Sudo:Video"..v) then
db = "فيديو 📹"
elseif redis:get(bot_id.."Add:Rd:Sudo:File"..v) then
db = "ملف 📁"
elseif redis:get(bot_id.."Add:Rd:Sudo:Audio"..v) then
db = "اغنيه 🎵"
end
text = text..""..k.." » {"..v.."} » {"..db.."}\n"
end
if #list == 0 then
text = "⚠┇لا توجد ردود للمطور"
end
send(msg.chat_id_, msg.id_,"["..text.."]")
elseif text == "اضف رد للكل" and Dev_Raider(msg) then 
send(msg.chat_id_, msg.id_,"📮┇ارسل الان الكلمه لاضافتها في ردود المكور ")
redis:set(bot_id.."Set:Rd"..msg.sender_user_id_..":"..msg.chat_id_,true)
elseif text == "حذف رد للكل" and Dev_Raider(msg) then 
send(msg.chat_id_, msg.id_,"📮┇ارسل الان الكلمه لحذفها من ردود المطور")
redis:set(bot_id.."Set:On"..msg.sender_user_id_..":"..msg.chat_id_,true)
end
if text and text:match("^تنزيل الكل @(.*)$") and Owner(msg) then
print('&&&')
function FunctionStatus(extra, result, success)
if (result.id_) then
if Dev_Raider_User(result.id_) == true then
send(msg.chat_id_, msg.id_,"⚠┇ لا تستطيع تنزيل المطور الاساسي")
return false 
end
if redis:sismember(bot_id.."Developer:Bot",result.id_) then
dev = "المطور ،" else dev = "" end
if redis:sismember(bot_id.."President:Group"..msg.chat_id_, result.id_) then
crr = "منشئ اساسي ،" else crr = "" end
if redis:sismember(bot_id..'Constructor:Group'..msg.chat_id_, result.id_) then
cr = "منشئ ،" else cr = "" end
if redis:sismember(bot_id..'Manager:Group'..msg.chat_id_, result.id_) then
own = "مدير ،" else own = "" end
if redis:sismember(bot_id..'Admin:Group'..msg.chat_id_, result.id_) then
mod = "ادمن ،" else mod = "" end
if redis:sismember(bot_id..'Vip:Group'..msg.chat_id_, result.id_) then
vip = "مميز ،" else vip = ""
end
if Rank_Checking(result.id_,msg.chat_id_) ~= false then
send(msg.chat_id_, msg.id_,"\n🔖┇تم تنزيل الشخص من الرتب التاليه \n📥┇ { "..dev..""..crr..""..cr..""..own..""..mod..""..vip.." } \n")
else
send(msg.chat_id_, msg.id_,"\n🚸┇ليس لديه رتب حتى استطيع تنزيله \n")
end
if Dev_Raider_User(msg.sender_user_id_) == true then
redis:srem(bot_id.."Developer:Bot", result.id_)
redis:srem(bot_id.."President:Group"..msg.chat_id_,result.id_)
redis:srem(bot_id..'Constructor:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Manager:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Admin:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Vip:Group'..msg.chat_id_, result.id_)
elseif redis:sismember(bot_id.."Developer:Bot",msg.sender_user_id_) then
redis:srem(bot_id..'Admin:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Vip:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Manager:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Constructor:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id.."President:Group"..msg.chat_id_,result.id_)
elseif redis:sismember(bot_id.."President:Group"..msg.chat_id_, msg.sender_user_id_) then
redis:srem(bot_id..'Admin:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Vip:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Manager:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Constructor:Group'..msg.chat_id_, result.id_)
elseif redis:sismember(bot_id..'Constructor:Group'..msg.chat_id_, msg.sender_user_id_) then
redis:srem(bot_id..'Admin:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Vip:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Manager:Group'..msg.chat_id_, result.id_)
elseif redis:sismember(bot_id..'Manager:Group'..msg.chat_id_, msg.sender_user_id_) then
redis:srem(bot_id..'Admin:Group'..msg.chat_id_, result.id_)
redis:srem(bot_id..'Vip:Group'..msg.chat_id_, result.id_)
end
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = text:match("^تنزيل الكل @(.*)$")}, FunctionStatus, nil)
end
if text == ("تنزيل الكل") and msg.reply_to_message_id_ ~= 0 and Owner(msg) then
function Function_Status(extra, result, success)
if Dev_Raider_User(result.sender_user_id_) == true then
send(msg.chat_id_, msg.id_,"⚠┇ لا تستطيع تنزيل المطور الاساسي")
return false 
end
if redis:sismember(bot_id.."Developer:Bot",result.sender_user_id_) then
dev = "المطور ،" else dev = "" end
if redis:sismember(bot_id.."President:Group"..msg.chat_id_, result.sender_user_id_) then
crr = "منشئ اساسي ،" else crr = "" end
if redis:sismember(bot_id..'Constructor:Group'..msg.chat_id_, result.sender_user_id_) then
cr = "منشئ ،" else cr = "" end
if redis:sismember(bot_id..'Manager:Group'..msg.chat_id_, result.sender_user_id_) then
own = "مدير ،" else own = "" end
if redis:sismember(bot_id..'Admin:Group'..msg.chat_id_, result.sender_user_id_) then
mod = "ادمن ،" else mod = "" end
if redis:sismember(bot_id..'Vip:Group'..msg.chat_id_, result.sender_user_id_) then
vip = "مميز ،" else vip = ""
end
if Rank_Checking(result.sender_user_id_,msg.chat_id_) ~= false then
send(msg.chat_id_, msg.id_,"\n🔖┇تم تنزيل الشخص من الرتب التاليه \n📥┇ { "..dev..""..crr..""..cr..""..own..""..mod..""..vip.." } \n")
else
send(msg.chat_id_, msg.id_,"\n🚸┇ليس لديه رتب حتى استطيع تنزيله \n")
end
if Dev_Raider_User(msg.sender_user_id_) == true then
redis:srem(bot_id.."Developer:Bot", result.sender_user_id_)
redis:srem(bot_id.."President:Group"..msg.chat_id_,result.sender_user_id_)
redis:srem(bot_id..'Constructor:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Manager:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Admin:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Vip:Group'..msg.chat_id_, result.sender_user_id_)
elseif redis:sismember(bot_id.."Developer:Bot",msg.sender_user_id_) then
redis:srem(bot_id..'Admin:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Vip:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Manager:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Constructor:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id.."President:Group"..msg.chat_id_,result.sender_user_id_)
elseif redis:sismember(bot_id.."President:Group"..msg.chat_id_, msg.sender_user_id_) then
redis:srem(bot_id..'Admin:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Vip:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Manager:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Constructor:Group'..msg.chat_id_, result.sender_user_id_)
elseif redis:sismember(bot_id..'Constructor:Group'..msg.chat_id_, msg.sender_user_id_) then
redis:srem(bot_id..'Admin:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Vip:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Manager:Group'..msg.chat_id_, result.sender_user_id_)
elseif redis:sismember(bot_id..'Manager:Group'..msg.chat_id_, msg.sender_user_id_) then
redis:srem(bot_id..'Admin:Group'..msg.chat_id_, result.sender_user_id_)
redis:srem(bot_id..'Vip:Group'..msg.chat_id_, result.sender_user_id_)
end
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, Function_Status, nil)
elseif text == "رتبتي" then
local rtp = Get_Rank(msg.sender_user_id_,msg.chat_id_)
send(msg.chat_id_, msg.id_,"⚡┇ رتبتك في البوت : "..rtp)
elseif text == "اسمي"  then 
tdcli_function({ID="GetUser",user_id_=msg.sender_user_id_},function(extra,result,success)
if result.first_name_  then
first_name = "👤┇ اسمك الاول : `"..(result.first_name_).."`"
else
first_name = ""
end   
if result.last_name_ then 
last_name = "👤┇ اسمك الثاني ← : `"..result.last_name_.."`" 
else
last_name = ""
end      
send(msg.chat_id_, msg.id_,first_name.."\n"..last_name) 
end,nil)
elseif text==("عدد الكروب") and Admin(msg) then  
if msg.can_be_deleted_ == false then 
send(msg.chat_id_,msg.id_,"⚠┇ البوت ليس ادمن هنا \n") 
return false  
end 
tdcli_function({ID ="GetChat",chat_id_=msg.chat_id_},function(arg,ta) 
tdcli_function({ID="GetChannelFull",channel_id_ = msg.chat_id_:gsub("-100","")},function(arg,data) 
local saied = "👮┇ عدد الادمنيه : "..data.administrator_count_..
"\n🚯┇ عدد المطرودين : "..data.kicked_count_..
"\n👥┇ عدد الاعضاء : "..data.member_count_..
"\n📨┇ عدد رسائل الكروب : "..(msg.id_/2097152/0.5)..
"\n〽┇ اسم المجموعه : ["..ta.title_.."]"
send(msg.chat_id_, msg.id_, saied) 
end,nil)end,nil)
elseif text == "غادر" then 
if DeveloperBot(msg) and not redis:get(bot_id.."Status:Lock:Left"..msg.chat_id_) then 
tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=bot_id,status_={ID = "ChatMemberStatusLeft"},},function(e,g) end, nil) 
send(msg.chat_id_, msg.id_,"📫┇ تم مغادرة المجموعه") 
redis:srem(bot_id.."ChekBotAdd",msg.chat_id_)  
end
elseif text and text:match("^غادر (-%d+)$") then
local GP_ID = {string.match(text, "^(غادر) (-%d+)$")}
if DeveloperBot(msg) and not redis:get(bot_id.."Status:Lock:Left"..msg.chat_id_) then 
tdcli_function ({ID = "ChangeChatMemberStatus",chat_id_=GP_ID[2],user_id_=bot_id,status_={ID = "ChatMemberStatusLeft"},},function(e,g) end, nil) 
send(msg.chat_id_, msg.id_,"📫┇ تم مغادرة المجموعه") 
send(GP_ID[2], 0,"📫┇ تم مغادرة المجموعه بامر من مطور البوت") 
redis:srem(bot_id.."ChekBotAdd",GP_ID[2])  
end
elseif text == Name_Bot then
local namebot = {
"عمر "..Name_Bot.. " شتريد؟",
"أჂ̤ أჂ̤ هياتني اني",
"موجود بس لتصيح",
"لتــلح دا احجي ويه بنات سكر بعدين اجاوبك",
"راح نموت بكورونا ونته بعدك تصيح "..Name_Bot,
'يمعود والله نعسان'
}
name = math.random(#namebot)
send(msg.chat_id_, msg.id_, namebot[name]) 
elseif text == "بوت" then
local BotName = {
"باوع لك خليني احبك وصيحلي باسمي "..Name_Bot.. "",
"لتخليني ارجع لحركاتي لقديمه وردا ترا اسمي "..Name_Bot.. "",
"راح نموت بكورونا ونته بعدك تصيح بوت"
}
BotNameText = math.random(#BotName)
send(msg.chat_id_, msg.id_,BotName[BotNameText]) 
elseif text == "تغير اسم البوت" and Dev_Raider(msg) or text == "تغيير اسم البوت" and Dev_Raider(msg) then 
redis:setex(bot_id.."Change:Name:Bot"..msg.sender_user_id_,300,true) 
send(msg.chat_id_, msg.id_,"📫┇ ارسل لي الاسم الان ")  
elseif text=="اذاعه خاص" and msg.reply_to_message_id_ == 0 and DeveloperBot(msg) then 
if redis:get(bot_id.."Status:Broadcasting:Bot") and not Dev_Raider(msg) then 
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل الاذاعه من قبل المطور الاساسي !")
return false end
redis:setex(bot_id.."Broadcasting:Users" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
send(msg.chat_id_, msg.id_,"🔘┇ارسل لي المنشور الان\n〽┇يمكنك ارسال -{ صوره - ملصق - متحركه - رساله }\n⚠┇لالغاء الاذاعه ارسل : الغاء") 
return false
elseif text=="اذاعه" and msg.reply_to_message_id_ == 0 and DeveloperBot(msg) then 
if redis:get(bot_id.."Status:Broadcasting:Bot") and not Dev_Raider(msg) then 
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل الاذاعه من قبل المطور الاساسي !")
return false end
redis:setex(bot_id.."Broadcasting:Groups" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
send(msg.chat_id_, msg.id_,"🔘┇ارسل لي المنشور الان\n〽┇يمكنك ارسال -{ صوره - ملصق - متحركه - رساله }\n⚠┇لالغاء الاذاعه ارسل : الغاء") 
return false
elseif text=="اذاعه بالتثبيت" and msg.reply_to_message_id_ == 0 and DeveloperBot(msg) then 
if redis:get(bot_id.."Status:Broadcasting:Bot") and not Dev_Raider(msg) then 
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل الاذاعه من قبل المطور الاساسي !")
return false end
redis:setex(bot_id.."Broadcasting:Groups:Pin" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
send(msg.chat_id_, msg.id_,"🔘┇ارسل لي المنشور الان\n〽┇يمكنك ارسال -{ صوره - ملصق - متحركه - رساله }\n⚠┇لالغاء الاذاعه ارسل : الغاء") 
return false
elseif text=="اذاعه بالتوجيه" and msg.reply_to_message_id_ == 0  and DeveloperBot(msg) then 
if redis:get(bot_id.."Status:Broadcasting:Bot") and not Dev_Raider(msg) then 
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل الاذاعه من قبل المطور الاساسي !")
return false end
redis:setex(bot_id.."Broadcasting:Groups:Fwd" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
send(msg.chat_id_, msg.id_,"〽┇ارسل لي التوجيه الان\n☑┇ليتم نشره في المجموعات") 
return false
elseif text=="اذاعه بالتوجيه خاص" and msg.reply_to_message_id_ == 0  and DeveloperBot(msg) then 
if redis:get(bot_id.."Status:Broadcasting:Bot") and not Dev_Raider(msg) then 
send(msg.chat_id_, msg.id_,"☑┇تم تعطيل الاذاعه من قبل المطور الاساسي !")
return false end
redis:setex(bot_id.."Broadcasting:Users:Fwd" .. msg.chat_id_ .. ":" .. msg.sender_user_id_, 600, true) 
send(msg.chat_id_, msg.id_,"〽┇ارسل لي التوجيه الان\n☑┇ليتم نشره الى المشتركين") 
return false

elseif text == "الاعدادات" and Admin(msg) then    
if redis:get(bot_id.."Status:lockpin"..msg.chat_id_) then    
lock_pin = "{✔️}"
else 
lock_pin = "{✖}"    
end
if redis:get(bot_id.."Status:Lock:tagservr"..msg.chat_id_) then    
lock_tagservr = "{✔️}"
else 
lock_tagservr = "{✖}"
end
if redis:get(bot_id.."Status:Lock:text"..msg.chat_id_) then    
lock_text = "← {✔️}"
else 
lock_text = "← {✖}"    
end
if redis:get(bot_id.."Status:Lock:AddMempar"..msg.chat_id_) == "kick" then
lock_add = "← {✔️}"
else 
lock_add = "← {✖}"    
end    
if redis:get(bot_id.."Status:Lock:Join"..msg.chat_id_) == "kick" then
lock_join = "← {✔️}"
else 
lock_join = "← {✖}"    
end    
if redis:get(bot_id.."Status:Lock:edit"..msg.chat_id_) then    
lock_edit = "← {✔️}"
else 
lock_edit = "← {✖}"    
end
if redis:get(bot_id.."Chek:Welcome"..msg.chat_id_) then
welcome = "← {✔️}"
else 
welcome = "← {✖}"    
end
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_, "Spam:User") == "kick" then     
flood = "← { بالطرد }"     
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Spam:User") == "keed" then     
flood = "← { بالتقيد }"     
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Spam:User") == "mute" then     
flood = "← { بالكتم }"           
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Spam:User") == "del" then     
flood = "← {✔️}"
else     
flood = "← {✖}"     
end
if redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "del" then
lock_photo = "← {✔️}" 
elseif redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "ked" then 
lock_photo = "← { بالتقيد }"   
elseif redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "ktm" then 
lock_photo = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:Photo"..msg.chat_id_) == "kick" then 
lock_photo = "← { بالطرد }"   
else
lock_photo = "← {✖}"   
end    
if redis:get(bot_id.."Status:Lock:Contact"..msg.chat_id_) == "del" then
lock_phon = "← {✔️}" 
elseif redis:get(bot_id.."Status:Lock:Contact"..msg.chat_id_) == "ked" then 
lock_phon = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:Contact"..msg.chat_id_) == "ktm" then 
lock_phon = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:Contact"..msg.chat_id_) == "kick" then 
lock_phon = "← { بالطرد }"    
else
lock_phon = "← {✖}"    
end    
if redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "del" then
lock_links = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "ked" then
lock_links = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "ktm" then
lock_links = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:Link"..msg.chat_id_) == "kick" then
lock_links = "← { بالطرد }"    
else
lock_links = "← {✖}"    
end
if redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "del" then
lock_cmds = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "ked" then
lock_cmds = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "ktm" then
lock_cmds = "← { بالكتم }"   
elseif redis:get(bot_id.."Status:Lock:Cmd"..msg.chat_id_) == "kick" then
lock_cmds = "← { بالطرد }"    
else
lock_cmds = "← {✖}"    
end
if redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "del" then
lock_user = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "ked" then
lock_user = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "ktm" then
lock_user = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:User:Name"..msg.chat_id_) == "kick" then
lock_user = "← { بالطرد }"    
else
lock_user = "← {✖}"    
end
if redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "del" then
lock_hash = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "ked" then 
lock_hash = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "ktm" then 
lock_hash = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:hashtak"..msg.chat_id_) == "kick" then 
lock_hash = "← { بالطرد }"    
else
lock_hash = "← {✖}"    
end
if redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "del" then
lock_muse = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "ked" then 
lock_muse = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "ktm" then 
lock_muse = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "kick" then 
lock_muse = "← { بالطرد }"    
else
lock_muse = "← {✖}"    
end 
if redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "del" then
lock_ved = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "ked" then 
lock_ved = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "ktm" then 
lock_ved = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:Video"..msg.chat_id_) == "kick" then 
lock_ved = "← { بالطرد }"    
else
lock_ved = "← {✖}"    
end
if redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "del" then
lock_gif = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "ked" then 
lock_gif = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "ktm" then 
lock_gif = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:Animation"..msg.chat_id_) == "kick" then 
lock_gif = "← { بالطرد }"    
else
lock_gif = "← {✖}"    
end
if redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "del" then
lock_ste = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "ked" then 
lock_ste = "بالتقيد "    
elseif redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "ktm" then 
lock_ste = "بالكتم "    
elseif redis:get(bot_id.."Status:Lock:Sticker"..msg.chat_id_) == "kick" then 
lock_ste = "← { بالطرد }"    
else
lock_ste = "← {✖}"    
end
if redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "del" then
lock_geam = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "ked" then 
lock_geam = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "ktm" then 
lock_geam = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:geam"..msg.chat_id_) == "kick" then 
lock_geam = "← { بالطرد }"    
else
lock_geam = "← {✖}"    
end    
if redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "del" then
lock_vico = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "ked" then 
lock_vico = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "ktm" then 
lock_vico = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:vico"..msg.chat_id_) == "kick" then 
lock_vico = "← { بالطرد }"    
else
lock_vico = "← {✖}"    
end    
if redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "del" then
lock_inlin = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "ked" then 
lock_inlin = "← { بالتقيد }"
elseif redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "ktm" then 
lock_inlin = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:Keyboard"..msg.chat_id_) == "kick" then 
lock_inlin = "← { بالطرد }"
else
lock_inlin = "← {✖}"
end
if redis:get(bot_id.."Status:Lock:forward"..msg.chat_id_) == "del" then
lock_fwd = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:forward"..msg.chat_id_) == "ked" then 
lock_fwd = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:forward"..msg.chat_id_) == "ktm" then 
lock_fwd = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:forward"..msg.chat_id_) == "kick" then 
lock_fwd = "← { بالطرد }"    
else
lock_fwd = "← {✖}"    
end    
if redis:get(bot_id.."Status:Lock:Document"..msg.chat_id_) == "del" then
lock_file = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:Document"..msg.chat_id_) == "ked" then 
lock_file = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:Document"..msg.chat_id_) == "ktm" then 
lock_file = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:Document"..msg.chat_id_) == "kick" then 
lock_file = "← { بالطرد }"    
else
lock_file = "← {✖}"    
end    
if redis:get(bot_id.."Status:Lock:Unsupported"..msg.chat_id_) == "del" then
lock_self = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:Unsupported"..msg.chat_id_) == "ked" then 
lock_self = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:Unsupported"..msg.chat_id_) == "ktm" then 
lock_self = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:Unsupported"..msg.chat_id_) == "kick" then 
lock_self = "← { بالطرد }"    
else
lock_self = "← {✖}"    
end
if redis:get(bot_id.."Status:Lock:Bot:kick"..msg.chat_id_) == "del" then
lock_bots = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:Bot:kick"..msg.chat_id_) == "ked" then
lock_bots = "← { بالتقيد }"   
elseif redis:get(bot_id.."Status:Lock:Bot:kick"..msg.chat_id_) == "kick" then
lock_bots = "← { بالطرد }"    
else
lock_bots = "← {✖}"    
end
if redis:get(bot_id.."Status:Lock:Markdaun"..msg.chat_id_) == "del" then
lock_mark = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:Markdaun"..msg.chat_id_) == "ked" then 
lock_mark = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:Markdaun"..msg.chat_id_) == "ktm" then 
lock_mark = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:Markdaun"..msg.chat_id_) == "kick" then 
lock_mark = "← { بالطرد }"    
else
lock_mark = "← {✖}"    
end
if redis:get(bot_id.."Status:Lock:Spam"..msg.chat_id_) == "del" then    
lock_spam = "← {✔️}"
elseif redis:get(bot_id.."Status:Lock:Spam"..msg.chat_id_) == "ked" then 
lock_spam = "← { بالتقيد }"    
elseif redis:get(bot_id.."Status:Lock:Spam"..msg.chat_id_) == "ktm" then 
lock_spam = "← { بالكتم }"    
elseif redis:get(bot_id.."Status:Lock:Spam"..msg.chat_id_) == "kick" then 
lock_spam = "← { بالطرد }"    
else
lock_spam = "← {✖}"    
end        
if not redis:get(bot_id.."Status:Reply:Manager"..msg.chat_id_) then
ReplyManager = "← {✔️}"
else
ReplyManager = "← {✖}"
end
if not redis:get(bot_id.."Status:Reply:Sudo"..msg.chat_id_) then
ReplySudo = "← {✔️}"
else
ReplySudo = "← {✖}"
end
if not redis:get(bot_id.."Status:Lock:Id:Photo"..msg.chat_id_)  then
IdPhoto = "← {✔️}"
else
IdPhoto = "← {✖}"
end
if not redis:get(bot_id.."Status:Lock:Id:Py:Photo"..msg.chat_id_) then
IdPyPhoto = "← {✔️}"
else
IdPyPhoto = "← {✖}"
end
if not redis:get(bot_id.."Status:Cheking:Kick:Me:Group"..msg.chat_id_)  then
KickMe = "← {✔️}"
else
KickMe = "← {✖}"
end
if not redis:get(bot_id.."Status:Lock:Ban:Group"..msg.chat_id_)  then
Banusers = "← {✔️}"
else
Banusers = "← {✖}"
end
if not redis:get(bot_id.."Status:Cheking:Seted"..msg.chat_id_) then
Setusers = "← {✔️}"
else
Setusers = "← {✖}"
end
if redis:get(bot_id.."Link_Group"..msg.chat_id_) then
Link_Group = "← {✔️}"
else
Link_Group = "← {✖}"
end
if not redis:get(bot_id.."Status:Fun:Group"..msg.chat_id_) then
FunGroup = "← {✔️}"
else
FunGroup = "← {✖}"
end
local Num_Flood = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id_,"Num:Spam") or 0
send(msg.chat_id_, msg.id_,"*\n🔖┇اعدادات المجموعه "..
"\n━━━━━━━━━━━━━"..
"\n🔏┇علامة ال (✔️) تعني مفعل"..
"\n🔓┇علامة ال (✖) تعني معطل"..
"\n━━━━━━━━━━━━━"..
"\n📌┇الروابط "..lock_links..
"\n".."📌┇الكلايش "..lock_spam..
"\n".."📌┇الكيبورد "..lock_inlin..
"\n".."📌┇الاغاني "..lock_vico..
"\n".."📌┇المتحركه "..lock_gif..
"\n".."📌┇الملفات "..lock_file..
"\n".."📌┇الدردشه "..lock_text..
"\n".."📌┇الفيديو "..lock_ved..
"\n".."📌┇الصور "..lock_photo..
"\n━━━━━━━━━━━━━"..
"\n".."〽┇المعرفات  "..lock_user..
"\n".."〽┇التاك "..lock_hash..
"\n".."〽┇البوتات "..lock_bots..
"\n".."〽┇التوجيه "..lock_fwd..
"\n".."〽┇الصوت "..lock_muse..
"\n".."〽┇الملصقات "..lock_ste..
"\n".."〽┇الجهات "..lock_phon..
"\n".."〽┇الدخول "..lock_join..
"\n".."〽┇الاضافه "..lock_add..
"\n".."〽┇السيلفي "..lock_self..
"\n━━━━━━━━━━━━━"..
"\n".."🔰┇التثبيت "..lock_pin..
"\n".."🔰┇الاشعارات "..lock_tagservr..
"\n".."🔰┇الماركدون "..lock_mark..
"\n".."🔰┇التعديل "..lock_edit..
"\n".."🔰┇الالعاب "..lock_geam..
"\n".."🔰┇التكرار "..flood..
"\n━━━━━━━━━━━━━"..
"\n".."💢┇الترحيب "..welcome..
"\n".."💢┇الرفع "..Setusers..
"\n".."💢┇الطرد "..Banusers..
"\n".."💢┇الايدي "..IdPhoto..
"\n".."💢┇الايدي بالصوره "..IdPyPhoto..
"\n".."💢┇اطردني "..KickMe..
"\n".."💢┇ردود المدير "..ReplyManager..
"\n".."💢┇ردود المطور "..ReplySudo..
"\n".."💢┇اوامر التحشيش "..FunGroup..
"\n".."💢┇جلب الرابط "..Link_Group..
"\n".."💢┇عدد التكرار ← {"..Num_Flood.."}\n\n.*")     
elseif text == 'تعين الايدي' and Owner(msg) then
redis:setex(bot_id.."Redis:Id:Group"..msg.chat_id_..""..msg.sender_user_id_,240,true)  
lsend(msg.chat_id_, msg.id_,[[
📝┇ارسل الان النص
🔘┇يمكنك اضافه :
👤┇`#username` » اسم المستخدم
📨┇`#msgs` » عدد الرسائل
🌄┇`#photos` » عدد الصور
🚸┇`#id` » ايدي المستخدم
📈┇`#auto` » نسبة التفاعل
🙋┇`#stast` » رتبة المستخدم 
📝┇`#edit` » عدد السحكات
💎┇`#game` » عدد المجوهرات
📱┇`#AddMem` » عدد الجهات
📋┇`#Description` » تعليق الصوره
]])
return false  
end 
if text == 'ايدي' and tonumber(msg.reply_to_message_id_) == 0 and not redis:get(bot_id..'Status:Lock:Id:Photo'..msg.chat_id_) then
tdcli_function ({ID = "GetUserProfilePhotos",user_id_ = msg.sender_user_id_,offset_ = 0,limit_ = 1},function(extra,saied,success) 
tdcli_function ({ID = "GetUser",user_id_ = msg.sender_user_id_},function(arg,data) 
if data.username_ then
UserName_User = '@'..data.username_
else
UserName_User = 'لا يوجد'
end
local Id = msg.sender_user_id_
local NumMsg = redis:get(bot_id..'Num:Message:User'..msg.chat_id_..':'..msg.sender_user_id_) or 0
local TotalMsg = Total_message(NumMsg)
local Status_Gps = Get_Rank(Id,msg.chat_id_)
local NumMessageEdit = redis:get(bot_id..'Num:Message:Edit'..msg.chat_id_..msg.sender_user_id_) or 0
local Num_Games = redis:get(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_) or 0
local Add_Mem = redis:get(bot_id.."Num:Add:Memp"..msg.chat_id_..":"..msg.sender_user_id_) or 0
local Total_Photp = (saied.total_count_ or 0)
local Texting = {
'ملاك وناسيك بكروبنه😟',
"حلغوم والله☹️ ",
"اطلق صوره🐼❤️",
"كيكك والله🥺",
"لازك بيها غيرها عاد😒",
}
local Description = Texting[math.random(#Texting)]
local Get_Is_Id = redis:get(bot_id.."Set:Id:Group"..msg.chat_id_)
if not redis:get(bot_id..'Status:Lock:Id:Py:Photo'..msg.chat_id_) then
if saied.photos_[0] then
if Get_Is_Id then
local Get_Is_Id = Get_Is_Id:gsub('#AddMem',Add_Mem) 
local Get_Is_Id = Get_Is_Id:gsub('#id',Id) 
local Get_Is_Id = Get_Is_Id:gsub('#username',UserName_User) 
local Get_Is_Id = Get_Is_Id:gsub('#msgs',NumMsg) 
local Get_Is_Id = Get_Is_Id:gsub('#edit',NumMessageEdit) 
local Get_Is_Id = Get_Is_Id:gsub('#stast',Status_Gps) 
local Get_Is_Id = Get_Is_Id:gsub('#auto',TotalMsg) 
local Get_Is_Id = Get_Is_Id:gsub('#Description',Description) 
local Get_Is_Id = Get_Is_Id:gsub('#game',Num_Games) 
local Get_Is_Id = Get_Is_Id:gsub('#photos',Total_Photp) 
sendPhoto(msg.chat_id_,msg.id_,saied.photos_[0].sizes_[1].photo_.persistent_id_,Get_Is_Id)
else
sendPhoto(msg.chat_id_,msg.id_,saied.photos_[0].sizes_[1].photo_.persistent_id_,'🌇┇'..Description..'\n〽┇ايديك ← '..Id..'\n👤┇معرفك ← '..UserName_User..'\n🚸┇رتبتك ← '..Status_Gps..'\n📧┇رسائلك ← '..NumMsg..'\n📝┇السحكات ← '..NumMessageEdit..' \n📊┇تتفاعلك ← '..TotalMsg..'\n💎┇ مجوهراتك ← '..Num_Games)
end
else
send(msg.chat_id_, msg.id_,'\n*〽┇ايديك ← '..Id..'\n👤┇معرفك ← *['..UserName_User..']*\n🚸┇رتبتك ← '..Status_Gps..'\n📧┇رسائلك ← '..NumMsg..'\n📝┇السحكات ← '..NumMessageEdit..' \n📊┇تتفاعلك ← '..TotalMsg..'\n💎┇ مجوهراتك ← '..Num_Games..'*') 
end
else
if Get_Is_Id then
local Get_Is_Id = Get_Is_Id:gsub('#AddMem',Add_Mem) 
local Get_Is_Id = Get_Is_Id:gsub('#id',Id) 
local Get_Is_Id = Get_Is_Id:gsub('#username',UserName_User) 
local Get_Is_Id = Get_Is_Id:gsub('#msgs',NumMsg) 
local Get_Is_Id = Get_Is_Id:gsub('#edit',NumMessageEdit) 
local Get_Is_Id = Get_Is_Id:gsub('#stast',Status_Gps) 
local Get_Is_Id = Get_Is_Id:gsub('#auto',TotalMsg) 
local Get_Is_Id = Get_Is_Id:gsub('#Description',Description) 
local Get_Is_Id = Get_Is_Id:gsub('#game',Num_Games) 
local Get_Is_Id = Get_Is_Id:gsub('#photos',Total_Photp) 
send(msg.chat_id_, msg.id_,'['..Get_Is_Id..']') 
else
send(msg.chat_id_, msg.id_,'\n*〽┇ايديك ← '..Id..'\n👤┇معرفك ← *['..UserName_User..']*\n🚸┇رتبتك ← '..Status_Gps..'\n📧┇رسائلك ← '..NumMsg..'\n📝┇السحكات ← '..NumMessageEdit..' \n📊┇تتفاعلك ← '..TotalMsg..'\n💎┇ مجوهراتك ← '..Num_Games..'*') 
end
end
end,nil)   
end,nil)   
end
if text and text:match('^تنظيف (%d+)$') and Admin(msg) or text and text:match('^حذف (%d+)$') and Admin(msg) or text and text:match('^مسح (%d+)$') and Admin(msg) then    
local Msg_Num = tonumber(text:match('^تنظيف (%d+)$')) or tonumber(text:match('^حذف (%d+)$'))  or tonumber(text:match('^مسح (%d+)$')) 
if Msg_Num > 1000 then 
send(msg.chat_id_, msg.id_,'⚠┇تستطيع حذف *(1000)* رساله فقط') 
return false  
end  
local Message = msg.id_
for i=1,tonumber(Msg_Num) do
Delete_Message(msg.chat_id_,{[0]=Message})
Message = Message - 1048576
end
send(msg.chat_id_, msg.id_,'☑┇تم ازالة *- '..Msg_Num..'* رساله من المجموعه')  
elseif text == 'ايدي' and tonumber(msg.reply_to_message_id_) > 0 and not redis:get(bot_id..'Status:Lock:Id:Photo'..msg.chat_id_) then
function Function_Status(extra, result, success)
tdcli_function ({ID = "GetUser",user_id_ = result.sender_user_id_},function(arg,data) 
if data.first_name_ == false then
send(msg.chat_id_, msg.id_,'⚠┇ الحساب محذوف لا توجد معلوماته ')
return false
end
if data.username_ then
UserName_User = '@'..data.username_
else
UserName_User = 'لا يوجد'
end
local Id = data.id_
local NumMsg = redis:get(bot_id..'Num:Message:User'..msg.chat_id_..':'..data.id_) or 0
local TotalMsg = Total_message(NumMsg)
local Status_Gps = Get_Rank(Id,msg.chat_id_)
local NumMessageEdit = redis:get(bot_id..'Num:Message:Edit'..msg.chat_id_..data.id_) or 0
local Num_Games = redis:get(bot_id.."Status:Msg_User"..msg.chat_id_..":"..data.id_) or 0
local Add_Mem = redis:get(bot_id.."Num:Add:Memp"..msg.chat_id_..":"..data.id_) or 0
send(msg.chat_id_, msg.id_,'\n*〽┇ايديه ← '..Id..'\n📧┇رسائله ← '..NumMsg..'\n👤┇معرفه ← *['..UserName_User..']*\n📊┇تفاعله ← '..TotalMsg..'\n🚸┇رتبته ← '..Status_Gps..'\n📝┇تعديلاته ← '..NumMessageEdit..'\n👥┇جهاته ← '..Add_Mem..'*') 
end,nil)   
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, Function_Status, nil)
return false
elseif text and text:match("^ايدي @(.*)$") and not redis:get(bot_id..'Status:Lock:Id:Photo'..msg.chat_id_) then
local username = text:match("^ايدي @(.*)$")
function Function_Status(extra, result, success)
if result.id_ then
tdcli_function ({ID = "GetUser",user_id_ = result.id_},function(arg,data) 
if data.username_ then
UserName_User = '@'..data.username_
else
UserName_User = 'لا يوجد'
end
local Id = data.id_
local NumMsg = redis:get(bot_id..'Num:Message:User'..msg.chat_id_..':'..data.id_) or 0
local TotalMsg = Total_message(NumMsg)
local Status_Gps = Get_Rank(Id,msg.chat_id_)
local NumMessageEdit = redis:get(bot_id..'Num:Message:Edit'..msg.chat_id_..data.id_) or 0
local Num_Games = redis:get(bot_id.."Status:Msg_User"..msg.chat_id_..":"..data.id_) or 0
local Add_Mem = redis:get(bot_id.."Num:Add:Memp"..msg.chat_id_..":"..data.id_) or 0
send(msg.chat_id_, msg.id_,'\n*〽┇ايديه ← '..Id..'\n📧┇رسائله ← '..NumMsg..'\n👤┇معرفه ← *['..UserName_User..']*\n📊┇تفاعله ← '..TotalMsg..'\n🚸┇رتبته ← '..Status_Gps..'\n📝┇تعديلاته ← '..NumMessageEdit..'\n👥┇جهاته ← '..Add_Mem..'*') 
end,nil)   
else
send(msg.chat_id_, msg.id_,'⚠┇لا يوجد حساب بهاذا المعرف')
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = username}, Function_Status, nil)
return false
elseif text == "سمايلات" or text == "سمايل" then
if redis:get(bot_id.."Status:Lock:Game:Group"..msg.chat_id_) then
redis:del(bot_id.."Status:Set:Sma"..msg.chat_id_)
Random = {"🍏","🍎","🍐","🍊","🍋","🍉","🍇","🍓","🍈","🍒","🍑","🍍","🥥","🥝","🍅","🍆","🥑","🥦","🥒","🌶","🌽","🥕","🥔","🥖","🥐","🍞","🥨","🍟","🧀","🥚","🍳","🥓","🥩","🍗","🍖","🌭","🍔","🍠","🍕","🥪","🥙","☕️","??","🥤","🍶","🍺","🍻","🏀","⚽️","🏈","⚾️","🎾","🏐","🏉","🎱","🏓","🏸","🥅","🎰","🎮","🎳","🎯","🎲","🎻","🎸","🎺","🥁","🎹","🎼","🎧","🎤","🎬","🎨","🎭","🎪","🎟","🎫","🎗","🏵","🎖","🏆","🥌","🛷","🚗","🚌","🏎","🚓","🚑","🚚","🚛","🚜","🇮🇶","⚔","🛡","🔮","🌡","💣","📌","📍","📓","📗","📂","📅","📪","📫","📬","📭","⏰","📺","🎚","☎️","📡"}
SM = Random[math.random(#Random)]
redis:set(bot_id.."Status:Random:Sm"..msg.chat_id_,SM)
send(msg.chat_id_, msg.id_,"🔰┇اسرع واحد يدز هاذا السمايل ? ~ {`"..SM.."`}")
return false
end
elseif text == "الاسرع" or tect == "ترتيب" then
if redis:get(bot_id.."Status:Lock:Game:Group"..msg.chat_id_) then
redis:del(bot_id.."Status:Speed:Tr"..msg.chat_id_)
KlamSpeed = {"سحور","سياره","استقبال","قنفه","ايفون","بزونه","مطبخ","كرستيانو","دجاجه","مدرسه","الوان","غرفه","ثلاجه","كهوه","سفينه","العراق","محطه","طياره","رادار","منزل","مستشفى","كهرباء","تفاحه","اخطبوط","سلمون","فرنسا","برتقاله","تفاح","مطرقه","بتيته","لهانه","شباك","باص","سمكه","ذباب","تلفاز","حاسوب","انترنيت","ساحه","جسر"};
name = KlamSpeed[math.random(#KlamSpeed)]
redis:set(bot_id.."Status:Klam:Speed"..msg.chat_id_,name)
name = string.gsub(name,"سحور","س ر و ح")
name = string.gsub(name,"سياره","ه ر س ي ا")
name = string.gsub(name,"استقبال","ل ب ا ت ق س ا")
name = string.gsub(name,"قنفه","ه ق ن ف")
name = string.gsub(name,"ايفون","و ن ف ا")
name = string.gsub(name,"بزونه","ز و ه ن")
name = string.gsub(name,"مطبخ","خ ب ط م")
name = string.gsub(name,"كرستيانو","س ت ا ن و ك ر ي")
name = string.gsub(name,"دجاجه","ج ج ا د ه")
name = string.gsub(name,"مدرسه","ه م د ر س")
name = string.gsub(name,"الوان","ن ا و ا ل")
name = string.gsub(name,"غرفه","غ ه ر ف")
name = string.gsub(name,"ثلاجه","ج ه ت ل ا")
name = string.gsub(name,"كهوه","ه ك ه و")
name = string.gsub(name,"سفينه","ه ن ف ي س")
name = string.gsub(name,"العراق","ق ع ا ل ر ا")
name = string.gsub(name,"محطه","ه ط م ح")
name = string.gsub(name,"طياره","ر ا ط ي ه")
name = string.gsub(name,"رادار","ر ا ر ا د")
name = string.gsub(name,"منزل","ن ز م ل")
name = string.gsub(name,"مستشفى","ى ش س ف ت م")
name = string.gsub(name,"كهرباء","ر ب ك ه ا ء")
name = string.gsub(name,"تفاحه","ح ه ا ت ف")
name = string.gsub(name,"اخطبوط","ط ب و ا خ ط")
name = string.gsub(name,"سلمون","ن م و ل س")
name = string.gsub(name,"فرنسا","ن ف ر س ا")
name = string.gsub(name,"برتقاله","ر ت ق ب ا ه ل")
name = string.gsub(name,"تفاح","ح ف ا ت")
name = string.gsub(name,"مطرقه","ه ط م ر ق")
name = string.gsub(name,"بتيته","ب ت ت ي ه")
name = string.gsub(name,"لهانه","ه ن ل ه ل")
name = string.gsub(name,"شباك","ب ش ا ك")
name = string.gsub(name,"باص","ص ا ب")
name = string.gsub(name,"سمكه","ك س م ه")
name = string.gsub(name,"ذباب","ب ا ب ذ")
name = string.gsub(name,"تلفاز","ت ف ل ز ا")
name = string.gsub(name,"حاسوب","س ا ح و ب")
name = string.gsub(name,"انترنيت","ا ت ن ر ن ي ت")
name = string.gsub(name,"ساحه","ح ا ه س")
name = string.gsub(name,"جسر","ر ج س")
send(msg.chat_id_, msg.id_,"🔰┇اسرع واحد يرتبها ~ {"..name.."}")
return false
end
elseif text == "حزوره" then
if redis:get(bot_id.."Status:Lock:Game:Group"..msg.chat_id_) then
redis:del(bot_id.."Status:Set:Hzora"..msg.chat_id_)
Hzora = {"الجرس","عقرب الساعه","السمك","المطر","5","الكتاب","البسمار","7","الكعبه","بيت الشعر","لهانه","انا","امي","الابره","الساعه","22","غلط","كم الساعه","البيتنجان","البيض","المرايه","الضوء","الهواء","الضل","العمر","القلم","المشط","الحفره","البحر","الثلج","الاسفنج","الصوت","بلم"};
name = Hzora[math.random(#Hzora)]
redis:set(bot_id.."Status:Klam:Hzor"..msg.chat_id_,name)
name = string.gsub(name,"الجرس","شيئ اذا لمسته صرخ ما هوه ؟")
name = string.gsub(name,"عقرب الساعه","اخوان لا يستطيعان تمضيه اكثر من دقيقه معا فما هما ؟")
name = string.gsub(name,"السمك","ما هو الحيوان الذي لم يصعد الى سفينة نوح عليه السلام ؟")
name = string.gsub(name,"المطر","شيئ يسقط على رأسك من الاعلى ولا يجرحك فما هو ؟")
name = string.gsub(name,"5","ما العدد الذي اذا ضربته بنفسه واضفت عليه 5 يصبح ثلاثين ")
name = string.gsub(name,"الكتاب","ما الشيئ الذي له اوراق وليس له جذور ؟")
name = string.gsub(name,"البسمار","ما هو الشيئ الذي لا يمشي الا بالضرب ؟")
name = string.gsub(name,"7","عائله مؤلفه من 6 بنات واخ لكل منهن .فكم عدد افراد العائله ")
name = string.gsub(name,"الكعبه","ما هو الشيئ الموجود وسط مكة ؟")
name = string.gsub(name,"بيت الشعر","ما هو البيت الذي ليس فيه ابواب ولا نوافذ ؟ ")
name = string.gsub(name,"لهانه","وحده حلوه ومغروره تلبس مية تنوره .من هيه ؟ ")
name = string.gsub(name,"انا","ابن امك وابن ابيك وليس باختك ولا باخيك فمن يكون ؟")
name = string.gsub(name,"امي","اخت خالك وليست خالتك من تكون ؟ ")
name = string.gsub(name,"الابره","ما هو الشيئ الذي كلما خطا خطوه فقد شيئا من ذيله ؟ ")
name = string.gsub(name,"الساعه","ما هو الشيئ الذي يقول الصدق ولكنه اذا جاع كذب ؟")
name = string.gsub(name,"22","كم مره ينطبق عقربا الساعه على بعضهما في اليوم الواحد ")
name = string.gsub(name,"غلط","ما هي الكلمه الوحيده التي تلفض غلط دائما ؟ ")
name = string.gsub(name,"كم الساعه","ما هو السؤال الذي تختلف اجابته دائما ؟")
name = string.gsub(name,"البيتنجان","جسم اسود وقلب ابيض وراس اخظر فما هو ؟")
name = string.gsub(name,"البيض","ماهو الشيئ الذي اسمه على لونه ؟")
name = string.gsub(name,"المرايه","ارى كل شيئ من دون عيون من اكون ؟ ")
name = string.gsub(name,"الضوء","ما هو الشيئ الذي يخترق الزجاج ولا يكسره ؟")
name = string.gsub(name,"الهواء","ما هو الشيئ الذي يسير امامك ولا تراه ؟")
name = string.gsub(name,"الضل","ما هو الشيئ الذي يلاحقك اينما تذهب ؟ ")
name = string.gsub(name,"العمر","ما هو الشيء الذي كلما طال قصر ؟ ")
name = string.gsub(name,"القلم","ما هو الشيئ الذي يكتب ولا يقرأ ؟")
name = string.gsub(name,"المشط","له أسنان ولا يعض ما هو ؟ ")
name = string.gsub(name,"الحفره","ما هو الشيئ اذا أخذنا منه ازداد وكبر ؟")
name = string.gsub(name,"البحر","ما هو الشيئ الذي يرفع اثقال ولا يقدر يرفع مسمار ؟")
name = string.gsub(name,"الثلج","انا ابن الماء فان تركوني في الماء مت فمن انا ؟")
name = string.gsub(name,"الاسفنج","كلي ثقوب ومع ذالك احفض الماء فمن اكون ؟")
name = string.gsub(name,"الصوت","اسير بلا رجلين ولا ادخل الا بالاذنين فمن انا ؟")
name = string.gsub(name,"بلم","حامل ومحمول نصف ناشف ونصف مبلول فمن اكون ؟ ")
send(msg.chat_id_, msg.id_,"🔰┇اسرع واحد يحل الحزوره ↓\n {"..name.."}")
return false
end
elseif text == "معاني" then
if redis:get(bot_id.."Status:Lock:Game:Group"..msg.chat_id_) then
redis:del(bot_id.."Status:Set:Maany"..msg.chat_id_)
Maany_Rand = {"قرد","دجاجه","بطريق","ضفدع","بومه","نحله","ديك","جمل","بقره","دولفين","تمساح","قرش","نمر","اخطبوط","سمكه","خفاش","اسد","فأر","ذئب","فراشه","عقرب","زرافه","قنفذ","تفاحه","باذنجان"}
name = Maany_Rand[math.random(#Maany_Rand)]
redis:set(bot_id.."Status:Maany"..msg.chat_id_,name)
name = string.gsub(name,"قرد","🐒")
name = string.gsub(name,"دجاجه","🐔")
name = string.gsub(name,"بطريق","🐧")
name = string.gsub(name,"ضفدع","🐸")
name = string.gsub(name,"بومه","🦉")
name = string.gsub(name,"نحله","🐝")
name = string.gsub(name,"ديك","🐓")
name = string.gsub(name,"جمل","🐫")
name = string.gsub(name,"بقره","🐄")
name = string.gsub(name,"دولفين","🐬")
name = string.gsub(name,"تمساح","🐊")
name = string.gsub(name,"قرش","🦈")
name = string.gsub(name,"نمر","🐅")
name = string.gsub(name,"اخطبوط","🐙")
name = string.gsub(name,"سمكه","🐟")
name = string.gsub(name,"خفاش","🦇")
name = string.gsub(name,"اسد","🦁")
name = string.gsub(name,"فأر","🐭")
name = string.gsub(name,"ذئب","🐺")
name = string.gsub(name,"فراشه","🦋")
name = string.gsub(name,"عقرب","🦂")
name = string.gsub(name,"زرافه","🦒")
name = string.gsub(name,"قنفذ","🦔")
name = string.gsub(name,"تفاحه","🍎")
name = string.gsub(name,"باذنجان","🍆")
send(msg.chat_id_, msg.id_,"🔰┇اسرع واحد يدز معنى السمايل ~ {"..name.."}")
return false
end
elseif text == "العكس" then
if redis:get(bot_id.."Status:Lock:Game:Group"..msg.chat_id_) then
redis:del(bot_id.."Status:Set:Aks"..msg.chat_id_)
katu = {"باي","فهمت","موزين","اسمعك","احبك","موحلو","نضيف","حاره","ناصي","جوه","سريع","ونسه","طويل","سمين","ضعيف","شريف","شجاع","رحت","عدل","نشيط","شبعان","موعطشان","خوش ولد","اني","هادئ"}
name = katu[math.random(#katu)]
redis:set(bot_id.."Status:Set:Aks:Game"..msg.chat_id_,name)
name = string.gsub(name,"باي","هلو")
name = string.gsub(name,"فهمت","مافهمت")
name = string.gsub(name,"موزين","زين")
name = string.gsub(name,"اسمعك","ماسمعك")
name = string.gsub(name,"احبك","ماحبك")
name = string.gsub(name,"موحلو","حلو")
name = string.gsub(name,"نضيف","وصخ")
name = string.gsub(name,"حاره","بارده")
name = string.gsub(name,"ناصي","عالي")
name = string.gsub(name,"جوه","فوك")
name = string.gsub(name,"سريع","بطيء")
name = string.gsub(name,"ونسه","ضوجه")
name = string.gsub(name,"طويل","قزم")
name = string.gsub(name,"سمين","ضعيف")
name = string.gsub(name,"ضعيف","قوي")
name = string.gsub(name,"شريف","كواد")
name = string.gsub(name,"شجاع","جبان")
name = string.gsub(name,"رحت","اجيت")
name = string.gsub(name,"عدل","ميت")
name = string.gsub(name,"نشيط","كسول")
name = string.gsub(name,"شبعان","جوعان")
name = string.gsub(name,"موعطشان","عطشان")
name = string.gsub(name,"خوش ولد","موخوش ولد")
name = string.gsub(name,"اني","مطي")
name = string.gsub(name,"هادئ","عصبي")
send(msg.chat_id_, msg.id_,"🔰┇اسرع واحد يدز العكس ~ {"..name.."}")
return false
end
elseif text == "خمن" or text == "تخمين" then   
if redis:get(bot_id.."Status:Lock:Game:Group"..msg.chat_id_) then
Num = math.random(1,20)
redis:set(bot_id.."Status:GAMES:NUM"..msg.chat_id_,Num) 
send(msg.chat_id_, msg.id_,"\n📛┇اهلا بك عزيزي في لعبة التخمين :\nٴ━━━━━━━━━━\n".."💢┇ملاحظه لديك { 3 } محاولات فقط فكر قبل ارسال تخمينك \n\n".."🔖┇سيتم تخمين عدد ما بين ال {1 و 20} اذا تعتقد انك تستطيع الفوز جرب واللعب الان ؟ ")
redis:setex(bot_id.."Status:GAME:TKMEN" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 100, true)  
return false  
end
elseif text == "محيبس" or text == "بات" then
if redis:get(bot_id.."Status:Lock:Game:Group"..msg.chat_id_) then   
Num = math.random(1,6)
redis:set(bot_id.."Status:Games:Bat"..msg.chat_id_,Num) 
send(msg.chat_id_, msg.id_,[[
*➀       ➁     ➂      ➃      ➄     ➅
↓      ↓     ↓      ↓     ↓     ↓
👊 ‹› 👊 ‹› 👊 ‹› 👊 ‹› 👊 ‹› 👊
📮┇اختر لأستخراج المحيبس الايد التي تحمل المحيبس 
🎁┇الفائز يحصل على { 3 } من النقاط *
]])
redis:setex(bot_id.."Status:SET:GAME" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 100, true)  
return false  
end
elseif text == "المختلف" then
if redis:get(bot_id.."Status:Lock:Game:Group"..msg.chat_id_) then
mktlf = {"😸","☠","🐼","🐇","🌑","🌚","⭐️","✨","⛈","🌥","⛄️","👨‍🔬","👨‍💻","👨‍🔧","🧚‍♀","🧜‍♂","🧝‍♂","🙍‍♂","🧖‍♂","👬","🕒","🕤","⌛️","📅",};
name = mktlf[math.random(#mktlf)]
redis:del(bot_id.."Status:Set:Moktlf:Bot"..msg.chat_id_)
redis:set(bot_id.."Status::Set:Moktlf"..msg.chat_id_,name)
name = string.gsub(name,"😸","😹😹😹😹😹😹😹😹😸😹😹😹😹")
name = string.gsub(name,"☠","💀💀💀💀💀💀💀☠💀💀💀💀💀")
name = string.gsub(name,"🐼","👻👻👻🐼👻👻👻👻👻👻👻")
name = string.gsub(name,"🐇","🕊🕊🕊🕊🕊🐇🕊🕊🕊🕊")
name = string.gsub(name,"🌑","🌚🌚🌚🌚🌚🌑🌚🌚🌚")
name = string.gsub(name,"🌚","🌑🌑🌑🌑🌑🌚🌑🌑🌑")
name = string.gsub(name,"⭐️","🌟🌟🌟🌟🌟🌟🌟🌟⭐️🌟🌟🌟")
name = string.gsub(name,"✨","💫💫💫💫💫✨💫💫💫💫")
name = string.gsub(name,"⛈","🌨🌨🌨🌨🌨⛈🌨🌨🌨🌨")
name = string.gsub(name,"🌥","⛅️⛅️⛅️⛅️⛅️⛅️🌥⛅️⛅️⛅️⛅️")
name = string.gsub(name,"⛄️","☃☃☃☃☃☃⛄️☃☃☃☃")
name = string.gsub(name,"👨‍🔬","👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👨‍🔬👩‍🔬👩‍🔬👩‍🔬")
name = string.gsub(name,"👨‍💻","👩‍💻👩‍💻👩‍‍💻👩‍‍💻👩‍💻👨‍💻👩‍💻👩‍💻👩‍💻")
name = string.gsub(name,"👨‍🔧","👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👨‍🔧👩‍🔧")
name = string.gsub(name,"👩‍🍳","👨‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳👩‍🍳👨‍🍳👨‍🍳👨‍🍳")
name = string.gsub(name,"🧚‍♀","🧚‍♂🧚‍♂🧚‍♂🧚‍♂🧚‍♀🧚‍♂🧚‍♂")
name = string.gsub(name,"🧜‍♂","🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧚‍♂🧜‍♀🧜‍♀🧜‍♀")
name = string.gsub(name,"🧝‍♂","🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♂🧝‍♀🧝‍♀🧝‍♀")
name = string.gsub(name,"🙍‍♂️","🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙍‍♂️🙎‍♂️🙎‍♂️🙎‍♂️")
name = string.gsub(name,"🧖‍♂️","🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♂️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️")
name = string.gsub(name,"👬","👭👭👭👭👭👬👭👭👭")
name = string.gsub(name,"👨‍👨‍👧","👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👧👨‍👨‍👦👨‍👨‍👦")
name = string.gsub(name,"🕒","🕒🕒🕒🕒🕒🕒🕓🕒🕒🕒")
name = string.gsub(name,"🕤","🕥🕥🕥🕥🕥🕤🕥🕥🕥")
name = string.gsub(name,"⌛️","⏳⏳⏳⏳⏳⏳⌛️⏳⏳")
name = string.gsub(name,"📅","📆📆📆📆📆📆📅📆📆")
send(msg.chat_id_, msg.id_,"🔰┇اسرع واحد يدز الاختلاف ~ {"..name.."}")
return false
end
elseif text == "امثله" then
if redis:get(bot_id.."Status:Lock:Game:Group"..msg.chat_id_) then
mthal = {"جوز","ضراطه","الحبل","الحافي","شقره","بيدك","سلايه","النخله","الخيل","حداد","المبلل","يركص","قرد","العنب","العمه","الخبز","بالحصاد","شهر","شكه","يكحله",};
name = mthal[math.random(#mthal)]
redis:set(bot_id.."Status:Set:Amth"..msg.chat_id_,name)
redis:del(bot_id.."Status:Set:Amth:Bot"..msg.chat_id_)
name = string.gsub(name,"جوز","ينطي____للماعده سنون")
name = string.gsub(name,"ضراطه","الي يسوق المطي يتحمل___")
name = string.gsub(name,"بيدك","اكل___محد يفيدك")
name = string.gsub(name,"الحافي","تجدي من___نعال")
name = string.gsub(name,"شقره","مع الخيل يا___")
name = string.gsub(name,"النخله","الطول طول___والعقل عقل الصخلة")
name = string.gsub(name,"سلايه","بالوجه امراية وبالظهر___")
name = string.gsub(name,"الخيل","من قلة___شدو على الچلاب سروج")
name = string.gsub(name,"حداد","موكل من صخم وجهه كال آني___")
name = string.gsub(name,"المبلل","___ما يخاف من المطر")
name = string.gsub(name,"الحبل","اللي تلدغة الحية يخاف من جرة___")
name = string.gsub(name,"يركص","المايعرف___يكول الكاع عوجه")
name = string.gsub(name,"العنب","المايلوح___يكول حامض")
name = string.gsub(name,"العمه","___إذا حبت الچنة ابليس يدخل الجنة")
name = string.gsub(name,"الخبز","انطي___للخباز حتى لو ياكل نصه")
name = string.gsub(name,"باحصاد","اسمة___ومنجله مكسور")
name = string.gsub(name,"شهر","امشي__ولا تعبر نهر")
name = string.gsub(name,"شكه","يامن تعب يامن__يا من على الحاضر لكة")
name = string.gsub(name,"القرد","__بعين امه غزال")
name = string.gsub(name,"يكحله","اجه___عماها")
send(msg.chat_id_, msg.id_,"🔰┇اسرع واحد يكمل المثل ~ {"..name.."}")
return false
end
elseif text == 'السورس' or text == 'سورس' or text == 'ياسورس'  then
send(msg.chat_id_, msg.id_,[[
💢┇Source Raider
━━━━━━━━━━━━━

💠┇[Channel Source ،](t.me/RaiderCli)

💬┇[Communication Source](t.me/RSAIEDBOT)

━━━━━━━━━━━━━
⚜┇[Developer Source !](t.me/RSAIED)
]]) 
elseif text == 'الاوامر' and Admin(msg) then
send(msg.chat_id_, msg.id_,[[*
💢┇توجد ← 5 اوامر في البوت
━━━━━━━━━━━━━
📮┇ارسل { م1 } ← اوامر الحمايه
⚜┇ارسل { م2 } ← اوامر الادمنيه
💠┇ارسل { م3 } ← اوامر المدراء
🌀┇ارسل { م4 } ← اوامر المنشئين
🗯┇ارسل { م5 } ← اوامر مطورين البوت
━━━━━━━━━━━━━
⚡┇قناة البوت ←* @RaiderCli
]]) 
elseif text == 'م1' and Admin(msg) then
send(msg.chat_id_, msg.id_,[[*
💢┇اوامر الحمايه اتبع مايلي ...
━━━━━━━━━━━━━
☑┇قفل ، فتح ← الامر 
☑┇تستطيع قفل حمايه كما يلي ...
📛┇← { بالتقيد ، بالطرد ، بالكتم }
━━━━━━━━━━━━━
⚡┇الروابط
⚡┇المعرف
⚡┇التاك
⚡┇الشارحه
⚡┇التعديل
⚡┇التثبيت
⚡┇المتحركه
⚡┇الملفات
⚡┇الصور
━━━━━━━━━━━━━
〽┇الماركداون
〽┇البوتات
〽┇التكرار
〽┇الكلايش
〽┇السيلفي
〽┇الملصقات
〽┇الفيديو
〽┇الانلاين
〽┇الدردشه
━━━━━━━━━━━━━
💢┇التوجيه
💢┇الاغاني
💢┇الصوت
💢┇الجهات
💢┇الاشعارات
━━━━━━━━━━━━━
⚡┇قناة البوت ←* @RaiderCli
]]) 
elseif text == 'م2' and Admin(msg) then
send(msg.chat_id_, msg.id_,[[*
💢┇اوامر ادمنية المجموعه ...
━━━━━━━━━━━━━
🔗┇رفع، تنزيل ← مميز
🔗┇تاك للكل ، عدد الكروب
🔗┇كتم ، حظر ، طرد ، تقيد
🔗┇الغاء كتم ، الغاء حظر ، الغاء تقيد
🔗┇منع ، الغاء منع 
━━━━━━━━━━━━━
📑┇عرض القوائم كما يلي ...
━━━━━━━━━━━━━
⛔┇المكتومين
⛔┇المميزين 
⛔┇قائمه المنع
⛔┇الصلاحيات
━━━━━━━━━━━━━
📌┇تثبيت ، الغاء تثبيت
📌┇الرابط ، الاعدادات
📌┇الترحيب ، القوانين
📌┇تفعيل ، تعطيل ← الترحيب
📌┇تفعيل ، تعطيل ← الرابط
📌┇اضف صلاحيه ، مسح صلاحيه 
📌┇جهاتي ،ايدي ، رسائلي
📌┇سحكاتي ، مجوهراتي
📌┇كشف البوتات
━━━━━━━━━━━━━
🆕┇وضع ، ضع ← الاوامر التاليه 
🚸┇اسم ، رابط ، صوره
🚸┇قوانين ، وصف ، ترحيب
━━━━━━━━━━━━━
🗑┇حذف ، مسح ← الاوامر التاليه
💥┇قائمه المنع ، المحظورين 
💥┇المميزين ، المكتومين ، القوانين
💥┇المطرودين ، البوتات ، الصوره
💥┇الصلاحيات ، الرابط
━━━━━━━━━━━━━
⚡┇قناة البوت ←* @RaiderCli
]]) 
elseif text == 'م3' and Owner(msg) then
send(msg.chat_id_, msg.id_,[[*
💢┇اوامر المدراء في المجموعه
━━━━━━━━━━━━━
💠┇رفع ، تنزيل ← ادمن
📑┇الادمنيه 
〽️┇رفع، كشف ← القيود
⚜┇تنزيل الكل ← { بالرد ، بالمعرف }
━━━━━━━━━━━━━
📛┇لتغيير رد الرتب في البوت
━━━━━━━━━━━━━
♻️┇تغير رد ← {اسم الرتبه والنص} 
💠┇المطور ، المنشئ الاساسي
💠┇المنشئ ، المدير ، الادمن
💠┇المميز ، العضو
━━━━━━━━━━━━━
💭┇تفعيل ، تعطيل ← الاوامر التاليه ↓
━━━━━━━━━━━━━
♦️┇الايدي ، الايدي بالصوره
♦️┇ردود المطور ، ردود المدير
♦️┇اطردني ، الالعاب ، الرفع
♦️┇الحظر ، الرابط ، اوامر التحشيش
━━━━━━━━━━━━━
🎐┇تعين ، مسح ←{ الايدي }
🎐┇رفع الادمنيه ، مسح الادمنيه
🎐┇ردود المدير ، مسح ردود المدير
🎐┇اضف ، حذف ← { رد }
🎐┇تنظيف ← { عدد }
━━━━━━━━━━━━━
⚡┇قناة البوت ←* @RaiderCli
]]) 
elseif text == 'م4' and Constructor(msg) then
send(msg.chat_id_, msg.id_,[[*
💢┇اوامر المنشئ الاساسي
━━━━━━━━━━━━━
⚜┇رفع ، تنزيل ←{ منشئ }
⚜┇المنشئين ، مسح المنشئين
━━━━━━━━━━━━━
🏅┇اوامر المنشئ المجموعه
━━━━━━━━━━━━━
💠┇رفع ، تنزيل ← { مدير }
💠┇المدراء ، مسح المدراء
💠┇اضف رسائل ← { بالرد او الايدي }
💠┇اضف مجوهرات ← { بالرد او الايدي }
💠┇اضف ، حذف ← { امر }
💠┇الاوامر المضافه ، مسح الاوامر المضافه
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
⚡┇قناة البوت ←* @RaiderCli
]]) 
elseif text == 'م5' and DeveloperBot(msg)  then
send(msg.chat_id_, msg.id_,[[*
💢┇اوامر المطور الاساسي  
━━━━━━━━━━━━━
💭┇حظر عام ، الغاء العام
💭┇اضف ، حذف ← { مطور } 
💭┇قائمه العام ، مسح قائمه العام
💭┇المطورين ، مسح المطورين
━━━━━━━━━━━━━
📪┇اضف ، حذف ← { رد للكل }
📪┇وضع ، حذف ← { كليشه المطور } 
📪┇مسح ردود المطور ، ردود المطور 
📪┇تحديث ،  تحديث السورس 
📪┇تعين عدد الاعضاء ← { العدد }
━━━━━━━━━━━━━
💠┇تفعيل ، تعطيل ← { الاوامر التاليه ↓}
🌀┇البوت الخدمي ، المغادرة ، الاذاعه
🌀┇ملف ← { اسم الملف }
━━━━━━━━━━━━━
🗑┇مسح جميع الملفات 
🗂┇المتجر ، الملفات
━━━━━━━━━━━━━
⚜┇اوامر المطور في البوت
━━━━━━━━━━━━━
📛┇تفعيل ، تعطيل ، الاحصائيات
📛┇رفع، تنزيل ← { منشئ اساسي }
📛┇مسح الاساسين ، المنشئين الاساسين 
📛┇غادر ، غادر ← { والايدي }
📛┇اذاعه ، اذاعه بالتوجيه ، اذاعه بالتثبيت
📛┇اذاعه خاص ، اذاعه خاص بالتوجيه 
┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉
⚡┇قناة البوت ←* @RaiderCli
]]) 
elseif text == 'الالعاب' then
send(msg.chat_id_, msg.id_,[[*
⛔┇قائمه الالعاب البوت
━━━━━━━━━━━━━
🎮┇لعبة المختلف » المختلف
🎮┇لعبة الامثله » امثله
🎮┇لعبة العكس » العكس
🎮┇لعبة الحزوره » حزوره
🎮┇لعبة المعاني » معاني
🎮┇لعبة البات » بات
🎮┇لعبة التخمين » خمن
🎮┇لعبه الاسرع » الاسرع
🎮┇لعبة السمايلات » سمايلات
━━━━━━━━━━━━━
💠┇مجوهراتي ← لعرض عدد الارباح
💬┇بيع مجوهراتي ← { العدد } ← لبيع كل مجوهره مقابل {50} رساله
*]]) 
elseif text == 'رسائلي' then
local nummsg = redis:get(bot_id..'Num:Message:User'..msg.chat_id_..':'..msg.sender_user_id_) or 1
send(msg.chat_id_, msg.id_,'📨┇عدد رسائلك هنا *~ '..nummsg..'*') 
elseif text == 'سحكاتي' or text == 'تعديلاتي' then
local edit = redis:get(bot_id..'Num:Message:Edit'..msg.chat_id_..msg.sender_user_id_) or 0
send(msg.chat_id_, msg.id_,'📝┇عدد التعديلات هنا *~ '..edit..'*') 
elseif text == 'جهاتي' then
local addmem = redis:get(bot_id.."Num:Add:Memp"..msg.chat_id_..":"..msg.sender_user_id_) or 0
send(msg.chat_id_, msg.id_,'👥┇عدد جهاتك المضافه هنا *~ '..addmem..'*') 
elseif text == "مجوهراتي" then 
local Num = redis:get(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_) or 0
if Num == 0 then 
Text = "⚠┇لم تفز بأي مجوهره "
else
Text = "🎁┇عدد الجواهر التي ربحتها *← "..Num.." *"
end
send(msg.chat_id_, msg.id_,Text) 
elseif text and text:match("^بيع مجوهراتي (%d+)$") then
local NUMPY = text:match("^بيع مجوهراتي (%d+)$") 
if tonumber(NUMPY) == tonumber(0) then
send(msg.chat_id_,msg.id_,"\n*📮┇لا استطيع البيع اقل من 1 *") 
return false 
elseif tonumber(redis:get(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_)) == tonumber(0) then
send(msg.chat_id_,msg.id_,"🔖┇ليس لديك جواهر من الالعاب \n📬┇اذا كنت تريد ربح الجواهر \n📌┇ارسل الالعاب وابدأ اللعب ! ") 
else
local NUM_GAMES = redis:get(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_)
if tonumber(NUMPY) > tonumber(NUM_GAMES) then
send(msg.chat_id_,msg.id_,"\n⚠┇ليس لديك جواهر بهاذا العدد \n📬┇لزيادة مجوهراتك في اللعبه \n📌┇ارسل الالعاب وابدأ اللعب !") 
return false 
end
local NUMNKO = (NUMPY * 50)
redis:decrby(bot_id.."Num:Add:Games"..msg.chat_id_..msg.sender_user_id_,NUMPY)  
redis:incrby(bot_id.."Num:Message:User"..msg.chat_id_..":"..msg.sender_user_id_,NUMNKO)  
send(msg.chat_id_,msg.id_,"☑┇تم خصم *~ { "..NUMPY.." }* من مجوهراتك \n📨┇وتم اضافة* ~ { "..(NUMPY * 50).." } رساله الى رسالك *")
end 
return false 
elseif text and text:match("^اضف رسائل (%d+)$") and msg.reply_to_message_id_ == 0 and Constructor(msg) then    
saied = text:match("^اضف رسائل (%d+)$")
redis:set(bot_id.."Status:id:user"..msg.chat_id_,saied)  
redis:setex(bot_id.."Status:Add:msg:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 120, true)  
send(msg.chat_id_, msg.id_, "✉┇ارسل لي عدد الرسائل الان") 
return false
elseif text and text:match("^اضف مجوهرات (%d+)$") and msg.reply_to_message_id_ == 0 and Constructor(msg) then  
saied = text:match("^اضف مجوهرات (%d+)$")
redis:set(bot_id.."Status:idgem:user"..msg.chat_id_,saied)  
redis:setex(bot_id.."Status:gemadd:user" .. msg.chat_id_ .. "" .. msg.sender_user_id_, 120, true)  
send(msg.chat_id_, msg.id_, "💠┇ارسل لي عدد المجوهرات الان") 
elseif text and text:match("^اضف مجوهرات (%d+)$") and msg.reply_to_message_id_ ~= 0 and Constructor(msg) then
function reply(extra, result, success)
redis:incrby(bot_id.."Num:Add:Games"..msg.chat_id_..result.sender_user_id_,text:match("^اضف مجوهرات (%d+)$"))  
send(msg.chat_id_, msg.id_,"📮┇تم اضافه عدد مجوهرات : "..text:match("^اضف مجوهرات (%d+)$").." ")  
end
tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},reply, nil)
return false
elseif text and text:match("^اضف رسائل (%d+)$") and msg.reply_to_message_id_ ~= 0 and Constructor(msg) then
function reply(extra, result, success)
redis:del(bot_id.."Status:Msg_User"..msg.chat_id_..":"..result.sender_user_id_) 
redis:incrby(bot_id.."Num:Message:User"..msg.chat_id_..":"..result.sender_user_id_,text:match("^اضف رسائل (%d+)$"))  
send(msg.chat_id_, msg.id_, "📮┇تم اضافه عدد الرسائل : "..text:match("^اضف رسائل (%d+)$").." ")  
end
tdcli_function ({ID = "GetMessage",chat_id_=msg.chat_id_,message_id_=tonumber(msg.reply_to_message_id_)},reply, nil)
return false
elseif text == "تنظيف المشتركين" and Dev_Raider(msg) then
local pv = redis:smembers(bot_id..'Num:User:Pv')  
local sendok = 0
for i = 1, #pv do
tdcli_function({ID='GetChat',chat_id_ = pv[i]},function(arg,dataq)
tdcli_function ({ ID = "SendChatAction",chat_id_ = pv[i], action_ = {  ID = "SendMessageTypingAction", progress_ = 100} },function(arg,data) 
if data.ID and data.ID == "Ok"  then
else
redis:srem(bot_id..'Num:User:Pv',pv[i])  
sendok = sendok + 1
end
if #pv == i then 
if sendok == 0 then
send(msg.chat_id_, msg.id_,'👤┇لا يوجد مشتركين وهميين')   
else
local ok = #pv - sendok
send(msg.chat_id_, msg.id_,'*👥┇عدد المشتركين الان ←{ '..#pv..' }\n⚠┇تم العثور على ←{ '..sendok..' } مشترك قام بحظر البوت\n☑┇اصبح عدد المشتركين الان ←{ '..ok..' } مشترك *')   
end
end
end,nil)
end,nil)
end
return false
elseif text == "تنظيف الكروبات" and Dev_Raider(msg) then
local group = redis:smembers(bot_id..'ChekBotAdd')  
local w = 0
local q = 0
for i = 1, #group do
tdcli_function({ID='GetChat',chat_id_ = group[i]
},function(arg,data)
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusMember" then
redis:srem(bot_id..'ChekBotAdd',group[i])  
w = w + 1
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusLeft" then
redis:srem(bot_id..'ChekBotAdd',group[i])  
q = q + 1
end
if data and data.type_ and data.type_.channel_ and data.type_.channel_.status_ and data.type_.channel_.status_.ID == "ChatMemberStatusKicked" then
redis:srem(bot_id..'ChekBotAdd',group[i])  
q = q + 1
end
if data and data.code_ and data.code_ == 400 then
redis:srem(bot_id..'ChekBotAdd',group[i])  
w = w + 1
end
if #group == i then 
if (w + q) == 0 then
send(msg.chat_id_, msg.id_,'👥┇لا توجد مجموعات وهميه ')   
else
local saied = (w + q)
local sendok = #group - saied
if q == 0 then
saied = ''
else
saied = '\n🚯┇ تم ازالة ~ '..q..' مجموعات من البوت'
end
if w == 0 then
raider = ''
else
raider = '\n🚯┇ تم ازالة ~'..w..' مجموعه لان البوت عضو'
end
send(msg.chat_id_, msg.id_,'*👥┇ عدد المجموعات الان ← { '..#group..' } مجموعه '..raider..''..saied..'\n🔘┇اصبح عدد المجموعات الان ← { '..sendok..' } مجموعات*\n')   
end
end
end,nil)
end
elseif text == "اطردني" or text == "طردني" then
if not redis:get(bot_id.."Status:Cheking:Kick:Me:Group"..msg.chat_id_) then
if Rank_Checking(msg.sender_user_id_, msg.chat_id_) == true then
send(msg.chat_id_, msg.id_, "\n⚠┇ عذرا لا استطيع طرد ( "..Get_Rank(msg.sender_user_id_,msg.chat_id_).." )")
return false
end
tdcli_function({ID="ChangeChatMemberStatus",chat_id_=msg.chat_id_,user_id_=msg.sender_user_id_,status_={ID="ChatMemberStatusKicked"},},function(arg,data) 
if (data and data.code_ and data.code_ == 400 and data.message_ == "CHAT_ADMIN_REQUIRED") then 
send(msg.chat_id_, msg.id_,"⚠┇ ليس لدي صلاحية حظر المستخدمين يرجى تفعيلها !") 
return false  
end
if (data and data.code_ and data.code_ == 3) then 
send(msg.chat_id_, msg.id_,"⚠┇ البوت ليس ادمن يرجى ترقيتي !") 
return false  
end
if data and data.code_ and data.code_ == 400 and data.message_ == "USER_ADMIN_INVALID" then 
send(msg.chat_id_, msg.id_,"⚠┇ عذرا لا استطيع طرد ادمنية المجموعه") 
return false  
end
if data and data.ID and data.ID == "Ok" then
send(msg.chat_id_, msg.id_,"🚷┇ تم طردك من المجموعه ") 
tdcli_function ({ ID = "ChangeChatMemberStatus", chat_id_ = msg.chat_id_, user_id_ = msg.sender_user_id_, status_ = { ID = "ChatMemberStatusLeft" },},function(arg,ban) end,nil)   
return false
end
end,nil)   
else
send(msg.chat_id_, msg.id_,"⚠┇ امر اطردني تم تعطيله من قبل المدراء ") 
end
elseif text and text:match("^رفع القيود @(.*)") and Owner(msg) then 
local username = text:match("^رفع القيود @(.*)") 
function Function_Status(extra, result, success)
if result.id_ then
if Dev_Raider(msg) then
redis:srem(bot_id.."Removal:User:Groups",result.id_)
redis:srem(bot_id.."Removal:User:Group"..msg.chat_id_,result.id_)
redis:srem(bot_id.."Silence:User:Group"..msg.chat_id_,result.id_)
Send_Options(msg,result.id_,"reply","\n📫┇ تم الغاء القيود عنه")  
else
redis:srem(bot_id.."Removal:User:Group"..msg.chat_id_,result.id_)
redis:srem(bot_id.."Silence:User:Group"..msg.chat_id_,result.id_)
Send_Options(msg,result.id_,"reply","\n📫┇ تم الغاء القيود عنه")  
end
else
send(msg.chat_id_, msg.id_,"📫┇ المعرف غلط")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = username}, Function_Status, nil)
elseif text == "رفع القيود" and Owner(msg) then
function Function_Status(extra, result, success)
if Dev_Raider(msg) then
redis:srem(bot_id.."Removal:User:Groups",result.sender_user_id_)
redis:srem(bot_id.."Removal:User:Group"..msg.chat_id_,result.sender_user_id_)
redis:srem(bot_id.."Silence:User:Group"..msg.chat_id_,result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","\n📫┇ تم الغاء القيود عنه")  
else
redis:srem(bot_id.."Removal:User:Group"..msg.chat_id_,result.sender_user_id_)
redis:srem(bot_id.."Silence:User:Group"..msg.chat_id_,result.sender_user_id_)
Send_Options(msg,result.sender_user_id_,"reply","\n📫┇ تم الغاء القيود عنه")  
end
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, Function_Status, nil)
elseif text and text:match("^كشف القيود @(.*)") and Owner(msg) then 
local username = text:match("^كشف القيود @(.*)") 
function Function_Status(extra, result, success)
if result.id_ then
if redis:sismember(bot_id.."Silence:User:Group"..msg.chat_id_,result.id_) then
Muted = "مكتوم"
else
Muted = "غير مكتوم"
end
if redis:sismember(bot_id.."Removal:User:Group"..msg.chat_id_,result.id_) then
Ban = "محظور"
else
Ban = "غير محظور"
end
if redis:sismember(bot_id.."Removal:User:Groups",result.id_) then
GBan = "محظور عام"
else
GBan = "غير محظور عام"
end
send(msg.chat_id_, msg.id_,"💢┇ الحظر العام ← "..GBan.."\n〽┇ الحظر ← "..Ban.."\n🔖┇ الكتم ← "..Muted)
else
send(msg.chat_id_, msg.id_,"📫┇ المعرف غلط")
end
end
tdcli_function ({ID = "SearchPublicChat",username_ = username}, Function_Status, nil)
elseif text == "كشف القيود" and Owner(msg) then 
function Function_Status(extra, result, success)
if redis:sismember(bot_id.."Silence:User:Group"..msg.chat_id_,result.sender_user_id_) then
Muted = "مكتوم"
else
Muted = "غير مكتوم"
end
if redis:sismember(bot_id.."Removal:User:Group"..msg.chat_id_,result.sender_user_id_) then
Ban = "محظور"
else
Ban = "غير محظور"
end
if redis:sismember(bot_id.."Removal:User:Groups",result.sender_user_id_) then
GBan = "محظور عام"
else
GBan = "غير محظور عام"
end
send(msg.chat_id_, msg.id_,"💢┇ الحظر العام ← "..GBan.."\n〽┇ الحظر ← "..Ban.."\n🔖┇ الكتم ← "..Muted)
end
tdcli_function ({ID = "GetMessage",chat_id_ = msg.chat_id_,message_id_ = tonumber(msg.reply_to_message_id_)}, Function_Status, nil)
elseif text ==("رفع الادمنيه") and Owner(msg) then
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
local num2 = 0
local admins = data.members_
for i=0 , #admins do
if data.members_[i].bot_info_ == false and data.members_[i].status_.ID == "ChatMemberStatusEditor" then
redis:sadd(bot_id..'Admin:Group'..msg.chat_id_, admins[i].user_id_)
num2 = num2 + 1
tdcli_function ({ID = "GetUser",user_id_ = admins[i].user_id_},function(arg,b) 
if b.username_ == true then
end
if b.first_name_ == false then
redis:srem(bot_id..'Admin:Group'..msg.chat_id_, admins[i].user_id_)
end
end,nil)   
else
redis:sadd(bot_id..'Admin:Group'..msg.chat_id_, admins[i].user_id_)
end
end
if num2 == 0 then
send(msg.chat_id_, msg.id_,"💥┇ لا توجد ادمنية ليتم رفعهم") 
else
send(msg.chat_id_, msg.id_,"🔘┇ تمت ترقية - "..num2.." من ادمنية المجموعه") 
end
end,nil)   
elseif text ==("المنشئ") then
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
owner_id = admins[i].user_id_
tdcli_function ({ID = "GetUser",user_id_ = owner_id},function(arg,b) 
if b.first_name_ == false then
send(msg.chat_id_, msg.id_,"🔘┇ حساب المنشئ محذوف")
return false  
end
local UserName = (b.username_ or "RaiderCli")
send(msg.chat_id_, msg.id_,"🚸┇منشئ المجموعه ~ ["..b.first_name_.."](T.me/"..UserName..")")  
end,nil)   
end
end
end,nil)   
elseif text ==("رفع المنشئ") and DeveloperBot(msg) then 
tdcli_function ({ID = "GetChannelMembers",channel_id_ = msg.chat_id_:gsub("-100",""),filter_ = {ID = "ChannelMembersAdministrators"},offset_ = 0,limit_ = 100},function(arg,data) 
local admins = data.members_
for i=0 , #admins do
if data.members_[i].status_.ID == "ChatMemberStatusCreator" then
owner_id = admins[i].user_id_
end
end
tdcli_function ({ID = "GetUser",user_id_ = owner_id},function(arg,b) 
if b.first_name_ == false then
send(msg.chat_id_, msg.id_,"⚠┇حساب المنشئ محذوف")
return false  
end
local UserName = (b.username_ or "RaiderCli")
send(msg.chat_id_, msg.id_,"🚸┇تم ترقية منشئ المجموعه ← ["..b.first_name_.."](T.me/"..UserName..")")  
redis:sadd(bot_id.."President:Group"..msg.chat_id_,b.id_)
end,nil)   
end,nil)   
elseif text and text:match("^تعين عدد الاعضاء (%d+)$") and Dev_Raider(msg) then
redis:set(bot_id..'Num:Add:Bot',text:match("تعين عدد الاعضاء (%d+)$") ) 
send(msg.chat_id_, msg.id_,'*☑┇ تم تعيين عدد اعضاء تفعيل البوت اكثر من : '..text:match("تعين عدد الاعضاء (%d+)$")..' عضو *')
elseif text =='الاحصائيات' and DeveloperBot(msg) then 
send(msg.chat_id_, msg.id_,'*📋┇عدد احصائيات البوت الكامله \n━━━━━━━━━━━━━\n📮┇عدد المجموعات : '..(redis:scard(bot_id..'ChekBotAdd') or 0)..'\n👤┇عدد المشتركين : '..(redis:scard(bot_id..'Num:User:Pv') or 0)..'*')
elseif text == 'المطور' or text == 'مطور' then
local TextingDevRaider = redis:get(bot_id..'Texting:DevRaider')
if TextingDevRaider then 
send(msg.chat_id_, msg.id_,TextingDevRaider)
else
send(msg.chat_id_, msg.id_,'['..UserName_Dev..']')
end
elseif text == 'حذف كليشه المطور' and Dev_Raider(msg) then
redis:del(bot_id..'Texting:DevRaider')
send(msg.chat_id_, msg.id_,'☑┇ تم حذف كليشه المطور')
end
end
end
return {Raider = Script}
