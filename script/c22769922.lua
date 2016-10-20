--Glorious Victory
function c22769922.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c22769922.condition)
	e1:SetCost(c22769922.cost)
	e1:SetOperation(c22769922.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22769922,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22769922)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c22769922.spcost)
	e2:SetTarget(c22769922.sptg)
	e2:SetOperation(c22769922.spop)
	c:RegisterEffect(e2)
end
function c22769922.confilter(c,tp)
	return c:GetSummonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c22769922.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22769922.confilter,1,nil,tp)
end
function c22769922.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000)
	else Duel.PayLPCost(tp,2000) end
end
function c22769922.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c22769922.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(c22769922.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c22769922.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() and e:GetHandler()~=re:GetHandler()
end
function c22769922.disable(e,c)
	return c~=e:GetHandler() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function c22769922.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c22769922.spfilter(c,e,tp)
	return c:IsSetCard(0xaa12) and c:GetLevel()==10 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22769922.setfilter(c,tp)
	return c:IsType(TYPE_TRAP+TYPE_COUNTER) and c:IsSSetable(true)
end
function c22769922.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22769922.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22769922.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22769922.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c22769922.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
			and Duel.IsExistingTarget(c22769922.setfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectTarget(tp,c22769922.setfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) and (tc:IsType(TYPE_TRAP+TYPE_COUNTER) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) then
				Duel.SSet(tp,tc)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end