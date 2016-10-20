--Zobek's Curse
function c59821102.initial_effect(c)
	c:SetUniqueOnField(1,0,59821102)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821102,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,59821102)
	e2:SetCost(c59821102.pccost)
	e2:SetTarget(c59821102.pctg)
	e2:SetOperation(c59821102.pcop)
	c:RegisterEffect(e2)
end
function c59821102.pccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c59821102.pcfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and not c:IsForbidden()
end
function c59821102.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c59821102.pcfilter(chkc) end
	local b1=Duel.IsExistingTarget(c59821102.pcfilter,tp,LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c59821102.pcfilter,tp,LOCATION_EXTRA,0,1,nil)
	if chk==0 then
		if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
		return b1 or b2
	end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(59821102,1),aux.Stringid(59821102,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(59821102,1))
	else op=Duel.SelectOption(tp,aux.Stringid(59821102,2))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		Duel.SelectTarget(tp,c59821102.pcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	else
		e:SetProperty(0)
	end
end
function c59821102.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c59821102.pcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end