--Curator of End.Catalog
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
	c:EnableReviveLimit()
	--Proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(s_id,0))
	e1:SetCondition(scard.a_cd)
	e1:SetOperation(scard.a_op)
	c:RegisterEffect(e1)
	--Attach
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(scard.b_tg)
	e2:SetValue(scard.b_val)
	e2:SetOperation(scard.b_op)
	c:RegisterEffect(e2)
	if not scard._ec_aef then scard._ec_aef={} end
	scard._ec_aef[c]=e2
	--Immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(TIMING_MAIN_END)
	e3:SetDescription(aux.Stringid(s_id,1))
	e3:SetCondition(scard.c_cd)
	e3:SetTarget(scard.c_tg)
	e3:SetOperation(scard.c_op)
	c:RegisterEffect(e3)
	--Shuffle
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e4:SetDescription(aux.Stringid(s_id,7))
	e4:SetCost(scard.d_cs)
	e4:SetTarget(scard.d_tg)
	e4:SetOperation(scard.d_op)
	c:RegisterEffect(e4)
	--can't activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	e5:SetValue(scard.e_val)
	c:RegisterEffect(e5)
end

function scard.a_fil(c,tp)
	return c:IsRace(RACE_PYRO) and c:GetLevel()==3 and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(scard.a_fil2,tp,LOCATION_MZONE,0,1,c,c:GetCode())
end

function scard.a_fil2(c,n)
	return c:IsRace(RACE_PYRO) and c:GetLevel()==3 and c:IsAbleToRemoveAsCost() and not c:IsCode(n)
end

function scard.a_cd(e,c)
	if not c then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.IsExistingMatchingCard(scard.a_fil,tp,LOCATION_MZONE,0,1,nil,tp)
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,scard.a_fil,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,scard.a_fil2,tp,LOCATION_MZONE,0,1,1,g:GetFirst(),g:GetFirst():GetCode())
	g:Merge(g2)
	Duel.ConfirmCards(1-tp,g)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function scard.b_fil(c,rc)
	return c==rc and c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_EFFECT) and c:IsLocation(LOCATION_SZONE) and c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:GetSequence()<5
end

function scard.b_s_fil(c)
	return c._ec_aef and c._ec_aef[c] and c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsDisabled()
end

function scard.b_fid(c,i)
	return c:GetFieldID()<i
end

function scard.b_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		if not re or not eg:IsExists(scard.b_fil,1,nil,re:GetHandler()) then return false end
		local sg=Duel.GetMatchingGroup(scard.b_s_fil,tp,LOCATION_MZONE,0,nil)
		return not sg:IsExists(scard.b_fid,1,c,c:GetFieldID())
	end
	if Duel.SelectYesNo(tp,aux.Stringid(s_id,2)) then
		local sg=Duel.GetMatchingGroup(scard.b_s_fil,tp,LOCATION_MZONE,0,nil)
		if sg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
			sg=sg:Select(tp,1,1,nil)
		end
		e:SetLabel(sg:GetFirst():GetSequence())
		Duel.HintSelection(sg)
		local g=eg:Filter(scard.b_fil,nil,re:GetHandler())
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
	local c=Duel.GetFieldCard(tp,LOCATION_MZONE,e:GetLabel())
	Duel.Overlay(c,g)
	g:DeleteGroup()
end

function scard.c_cd(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

function scard.c_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(s_id,3))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
end

function scard.c_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(scard.c_imfil)
		local ty=e:GetLabel()
		e1:SetDescription(aux.Stringid(s_id,ty+4))
		if ty==0 then
			e1:SetLabel(TYPE_MONSTER)
		elseif ty==1 then
			e1:SetLabel(TYPE_SPELL)
		else
			e1:SetLabel(TYPE_TRAP)
		end
		c:RegisterEffect(e1,true)
	end
end

function scard.c_imfil(e,re)
	return re:IsActiveType(e:GetLabel())
end

function scard.d_fil(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end

function scard.d_cd(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end

function scard.d_cs(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function scard.d_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end

function scard.d_op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local c=e:GetHandler()
		if tc:IsAbleToDeck() and c:CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(s_id,8)) then
			c:RemoveOverlayCard(tp,1,1,REASON_COST)
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end

function scard.e_fil(c,n)
	return c:IsCode(n) and c:IsFaceup()
end

function scard.e_val(e,re,tp)
	local rc=re:GetHandler()
	return not rc:IsImmuneToEffect(e) and Duel.IsExistingMatchingCard(scard.e_fil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,rc:GetCode())
end
