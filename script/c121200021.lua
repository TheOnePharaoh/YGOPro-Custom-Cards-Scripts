--End.Catalog Scripture #1 『A』
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
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
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
	--PutFaceup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetDescription(aux.Stringid(s_id,1))
	e4:SetCondition(scard.efmon)
	e4:SetTarget(scard.c_tg)
	e4:SetOperation(scard.c_op)
	c:RegisterEffect(e4)
end

function scard.efmon(e)
	return e:GetHandler():IsType(TYPE_EFFECT)
end

function scard.a_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,tp,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,tp,LOCATION_SZONE)
end

function scard.a_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(s_id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoGrave(c,REASON_EFFECT)
end

function scard.b_fil(c,n)
	return c:IsCode(n) and c:IsFaceup()
end

function scard.b_val(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_SPELL) and not rc:IsImmuneToEffect(e) and Duel.IsExistingMatchingCard(scard.b_fil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,rc:GetCode())
end

function scard.c_fil(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)
end

function scard.c_tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and scard.c_fil(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(scard.c_fil,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,scard.c_fil,tp,LOCATION_GRAVE,0,1,1,nil)
end

function scard.c_op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47c0000)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCondition(scard.c_dcd)
		e2:SetOperation(scard.c_dop)
		Duel.RegisterEffect(e2,tp)
		local fid=e:GetHandler():GetFieldID()
		e2:SetLabel(fid)
		e2:SetLabelObject(tc)
		tc:RegisterFlagEffect(s_id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
	end
end

function scard.c_dcd(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c and c:GetFlagEffectLabel(s_id)==e:GetLabel() then return true end
	e:Reset()
	return false
end

function scard.c_dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c then Duel.Destroy(c,REASON_EFFECT) end
end
