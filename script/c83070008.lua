--Hydrush Pegasus
function c83070008.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c83070008.spcon)
	c:RegisterEffect(e1)
	--shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(83070008,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c83070008.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--lv down
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(83070008,1))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0x1c0)
	e5:SetTarget(c83070008.target)
	e5:SetOperation(c83070008.operation)
	c:RegisterEffect(e5)
end
function c83070008.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x837)
end
function c83070008.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c83070008.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c83070008.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(1-tp)
	Duel.RaiseEvent(e:GetHandler(),8307,e,0,0,1-tp,0)
end
function c83070008.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c83070008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c83070008.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c83070008.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c83070008.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c83070008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(2)
		tc:RegisterEffect(e1)
	end
end
