--Vocaloid Ruby
function c41045209.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41045209,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,41045209)
	e1:SetCost(c41045209.cost)
	e1:SetTarget(c41045209.target)
	e1:SetOperation(c41045209.operation)
	c:RegisterEffect(e1)
	--cannot synchro material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(c41045209.synlimit1)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e3)
end
function c41045209.cfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and (c:IsSetCard(0x0dac405) or c:IsSetCard(0x0dac406))
		and not c:IsCode(41045209) and c:IsAbleToGraveAsCost()
end
function c41045209.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then loc=LOCATION_MZONE end
	if chk==0 then return Duel.IsExistingMatchingCard(c41045209.cfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c41045209.cfilter,tp,loc,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c41045209.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c41045209.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c41045209.synlimit1(e,c)
	if not c then return false end
	return not c:IsSetCard(0x0dac402)
end
