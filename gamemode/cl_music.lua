Music = {}
Music.currentlyPlaying = "NULL"
--Music.currentlyPlaying = CreateSound(playerObject, "gmodtower/virus/roundplay1.mp3") -- Generic

local function serializeFields()
	timer.Simple(1, function()
		local playerObject = LocalPlayer()

		Music.stinger = Sound("virus/stinger.mp3")

		Music.round = {
			[1] = CreateSound(playerObject, "virus/roundplay1.mp3"),
			[2] = CreateSound(playerObject, "virus/roundplay2.mp3"),
			[3] = CreateSound(playerObject, "virus/roundplay3.mp3"),
			[4] = CreateSound(playerObject, "virus/roundplay4.mp3"),
			[5] = CreateSound(playerObject, "virus/roundplay5.mp3")
		}

		Music.survivorsWin = {
			[1] = CreateSound(playerObject, "virus/roundend_survivors.mp3"),
			[2] = Sound("virus/announce_survivorswin.wav"),
			[3] = Sound("virus/ui/menu.wav")
		}

		Music.waitingForPlayers = CreateSound(playerObject, "virus/warmupPeriod.mp3")

		Music.warmupPeriod = CreateSound(playerObject, "virus/waiting_forinfection2.mp3")
	end)
end

hook.Add("Initialize","Virus Music serializeFields", serializeFields)

function Music:play(soundObj)
	if soundObj == nil then return end
	if soundObj == Music.currentlyPlaying then return end -- Maybe change this?

	if Music.currentlyPlaying != "NULL" then Music.currentlyPlaying:Stop() end
	soundObj:Stop() -- We have to do this so that it's reset and able to be played. If it's played before, it wouldn't play again.
	soundObj:Play()
	Music.currentlyPlaying = soundObj
end

function Music:playWaitingForPlayers()
	Music:play(Music.waitingForPlayers)
end

function Music:playWarmupPeriod()
	Music:play(Music.warmupPeriod)
end
net.Receive("Virus warmupPeriod", Music.playWarmupPeriod)

function Music:playRoundMusic()
	Music:play(Music.round[math.random(#Music.round)])
	surface.PlaySound(Music.stinger)
end
net.Receive("Virus roundMusic", Music.playRoundMusic)

function Music:playSurvivorWin()
	Music:play(Music.survivorsWin[1])
	surface.PlaySound(Music.survivorsWin[2])
	surface.PlaySound(Music.survivorsWin[3])
end
net.Receive("Virus survivorsWin", Music.playSurvivorWin)

local function infectedStinger()
	surface.PlaySound(Music.stinger)
end
net.Receive("Virus onInfected", infectedStinger)
