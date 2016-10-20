--Dreadnought Mark - 011 Issabel
function c22769928.initial_effect(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetOperation(c22769928.chop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(c22769928.chop2)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22769928,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c22769928.spcon)
	e3:SetTarget(c22769928.sptg)
	e3:SetOperation(c22769928.spop)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22769928,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,22769928)
	e4:SetCondition(c22769928.descon)
	e4:SetTarget(c22769928.destg)
	e4:SetOperation(c22769928.desop)
	c:RegisterEffect(e4)
	--cannot be effect target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
end
function c22769928.chop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function c22769928.chop2(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp or not re:IsActiveType(TYPE_COUNTER) then return end
	e:GetLabelObject():SetLabel(1)
end
function c22769928.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function c22769928.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22769928.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c22769928.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c22769928.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c22769928.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
