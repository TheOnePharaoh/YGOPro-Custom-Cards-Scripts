--The Keeper of Ynershia
--  By Shad3

local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end

local scard,s_id=getID()
local sc_id=0x73d

function scard.initial_effect(c)
	--Battle-indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(scard.a_val)
	c:RegisterEffect(e1)
	--Protect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(scard.b_tg)
	e4:SetValue(scard.b_val)
	e4:SetOperation(scard.b_op)
	c:RegisterEffect(e4)
	if not scard.ykeeper then scard.ykeeper={} end
	scard.ykeeper[c]=e4
end

function scard.a_val(e,c)
	return c:GetAttack()<=e:GetHandler():GetAttack()+200
end

function scard.b_fil(c)
	return c:IsFaceup() and c:IsSetCard(sc_id) and c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end

function scard.b_s_fil(c)
	return c.ykeeper and c.ykeeper[c] and c:IsFaceup() and not c:IsDisabled() and c:GetFlagEffect(s_id)==0
end

function scard.b_fid(c,i)
	return c:GetFieldID()<i
end

function scard.b_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		if c:GetFlagEffect(s_id)~=0 or not eg:IsExists(scard.b_fil,1,nil) then return false end
		local sg=Duel.GetMatchingGroup(scard.b_s_fil,tp,LOCATION_MZONE,0,nil)
		return not sg:IsExists(scard.b_fid,1,c,c:GetFieldID())
	end
	if Duel.CheckLPCost(tp,300) and Duel.SelectYesNo(tp,aux.Stringid(s_id,0)) then
		local sg=Duel.GetMatchingGroup(scard.b_s_fil,tp,LOCATION_MZONE,0,nil)
		if sg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
			sg=sg:Select(tp,1,1,nil)
		end
		Duel.HintSelection(sg)
		sg:GetFirst():RegisterFlagEffect(s_id,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,0)
		local amt=Duel.GetLP(tp)/300
		local g=eg:Filter(scard.b_fil,nil)
		if g:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			g=g:Select(tp,1,amt,nil)
		end
		Duel.PayLPCost(tp,g:GetCount()*300)
		Duel.HintSelection(g)
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end

function scard.b_val(e,c)
	local g=e:GetLabelObject()
	return g and g:IsContains(c)
end

function scard.b_op(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g then return end
	local c=g:GetFirst()
	while c do
		if c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER) and c:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(500)
			c:RegisterEffect(e1)
		end
		c=g:GetNext()
	end
	g:DeleteGroup()
end
