--Ｓｐゴーストリック・ハウス
function c777000002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c777000002.con)
	e1:SetTarget(c777000002.tg)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c777000002.bttg)
	e2:SetValue(c777000002.btval)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c777000002.dirtg)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(c777000002.val)
	c:RegisterEffect(e4)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c777000002.con2)
	e5:SetTarget(c777000002.tg)
	c:RegisterEffect(e5)
	--maintain
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetOperation(c777000002.mtop)
	c:RegisterEffect(e6)
end
function c777000002.confilter(c)
	return c:IsSetCard(0x1200)
end
function c777000002.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if e:GetHandler():IsLocation(LOCATION_HAND) then
		return tc:GetCounter(0x91)>5 and not Duel.IsExistingMatchingCard(c777000002.confilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
	else
		return tc:GetCounter(0x91)>5
	end
end
function c777000002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(c777000002.confilter,tp,LOCATION_SZONE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c777000002.confilter,tp,LOCATION_SZONE,0,sg:GetCount(),sg:GetCount(),c)
	if g:GetCount()>0 then
		if not Duel.SendtoGrave(g,REASON_RULE) then
			Duel.Destroy(g,REASON_RULE)
		end
	end
	e:SetType(EFFECT_TYPE_ACTIVATE)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function c777000002.con2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	return tc:GetCounter(0x91)>5 and Duel.IsExistingMatchingCard(c777000002.confilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function c777000002.bttg(e,c)
	return c:IsFacedown()
end
function c777000002.btval(e,c)
	return not c:IsImmuneToEffect(e)
end
function c777000002.dirtg(e,c)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,c:GetControler(),0,LOCATION_MZONE,1,nil)
end
function c777000002.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 or (rc and not rc:IsSetCard(0x8d)) then
		return dam/2
	else return dam end
end
function c777000002.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	local td=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if td:IsCanRemoveCounter(tp,0x91,1,REASON_COST) and Duel.SelectYesNo(tp,aux.Stringid(777000002,0)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		td:RemoveCounter(tp,0x91,1,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
