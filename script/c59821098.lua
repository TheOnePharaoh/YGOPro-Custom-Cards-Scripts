--The Idol's Flaming Spirit
function c59821098.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,59821098+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c59821098.condition)
	e1:SetCost(c59821098.cost)
	e1:SetTarget(c59821098.target)
	e1:SetOperation(c59821098.activate)
	c:RegisterEffect(e1)
end
function c59821098.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	return ct1<ct2
end
function c59821098.filter(c,e,tp,b1,setcode)
	return c:IsSetCard(setcode) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and (b1 or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c59821098.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(59821098,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c59821098.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c59821098.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xa1a2) and c:IsLocation(LOCATION_EXTRA)
end
function c59821098.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return (b1 or b2)
		and Duel.IsExistingMatchingCard(c59821098.filter,tp,LOCATION_DECK,0,1,nil,e,tp,b1,0xa1a2)
		and Duel.IsExistingMatchingCard(c59821098.filter,tp,LOCATION_DECK,0,1,nil,e,tp,b1,0xc4) end
end
function c59821098.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if not b1 and not b2 then return end
	local g1=Duel.GetMatchingGroup(c59821098.filter,tp,LOCATION_DECK,0,nil,e,tp,b1,0xa1a2)
	local g2=Duel.GetMatchingGroup(c59821098.filter,tp,LOCATION_DECK,0,nil,e,tp,b1,0xc4)
	if g1:GetCount()==0 or g2:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ShuffleDeck(tp)
	local cg=sg1:Select(1-tp,1,1,nil)
	local tc=cg:GetFirst()
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	if b1 and (not b2 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectYesNo(tp,aux.Stringid(59821098,0))) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	sg1:RemoveCard(tc)
	Duel.PSendtoExtra(sg1,nil,REASON_EFFECT)
end
