--Ynershia Common Functions
--  By Shad3

local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()

function scard.initial_effect(c)
	if not scard.reg then
		scard.reg=true
		--BP total ATK count
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(scard.atk_count)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_PHASE_START+PHASE_BATTLE_START)
		ge2:SetOperation(scard.atk_reset)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_TURN_END)
		Duel.RegisterEffect(ge3,0)
		scard.atkcounter={[0]=0,[1]=0}
		function Duel.GetAttackAnnounceCount(p)
			return scard.atkcounter[p]
		end
		--ATK event raise, player-agnostic
		local ge4=Effect.GlobalEffect()
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_ADJUST)
		ge4:SetOperation(scard.atk_event_raise)
		Duel.RegisterEffect(ge4,0)
		scard.atk_change_table={}
		function Card.GetAttackChange(c)
			return scard.atk_change_table[c] or 0
		end
		--
	end
end

function scard.atk_count()
	local p=Duel.GetAttacker():GetControler()
	scard.atkcounter[p]=scard.atkcounter[p]+1
end

function scard.atk_reset()
	scard.atkcounter[0]=0
	scard.atkcounter[1]=0
end

function scard.atk_event_raise()
	local rg=Group.CreateGroup()
	local g=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	local c=g:GetFirst()
	while c do
		local n_atk=c:GetAttack()
		if c:GetFlagEffect(s_id)~=0 then
			local c_atk=n_atk-c:GetFlagEffectLabel(s_id)
			if c_atk~=0 then
				c:SetFlagEffectLabel(s_id,n_atk)
				scard.atk_change_table[c]=c_atk
				rg:AddCard(c)
				Duel.RaiseSingleEvent(c,EVENT_CUSTOM+s_id,Effect.GlobalEffect(),0,PLAYER_NONE,PLAYER_NONE,c_atk)
			end
		else
			c:RegisterFlagEffect(s_id,RESET_EVENT+0x1fe0000,0,1,n_atk)
		end
		c=g:GetNext()
	end
	if rg:GetCount()>0 then
		Duel.RaiseEvent(rg,EVENT_CUSTOM+s_id,Effect.GlobalEffect(),0,PLAYER_NONE,PLAYER_NONE,0)
		Duel.Readjust()
	end
end
