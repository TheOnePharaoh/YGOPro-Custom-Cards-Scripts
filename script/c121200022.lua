--End.Catalog Scripture #2 『E』
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
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--MP/BP
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetCountLimit(1)
	e2:SetDescription(aux.Stringid(s_id,0))
	e2:SetTarget(scard.a_tg)
	e2:SetOperation(scard.a_op)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EVENT_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e2b)
	--EffectMonster
	--cannotAct
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(scard.efmon)
	e3:SetValue(scard.b_val)
	c:RegisterEffect(e3)
	--Set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(scard.efmon)
	e4:SetTarget(scard.c_tg)
	e4:SetValue(scard.c_val)
	e4:SetOperation(scard.c_op)
	c:RegisterEffect(e4)
	if not scard._ecsb then scard._ecsb={} end
	scard._ecsb[c]=e4
end

function scard.efmon(e)
	return e:GetHandler():IsType(TYPE_EFFECT)
end

function scard.a_fil(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end

function scard.a_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,LOCATION_SZONE)
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.DiscardHand(tp,scard.a_fil,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoGrave(c,REASON_EFFECT)
end

function scard.b_fil(c,n)
	return c:IsCode(n) and c:IsFaceup()
end

function scard.b_val(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_MONSTER) and not rc:IsImmuneToEffect(e) and Duel.IsExistingMatchingCard(scard.b_fil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,rc:GetCode())
end

function scard.c_fil(c,rc)
	return c==rc and c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_EFFECT) and c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:GetSequence()<5 and c:IsSSetable()
end

function scard.c_s_fil(c)
	return c._ecsb and c._ecsb[c] and c:IsFaceup() and not c:IsDisabled() and c:GetFlagEffect(s_id)==0
end

function scard.c_fid(c,i)
	return c:GetFieldID()<i
end

function scard.c_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		if c:GetFlagEffect(s_id)~=0 or not re or not eg:IsExists(scard.c_fil,1,nil,re:GetHandler()) then return false end
		local sg=Duel.GetMatchingGroup(scard.c_s_fil,tp,LOCATION_MZONE,0,nil)
		return not sg:IsExists(scard.c_fid,1,c,c:GetFieldID())
	end
	if Duel.SelectYesNo(tp,aux.Stringid(s_id,1)) then
		local sg=Duel.GetMatchingGroup(scard.c_s_fil,tp,LOCATION_MZONE,0,nil)
		if sg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
			sg=sg:Select(tp,1,1,nil)
		end
		Duel.HintSelection(sg)
		sg:GetFirst():RegisterFlagEffect(s_id,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,0)
		local g=eg:Filter(scard.c_fil,nil,re:GetHandler())
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end

function scard.c_val(e,c)
	local g=e:GetLabelObject()
	return g and g:IsContains(c)
end

function scard.c_op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.ChangePosition(g,POS_FACEDOWN)
	Duel.RaiseEvent(g,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	g:DeleteGroup()
end
